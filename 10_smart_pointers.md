# Smart pointers

A *pointer* in programming is a powerful tool that holds a memory address. This address is a reference to, or "*points to*", some data stored elsewhere in memory. In Rust, the most common type of pointer is a reference, denoted by the `&` symbol. References in Rust borrow the value they point to, adhering to Rust's strict borrowing and ownership rules.

*Smart Pointers*, a step beyond traditional pointers, are data structures that not only mimic pointers by holding a memory address, but also incorporate additional metadata and capabilities.

One key distinction between references and smart pointers in Rust lies in the concept of ownership. While references merely borrow the data they point to, smart pointers, in many instances, actually own the data they're pointing at. This ownership is managed according to Rust's rules, ensuring memory safety without a garbage collector.

## Index

1. [Using box to Point to Data on the Heap](#using-box-to-point-to-data-on-the-heap)
    - [Using a `Box` to Store Data on the Heap](#using-a-box-to-store-data-on-the-heap)
    - [Enabling `Recursive Types` with Boxes](#enabling-recursive-types-with-boxes)
        - [More information about *Cons List*](#more-information-about-cons-list)
        - [Using Box to Get a Recursive Type with a Known Size](#using-box-to-get-a-recursive-type-with-a-known-size)
2. [Treating Smart Pointers Like Regular References with the Deref Trait](#treating-smart-pointers-like-regular-references-with-the-deref-trait)
    - [Following the `pointer` to the `Value`](#following-the-pointer-to-the-value)
    - [Using Box like a Reference](#using-box-like-a-reference)
    - [Defining Our Own Smart Pointer](#defining-our-own-smart-pointer)
    - [Implicit Deref Coercions with Functions and Methods](#implicit-deref-coercions-with-functions-and-methods)
3. [Running Code on Cleanup with the Drop Trait](#running-code-on-cleanup-with-the-drop-trait)
    - [Dropping a Value Early with std::mem::drop](#dropping-a-value-early-with-stdmemdrop)
4. [Hypothesis](#hypothesis)

## Using box to Point to Data on the Heap

The most straightforward smart pointer is a `box`, whose type is written `Box<T>`. Boxes allow you to store data on the heap rather than the stack. What remains on the stack is the pointer to the heap data.

Boxes do not introduce any performance overhead, with the exception of their data being stored on the heap rather than the stack. However, they don't come with many additional features. They are most commonly used in the following cases:

1. When you're dealing with a type whose size is not determinable at compile time, but you need to use a value of that type in a context that necessitates a known size.
1. When you're working with a large data set and you want to pass ownership without the data being duplicated in the process.
1. When you need to own a value and are only concerned with it being a type that adheres to a specific trait, rather than it being a specific type.

### Using a `Box` to Store Data on the Heap

```rust
fn main() {
    let b = Box::new(5);
    println!("b = {}", b);
}
```

We define the variable `b` to have the value of a `Box` that points to the value `5`, which is allocated on the heap. This program will print `b = 5`; in this case, we can access the data in the box similar to how we would if this data were on the stack. Just like any owned value, when a box goes out of scope, as `b` does at the end of `main`, it will be deallocated. The deallocation happens both for the box (stored on the stack) and the data it points to (stored on the heap).

### Enabling `Recursive Types` with Boxes

Recursive types are types that include values of the same type within their own definition. An example of this could be a data structure like a linked list, where each element (or node) points to another element of the same type.

The challenge with recursive types is that Rust needs to determine how much space a type will occupy at compile time. However, with recursive types, a value can contain another value of the same type, which can in turn contain another value of the same type, and so on. This potential for infinite nesting makes it impossible for Rust to determine the exact amount of space a recursive type will need.

This is where boxes become useful. A box is a type of pointer that points to data stored on the heap, and the size of a pointer is known. By incorporating a box into the recursive type definition, we can create recursive types. The box will contain the recursive part, and since the size of the box is known, this makes the overall type's size known as well. This is why boxes are often used in recursive type definitions in Rust.

#### More information about *Cons List*

A cons list is a type of data structure that originates from the `Lisp` programming language and its dialects. It is essentially the Lisp version of a linked list, and is composed of nested pairs.

The term "cons" is short for "construct function", which is a function in Lisp that constructs a new pair from its two arguments. Each pair in a cons list consists of a value and a reference to the next pair.

By repeatedly calling the `cons` function on a pair (which consists of a value and another pair), we can create a cons list. This results in a structure made up of recursive pairs, hence the term "nested pairs". This structure forms the basis of the cons list data structure.

For example, here’s a pseudocode representation of a cons list containing the list 1, 2, 3 with each pair in parentheses:

```plaintext
(1, (2, (3, Nil)))
```

A cons list is a special type of list that comes from the Lisp programming language. Each item in a cons list has two parts: the current value and the next item. The last item in the list is called `Nil` and doesn't have a next item.

Creating a cons list involves repeatedly calling the `cons` function. The `Nil` value is used to indicate the end of the list. It's important to note that this `Nil` is not the same as the "null" or "nil" concept you might see elsewhere, which usually means an invalid or missing value.

In Rust, cons lists aren't used very often. If you need a list of items, `Vec<T>` is usually a better choice. However, understanding cons lists can be helpful for learning about more complex recursive data types and how boxes can be used to create them.

To make the previos example in Rust, we can use the following code:

```rust
enum List {
    Cons(i32, List),
    Nil,
}

use List::{Cons, Nil};

fn main() {
    let list = Cons(1, Cons(2, Cons(3, Nil)));
}
```

The provided Rust code is trying to create a simple linked list using an `enum` called `List`. This `List` has two variants: `Cons` and `Nil`. `Cons` represents an element in the list and a reference to the next element, while `Nil` represents the end of the list.

In the `main` function, it attempts to create a `List` with three elements (1, 2, and 3). However, this code will result in a compile-time error.

The error occurs because Rust needs to know the size of each type at compile time. But with this definition of `List`, Rust can't determine its size. The `Cons` variant is recursive because it holds a `List` within itself, which could be another `Cons` that holds another `List`, and so on. This could theoretically continue infinitely, so Rust doesn't know how much memory a `List` could end up taking. Therefore, it gives a compile-time error saying that `List` "has infinite size".

To understand why this happens, let's look at how the compiler tries to determine the size of `List`. It starts with the `Cons` variant, which holds a value of type `i32` and a value of type `List`. Therefore, `Cons` needs an amount of space equal to the size of an `i32` plus the size of a `List`. To figure out how much memory the `List` type needs, the compiler looks at the variants, starting with the `Cons` variant. The `Cons` variant holds a value of type `i32` and a value of type `List`. This process continues infinitely because each `List` contains another `List`, leading to the error.

#### Using Box to Get a Recursive Type with a Known Size

Because `Box<T>` is a smart pointer, Rust always knows how much space a `Box<T>` needs: a pointer's size soesn't change based on the amount of data it's pointing to. This menas we can put a `Box<T>` inside the `Cons` variant instead of another `List` value directly. The `Box<T>` will point to the next `List` value that will be on the heap rather than inside the `Cons` variant. Conceptually, we still have a list, created with lists holding other lists, but this implementation is now more like placing the items next to one another rather than inside one another.

```rust
enum List {
    Cons(i32, Box<List>),
    Nil,
}

use List::{Cons, Nil};

fn main() {
    let list = Cons(1, Box::new(Cons(2, Box::new(Cons(3, Box::new(Nil))))));
}
```

The `Box<T>` type is a smart pointer because it implements the `Deref` trait, which allows `Box<T>` values to be treated like references. When a `Box<T>` value goes out of scope, the heap data that the box is pointing to is cleaned up as well because of the `Drop` trait implementation. These two traits will be even more important to the functionality provided by the other smart pointer types we’ll discuss in the rest of this chapter. Let’s explore these two traits in more detail.

## Treating Smart Pointers Like Regular References with the Deref Trait

Implementing the `Deref` trait allows you to customize the behavior of the *dereference operator* `*`. By implementing `Deref` in such a way that a smart pointer can be treated like a regular reference, you can write code that operates on references and use that code with smart pointers too.

### Following the `pointer` to the `Value`

A regular reference is a type of pointer, and one way to think of a pointer is as an arrow to a value stored somewhere else. Just as explained in the example below we create a variable `x` that holds the value `5`, and then we create a reference `y` that points to `x`.

```rust
fn main() {
    let x = 5;
    let y = &x;

    assert_eq!(5, x);
    assert_eq!(5, *y);
}
```

The variable `x` holds an `i32` value `5`. We set `y` equal to a reference to `x`. We can assert that `x` is equal to `5`. However, if we want to make an assertion about the value in `y`, we have to use `*y` to follow the reference to the value it’s pointing to (hence dereference) so the compiler can compare the actual value. Once we dereference `y`, we have access to the integer value `y` is pointing to that we can compare with `5`.

If we tried to use `assert_eq!(5, y);`, it would cause an error. This is because `y` is a reference to a value of type `i32`, not an actual `i32` value. So, we can't directly compare `y` with `5`.

### Using Box like a Reference

We can rewrite the above code to use a `Box` instead of a reference, and the `Deref` trait will allow us to use the `*` operator to follow the reference in the same way.

```rust
fn main() {
    let x = 5;
    let y = Box::new(x);

    assert_eq!(5, x);
    assert_eq!(5, *y);
}
```

The main difference between this example and the last before this is that here we set `y`to be an instance of a `Box<T>` pointing to a **copied** value of `x`. The last assertion in the code uses the dereference operator (`*`) to access the value inside a `Box<T>`. This works similarly to how we use the dereference operator with references.

In the case of `Box<T>`, it's set up to return the value it's storing when dereferenced. This is why we can use the dereference operator to access the value inside a `Box<T>`, just like we can with references.

### Defining Our Own Smart Pointer

Let’s build a smart pointer similar to the `Box<T>` type provided by the standard library to experience how smart pointers behave differently from references by default.

>**Note:** The `Box<T>` type is ultimately defined as tuple struct with one element check the exmample below where we define our own smart pointer.

```rust
struct MyBox<T>(T);

impl <T> MyBox<T> {
    fn new(x: T) -> MyBox<T> {
        MyBox(x)
    }
}
```

We define a struct named `MyBox` and declare a generic parameter `T`, because we want our type to hold values of any type. The `MyBox` type is a tuple struct with one element of type `T`. The `MyBox::new` function takes one parameter of type `T` and returns a `MyBox` instance that holds the value passed in.

```rust
use std::ops::Deref;

impl<T> Deref for MyBox<T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}
```

The type `Target = T;` syntax defines an associated type for the Deref trait to use. The type `Target = T`; syntax defines an associated type for the Deref trait to use. Remember that the wa to access to a value in a tuple struct is to use the dot operator followed by the index of the value in the tuple. In the case of `MyBox`, `self.0` will return the value `T` that `MyBox` is holding. The `deref` method then returns a reference to the value we want to access with the `*` operator.

```rust
use std::ops::Deref;

impl<T> Deref for MyBox<T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

fn main() {
    let x = 5;
    let y = MyBox::new(x);

    assert_eq!(5, x);
    assert_eq!(5, *y);
}
```

Without the `Deref` trait, the compiler can only dereference `&` references. The `deref` method gives the compiler the ability to take a value of any type that implements `Deref` and call the `deref` method to get a `&` reference that it knows how to dereference.

When we entered `*y` in the `assert_eq!` macro, the compiler replaced it with `*(y.deref())`. The expression `*(y.deref())` is the same as `*(y.0)`, which is the same as `x`. The `deref` method lets us write code that functions similarly whether we have a reference or a `MyBox<T>`.

### Implicit Deref Coercions with Functions and Methods

`Deref coercion` is a convenience provided by Rust that automatically converts a reference to a type that implements the `Deref` trait into a reference to another type. For example, deref coercion can convert `&String` to `&str` because String implements the `Deref` trait such that it returns `&str`. `Deref coercion` is a convenience Rust performs on arguments to functions and methods, and works only on types that implement the Deref trait. It happens automatically when we pass a reference to a particular type’s value as an argument to a function or method that doesn’t match the parameter type in the function or method definition. A sequence of calls to the `deref` method converts the type we provided into the type the parameter needs.

```rust
use std::ops::Deref;

impl<T> Deref for MyBox<T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

fn hello(name: &str) {
    println!("Hello, {}!", name);
}

fn main() {
    let m = MyBox::new(String::from("Rust"));
    hello(&m);
}
```

In this example, `MyBox<String>` implements the `Deref` trait, with `Target` being `String`. The function `hello` takes a `&str`. When we call `hello(&m)`, Rust automatically references `m` (which is of type `&MyBox<String>`) to `&String`, and then to `&str`. This is Deref coercion.

Without Deref coercion, we would have to write `hello(&(*m)[..])`, which is less ergonomic and harder to read.

```rust
hello(&(*m)[..]);
```

## Running Code on Cleanup with the Drop Trait

The `Drop` trait in Rust provides a way to run some code when a value goes out of scope. This is especially useful when dealing with resources that need to be cleaned up or freed when we're done using them, like files or network connections. By implementing the `Drop` trait on a type, we can specify what happens when a value of that type is no longer needed. This allows us to add cleanup code in a structured and predictable way, and Rust will automatically call `drop` for us at the appropriate time.

>**Note:** Rust uses a concept called RAII (Resource Acquisition Is Initialization). This means when an object goes out of scope, its destructor (a `drop` function in Rust) is called and its owned resources are freed. This helps prevent many common issues associated with manual resource management.
>
> However, it's still a good practice to close connections (like those to a database or a file) as soon as you're done with them. While Rust will automatically close the connection when the object goes out of scope, keeping a connection open longer than necessary can potentially lead to performance issues, especially in programs that handle a large number of connections. So, good resource management practices are still important in Rust.

In the exmaple below, we define a struct `CustomSmartPointer` that holds a `String` value. We implement the `Drop` trait for `CustomSmartPointer` to specify what happens when a `CustomSmartPointer` instance goes out of scope.

```rust
struct CustomSmartPointer {
    data: String,
}

impl Drop for CustomSmartPointer {
    fn drop(&mut self) {
        println!("Dropping CustomSmartPointer with data `{}`!", self.data)
    }
}

fn main() {
    let _c: CustomSmartPointer = CustomSmartPointer {
        data:String::from("my stuff")
    };

    let _d: CustomSmartPointer = CustomSmartPointer {
        data:String::from("other stuff")
    };

    println!("CustomSmartPointer Created");
}
```

The `Drop` trait is included in the prelude, so we don’t need to bring it into scope. We implement the `Drop` trait on `CustomSmartPointer` and provide an implementation for the `drop` method that calls `println!`. The body of the `drop` function is where you would place any logic that you wanted to run when an instance of your type goes out of scope. We’re printing some text here to demonstrate visually when Rust will call `drop`.

In `main`, we create two instances of `CustomSmartPointer` and then print "CustomSmartPointers created". At the end of `main`, our instances of `CustomSmartPointer` will go out of scope, and Rust will call the code we put in the `drop` method, printing our final message.

### Dropping a Value Early with std::mem::drop

Unfortunately, it’s not straightforward to disable the automatic `drop` functionality. Disabling `drop` isn’t usually necessary; the whole point of the `Drop` trait is that it’s taken care of automatically. Occasionally, however, you might want to clean up a value early. One example is when using smart pointers that manage locks: you might want to force the `drop` method that releases the lock so that other code in the same scope can acquire the lock. Rust doesn’t let you call the `Drop` trait’s `drop` method manually; instead you have to call the `std::mem::drop` function provided by the standard library if you want to force a value to be dropped before the end of its scope.

If we try to call the `Drop` trait’s `drop` method manually, we'll get a compile-time error. This is because Rust doesn't allow explicit calls to `drop` to prevent double cleanup of resources. The `Drop` trait's `drop` method is automatically called when a value goes out of scope, and manually calling `drop` would interfere with this process. If you need to force a value to be dropped early, you can use the `std::mem::drop` function instead.

```rust
use std::mem::drop;

```rust
struct CustomSmartPointer {
    data: String,
}

impl Drop for CustomSmartPointer {
    fn drop(&mut self) {
        println!("Dropping CustomSmartPointer with data `{}`!", self.data)
    }
}

fn main() {
    let _c: CustomSmartPointer = CustomSmartPointer {
        data:String::from("my stuff")
    };

    println!("CustomSmartPointer `_c` Created");

    drop(_c);

    let _d: CustomSmartPointer = CustomSmartPointer {
        data:String::from("other stuff")
    };

    println!("CustomSmartPointer `_d` Created");
}
```

In this example, we create an instance of `CustomSmartPointer` and then print a message. We then call `std::mem::drop` and pass `_c` to it. This will force Rust to drop the value `_c` immediately, and the `drop` method will be called. We then create another instance of `CustomSmartPointer` and print another message. When `_d` goes out of scope at the end of `main`, Rust will call `drop` on it as well.

## Hypothesis

Having understood how `Box<T>` works, it's clear that values stored on the heap, such as those in `Vec<T>` or `String`, can be considered as types of smart pointers.

## The Reference Counted Smart Pointer

In the majority of cases, ownership is clear: you know exactly which variable owns a given value. However, there are cases when a single value might have multiple owners. For example, in graph data structures, multiple edges might point to the same node, and that node is conceptually owned by all of the edges that point to it. A node shouldn't be cleaned up unless it doesn't have any edges pointing to it.

You have to enable multipe ownership explicitly by using the Rust type `Rc<T>`, which is an abbreviation for *Reference Counted*. The `Rc<T>` type keeps track of the number of references to a value to determine whether or not the value is still in use. If there are zero references to a value, the value can be cleaned up without any references becoming invalid.

Imagine `Rc<T>` as a TV in a family room. When one person enters to watch TV, they turn it on. Others can come into the room and watch the TV. When the last person leaves the room, they turn off the TV because it’s no longer being used. If someone turns off the TV while others are still watching it, there would be uproar from the remaining TV watchers!

We use the `Rc<T>` type when we want to allocate some data on the heap for multiple parts of our program to read and we can’t determine at compile time which part will finish using the data last. If we knew which part would finish last, we could just make that part the data’s owner, and the normal ownership rules enforced at compile time would take effect.

## Interior Mutability Pattern

The interior mutability is a design pattern in Rust that allows you to mutate data even when there are immutable references to that data. According to the Rust borrowing rules, you can't have mutable and immutable references to the same data in the same scope, and normally this action is disallowed by the borrowing rules. To mutate data the pattern use is to use `unsafe` code inside a data structure to bend Rust's usual rules around mutation and borrowing.

>**Note:** Just to remember the borrowing rules of Rust, At any given time, you can have either one mutable reference or any number of immutable references, but not both at the same time. Good Luck!

### Enforcing Borrowing Rules at Runtime with `RefCell`

`RefCell<T>` is a type in Rust that allows you to bypass Rust's usual static borrowing rules. It enforces the single ownership rule, but allows mutable borrowing. This means you can have multiple references to the `RefCell<T>`, but only one of them can be mutable at a time. This is checked at runtime rather than compile time, which is why `RefCell<T>` is said to provide "interior mutability".

In contrast to `Rc<T>`, which allows multiple owners of the same data but only provides immutable access, `RefCell<T>` allows you to mutate the data it holds, but enforces a kind of "single ownership" at any given moment. This makes `RefCell<T>` useful in situations where you need to mutate data that is shared across different parts of your program.

But their is a trade-off, `RefCell<T>` could panic your code during runtime if you don't use it with care. The `RefCell<T>` type is useful when you're sure your code won't crash.

>**Note:** Check the `halting problem`.

#### Recap of the `Rc`, `RefCell` and `Box` Smart Pointers

- `Rc<T>` enables multiple owners of the same data; `Box<T>` and `RefCell<T>` have single owners.
- `Box<T>` allows immutable or mutable borrows checked at compile time; `Rc<T>` allows only immutable borrows checked at compile time; `RefCell<T>` allows immutable or mutable borrows checked at runtime.
- Because `RefCell<T>` allows mutable borrows checked at runtime, you can mutate the value inside the `RefCell<T>` even when the `RefCell<T>` is immutable.

### Interior Mutability: A Mutable Borrow to an Immutable Value

A Consequence of the borrowing rules is that when you have an immutable reference to a value, you can't borrow it mutably. For example this code won't compile:

```rust
fn main() {
    let x = 5;
    let y = &mut x;
}
```

### Keeping Track of Borrows at Runtime with `RefCell`

When creating immutable and mutable references in Rust, we use the `&` and `&mut` syntax, respectively. However, with `RefCell<T>`, we use the `borrow` and `borrow_mut` methods, which are part of the safe API that belongs to `RefCell<T>`.

The `borrow` method returns the smart pointer type `Ref<T>`, and `borrow_mut` returns the smart pointer type `RefMut<T>`. Both types implement `Deref`, so we can treat them like regular references.

The `RefCell<T>` keeps track of how many `Ref<T>` and `RefMut<T>` smart pointers are currently active. Every time we call `borrow`, the `RefCell<T>` increases its count of how many immutable borrows are active. When a `Ref<T>` value goes out of scope, the count of immutable borrows goes down by one.

Just like the compile-time borrowing rules, `RefCell<T>` lets us have many immutable borrows or one mutable borrow at any point in time. If we try to violate these rules, rather than getting a compiler error as we would with references, the implementation of `RefCell<T>` will panic at runtime.

## Reference Cycle Can Leak Memory

In Rust, "memory safety" is a core guarantee provided by the language to prevent bugs related to memory, such as null pointer dereferencing, dangling pointers, or buffer overflows. These are prevented at compile time by Rust's ownership and borrowing system.

However, memory leaks, where memory is allocated but never freed, are not considered a violation of memory safety in Rust. This is because they don't lead to the same kind of unpredictable behavior that other memory bugs do. While they can cause your program to use more memory over time, they don't cause your program to do something completely unexpected, which is what Rust's memory safety guarantees are designed to prevent.

Therefore, while Rust does a lot to prevent memory bugs, it doesn't guarantee that your program will be free of memory leaks. This means that, in Rust, memory leaks are considered to be memory safe.

### 🔄 Memory Leaks with Rc and RefCell in Rust

Rust allows memory leaks to occur when using `Rc<T>` and `RefCell<T>`. It's possible to create references where items refer to each other in a cycle. This creates memory leaks because the reference count of each item in the cycle will never reach 0, and the values will never be dropped.

This scenario is a demonstration of how memory leaks can occur in Rust: when circular references are created using `Rc<T>` and `RefCell<T>`, the reference count will never decrease to zero because each item is still being referenced. As a result, the values will not be dropped, leading to a memory leak. Despite this, such memory leaks are still considered memory safe in Rust, as they do not lead to the kind of unpredictable behavior that Rust's memory safety guarantees aim to prevent.

To see how this leak memory occurs, consider the following example:

```rust
use crate::List::{Cons, Nil};
use std::cell::RefCell;
use std::rc::Rc;

#[derive(Debug)]
enum List {
    Cons(i32, RefCell<Rc<List>>),
    Nil,
}

impl List {
    fn tail(&self) -> Option<&RefCell<Rc<List>>> {
        match self {
            Cons(_, item) => Some(item),
            Nil => None,
        }
    }
}

fn main() {
    let a = Rc::new(Cons(5, RefCell::new(Rc::new(Nil))));

    println!("a initial rc count = {}", Rc::strong_count(&a));
    println!("a next item = {:?}", a.tail());

    let b = Rc::new(Cons(10, RefCell::new(Rc::clone(&a))));

    println!("a rc count after b creation = {}", Rc::strong_count(&a));
    println!("b initial rc count = {}", Rc::strong_count(&b));
    println!("b next item = {:?}", b.tail());

    if let Some(link) = a.tail() {
        *link.borrow_mut() = Rc::clone(&b);
    }

    println!("b rc count after changing a = {}", Rc::strong_count(&b));
    println!("a rc count after changing a = {}", Rc::strong_count(&a));

    // Uncomment the next line to see that we have a cycle;
    // it will overflow the stack
    // println!("a next item = {:?}", a.tail());
}
```

In the code above we have an enum `List` that represents a cons list. The `Cons` variant holds an `i32` value and a `RefCell<Rc<List>>` that holds the next item in the list. The `Nil` variant represents the end of the list.

Then we implement a method `tail` to the `List` enum that returns the next item in the list. To understand that in this example -> `(1, (2, (3, Nil)))` we can see 3 chained `Cons` and the last one is `Nil`. We can see the first value `1` tail would be `2` and the tail of `2` would be `3` and the tail of `3` would be `Nil`. So that what the `tail` method would return.

Then we create a `Rc<List>` instance `a` that holds a `Cons` variant with the value `5` and a `RefCell<Rc<List>>` that holds a `Nil` variant. We then create another `Rc<List>` instance `b` that holds a `Cons` variant with the value `10` and a `RefCell<Rc<List>>` that holds `a`.

We then change the value of `a` to hold `b` instead of `Nil`. This creates a cycle: `a` points to `b`, and `b` points to `a`. This means that the reference count of each item in the cycle will never reach 0, and the values will never be dropped, leading to a memory leak.

In the comments, we can see that if we try to print the tail of `a`, it will overflow the stack. This is because the `println!` macro tries to print the `Rc<List>` instance, which in turn tries to print the `Rc<List>` instance, and so on, leading to an infinite loop.

Cool but not cool, right? 😅. Cool for us, not cool for the program.

In Rust, the reference count of the `Rc<List>` instances in both `a` and `b` are 2 after we change the list in `a` to point to `b`. At the end of `main`, Rust drops the variable `b`, which decreases the reference count of the `b Rc<List>` instance from 2 to 1. The memory that `Rc<List>` has on the heap won’t be dropped at this point, because its reference count is 1, not 0.

Then Rust drops `a`, which decreases the reference count of the `a Rc<List>` instance from 2 to 1 as well. This instance’s memory can’t be dropped either, because the other `Rc<List>` instance still refers to it. The memory allocated to the list will remain uncollected for the duration of the program's execution. This is a demonstration of how memory leaks can occur in Rust due to circular references and the reference counting mechanism of `Rc<T>`.

Creating reference cycles is not easily done, but it’s not impossible either. If you have `RefCell<T>` values that contain `Rc<T>` values or similar nested combinations of types with interior mutability and reference counting, you must ensure that you don’t create cycles; you can’t rely on Rust to catch them. Creating a reference cycle would be a logic bug in your program that you should use automated tests, code reviews, and other software development practices to minimize.

>**Note:** Fun fact to understand that a memory leak persists only during the runtime of the program. After the program has finished executing, all the memory allocated on the heap by the program is reclaimed by the operating system. Dont be like me and think that this memory leak will persist forever.

### Preventing Reference Cycles: Turning an `Rc<T>` into a `Weak<T>`

So far we have demonstrated how `Rc::clone` increases the `strong_count` of an `Rc<T>` instance, and an `Rc<T>` instance is only cleaned up if it's `strong_count` is 0. However, `Rc<T>` also has a `weak_count`, which is the number of `Weak<T>` references to the value inside the `Rc<T>`, but it doesn't affect whether or not the value will be cleaned up. Strong refernces are how you can share ownership of an `Rc<T>` instance. Weak references don't express an ownership relationship, and their count doesn't affect when an `Rc<T>` instance is cleaned up. They won’t cause a reference cycle because any cycle involving some weak references will be broken once the strong reference count of values involved is 0.

When you call `Rc::downgrade`, you get a smart pointer of type `Weak<T>`. Instead of increasing the `strong_count`, `Rc::downgrade` increases the `weak_count`. You can then call `Weak::upgrade` to get an `Option<Rc<T>>` from a `Weak<T>`, which will return `Some` if the `Rc<T>` value has not been dropped yet and `None` if the `Rc<T>` value has been dropped.
