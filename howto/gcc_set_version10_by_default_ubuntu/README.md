Install and make GNU GCC 10 default in Ubuntu 20.04 Focal
---

The best way to install and use GNU GCC 10 is to install first, build-essential package, which will pull in the GNU GCC 9.2, and then install the GNU GCC 10. In fact, it is possible to install only GNU GCC 10 packages, but build-essential brings with it many additional packages, which are mandatory for the configuration and compiling stages.
GNU GCC is included in the official Ubuntu Focal repository.
It needs to be installed and made to be the default compiler.

Install build-essential ensures all generic packages to be installed, which are involved in the building process of a software product.

There are the steps to install and use GNU GCC 10 under Ubuntu 20.04:

1. Install build-essential package.
2. Install gcc-10 packages (g++, too).
3. Make GNU GCC 10 default compiler using update-alternatives


```
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y build-essential
sudo apt install -y gcc-10 g++-10 cpp-10
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 --slave /usr/bin/g++ g++ /usr/bin/g++-10 --slave /usr/bin/gcov gcov /usr/bin/gcov-10

```
