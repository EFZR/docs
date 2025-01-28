# Enums and Pattern Matching in Rust 🦀

## Index

1. [Defining an enum](#defining-an-enum)
    - [differences between enums and structs](#differences-between-enums-and-structs)
    - [The Option Enum and Its Advantages Over Null Values](#the-option-enum-and-its-advantages-over-null-values)
1. [The match Control Flow Operator](#the-match-control-flow-operator)
    - [Patterns that binds to values](#patterns-that-binds-to-values)
    - [Matching with Option\<T\>](#matching-with-optiont)
    - [The _ Placeholder](#the-_-placeholder)
1. [Concise Control Flow with if let](#concise-control-flow-with-if-let)
1. [Enums and Pattern Matching Summary](#enums-and-pattern-matching-summary)

## Defining an enum

An `enum` is a way to define a type by enumerating its possible variants. The `enum` keyword allows the creation of a type which may be one of a few different variants. Any variant which is valid as a struct is also valid as an enum.

```rust
enum IpAddrKind {
    V4,
    V6,
}
```

We can also attach data to each variant of the enum directly, so they can hold different types and amounts of associated data.

```rust
enum IpAddr {
    V4(u8, u8, u8, u8),
    V6(String),
}
```

We can also define methods on enums.

```rust
enum IpAddr {
    V4(u8, u8, u8, u8),
    V6(String),
}

impl IpAddr {
    fn call(&self) {
        // method body would be defined here
    }
}
```

### `differences` between `enums` and `structs`

If just like me you got confused between the differences between enums and structs, I found this explanation very useful:

`Structs` are used to create a data type that can contain multiple other data types, all instances of the struct have the same fields with the same names and types. `Structs` are usefule when you want to bundle related values together.

`Enums` are used to create a data type that can be **one** of several variants. Each variant can have different types and amounts of associated data. `Enums` are useful when you have a type that can be one of several distinct possibilities.

### `The Option Enum and Its Advantages Over Null Values`

The `Option` type is used in many places because it encodes the very common scenario in which a value could be something or it could be nothing. Expressing this concept in terms of the type system means the compiler can check whether you’ve handled all the cases you should be handling; this functionality can prevent bugs that are extremely common in other programming languages.

>**fact:** The null values is considered the billion dollar mistake by Tony Hoare, the inventor of the null reference, because is easy to understand that a null value can crash completely a program.

```rust
enum Option<T> {
    Some(T),
    None,
}
```

The `Option<T>` enum is so useful that it’s even included in the prelude; you don’t need to bring it into scope explicitly. In addition, so are its variants: you can use `Some` and `None` directly without the `Option::` prefix. The `Option<T>` enum is still just a regular enum, and `Some(T)` and `None` are still variants of type `Option<T>`.

```rust
fn main() {
    let some_number = Some(5);
    let some_string = Some("a string");

    let absent_number: Option<i32> = None;
}
```

If we use `None` rather than `Some`, we need to tell Rust what type of `Option<T>` we have, because the compiler can’t infer the type that the `Some` variant will hold by looking only at a `None` value.

## The match Control Flow Operator

In Rust, the `match` expression is how you run code based on what a value is and execute code based on which variant of an enum a value is. We can use `match` with `enums` to compare the value of the `enum` with the value of the `match` and execute the code of the `match` if the values are the same. Each `match` expression is made up of arms.

```rust
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter,
}

fn main() {
    let coin = Coin::Penny;
    let value = value_in_cents(coin);
}

fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => {
            println!("Lucky penny!");
            1
        },
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter => 25,
    }
}
```

### `Patterns that binds to values`

Other useful feature of rust is that we can bind values to variables in the match patterns.

```rust
#[derive(Debug)]
enum UsState {
    Alabama,
    Alaska,
    // --snip--
}

enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter(UsState),
}

fn main() {
    let coin = Coin::Quarter(UsState::Alaska);
    let value = value_in_cents(coin);
}

fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter(state) => {
            println!("State quarter from {:?}!", state);
            25
        },
    }
}
```

### `Matching with Option\<T\>`

The `Option<T>` enum is so useful that it’s even included in the prelude; you don’t need to bring it into scope explicitly. In addition, so are its variants: you can use `Some` and `None` directly without the `Option::` prefix. The `Option<T>` enum is still just a regular enum, and `Some(T)` and `None` are still variants of type `Option<T>`.

```rust
enum Option<T> {
    Some(T),
    None,
}

fn main() {
    let five = Some(5);
    let six = plus_one(five);
    let none = plus_one(None);
}

fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        None => None,
        Some(i) => Some(i + 1),
    }
}
```

### `The _ Placeholder`

The `_` placeholder is a catchall value; in the case of `enum` we can use it to match any value.

```rust
fn main() {
    let some_u8_value: u8 = 0;
    match some_u8_value {
        1 => println!("one"),
        3 => println!("three"),
        5 => println!("five"),
        7 => println!("seven"),
        _ => (),
    }
}
```

## Concise Control Flow with if let

The `if let` syntax lets you combine `if` and `let` into a less verbose way to handle values that match one pattern while ignoring the rest.

```rust
fn main() {
    let some_u8_value = Some(0u8);
    match some_u8_value {
        Some(3) => println!("three"),
        _ => (),
    }

    if let Some(3) = some_u8_value {
        println!("three");
    }
}
```

We can also use `else` with `if let`.

```rust
fn main() {
    let mut count = 0;
    match coin {
        Coin::Quarter(state) => println!("State quarter from {:?}!", state),
        _ => count += 1,
    }

    if let Coin::Quarter(state) = coin {
        println!("State quarter from {:?}!", state);
    } else {
        count += 1;
    }
}
```

## Enums and Pattern Matching Summary

- Enums allow you to define a type by enumerating its possible variants.
- The `Option` enum is useful because it encodes the very common scenario in which a value could be something or it could be nothing.
- The `match` control flow operator is how you run code based on what a value is and execute code based on which variant of an enum a value is.
- Patterns can be made up of literal values, variable names, wildcards, and many other things.
- The `if let` syntax lets you combine `if` and `let` into a less verbose way to handle values that match one pattern while ignoring the rest.
- The `result` type is used to encode recoverable errors, and the `panic!` macro is used when the error cannot be handled.
