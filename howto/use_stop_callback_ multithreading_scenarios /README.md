How to use `std::stop_callback` in multithreading scenarios
---

If you're dealing with `std::stop_callback` and multithreading scenarios, here's a deeper explanation and example of how to use `std::stop_callback` effectively for managing cancellation in a thread-safe manner.

## **What is `std::stop_callback`?**

`std::stop_callback` is a C++20 addition, which works alongside `std::stop_token` and `std::stop_source`. 
These classes make it easier to implement cooperative cancellation in multithreading. 
A `std::stop_callback` is registered with a `std::stop_token` and gets invoked when a stop request is received via an associated `std::stop_source`.
This mechanism avoids the need for polling or using complex locking mechanisms to communicate a stop signal between threads, leading to cleaner and more efficient cancellation.

### **Example Use Case: Daemon with Cancellation**
Here's an example scenario that shows a threadable daemon process that can be cancelled via `std::stop_callback`.

```cpp
#include <iostream>
#include <thread>
#include <stop_token>
#include <atomic>
#include <chrono>

// Example for representing an event loop or daemon-like operation
void daemonProcess(std::stop_token stopToken) {
    std::atomic<int> cycleCount = 0;

    // Register a callback that gets called when a stop signal is issued.
    std::stop_callback stopCallback(stopToken, [&]() {
        std::cout << "Stop requested. Cleaning up...\n";
    });

    // Simulate the daemon running in a loop
    while (!stopToken.stop_requested()) {
        // Simulate work
        cycleCount++;
        std::cout << "Daemon running: cycle " << cycleCount << "\n";
        std::this_thread::sleep_for(std::chrono::seconds(1));

        if (cycleCount >= 10) {  // Simulate exit condition after 10 cycles
            std::cout << "Exiting daemon normally after 10 cycles.\n";
            break;
        }
    }

    // Cleanup or gracefully stop the daemon
    std::cout << "Daemon stopped. Final cycle count: " << cycleCount << "\n";
}

int main() {
    // Create a stop source
    std::stop_source stopSource; 
    std::stop_token stopToken = stopSource.get_token();

    // Start daemon in a separate thread
    std::thread daemonThread(daemonProcess, stopToken);

    // Simulate user request to stop after 4 seconds
    std::this_thread::sleep_for(std::chrono::seconds(4));
    std::cout << "Requesting stop...\n";
    stopSource.request_stop();

    // Join thread
    if (daemonThread.joinable()) {
        daemonThread.join();
    }

    std::cout << "Main thread exiting.\n";
    return 0;
}
```

### **Explanation of the Example**

1. **`std::stop_source` and `std::stop_token`:**
    - The `std::stop_source` is used to issue a stop request (via `request_stop()`).
    - The `std::stop_token` is passed to the thread to monitor stop requests.

2. **`std::stop_callback`:**
    - Registered with the `std::stop_token`. When a stop signal is issued, the callback is executed immediately, allowing you to handle stop-specific cleanup.

3. **Daemon process:**
    - The `daemonProcess` function simulates an event loop or daemon-like task.
    - It regularly checks `stopToken.stop_requested()` to see if a stop signal has been issued. This avoids unnecessary locking or polling overhead.

4. **Graceful exit:**
    - On receiving a stop signal, the callback cleans up, and the loop exits gracefully. Any necessary cleanup logic can also be added after the loop exits (e.g., releasing resources, saving state, etc.).

### **Key Advantages of `std::stop_callback`:**

1. Automatic and thread-safe invocation of callbacks when a stop is requested.
2. No polling or manual synchronization required to check for cancellation.
3. Simple and clean control flow for managing thread cancellation.

### **Expanding with More Complex Scenarios**

If your `daemonEvent` is part of a larger structure, consider encapsulating the stop mechanism in a class. Here's an example structure:

```cpp
#include <iostream>
#include <thread>
#include <stop_token>
#include <atomic>
#include <chrono>

class Daemon {
private:
    std::stop_source stopSource;
    std::thread daemonThread;

public:
    // Start the daemon process
    void start() {
        std::stop_token stopToken = stopSource.get_token();
        daemonThread = std::thread([stopToken]() {
            std::atomic<int> cycleCount = 0;

            std::stop_callback stopCallback(stopToken, [&]() {
                std::cout << "Stop requested in callback. Exiting daemon...\n";
            });

            while (!stopToken.stop_requested()) {
                cycleCount++;
                std::cout << "Daemon cycle " << cycleCount << "\n";
                std::this_thread::sleep_for(std::chrono::seconds(1));
            }
        });
    }

    // Stop the daemon process
    void stop() {
        stopSource.request_stop();  // Request the daemon to stop gracefully
        if (daemonThread.joinable()) {
            daemonThread.join();
        }
    }

    ~Daemon() {
        stop();
    }
};

int main() {
    Daemon daemon;
    daemon.start();

    std::this_thread::sleep_for(std::chrono::seconds(5));
    std::cout << "Stopping daemon from main...\n";

    daemon.stop();
    return 0;
}
```

### **When to Use `std::stop_callback`:**

- Inside long-running or infinite loops where an external thread or user needs to signal cancellation.
- For daemon-like processes or event-driven tasks where a graceful exit is required.
- In scenarios needing cooperative cancellation instead of abrupt termination.

