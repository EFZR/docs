# Understanding Ownership in Rust 🦀

## Index

1. [What is ownership?](#what-is-ownership)
1. [Previous concepts](#previous-concepts)
    - [Stack and Heap](#stack-and-heap)
1. [Ownership Rules](#ownership-rules)
    - [Variable Scope](#variable-scope)
    - [The String Type](#the-string-type)
    - [Memory and Allocation](#memory-and-allocation)
    - [Variables and Data Interactions](#variables-and-data-interactions)
    - [The String Type](#the-string-type)
    - [Stack-Only Data: Copy](#stack-only-data-copy)
    - [Ownership and Functions](#ownership-and-functions)
    - [Return Values and Scope](#return-values-and-scope)
1. [References and Borrowing](#references-and-borrowing)
    - [Mutable References](#mutable-references)
    - [Dangling References](#dangling-references)
1. [The slice Type](#the-slice-type)
1. [Conclusion of Ownership](#conclusion-of-ownership)

## What is ownership?

Ownership is a unique feature in Rust that allows for memory management without the need for a garbage collector. It operates through a system of rules that the compiler checks at compile time. Importantly, these ownership features do not slow down your program while it's running, providing efficient memory management.

## Previous concepts

They are some previous concepts that are important to understand:

### `Stack and Heap`

The stack and the heap are parts of memory that are available to your code to use at runtime, but they are structured in different ways. The stack stores values in the order it gets them and removes the values in the opposite order. This is referred to as last in, first out. All data stored on the stack must have a known, fixed size. Data with an unknown size at compile time or a size that might change must be stored on the heap instead. The heap is less organized: when you put data on the heap, you request a certain amount of space. The memory allocator finds an empty spot in the heap that is big enough, marks it as being in use, and returns a pointer, which is the address of that location. This process is called allocating on the heap and is sometimes abbreviated as just `allocating`.

## Ownership Rules

- Each value in Rust has a variable that’s called its `owner`.
- There can only be one owner at a time.
- When the owner goes out of scope, the value will be dropped.

### `Variable Scope`

The variable scope is the range within a program for which an item is valid.

```rust
fn main() {
    let s = "hello"; // s is valid from this point forward

    // do stuff with s
} // this scope is now over, and s is no longer valid
```

The variable `s` referes to a `string literal`, which is a hardcoded into the text of our program.

### `The String Type`

```rust
fn main() {
    let mut s = String::from("hello");

    s.push_str(", world!"); // push_str() appends a literal to a String

    println!("{}", s); // This will print `hello, world!`
}
```

In this case, `s` is a `String` type, which is allocated on the heap and as such is able to store an amount of text that is unknown to us at compile time. This string type is also growable, meaning it can be mutated.

The main difference between `String` and `string literal` is that `String` is allocated on the heap and can be mutated. `String literals` are immutable and stored in the program’s binary.

### `Memory and Allocation`

In the case of a `string literal`, we know the contents at compile time, so the text is hardcoded directly into the final executable. This is why string literals are fast and efficient. But these properties only come from the string literal’s immutability. Unfortunately, we can’t put a blob of memory into the binary for each piece of text whose size is unknown at compile time and whose size might change while running the program.

With the `String` type, in order to support a mutable, growable piece of text, we need to allocate an amount of memory on the heap, unknown at compile time, to hold the contents. This means:

- The memory must be requested from the operating system at runtime.
- We need a way of returning this memory to the operating system when we’re done with our `String`.

The first part is done by us: when we call `String::from`, its implementation requests the memory it needs. This is pretty much universal in programming languages.

The second part is done by Rust’s `drop` function. When a variable goes out of scope, Rust calls the `drop` function and cleans up the heap memory for that variable.

```rust
{
    let s = String::from("hello"); // s is valid from this point forward

    // do stuff with s
}                                  // this scope is now over, and s is no
                                   // longer valid
```

When `s` comes into scope, it is valid. It remains valid until it goes out of scope. This is when `drop` is called and the backing memory is freed.

`drop` is a function that is called automatically when a value goes out of scope, and it’s where the author of String can put the code to return the memory. Rust calls drop automatically at the closing curly bracket.

>**note:** In C++, this pattern of deallocating resources at the end of an item’s lifetime is sometimes called `Resource Acquisition Is Initialization (RAII)`. The drop function in Rust will be familiar to you if you’ve used RAII patterns.

### `Variables and Data Interactions`

```rust
fn main() {
    let x = 5;
    let y = x;
}
```

In this case, `x` is a `integer` type, which is allocated on the stack and as such is a fixed size. The `x` value is copied into `y` and both variables are valid.

```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1;
}
```

In this case, `s1` is a `String` type, which is allocated on the heap and as such is a unknown size. The `s1` value is moved into `s2` and `s1` is no longer valid. This is because Rust doesn’t copy the data, it invalidates the first variable. This is a problem because `s1` is no longer valid but we are still trying to use it.

This occurs because when `s2` is assigned to `s1`, the `String` data is copied, meaning we copy the pointer, the length, and the capacity that are on the stack. We do not copy the data on the heap that the pointer refers to.

If Rust did copy the `String`, the operation `s2 = s1` would be very expensive in terms of runtime performance if the data on the heap were large.

To ensure memory safety, there’s one more detail to what happens in this situation in Rust. Instead of trying to copy the allocated memory, Rust considers `s1` to no longer be valid and, therefore, Rust doesn’t need to free anything when `s1` goes out of scope. Check out what happens when you try to use `s1` after `s2` is created; it won’t work:

```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1;

     println!("{}, world!", s1);
}
```

If we want to deeply copy the heap data of the `String`, not just the stack data, we can use a common method called `clone`.

```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1.clone();

    println!("s1 = {}, s2 = {}", s1, s2);
}
```

The `clone` method will allocate new memory on the heap and copy the original string into it. This is why the `clone` operation is explicit: making a copy of something can be an expensive operation in terms of runtime performance.

### `Stack-Only Data: Copy`

```rust
fn main() {
    let x = 5;
    let y = x;

    println!("x = {}, y = {}", x, y);
}
```

In this case, `x` is a `integer` type, which is allocated on the stack and as such is a fixed size. The `x` value is copied into `y` and both variables are valid.

```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1;

    println!("s1 = {}, s2 = {}", s1, s2);
}
```

### `Ownership and Functions`

```rust
fn main() {
    let s = String::from("hello");  // s comes into scope

    takes_ownership(s);             // s's value moves into the function...
                                    // ... and so is no longer valid here

    let x = 5;                      // x comes into scope

    makes_copy(x);                  // x would move into the function,
                                    // but i32 is Copy, so it’s okay to still
                                    // use x afterward

} // Here, x goes out of scope, then s. But because s's value was moved, nothing
  // special happens.
fn takes_ownership(some_string: String) { // some_string comes into scope
    println!("{}", some_string);
} // Here, some_string goes out of scope and `drop` is called. The backing
    // memory is freed.

fn makes_copy(some_integer: i32) { // some_integer comes into scope
    println!("{}", some_integer);
} // Here, some_integer goes out of scope. Nothing special happens.
```

This example is similar to the previous one: the `String` value that `s` points to is moved into the function `takes_ownership` when it is called, and so is no longer valid in `main`. The `x` value is copied into the function `makes_copy`, so we still able to use `x` afterward in `main`.

### `Return Values and Scope`

```rust
fn main() {
    let s1 = gives_ownership();         // gives_ownership moves its return
                                        // value into s1

    let s2 = String::from("hello");     // s2 comes into scope

    let s3 = takes_and_gives_back(s2);  // s2 is moved into
                                        // takes_and_gives_back, which also
                                        // moves its return value into s3
} // Here, s3 goes out of scope and is dropped. s2 goes out of scope but was
  // moved, so nothing happens. s1 goes out of scope and is dropped.

fn gives_ownership() -> String {             // gives_ownership will move its
                                             // return value into the function
                                             // that calls it

    let some_string = String::from("hello"); // some_string comes into scope

    some_string                              // some_string is returned and
                                             // moves out to the calling
                                             // function
}

// takes_and_gives_back will take a String and return one
fn takes_and_gives_back(a_string: String) -> String { // a_string comes into
                                                       // scope

    a_string  // a_string is returned and moves out to the calling function
}
```

After all these explanations, we can conclude that:

- Returning values can also transfer ownership.
- Ownership can be transferred to a function and back.
- Ownership can be transferred to a function and can be returned from it.

## References and Borrowing

Instead of moving the ownership of a variable, we can use `references` to pass a variable value to a function. This is called `borrowing`.

A `reference` is like a pointer in that it’s an address we can follow to access the data stored at that address.

```rust
fn main() {
    let s1 = String::from("hello");

    let len = calculate_length(&s1);

    println!("The length of '{}' is {}.", s1, len);
}

fn calculate_length(s: &String) -> usize {
    s.len()
}
```

The `&s1` syntax lets us create a reference that refers to the value of `s1` but does not own it. Because it does not own it, the value it points to will not be dropped when the reference goes out of scope.

The ampersands in `&String` represent references, and they allow you to refer to some value without taking ownership of it.

It´s important to know that a reference can't be modified.

```rust
fn main() {
    let s = String::from("hello");

    change(&s);
}

fn change(some_string: &String) {
    some_string.push_str(", world");
}
```

This code will not compile because we are trying to modify a reference.

### `Mutable References`

We can use `&mut` to create a mutable reference. But we can only have one mutable reference to a particular piece of data in a particular scope.

```rust
fn main() {
    let mut s = String::from("hello");

    change(&mut s);
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}
```

Mutable references have one big restriction: if you have a mutable reference to a value, you can have no other references to that value. This code that attempts to create two mutable references to s will fail:

```rust
fn main() {
    let mut s = String::from("hello");

    let r1 = &mut s;
    let r2 = &mut s;

    println!("{}, {}", r1, r2);
}
```

Like this way, is not possible to create a mutable reference if we already have an immutable reference.

```rust
fn main() {
    let mut s = String::from("hello");

    let r1 = &s; // no problem
    let r2 = &s; // no problem
    let r3 = &mut s; // BIG PROBLEM

    println!("{}, {}, and {}", r1, r2, r3);
}
```

Note that a reference’s scope starts from where it is introduced and continues through the last time that reference is used. For instance, this code will compile because the last usage of the immutable references, the `println!`, occurs before the mutable reference is introduced:

```rust
fn main() {
    let mut s = String::from("hello");
    let r1 = &s; // no problem
    let r2 = &s; // no problem
    println!("{} and {}", r1, r2);

    let r3 = &mut s; // no problem
}
```

### `Dangling References`

In languages like C++ is normal to have dangle pointers, but in rust is not possible to have a `dangling reference`. Rust’s compiler guarantees that references will never be dangling references: if you have a reference to some data, the compiler will ensure that the data will not go out of scope before the reference to the data does just like this example:

```rust
fn main() {
    let reference_to_nothing = dangle();
}

fn dangle() -> &String {
    let s = String::from("hello");

    &s
}
```

The solution here is to return the String directly:

```rust
fn main() {
    let reference_to_nothing = no_dangle();
}

fn no_dangle() -> String {
    let s = String::from("hello");

    s
}
```

## The slice Type

A `slice` is a reference to a contiguous sequence of elements in a collection rather than the whole collection.

```rust
fn main() {
    let s = String::from("hello world");

    let hello = &s[0..5];
    let world = &s[6..11];
}
```

We can also use the `..` syntax to take the whole string.

```rust
fn main() {
    let s = String::from("hello");

    let slice = &s[..];
}
```

Also you can drop the value befor the `..` when you start from the first index

```rust
fn main() {
    let s = String::from("hello");

    let slice = &s[0..2];
    let slice = &s[..2];
}
```

And you can drop the value after the `..` when you end in the last index

```rust
fn main() {
    let s = String::from("hello");

    let len = s.len();

    let slice = &s[3..len];
    let slice = &s[3..];
}
```

## Conclusion of Ownership

With the ownership we understand that rust is low level programming language, because this maintain the security of the memory and the performance of the program checking the state of each variable in the compile time.

The rules for the ownership are:

- Each value in Rust has a variable that´s called its `owner`.
- There can only be one owner at a time.
- At the end of the scope of the varible/owner, the value will be `dropped`.

They are some extra rules I would like to aggregate:

- There is a way to check the value of a variable without losing the ownership, this is called `borrowing` and this is done with `references`.
- There can any number of references immutable to a particular piece of data in a particular scope.
- There can only be one mutable reference to a particular piece of data in a particular scope.

Also there are some concepts that are important to understand:

- **Stack:** All data stored on the stack are in the binary, so they don´t have an specific owner to be freed, this get freed when the variable goes out of scope and it´s done with the `LIFO` (Last In, First Out) order.
- **Heap:** All data stored on the heap are in the memory, so they have an specific owner to be freed, this get freed when the variable goes out of scope and it´s done with the `drop` function.

**References:** A reference the address of a value in memory.
