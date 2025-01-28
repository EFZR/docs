# Unsafe Rust 🦀

All the code we've discussed so far has had Rust's memory safety guarantees enforced at compile time. However, Rust has a second language hidden inside it that doesn't enforce these safety guarantees: it's called *unsafe Rust* and works just like regular Rust, but give us extra superpowers.

**Unsafe Rust** exists because, by nature, static analysis is conservative. When the compiler tries to determine whether or not code upholds the guarantees, it's better for it to reject some valid programs than to accept invalid program. Although the code might be okay, if the Rust compiler
doesn't have enough information to be sure, it will reject it. In these cases, you can use unsafe code to tell the compiler, "Trust me, I know what I'm doing". Be warned, however, that you use unsafe Rust at your own risk. If you use unsafe code incorrectly, you can cause problems like null pointer dereferencing, buffer overflows, and other memory safety violations.

Another reason Rust has an unsafe alter ego is that the underlying computer hardware is inherently unsafe. If Rust didn’t let you do unsafe operations, you couldn’t do certain tasks. Rust needs to allow you to do low-level systems programming, such as directly interacting with the operating system or even writing your own operating system. Working with low-level systems programming is one of the goals of the language. Let’s explore what we can do with unsafe Rust and how to do it.

## Index

1. [Unsafe Superpowers](#unsafe-superpowers)
2. [Dereferencing a Raw Pointer](#dereferencing-a-raw-pointer)
    - [Why use Raw Pointers?](#why-use-raw-pointers)
3. [Calling an Unsafe Function or Method](#calling-an-unsafe-function-or-method)
    - [Creating a Safe Abstraction over Unsafe Code](#creating-a-safe-abstraction-over-unsafe-code)
    - [Using `extern` Functions to Call External Code](#using-extern-functions-to-call-external-code)
        - [Application Binary Interface (ABI)](#application-binary-interface-abi)
        - [Calling Function from other Languages](#calling-function-from-other-languages)
4. [Access or Modify a Mutable Static Variable](#accessing-or-modifying-a-mutable-static-variable)
5. [Implement an Unsafe Trait](#implementing-an-unsafe-trait)
6. [Access Fields of Unions](#accessing-fields-of-unions)
7. [Summary](#summary)

## `Unsafe` Superpowers

To switch to unsafe Rust, use the `unsafe` keyword and then start a new block that holds the unsafe code. You can take four actions in unsafe Rust, called *unsafe superpowers*:

- [Dereference a raw pointer](#dereferencing-a-raw-pointer)
- [Call an unsafe function or method](#calling-an-unsafe-function-or-method)
- [Access or modify a mutable static variable](#accessing-or-modifying-a-mutable-static-variable)
- [Implement an unsafe trait](#implementing-an-unsafe-trait)
- [Access fields of `unions`](#accessing-fields-of-unions)

It’s important to understand that `unsafe` doesn’t turn off the borrow checker or disable any other of Rust’s safety checks: if you use a reference in `unsafe` code, it will still be checked. The `unsafe` keyword only gives you access to these five features that are then not checked by the compiler for memory safety. You’ll still get some degree of safety inside of an `unsafe` block.

In addition, `unsafe` does not means the code inside the block is dangerous or that it will definitely have memory safety bugs. The `unsafe` keyword is just a way to tell Rust that we, the programmer, will ensure the code inside the `unsafe` block will be memory safe.

To isolate unsafe code as much as possible, it’s best to enclose unsafe code within a safe abstraction and provide a safe API, which we’ll discuss later in the chapter when we examine unsafe functions and methods. Parts of the standard library are implemented as safe abstractions over unsafe code that has been audited. Wrapping unsafe code in a safe abstraction prevents uses of `unsafe` from leaking out into all the places that you or your users might want to use the functionality implemented with `unsafe` code, because using a safe abstraction is safe.

## Dereferencing a Raw Pointer

The Rust compiler ensures references are always valid. Unsafe Rust has two new types called *raw pointers* that are similar to references. As with references, raw pointers can be immutable or mutable and are written as `*const T` and `*mut T`, respectively. The asterisk isn’t the dereference operator; it’s part of the type name.

In the context of Raw Pointers:

- An `immutable` raw pointer, once dereferenced, cannot be used to directly modify the value it points to. This is similar to a constant in other languages. You can think of it as a read-only pointer. It allows you to look at the data it points to, but not change it.

- A `mutable` raw pointer, on the other hand, can be used to directly modify the value it points to after it has been dereferenced. This is similar to a variable in other languages. It's a read-write pointer. You can both look at the data it points to and change it.

Different from references and Smart Pointers, raw pointers:

- Are allowed to ignore the borrowing rules by having both immutable and mutable pointers or multiple mutable pointers to the same location
- Aren’t guaranteed to point to valid memory
- Are allowed to be null
- Don’t implement any automatic cleanup

In the next example, shows how to create a raw pointer from a reference

```rust
let mut num = 5;

let r1 = &num as *const i32;
let r2 = &mut num as *mut i32;
```

Notice that don't include the `unsafe` keyword in this code. We can create raw pointers in safe code; we just can't dereference raw pointers outside an `unsafe` block, because we can't guarantee the safety of the code around the raw pointers.

We’ve created raw pointers by using `as` to cast an immutable and a mutable reference into their corresponding raw pointer types. Because we created them directly from references guaranteed to be valid, we know these particular raw pointers are valid, but we can’t make that assumption about just any raw pointer.

To demonstrate how a raw pointer validity might be uncertain, in the example below we create a raw pointer to an arbitrary location in memory. Trying to use arbitrary memory is undefined: there might be data at that address or there might not, the compiler might optimize the code so there is no memory access, or the program might error with a segmentation fault. Usually there is no reason to create code like this, but it is possible.

```rust
let address = 0x012345usize;
let r = address as *const i32;
```

Remeber we can create raw pointers in safe code, but we can't dereference raw pointers outside an `unsafe` block, because we can't guarantee the safety of the code around the raw pointers. In the example below we use the dereference operator `*` to follow the raw pointer to the data it’s pointing to.

```rust
let mut num = 5;

let mut r1 = &num as *const i32;
let mut r2 = &mut num as *mut i32;

unsafe {
    println!("r1 is: {}", *r1);
    println!("r2 is: {}", *r2);
}
```

Creating a pointer does no harm; it’s only when we try to access the value that it points at that we might end up dealing with an invalid value.

### Why use Raw Pointers?

One major use case is when interfacing with C code, as you’ll see in the next section, “Calling an Unsafe Function or Method.” Another case is when building up safe abstractions that the borrow checker doesn’t understand. We’ll introduce unsafe functions and then look at an example of a safe abstraction that uses unsafe code.

## Calling an Unsafe Function or Method

Unsafe functions and methods look exactly like regular functions and methods, but they have an extra `unsafe` keyword before the rest of the definition. The `unsafe` keyword in this context indicates the function has requirements we need to uphold when we call this function, because Rust can't guarantee we've met these requirements. By calling an unsafe function within an unsafe block, we are saying that we've read this function's documentation and take responsibility for upholding the function's contracts.

In the code below we create an unsafe function named `dangerous` that doesn't do anything in its body:

```rust
unsafe fn dangerous() {
    println!("This is an unsafe function");
}

fn main() {
    unsafe {
        dangerous();
    }
}
```

We must call the unsafe function inside an `unsafe`, if not we would get a compile error. The `unsafe` block indicates that we, as the programmer, are taking responsibility for calling the unsafe function in this code.

### Creating a Safe Abstraction over Unsafe Code

Just because a function cotains unsafe code doesn't mean we have to mark the entire function as unsafe. In fact, wrapping unsafe code in a safe abstraction is a common way to use unsafe code is a common abstraction.

As an example we will study the `split_at_mut` method. This method is a safe abstraction over the unsafe code that splits a slice into two slices at a particular index. The method signature is:

```rust
let mut v = vec![1, 2, 3, 4, 5, 6];

let r = &mut v[..];

let (a, b) = r.split_at_mut(3);

assert_eq!(a, &mut [1, 2, 3]);
assert_eq!(b, &mut [4, 5, 6]);
```

We can't implement this function using only safe Rust, An attempt might look like this:

```rust
fn split_at_mut(slice: &mut [i32], mid: usize) -> (&mut [i32], &mut [i32]) {
    let len = slice.len();

    assert!(mid <= len);

    (&mut slice[..mid], &mut slice[mid..])
}
```

This function first gets the total length of the slice. Then it asserts that the index given as a parameter is within the slice by checking whether it’s less than or equal to the length. The assertion means that if we pass an index that is greater than the length to split the slice at, the function will panic before it attempts to use that index.

Then we return two mutable slices in a tuple: one from the start of the original slice to the `mid` index and another from `mid` to the end of the slice.

This would result in an compile error because the borrow checker can't understand that we're borrowing different parts of the slice, that is fundamentally ok because the two slice are not overlapping, but Rust isn’t smart enough to know this. When we know code is okay, but Rust doesn’t, it’s time to reach for unsafe code.

The implementation of `split_at_mut` using unsafe code is:

```rust
fn split_at_mut(slice: &mut [i32], mid: usize) -> (&mut [i32], &mut [i32]) {
    let len = slice.len();
    let ptr = slice.as_mut_ptr();

    assert!(mid <= len);

    unsafe {
        (
            std::slice::from_raw_parts_mut(ptr, mid),
            std::slice::from_raw_parts_mut(ptr.add(mid), len - mid),
        )
    }
}
```

**Slices** are a pointer to some data and the length of the slice. We use the `len` method to get the length of a slice and the `as_mut_ptr` method to access the raw pointer of a slice. In this case, because we have a mutable slice to `i32` values, `as_mut_ptr` returns a raw pointer with the type `*mut i32`, which we’ve stored in the variable `ptr`.

We keep the assertion that the `mid` index is within the slice. Then we get to the unsafe code: the `slice::from_raw_parts_mut` function takes a raw pointer and a length, and it creates a slice. We use this function to create a slice that starts from `ptr` and is `mid` items long. Then we call the `add` method on `ptr` with `mid` as an argument to get a raw pointer that starts at `mid`, and we create a slice using that pointer and the remaining number of items after `mid` as the length.

The function `slice::from_raw_parts_mut` is unsafe because it takes a raw pointer and must trust that this pointer is valid. The `add` method on raw pointers is also `unsafe`, because it must trust that the offset location is also a valid pointer. Therefore, we had to put an unsafe block around our calls to `slice::from_raw_parts_mut` and `add` so we could call them. By looking at the code and by adding the assertion that `mid` must be less than or equal to len, we can tell that all the raw pointers used within the unsafe block will be valid pointers to data within the slice. This is an acceptable and appropriate use of `unsafe`.

Note that we don’t need to mark the resulting `split_at_mut` function as `unsafe`, and we can call this function from safe Rust. We’ve created a safe abstraction to the `unsafe` code with an implementation of the function that uses unsafe code in a safe way, because it creates only valid pointers from the data this function has access to.

### Using `extern` Functions to Call External Code

Sometimes, your Rust code might need to interact with code written in another language. For this, Rust has a keyword, `extern` that facilitates the creation and use of a *Foreign Function Interface (FFI)*.

An **FFI** is a way for a programming language to define functions and a different (foreing) programming language to call those functions. Each language has its own FFI, and Rust has a particularly powerful one. The `extern` keyword is used to create an interface to the functions written in another language.

In the example below demonstrates how to set up an integration with the `abs` function from the C standard library, extern functions are always unsafe to call to Rust code. The reason is that other languages don't enforce Rust's rules and guarantees, so we need to be careful when calling code from other languages.

```rust
extern "C" {
    fn abs(input: i32) -> i32;
}

fn main() {
    unsafe {
        println!("Absolute value of -3 according to C: {}", abs(-3));
    }
}
```

Within the `extern "C"` block, we list the names and signatures of external functions from another language we want to call. The `"C"` part defines which *application binary interface (ABI)* the external function uses: the ABI defines how to call the function at the assembly level. The "C" ABI is the most common and follows the C programming language’s ABI.

#### Application Binary Interface (ABI)

An Application Binary Interface (ABI) is a specification that defines how different software components should interact at a binary level. It's essentially a contract between two binary program modules.

In the context of programming languages, an ABI often includes:

- **Calling Convention:** This dictates how functions' arguments are passed and return values retrieved.
- **Data Format:** The format of the binary data.
- **Type Sizes, Layouts, and Alignments:** These define the sizes, layouts, and alignments of types.
- **Object File Format:** This organizes machine code, read-only data, and uninitialized data.

In the context of the Rust code, the `"C"` in `extern "C"` specifies that the external function uses the C ABI. This means that the Rust compiler will use the rules and conventions of the C language's ABI when compiling the `abs` function call. This is necessary for the Rust code to correctly interface with the C code.

#### Calling Function from other Languages

We can also use `extern` to create an interface that allows other languages to call Rust functions. Instead of creating a whole `extern` block, we add the `extern` keyword and specify the ABI to use just before the `fn` keyword for the relevant function. We also need to add a `#[no_mangle]` annotation to tell the Rust compiler not to mangle the name of this function. Mangling is when a compiler changes the name we’ve given a function to a different name that contains more information for other parts of the compilation process to consume but is less human readable. Every programming language compiler mangles names slightly differently, so for a Rust function to be nameable by other languages, we must disable the Rust compiler’s name mangling.

In the following example, we make the `call_from_c` function accessible from C code, after it’s compiled to a shared library and linked from C:

```rust
#[no_mangle]
pub extern "C" fn call_from_c() {
    println!("Just called a Rust function from C!");
}
```

## Accessing or Modifying a `Mutable Static` Variable

Static Variables in Rust are *Global Varaible* are variable that are available in any part of the program. They are stored in the read-only memory of the program and are initialized only once. They are used to store data that is not going to be changed during the entire program.

In the code below there is an example of a *Global Variable*:

```rust
static HELLO_WORLD: &str = "Hello, world!";

fn main() {
    println!("Name is :{}", HELLO_WORLD);
}
```

Static Variable are `SCREAMING_SNAKE_CASE` by convention, and can only store references with the `'static` lifetime, which the Rust compiler can figure out the lifetime of the reference would be for the entire duration of the program.

A subtle difference between constants and immutable static variables is that values in a static variable have a fixed address in memory. Using the value will always access the same data. Constants, on the other hand, are allowed to duplicate their data whenever they’re used.

Another difference is that static variables can be mutable. However, accessing and modifying mutable static variables is unsafe due to the potential for data races. This is why any access to mutable static variables must be wrapped in an `unsafe` block in Rust.

In the example below we create a `'static` mutable variable named `COUNTER`:

```rust
static mut COUNTER: u32 = 0;

fn add_to_count(inc: u32) {
    unsafe {
        COUNTER += inc;
    }
}

fn main() {
    add_to_count(3);

    unsafe {
        println!("COUNTER: {}", COUNTER);
    }
}
```

As with regular variables, we specify mutability using the `mut` keyword. Any code that reads or writes from `COUNTER` must be within an `unsafe` block. This code compiles and prints `COUNTER: 3` as we would expect because it’s single threaded. Having multiple threads access `COUNTER` would likely result in data races.

## Implementing an Unsafe Trait

We can use `unsafe` to implement an unsafe trait. A trait is unsafe when at least one of its methods has some invariant that the compiler can’t verify. We declare that a trait is `unsafe` by adding the `unsafe` keyword before `trait` and marking the implementation of the trait as `unsafe` too, as shown in the example below:

```rust
unsafe trait Foo {
    // methods go here
}

unsafe impl Foo for i32 {
    // method implementations go here
}

fn main() {}
```

By using `unsafe impl`, we’re promising that we’ll uphold the invariants that the compiler can’t verify.

## Accessing Fields of `Unions`

The final action that works only with `unsafe` is accessing fields of a *union*. A `union` is similar to a `struct`, but only one declared field is used in a particular instance at one time. Unions are primarily used to interface with unions in C code. Accessing union fields is unsafe because Rust can’t guarantee the type of the data currently being stored in the union instance.

## Summary

Using `unsafe` to take one of the five actions (superpowers) just discussed isn’t wrong or even frowned upon. But it is trickier to get `unsafe` code correct because the compiler can’t help uphold memory safety. When you have a reason to use `unsafe` code, you can do so, and having the explicit `unsafe` annotation makes it easier to track down the source of problems when they occur.
