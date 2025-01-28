# Advanced Functions and Closures in Rust 🦀

## Function Pointers

You can pass regular functions to functions just as passing closures! This technique is useful when you pass a function you've already defined rather than defining a new closure. Functions coerce to the type `fn` (*with a lowercase f*), not be confused with the `Fn` closure trait. The `fn` type is called *function pointer*. Passing functions with function pointers is a way to pass functions as arguments to other functions.

Consider the following example: We define a function `add_one` that accepts an `i32` and returns an `i32`. We also define another function `do_twice` that accepts two parameters: a function pointer `f` and an `i32`. The `do_twice` function applies the function `f` to the `i32` argument twice and returns the sum of these two applications.

```rust
fn add_one(x: i32) -> i32 {
    x + 1
}

fn do_twice(f: fn(i32) -> i32, arg: i32) -> i32 {
    f(arg) + f(arg)
}

fn main() {
    let answer: i32 = do_twice(add_one, 5);

    println!("The answer is: {}", answer);
}
```

This code prints `The answer is: 12`. The `do_twice` function takes a function `f` as its first parameter and an `i32` as its second parameter. It calls the function `f` twice, passing the `i32` argument to `f` both times, and returns the sum of the two return values.

Unlike closures, `fn` is a type rather than a trait, so we specify `fn` as the parameter type directly rather than declaring a generic type parameter with one of the `Fn` trait as bound.

Functions pointers implement all three of the closure traits (`Fn`, `FnMut` and `FnOnce`), so you can always pass a function pointer as an argument for a function that expects a closure. It’s best to write functions using a generic type and one of the closure traits so your functions can accept either functions or closures.

As an example of where you could use either a closure defined inline or a named function, let's look at a use of the `map` method by the `Iterator` trait in the standard library. To use the `map` function to turn a vector of numbers into a vector of `String`, we could use a closure like this:

```rust
let list_of_numbers = vec![1, 2, 3];
let list_of_strings: Vec<String> = list_of_numbers
    .iter()
    .map(|i| i.to_string())
    .collect();
```

Or we could name a function as the argument to `map` instead of the closure:

```rust
fn main() {
    let list_of_numbers = vec![1, 2, 3];
    let list_of_strings: Vec<String> = list_of_numbers
        .iter()
        .map(ToString::to_string)
        .collect();
}
```

Here we are using the `to_string` method defined in the `ToString` trait, which the standard library has implemented for any type that implements the `Display` trait. This code will have the same effect as the closure in the previous example.

Also in the `enum`, the name of each enum work as an initializer function, and we can use this function as argument for methods that takes closure:

```rust
enum Status {
    Value(u32),
    Stop,
}

let list_of_status: Vec<Status> = (0u32..20)
    .map(Status::Value)
    .collect();
```

Here we create `Status::Value` instances using each `u32` value in the range that `map` is called on by using the initializer function of `Status::Value`.

## Returning Closures

Closure are represented as traits, which means you can't return closures directly. In most cases where you might want to return a trait, you can instead use the concrete type that implements the trait as the return value of the function. However, you can't do that with closures because they don't have a concrete type that is returnable; you're not allowed to use the function pointer `fn` as a return type, for example:

```rust
fn returns_closure() -> dyn Fn(i32) -> i32 {
    |x| x + 1
}
```

This would enter in an error because the error reference the `Sized` trait, indicating the Rust Compiler doesn't know how much space it will need to store the closure. The `Sized` trait is a trait that Rust implements by default on every type, and this is the error message that the Rust compiler gives us when we try to return a closure directly.

to fix this error, we can use a `Box` to return a closure:

```rust
fn returns_closure() -> Box<dyn Fn(i32) -> i32> {
    Box::new(|x| x + 1)
}
```
