# Functional features of Rust 🦀

Rust’s design has taken inspiration from many existing languages and techniques, and one significant influence is functional programming. Programming in a functional style often includes using functions as values by passing them in arguments, returning them from other functions, assigning them to variables for later execution, and so forth.

## Index

1. [Closures](#closures)
    - [Capturing the environment](#capturing-the-environment)
    - [Closure Type Inference and Annotation](#closure-type-inference-and-annotation)
    - [Capturing references of moving Ownership](#capturing-references-of-moving-ownership)
        - [Borrowing immutable references](#borrowing-immutable-references)
        - [Borrowing mutable references](#borrowing-mutable-references)
        - [Taking ownership](#taking-ownership)
    - [Moving Captured Values Out of Closures and the Fn Traits](#moving-captured-values-out-of-closures-and-the-fn-traits)
2. [Proccessing a series of items with iterators](#proccessing-a-series-of-items-with-iterators)
    - [The Iterator Trait and the next Method](#the-iterator-trait-and-the-next-method)
    - [Method that consume the Iterator](#method-that-consume-the-iterator)
        - [Consume Methods examples for iterators](#consume-methods-examples-for-iterators)
    - [Method that produce other Iterators](#method-that-produce-other-iterators)
        - [Adaptor Methods examples for iterators](#adaptor-methods-examples-for-iterators)

## Closures

Closures in Rust are anonymous functions you can save in a variable or pass as arguments to other functions. They are similar to lambda functions in other languages.

A closure is defined using a set of pipes (`|`), followed by a set of parameters, a function body, and optionally a return type. The syntax is as follows:

```rust
let closure = |param1, param2| -> return_type {cd pro   cd
    // function body
};
```

One of the unique features of closures in Rust is their ability to capture values from the environment in which they are defined. This means they can use variables from the surrounding scope:

```rust
let x = 4;
let equal_to_x = |z| z == x;
let y = 4;
assert!(equal_to_x(y));
```

In this example, the closure `equal_to_x` captures the value of `x` from its surrounding environment and uses it to compare with the input parameter `z`. The `assert!` macro then verifies the equality of `y` and `x`. Since `y` equals `x`, the assertion passes successfully.

### Capturing the environment

We'll first examine how we can use `closures` to capture values from the `environment` they're defined in for later use. Here's the scenario: Every so often, our t-shirt company gives away an exclusive, limited-edition shirt to someone on our mailing list as a promotion. People on the mailing list can optionally add their favorite color to their profile. If the person chosen for a free shirt has their `favorite color` set, they get that color shirt. If the person hasn't specified a `favorite color`, they get whatever color the company currently has the most of.

```rust
#[derive(Debug, PartialEq, Copy, Clone)]
enum ShirtColor {
    Red,
    Blue,
}

struct Inventory {
    shirts: Vec<ShirtColor>,
}

impl Inventory {
    fn giveaway(&self, user_preference: Option<ShirtColor>) -> ShirtColor {
        user_preference.unwrap_or_else(|| self.most_stocked())
    }

    fn most_stocked(&self) -> ShirtColor {
        let mut num_red = 0;
        let mut num_blue = 0;

        for color in &self.shirts {
            match color {
                ShirtColor::Red => num_red += 1,
                ShirtColor::Blue => num_blue += 1,
            }
        }
        if num_red > num_blue {
            ShirtColor::Red
        } else {
            ShirtColor::Blue
        }
    }
}

fn main() {
    let store = Inventory {
        shirts: vec![ShirtColor::Blue, ShirtColor::Red, ShirtColor::Blue],
    };

    let user_pref1 = Some(ShirtColor::Red);
    let giveaway1 = store.giveaway(user_pref1);
    println!(
        "The user with preference {:?} gets {:?}",
        user_pref1, giveaway1
    );

    let user_pref2 = None;
    let giveaway2 = store.giveaway(user_pref2);
    println!(
        "The user with preference {:?} gets {:?}",
        user_pref2, giveaway2
    );
}
```

This exercise can be done different ways but in this particular case, we chose this way to understand how closures are used.

First, we define an enum `ShirtColor` with two variants: `Red` and `Blue`. This enum represents the possible colors of a shirt.

Next, we define a struct `Inventory` that represents a store's inventory of shirts. It has one field, `shirts`, which is a vector of `ShirtColor`.

We then implement two methods on `Inventory`: `giveaway` and `most_stocked`.

The `giveaway` method takes an `Option<ShirtColor>` representing a user's color preference. If the user has a preference (`Some(ShirtColor)`), it returns that color. If the user has no preference (`None`), it uses a closure in the `unwrap_or_else` method to call the `most_stocked` method. This closure, defined as `|| self.most_stocked()`, captures `self` from its environment and uses it to determine which color the store has the most of, and returns that color.

The `most_stocked` method iterates over the `shirts` vector and counts the number of `Red` and `Blue` shirts. It then returns the color that has the highest count.

In the `main` function, we create an instance of `Inventory` with a vector of shirts. We then simulate two giveaways: one where the user has a color preference, and one where the user has no preference. For each giveaway, we print the user's preference and the color of the shirt they receive.

### Closure Type `Inference` and `Annotation`

There are more differences between functions and closures. Closures don't usually require you to annotate the types of the parameters or the return value like `fn` functions do.

>**Note:** Type annotations are required on functions because the types are part of an explicit interface exposed to your users. Defining this interface rigorously is important for ensuring that everyone agrees on the types of values a function uses and returns. Closures, on the other hand, aren’t used in an exposed interface like this: they’re stored in variables and used without naming them and exposing them to users of our library.

Closures are usually concise and pertinent to a specific context, rather than being applicable to any random situation. Within these specific contexts, the compiler is capable of inferring the types of the parameters and the return type, much like it can infer the types of most variables. However, there are rare instances where the compiler requires type annotations for closures as well.

Just as with variables, we can add type annotations to closures if we want to enhance explicitness and clarity, even though this might make the code more verbose than strictly necessary, check the following example:

```rust
let expensive_closure = |num: u32| -> u32 {
    println("calculating slowly...");
    thread::sleep(Duration::from_secs(2));
    num
}
```

With type annotations added, the syntax of closures looks more similar to the syntax of functions. Here we define a function that adds 1 to its parameter and a closure that has the same behavior, for comparison. We’ve added some spaces to line up the relevant parts. This illustrates how closure syntax is similar to function syntax except for the use of pipes and the amount of syntax that is optional:

```rust
fn add_one_v1   (x: u32) -> u32 { x + 1 }
let add one_v2 = |x: u32| -> u32 { x + 1 };
let add_one_v3 = |x|             { x + 1 };
let add_one_v4 = |x|               x + 1  ;
```

In Rust, the compiler often determines the types of variables and closures based on their usage. This is known as type inference.

For instance, consider the closures `add_one_v3` and `add_one_v4`. These closures need to be evaluated (i.e., called with some arguments) for the compiler to infer their types. This is because the types of the parameters and the return value of the closures are not explicitly stated.

This concept is similar to creating a new, empty vector with `let v = Vec::new();`. In this case, the compiler doesn't know what type of elements the vector is supposed to hold. To resolve this, you can either provide type annotations (like `let v: Vec<i32> = Vec::new();`) or insert some values into the vector (like `v.push(1);`) for the compiler to infer the type of the elements in the vector.

In both scenarios, the compiler requires additional information (either through type annotations or through usage) to infer the types. This is a key aspect of Rust's type system that helps maintain safety without sacrificing performance.

For closure definitions, the compiler will infer one concrete type for each of their parameters and for ther return value. Check the following example:

```rust
let example_closure = |x| x;
let s = example_closure(String::from("hello"));

let example_closure = |x| x;
let n = example_closure(5);
```

Here what's happening in this code:

1. We declare a closure example_closure that takes one parameter x and returns x. At this point, the compiler doesn't know the type of x.

2. We call example_closure with a String argument. The compiler infers that x must be of type String, and s is assigned the returned String.

3. We declare example_closure again with the same definition. This is a new closure that's separate from the first one. Again, the compiler doesn't know the type of x.

4. We call this new example_closure with an i32 argument. The compiler infers that x must be of type i32, and n is assigned the returned i32.

### Capturing `references` of `moving Ownership`

Closures can capture values from their environment in three ways, which directly map to the three ways a function can take a parameter: taking ownership, borrowing mutably, and borrowing immutably. These are encoded in the three `Fn` traits as follows. The closures will decide which of these to use based on what the body of the function does with the captured values.

#### Borrowing `immutable` references

```rust
fn main() {
    let list = vec![1, 2, 3];

    println!("Before defining closure: {:?}", list);

    let only_borrows = || println!("From closure: {:?}", list);

    println!("Before calling closure: {:?}", list);

    only_borrows();

    println!("After calling closure: {:?}", list);
}
```

>**Note:** This example demonstrates that a variable can be bound to a closure definition. In this case, `only_borrows` is bound to the closure definition. Later, we can invoke the closure by using the variable name followed by parentheses, treating it as if it were a function name.

#### Borrowing `mutable` references

```rust
fn main() {
    let mut list = vec![1, 2, 3];

    println!("Before defining closure: {:?}", list);

    let mut borrows_mutably = || list.push(7);

    borrows_mutably();

    println!("After calling closure: {:?}", list);
}
```

>**Note:** Observe that there isn't a `println!` statement between the definition and invocation of the `borrows_mutably` closure. When `borrows_mutably` is defined, it captures a mutable reference to `list`. After the closure is called, we don't use it again, thus ending the mutable borrow. During the period from the closure's definition to its invocation, an immutable borrow (like the one required by `println!`) is not permitted. This is because Rust disallows any other borrows when a mutable borrow is in effect.

#### Taking `ownership`

If you want to force the closure to take ownership of the values it uses in the environment, even though the body of the closure doesn’t strictly need ownership, you can use the `move` keyword before the parameter list.

This technique is mostly useful when passing a closure to a new thread to move the data so that it’s owned by the new thread. We’ll discuss threads and why you would want to use them in detail in Chapter 16 when we talk about concurrency, but for now, let's briefly explore spawning a new thread using a closure that needs the `move` keyword.

```rust
use std::thread;

fn main() {
    let list = vec![1, 2, 3];
    println!("Before defining closure: {:?}", list);

    thread::spawn(move || println!("From thread: {:?}", list))
        .join()
        .unwrap();
}
```

>**Note:** When spawning a new thread, it's often necessary for the closure to take ownership of the values it uses from the main thread. This is done using the `move` keyword. The reason for this is that the lifetime of the new thread may outlast the lifetime of the main thread. If the main thread finishes execution and gets cleaned up while the new thread is still running, any references that the new thread holds to data on the main thread would become invalid, leading to the `dangling reference` behavior. By moving ownership to the new thread, we ensure that the data lives as long as the new thread needs it, preventing such errors.

### Moving `Captured` Values Out of `Closures` and the `Fn` Traits

Closures in Rust have the ability to interact with their surrounding environment in a few different ways:

1. **Capturing a Reference or Ownership:** When a closure is defined, it can capture references to variables from its surrounding scope, or it can take ownership of those variables. This is determined by how the variables are used in the closure. If the closure only needs to read a variable, it will capture a reference. If it needs to modify the variable, it will capture a mutable reference. If the closure may outlive the original variable (for example, if the closure is passed to a new thread), it will take ownership of the variable.

2. **What Happens When the Closure is Called:** Once the closure has captured these references or values, what it does with them is determined by the code inside the closure. Here are the possibilities:

    - **Move a Captured Value Out of the Closure:** The closure can return a captured value, effectively moving it out of the closure. This is only possible if the closure has ownership of the value.

    - **Mutate the Captured Value:** If the closure has captured a mutable reference to a value, it can modify that value.

    - **Neither Move Nor Mutate the Value:** If the closure has captured an immutable reference to a value, it can read the value but not modify or move it.

    - **Capture Nothing:** If the closure doesn't use any variables from its environment, it doesn't capture anything.

These interactions between closures and their environment are a key feature that distinguish closures from regular functions in Rust.

The way a closure captures and handles values from the environment determines which traits the closure implements. These traits are crucial as they specify what kinds of closures functions and structs can use. Closures will automatically implement one, two, or all three of the `Fn` traits, in an additive fashion, depending on how the closure’s body handles the values:

- `FnOnce` applies to closures that can be called once. All closures implement at least this trait, because all closures can be called. A closure that moves captured values out of its body will only implement `FnOnce` and none of the other `Fn` traits, because it can only be called once.

- `FnMut` applies to closures that don’t move captured values out of their body, but that might mutate the captured values. These closures can be called more than once.

- `Fn` applies to closures that don’t move captured values out of their body and that don’t mutate captured values, as well as closures that capture nothing from their environment. These closures can be called more than once without mutating their environment, which is important in cases such as calling a closure multiple times concurrently.

To understand how these, lets look at the definition of the `unwrap_or_else` method:

```rust
impl<T> Option<T> {
    pub fn unwrap_or_else<F>(self, f: F) -> T
    where
        F: FnOnce() -> T
    {
        match self {
            Some(x) => x,
            None => f(),
        }
    }
}
```

Let's break down the `unwrap_or_else` function from the `Option` enum in Rust:

- `unwrap_or_else` has a generic type `T`, which represents the type of the value in the `Some` variant of an `Option`. This type `T` is also the return type of the `unwrap_or_else` function. So, if you call `unwrap_or_else` on an `Option<String>`, you will get a `String`.

- The `unwrap_or_else` function also has an additional generic type `F`. This type `F` is the type of the parameter named `f`, which is the closure we provide when calling `unwrap_or_else`.

- The trait bound specified on the generic type `F` is `FnOnce() -> T`. This means `F` must be a closure that can be called once, takes no arguments, and returns a `T`. The `FnOnce` in the trait bound indicates that `unwrap_or_else` will call `f` at most one time.

- In the body of `unwrap_or_else`, if the `Option` is `Some`, `f` won’t be called. If the `Option` is `None`, `f` will be called once.

- Because all closures implement `FnOnce`, `unwrap_or_else` can accept a wide variety of closures, making it highly flexible.

> **Note:** `FnOnce` is a trait in Rust, part of the standard library in the `std::ops` module. It represents closures that take ownership of their environment. This trait is automatically implemented by the compiler for closures that consume their environment, meaning they take ownership of the variables they capture and can't be called more than once. Rust also provides two other traits for function pointers and closures: `Fn` and `FnMut`. These traits are implemented based on how the closures use variables from their environment. More details about `FnOnce` and the other function traits can be found in the [Rust documentation](https://doc.rust-lang.org/std/ops/trait.FnOnce.html).

## Proccessing a series of items with `iterators`

The iterator pattern allows you to perform some task on a sequence of items in turn. An iterator is responsible for the logic of iterating over each item and determining when the sequence has finished. When you use iterators, you don’t have to reimplement that logic yourself.

In Rust, iterators are *lazy*, meaning they have no effect until you call methods that consume the iterator to use it up.

When you use a `for` loop with a vector in Rust, what actually happens under the hood is that an iterator is created for the vector. The `for` loop then iterates over each item in the iterator.

Here's an example:

```rust
let v = vec![1, 2, 3, 4, 5];

for i in v {
    println!("{}", i);
}
```

In this code, `for i in v` implicitly creates an iterator over the vector `v`. The `for` loop then goes through each item in the iterator, assigning the value to i and executing the loop body for each item.

This is equivalent to manually creating an iterator and looping over it:

```rust
let v = vec![1, 2, 3, 4, 5];
let mut iter = v.into_iter();

while let Some(i) = iter.next() {
    println!("{}", i);
}
```

### The `Iterator` Trait and the `next` Method

All iterators implement a trait named Iterator that is defined in the standard library. The definition of the trait looks like this:

```rust
pub trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;

    // methods with default implementations elided
}
```

The `Iterator` trait in Rust is designed with simplicity and flexibility in mind. It mandates the implementation of just a single method: `next`. This method retrieves one item at a time from the iterator. Each item is encapsulated in `Some`, a variant of an enum. When there are no more items to iterate over, the `next` method returns `None`, signaling the end of the iteration.

> **Note:** It's important to understand that the `next` method returns immutable references to the values in the vector when using the `iter` method. This means the iterator doesn't take ownership of the values but allows read-only access. If you need an iterator that takes ownership of the values, use `into_iter` instead of `iter`. For an iterator that provides mutable references (allowing you to modify the values), use `iter_mut`.

### Method that consume the `Iterator`

The `Iterator` trait in Rust provides a variety of methods with default implementations. Many of these methods rely on the `next` method in their implementation, which is why defining the `next` method is mandatory when implementing the `Iterator` trait. Methods that call `next` are known as *consuming adaptors*, as they 'consume' the iterator by taking ownership of it and iterating through the items by repeatedly calling `next`.

#### Consume Methods examples for iterators

- **sum**: Consumes the iterator and returns the sum of the items.
- **collect**: Consumes the iterator and collects the items into a collection data type, such as a vector or a hash map.
- **max**: Consumes the iterator and returns the maximum item.
- **min**: Consumes the iterator and returns the minimum item.
- **count**: Consumes the iterator and returns the number of items.
- **nth**: Consumes the iterator and returns the nth item.
- **last**: Consumes the iterator and returns the last item.
- **all**: Consumes the iterator and returns true if all items satisfy a predicate.
- **any**: Consumes the iterator and returns true if any item satisfies a predicate.
- **find**: Consumes the iterator and returns the first item that satisfies a predicate.
- **position**: Consumes the iterator and returns the index of the first item that satisfies a predicate.

### Method that produce other `Iterators`

`Iterator` adaptors are methods provided by the `Iterator` trait in Rust. Unlike consuming adaptors, they don't exhaust the iterator. Instead, they transform the original iterator in some way to produce a new iterator. This allows for flexible and efficient data manipulation.

#### Adaptor Methods examples for iterators

- **map**: Transforms each item in the iterator by applying a function to it.
- **filter**: Removes items from the iterator that don't satisfy a predicate.
- **enumerate**: Produces an iterator of tuples, where the first element of the tuple is the index and the second element is the original item.
- **skip**: Skips a specified number of items from the iterator.
- **take**: Takes a specified number of items from the iterator.
- **skip_while**: Skips items from the iterator until a predicate is false.
- **take_while**: Takes items from the iterator until a predicate is false.
- **flat_map**: Transforms each item in the iterator into an iterator, and then flattens these iterators into a single iterator.
- **chain**: Chains two iterators together, creating a new iterator that iterates over the items in the first iterator and then the second.
- **zip**: Zips two iterators together, creating a new iterator that iterates over the two iterators in parallel.
