# Common Programming Conepts 🦀

## Index

1. [Variables and Mutability](#variables-and-mutability)
    - [Variables](#variables)
    - [Constants](#constants)
    - [Shadowing](#shadowing)
1. [Data Types](#data-types)
    - [Scalar Types](#scalar-types)
        - [Integer Types](#integer-types)
        - [Floating-Point Types](#floating-point-types)
        - [Boolean Type](#boolean-type)
        - [Character Type](#character-type)
    - [Compound Types](#compound-types)
        - [The Tuple Type](#the-tuple-type)
        - [The Array Type](#the-array-type)
1. [Functions](#functions)
    - [Function Parameters](#function-parameters)
    - [Function Bodies Contain Statements and Expressions](#function-bodies-contain-statements-and-expressions)
    - [Functions with Return Values](#functions-with-return-values)
1. [Control Flow](#control-flow)
    - [if Expressions](#if-expressions)
    - [Repetition with Loops](#repetition-with-loops)
        - [loop](#loop)
        - [while](#while)
        - [for](#for)

## variables and mutability

### `Variables`

In rust, `variables` are immutable by default. This makes rust a `safe` language. To make them mutable, we need to use the `mut` keyword.

```rust
let x = 5;
x = 6; // This will throw an error

let mut y = 5;
y = 6; // This will work
```

### `Constants`

In rust, `constants` are immutable by default. They are declared using the `const` keyword. They are always immutable and must be annotated with a type.

```rust
const MAX_POINTS: u32 = 100_000;
```

### `Shadowing`

In rust, we can declare a new variable with the same name as a previous variable. This is called `shadowing`. This is different from `mut` because we’ll get a compile-time error if we accidentally try to reassign to this variable without using the `let` keyword. By using `let`, we can perform a few transformations on a value but have the variable be immutable after those transformations have been completed.

```rust
let x: i32 = 5;
let x: i32 = x + 1;
let x: i32 = x * 2;
{
    let x: i32 = x * 3;
}
```

## Data Types

### `Scalar Types`

A `scalar type` represents a single value. Rust has four primary scalar types: `integers`, `floating-point numbers`, `Booleans`, and `characters`.

#### **Integer Types**

An `integer` is a number without a fractional component. Rust’s `integers` are signed by default, meaning they can be positive or negative.

| Length  | Signed | Unsigned |
| ------- | ------ | -------- |
| 8-bit   | i8     | u8       |
| 16-bit  | i16    | u16      |
| 32-bit  | i32    | u32      |
| 64-bit  | i64    | u64      |
| 128-bit | i128   | u128     |
| arch    | isize  | usize    |

#### **Floating-Point Types**

Rust also has two primitive types for `floating-point` numbers, which are numbers with decimal points. Rust’s floating-point types are `f32` and `f64`, which are `32 bits` and `64 bits` in size, respectively. The default type is `f64` because on modern CPUs it’s roughly the same speed as `f32` but is capable of more precision.

#### **Boolean Type**

A `Boolean` type in Rust has two possible values: `true` and `false`. Booleans are one byte in size.

#### **Character Type**

Rust’s `char` type is the language’s most primitive alphabetic type, and the following code shows one way to use it. (Note that `char` literals are specified with single quotes, as opposed to string literals, which use double quotes.)

```rust
let c = 'z';
let z = 'ℤ';
let heart_eyed_cat = '😻';
```

### `Compound Types`

Rust has two primitive compound types: `tuples` and `arrays`.

#### **The Tuple Type**

A `tuple` is a general way of grouping together a number of values with a variety of types into one compound type. Tuples have a fixed length: once declared, they cannot grow or shrink in size.

```rust
let tup: (i32, f64, u8) = (500, 6.4, 1);
```

We can use `pattern matching` to destructure a tuple value, like this:

```rust
let (x, y, z) = tup;
```

We can access a tuple element directly by using a period (`.`) followed by the index of the value we want to access. For example:

```rust
let five_hundred = x.0;
let six_point_four = x.1;
let one = x.2;
```

#### **The Array Type**

Another way to have a collection of multiple values is with an `array`. Unlike a tuple, every element of an array must have the same type. Arrays in Rust are different from arrays in some other languages because arrays in Rust have a fixed length, like tuples.

```rust
let a = [1, 2, 3, 4, 5];
let months = ["January", "February", "March", "April", "May", "June", "July",
            "August", "September", "October", "November", "December"];
```

Arrays are useful when you want your data allocated on the stack rather than the heap. Or when you want to ensure you always have a fixed number of elements.

```rust
let a: [i32; 5] = [1, 2, 3, 4, 5];
let a = [3; 5]; // [3, 3, 3, 3, 3]
```

## Functions

```rust
fn main() {
    println!("Hello, world!");
}
```

### `Function Parameters`

Function definitions can also be made to include `parameters`. Parameters are special variables that are part of a function’s signature. When a function has parameters, you can provide it with `arguments`, which are concrete values for those parameters. The values you give as arguments must match the types of the parameters.

```rust
fn main() {
    another_function(5, 6);
}

fn another_function(x: i32, y: i32) {
    println!("The value of x is: {}", x);
    println!("The value of y is: {}", y);
}
```

### `Function Bodies Contain Statements and Expressions`

In rust is important to understand the difference between `statements` and `expressions`. Statements are instructions that perform some action and do not return a value. Expressions evaluate to a resulting value. Let’s look at some examples.

```rust
fn main() {
    let x = 5;

    let y = {
        let x = 3;
        x + 1
    };

    println!("The value of y is: {}", y);
}
```

In this example, `x + 1` is the expression that evaluates to `4`. This expression doesn’t include a semicolon `;` at the end, because expressions don’t include semicolons. If you add a semicolon to the end of an expression, you turn it into a statement, which will then not return a value. Keep this in mind as you explore function return values and expressions next.

### `Functions with Return Values`

```rust
fn main() {
    let x = five();

    println!("The value of x is: {}", x);
}

fn five() -> i32 {
    5
}
```

In this example, we add `-> i32` after the function signature to indicate that we want the function to return a value of this type.

## Control Flow

In every programming languages there are `control flow` features that allow you to change the program execution flow. In rust, we have `if` expressions and `loops`.

### `if Expressions`

The if expression works the same way as in other languages. The condition must be a `bool`. If the condition is true, the code block is executed. If the condition is false, the code block is skipped.

```rust
fn main() {
    let number = 3;

    if number < 5 {
        println!("condition was true");
    } else {
        println!("condition was false");
    }
}
```

This is an example of an `if` expression with multiple `else if` conditions, but in this cases we can use `match` instead.

```rust
fn main() {
    let number = 6;

    if number % 4 == 0 {
        println!("number is divisible by 4");
    } else if number % 3 == 0 {
        println!("number is divisible by 3");
    } else if number % 2 == 0 {
        println!("number is divisible by 2");
    } else {
        println!("number is not divisible by 4, 3, or 2");
    }
}
```

We can also use a `if` in a `let` statement.

```rust
fn main() {
    let condition = true;
    let number = if condition { 5 } else { 6 };

    println!("The value of number is: {}", number);
}
```

>**note:** The values that have the potential to be results from each arm of the if must be the same type.

### `Repetition with Loops`

Rust has three kinds of loops: `loop`, `while`, and `for`. Let’s cover each one with an example!

#### **loop**

The `loop` keyword tells Rust to execute a block of code over and over again forever or until you explicitly tell it to stop.

```rust
fn main() {
    loop {
        println!("again!");
    }
}
```

We can use `break` to stop the loop.

```rust
fn main() {
    let mut counter = 0;

    let result = loop {
        counter += 1;

        if counter == 10 {
            break counter * 2;
        }
    };

    println!("The result is {}", result);
}
```

#### **while**

The `while` loop is similar to the `loop` loop, but the condition is evaluated before each iteration of the loop. If the condition is `true`, the loop runs another iteration. If the condition is `false`, the loop exits.

```rust
fn main() {
    let mut number = 3;

    while number != 0 {
        println!("{number}!");

        number -= 1;
    }

    println!("LIFTOFF!!!");
}
```

#### **for**

The `for` loop is used to iterate over a sequence of values. For example, a range.

```rust
fn main() {
    let a = [10, 20, 30, 40, 50];

    for element in a {
        println!("the value is: {element}");
    }
}
```

We can also use a `for` loop to run some code a certain number of times by using a `Range`.

```rust
fn main() {
    for number in (1..4).rev() {
        println!("{number}!");
    }
    println!("LIFTOFF!!!");
}
```
