The noexcept Specifier and Operator
---

## noexcept

noexcept exists two forms
* as a specifier
* as an operator. 

### noexcept as specifier

By declaring a function, a method, or a lambda-function as noexcept, this specifies that these does not throw an exception.
If they throw, program just crashes. It is about function, methods and templates. 

```
void exFunc1() noexcept;        // this does not throw
void exFunc2() noexcept(true);  // this does not throw
void exFunc3() throw();         // this does not throw
void exFunc4() noexcept(false); // this may throw
``` 

#### Note: 

* throw() is equivalent to noexcept(true). It was deprecated with C++11 and was removed starting C++20. 
* noexcept(false) means : the function may throw an exception. 
* noexcept specification is part of the function type. However it be used for overloading. 


## Reasons to use of noexcept 

1. An exception specifier documents the behaviour. If a function is specified as noexcept, it can be safely used in a non-throwing function. 
2. As optimisation opportunity for the compiler. noexcept may not call std::unexpectedand may not unwind the stack. 
3. The initialisation of a container may cheap move the elements into the container if the move constructor is declared as noexcept!
4. If not declared as noexcept, the elements may be expensive copied into the container.

All functions may be either **non-throwing** or **potentially throwing**. 

## Potentially throwing means:

1. The function may contain/use other functions that may throw.
2. The function was declared without a noexcept specification.
3. The function uses a dynamic_cast to any reference.
4. There is an exception to the rule 2, that functions are potentially throwing if they have no noexcept specification. 
5. These exceptions include the following six special member functions. They are implicitly non-throwing.

  * Default constructor 
  * Destructor
  * Copy constructor
  * Move constructor
  * Copy assignment operator
  * Move assignment operator

This special six member such as the destructor can only be non-throwing if all destructors of the attributes and the bases-classes are non-throwing. 
Of course, the corresponding statement will hold for the five other special member functions.

### What happens when you throw an exception in a function which is declared as non-throwing? 

In this case, **std::terminate is called**. 
`std::terminate` calls the currently installed std::terminate_handler which calls std::abort by default.
The result is an abnormal program termination.

## noexcept as operator

1. The noexcept operator checks at compile-time if an expression does not throw an exception. 
2. The noexcept operator does not evaluate the expression. 
3. It can be used in a noexcept specifier of a function template to declare that the function may throw exceptions depending on the current type.

Example of a function template which copies it return value.

```c++
// noexceptOperator.cpp

#include <iostream>
#include <array>
#include <vector>

class NoexceptCopy{
public:
  std::array<int, 5> arr{1, 2, 3, 4, 5};             // (2)
};

class NonNoexceptCopy{
public:
  std::vector<int> v{1, 2, 3, 4 , 5};                // (3)
};

template <typename T> 
T copy(T const& src) noexcept(noexcept(T(src))){     // (1)
  return src; 
}

int main(){
    
    NoexceptCopy noexceptCopy;
    NonNoexceptCopy nonNoexceptCopy;
    
    std::cout << std::boolalpha << std::endl;
    
    std::cout << "noexcept(copy(noexceptCopy)): " <<            // (4)
                  noexcept(copy(noexceptCopy)) << std::endl;
                   
    std::cout << "noexcept(copy(nonNoexceptCopy)): " <<         // (5)
                  noexcept(copy(nonNoexceptCopy)) << std::endl;

    std::cout << std::endl;

}
``` 

Of course, the most interesting line in this example is the line (1). 
In particular, the expression noexcept(noexcept(T(src)). The inner noexcept ist the noexcept operator and the outer the noexcept specifier. 
The expression noexcept(T(src)) checks in this case if the copy constructor is non-throwing.
This is the case for the class Noexcept (2) but not for the class NonNoexcept (3) because of the copy constructor of std::vector that may throw. 
Consequently, the expression (4) returns true and the expression (5) returns false.

#### noexcept Operator

You can check at compile time with the help of the type traits library, if a type T has a non-throwing copy constructor `std::is_nothrow_copy_constructible::value`. 
Based on this use instead of the noexcept operator the predicate from the type traits library:

 
```c++
template <typename T> 
T copy(T const& src) noexcept(std::is_nothrow_copy_constructible<T>::value){
  return src; 
}
```
 
I prefer the type traits version because it is more expressive.

The next rule is about the noexcept specifier.


### Use noexcept in case of exiting a function because of a throw is impossible or unacceptable

It says that you should declare a function as noexcept, if

1. it does not throw or you don't care in case of an exception. 
2. You will to crash the program because you can not handle an exception such as std::bad_alloc due to memory exhaustion.
3. It's not a good idea to throw an exception if you are the direct owner of an object.

### Never throw while being the direct owner of an object

Here is an example to direct ownership from the guidelines:

```c++
void leak(int x)   // don't: may leak
{
    auto p = new int{7};
    if (x < 0) throw Get_me_out_of_here{};  // may leak *p
    // ...
    delete p;   // we may never get here
}
``` 

If the throw is fired the memory is lost and you have a leak. 
The simple solution is to get rid of the ownership and make the C++ runtime to the direct owner of the object. 
Just create a local object or at least a guard as a local object. 
And you know the C++ runtime takes care of local objects. Here are three variations of this idea.

```c++
void leak(int x)   // don't: may leak
{
    auto p1 = int{7};
    auto p2 = std::make_unique<int>(7);
    auto p3 = std::vector<int>(7);
    if (x < 0) throw Get_me_out_of_here{}; 
    // ...
}
``` 

p1 is locally created but p2 and p3 are kinds of guards for the objects. The std::vector uses the heap to manage its data. Additionally, with all three variations, you get rid of the delete call.
      
      
      
[https://www.modernescpp.com/index.php/c-core-guidelines-the-noexcept-specifier-and-operator]()      
