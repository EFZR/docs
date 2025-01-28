# Pattern and Matching in Rust 🦀

*Patterns* are special syntax in Rust for mathciong againset the structure of tyes, both complex and simple. Using patterns in conjunction with `match` expressions and other constructs gives you more control over a program's control flow. A pattern consist of some combincation of the following:

- Literals
- Destructured arrays, enums, structs, or tuples
- Variables
- Wildcards
- Placeholders

## Index

1. [All the Places Patterns Can Be Used](#all-the-places-patterns-can-be-used)
    - [match Arms](#match-arms)
    - [Conditional `if let` Expressions](#conditional-if-let-expressions)
    - [`while let` Conditional loops](#while-let-conditional-loops)
    - [`for` loops](#for-loops)
    - [`let` Statements](#let-statements)
    - [Function Parameters](#function-parameters)
2. [Refutability: Whether a Pattern Might Fail to Match](#refutability-whether-a-pattern-might-fail-to-match)

## All the Places Patterns Can Be Used

Patterns pop up in a number of places in Rust, and is possible you have been using it without realizing it.

### `match` Arms

We use patterns in the arms of `match` expressions. Formally, `match` expressions are defines ad the keyword `match`, a value to match on, and one or more match arms that consist of a pattern and an expression to run if the value matches that arm's pattern.

```rust
match VALUE {
    PATTERN => EXPRESSION,
    PATTERN => EXPRESSION,
    PATTERN => EXPRESSION,
}
```

For example, here is the `match` expression that matches an `Option<i32>` value in a variable x

```rust
match x {
    Some(i) => Some(i + 1),
    None => (),
}
```

One requirement for the `match` pattern is to cover every possible value, and the `_` wildcard can be used to match any value.

### Conditional `if let` Expressions

`if let` expressions mainly is a short way to write a `match` that only matches one case. It is useful when you only care about running code when a value matches one pattern and you don't want to list all the possible values.

It is also possible to combine the `if let`, `else if` and `else if let` arms related to each other.

```rust
fn main() {
    let favorite_color: Option<&str> = None;
    let is_tuesday = false;
    let age: Result<u8, _> = "34".parse();

    if let Some(color) = favorite_color {
        println!("Using your favorite color, {color}, as the background");
    } else if is_tuesday {
        println!("Tuesday is green day!");
    } else if let Ok(age) = age {
        if age > 30 {
            println!("Using purple as the background color");
        } else {
            println!("Using orange as the background color");
        }
    } else {
        println!("Using blue as the background color");
    }
}
```

The downside of using if let expressions is that the compiler doesn’t check for exhaustiveness, whereas with match expressions it does. If we omitted the last else block and therefore missed handling some cases, the compiler would not alert us to the possible logic bug.

### `while let` Conditional loops

Similar to `if let`, the `while let` conditional loop allows a `while` loop to run for as long as a pattern continues to match. In the code below we code a `while let` loop that uses a vector as a stack and prints the values in the vector in the opposite order in which they were pushed onto the stack.

```rust
fn main() {
    let mut stack = Vec::new();

    stack.push(1);
    stack.push(2);
    stack.push(3);

    while let Some(top) = stack.pop() {
        println!("{}", top);
    }
}
```

This example prints 3, 2, 1. The `pop` method takes the last element out of the vector and returns `Some(value)`. If the vector is empty, `pop` returns `None`. The `while` loop continues running the code in its block as long as `stack.pop()` returns `Some`. Once `pop` returns `None`, the loop stops.

### `for` loops

In a `for` loop, the value that directly follows the keyword `for` is a pattern. For example, in `for x in y` the `x` is the pattern. In the code below demonstrates how to use a pattern in a `for` loop to destructure, or break apart, a tuple as part of the `for` loop.

```rust
for (index, value) in (1..4).enumerate() {
    println!("index = {} and value = {}", index, value);
}
```

We adapt an iterator using the `enumerate` method so it return a tuple with an index in each iteration. The `for` loop is then used to destructure the tuple into two variables, `index` and `value`, which are then used in the body of the loop.

### `let` Statements

Patterns can be used in `let` statements to destructure a tuple, as shown in the code below.

```rust
let (x, y, z) = (1, 2, 3);
```

If we try to destructure a tuple and the number of variables does not match the number of elements in the tuple, we'll get a compile-time error.

```rust
let (x, y) = (1, 2, 3);
```

This code will not compile because the number of variables does not match the number of elements in the tuple. To avoid this error, we can use the `_` wildcard to ignore the value.

```rust
let (x, _, z) = (1, 2, 3);
```

Or maybe to ignore the rest of the values in the tuple.

```rust
let (x, ..) = (1, 2, 3);
```

### Function Parameters

Function parameters can also be patterns.

```rust
fn foo(x: i32) {
    // code
}
```

In the parameter of the function `foo`, `x` is a pattern that matches a single value. We can also use a destructured pattern as a function parameter.

```rust
fn print_coordinates(&(x, y): &(i32, i32)) {
    println!("Current location: ({}, {})", x, y);
}

fn main() {
    let point = (3, 5);
    print_coordinates(&point);
}
```

In the function `print_coordinates`, the parameter `&(x, y): &(i32, i32)` is a pattern that matches a reference to a tuple. The pattern `&(x, y)` takes a reference to a tuple and destructures it into two variables, `x` and `y`, which are then used in the body of the function.

## Refutability: Whether a Pattern Might Fail to Match

<!-- ## Understanding Refutable and Irrefutable Patterns in Rust -->

In Rust, patterns come in two forms: refutable and irrefutable.

Irrefutable patterns are those that will match for any possible value passed. An example of an irrefutable pattern is `x` in the statement `let x = 5;`. Here, `x` matches anything and therefore cannot fail to match.

On the other hand, refutable patterns can fail to match for some possible value. An example of a refutable pattern is `Some(x)` in the expression `if let Some(x) = a_value`. If the value in the `a_value` variable is `None` rather than `Some`, the `Some(x)` pattern will not match.

Certain constructs in Rust can only accept irrefutable patterns. These include function parameters, `let` statements, and `for` loops. This is because the program cannot do anything meaningful when values don’t match. The `if let` and `while let` expressions accept both refutable and irrefutable patterns, but the compiler warns against irrefutable patterns because by definition they’re intended to handle possible failure. The functionality of a conditional is in its ability to perform differently depending on success or failure.

In general, you don’t have to worry about the distinction between refutable and irrefutable patterns. However, it's important to be familiar with the concept of refutability so you can respond appropriately when you encounter it in an error message. In such cases, you may need to change either the pattern or the construct you’re using the pattern with, depending on the intended behavior of the code.

## Pattern Syntax

In this section, we gather all the syntax valid patterns in Rust.

### Matching Literals

```rust
let x = 1;

match x {
    1 => println!("one"),
    2 => println!("two"),
    3 => println!("three"),
    _ => println!("anything"),
}
```

### Matching Named Variables

```rust
let x = Some(5);
let y = 10;

match x {
    Some(50) => println!("Got 50"),
    Some(y) => println!("Matched, y = {:?}", y),
    _ => println!("Default case, x = {:?}", x),
}

println!("at the end: x = {:?}, y = {:?}", x, y);
```

In the above code, the `Some(50)` arm will not match because `x` is `Some(5)`. The `Some(y)` arm will match and bind `y` to the value inside the `Some`. The `y` we use in the `Some(y)` arm is a new variable that we declare, which is different from the `y` in the outer scope. This would print `Matched, y = 5`.

The code will end with `at eht end: x = Some(5), y = 10` because the `y` in the outer scope is not affected by the `y` in the `Some(y)` pattern.

### Multiple Patterns

```rust
let x = 1;

match x {
    1 | 2 => println!("one or two"),
    3 => println!("three"),
    _ => println!("anything"),
}
```

In the code above, the `1 | 2` pattern will match if `x` is either `1` or `2`. The `3` pattern will match if `x` is `3`. The `_` pattern will match if `x` is any other value.

In the `match` pattern is possible to have multiple expression in `match` arm separated by `|` which is an `OR` operator.

### Matching Ranges of Values with `...`

```rust
let x = 5;

match x {
    1..=5 => println!("one through five"),
    _ => println!("anything"),
}
```

In the code above, the `1..=5` pattern will match if `x` is `1`, `2`, `3`, `4`, or `5`. The `_` pattern will match if `x` is any other value.

The syntax `..=` is used to match a range that is inclusive at both ends. If we wanted to specify a range that is exclusive at one end, we would use two dots `..`. For example, `1..5` would match any number from 1 to 4, and `1..` would match any number greater than or equal to 1.

The compiler check that the range is not empty at compiled time. Other value that can be used in a range are the `char` type.

```rust
let x = 'c';

match x {
    'a'..='j' => println!("early ASCII letter"),
    'k'..='z' => println!("late ASCII letter"),
    _ => println!("something else"),
}
```

### Destructuring to Break Apart Values

We can also use patterns to destructure structs, enums and tuples to use different parts of these values. Let's walk through some examples.

#### Destructuring Structs

```rust
struct Point {
    x: i32,
    y: i32,
}

let p = Point { x: 0, y: 7 };
let Point { x: a, y: b } = p;

assert_eq!(0, a);
assert_eq!(7, b);
```

This code creates the variables `a` and `b` and binds them to the value of the `x` and `y` fields of the `Point` `p`. The pattern `Point { x: a, y: b }` is a struct pattern that destructures `p`, binding `a` to `p.x` and `b` to `p.y`.

Its common to use the same name as the field for the variable in the struct pattern like this: `Point {x: x, y: y}`, but to avoid redundancy, we can use the shorthand `Point {x, y}`.

```rust
let Point { x, y } = p;

assert_eq!(0, x);
assert_eq!(7, y);
```

Is also possible to destructure with literal values as part of the struct pattern rather than creating variables for all the fields.

```rust
struct Point {
    x: i32,
    y: i32,
}

let point = Point { x: 0, y: 7 };

match point {
    Point { x, y: 0 } => println!("Point is on the x axis at position {}", x),
    Point { x: 0, y } => println!("Point is on the y axis at position {}", y),
    Point { x, y } => println!("Point is at ({}, {})", x, y),
}
```

#### Destructuring Enums

The pattern used to destructure an Enum in Rust directly corresponds to the structure of the Enum's variants. An Enum can have multiple variants, and each variant can store different types and quantities of data. Therefore, the way we destructure these variants can vary based on their individual structure.

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

let msg = Message::ChangeColor(0, 160, 255);

match msg {
    Message::Quit => {
        println!("The Quit variant has no data to destructure.")
    }
    Message::Move { x, y } => {
        println!("Move in the x direction {} and in the y direction {}", x, y);
    }
    Message::Write(text) => println!("Text message: {}", text),
    Message::ChangeColor(r, g, b) => {
        println!("Change the color to red {}, green {}, and blue {}", r, g, b);
    }
}
```

This code will print `Change the color to red 0, green 160, and blue 255`. Try changing the value of msg to see the code from the other arms run.

#### Destructuring Nested Structs and Enums

We can also destructure nested structs and enums. For example, consider the following code:

```rust
enum Color {
    Rgb(i32, i32, i32),
    Hsv(i32, i32, i32),
}

enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(Color),
}

let msg = Message::ChangeColor(Color::Hsv(0, 160, 255));

match msg {
    Message::ChangeColor(Color::Rgb(r, g, b)) => {
        println!("Change the color to red {}, green {}, and blue {}", r, g, b);
    }
    Message::ChangeColor(Color::Hsv(h, s, v)) => {
        println!("Change the color to hue {}, saturation {}, and value {}", h, s, v);
    }
    _ => ()
}
```

This code will print `Change the color to hue 0, saturation 160, and value 255`. Try changing the value of msg to see the code from the other arms run.

#### Structs and Tuples

We can mix, match and nest destructuring patterns in even more complex ways. For example, consider the following code:

```rust
let ((feet, inches), Point { x, y }) = ((3, 10), Point { x: 3, y: -10 });

println!("feet = {}, inches = {}, x = {}, y = {}", feet, inches, x, y);
```

### Ignoring Values in a Pattern

Some cases is useful to ignore some values in a pattern using the syntax `_` or `..`.

#### Ignoring an Entire Value with `_`

We’ve used the underscore as a wildcard pattern that will match any value but not bind to the value. This is especially useful as the last arm in a `match` expression, but we can also use it in any pattern, including function parameters:

```rust
fn foo(_: i32, y: i32) {
    println!("This code only uses the y parameter: {}", y);
}

fn main() {
    foo(3, 4);
}
```

This code will completly ignore the first parameter that is `3` and print `This code only uses the y parameter: 4`.

#### Ignoring Parts of a Value with a Nested `_`

We can also use `_` inside another pattern to ignore just part of a value, for example, when we want to test for only part of a value but have no use for the other parts in the corresponding code we want to run.

```rust
let mut setting_value = Some(5);
let new_setting_value = Some(10);

match (setting_value, new_setting_value) {
    (Some(_), Some(_)) => {
        println!("Can't overwrite an existing customized value");
    }
    _ => {
        setting_value = new_setting_value;
    }
}

println!("setting is {:?}", setting_value);
```

#### Ignoring an Unused Variable by Starting Its Name with `_`

If you create a variable but don’t use it, Rust will usually issue a warning because that could be a bug. But sometimes, starting a variable name with an underscore is used to indicate that the variable is unused. For example:

```rust
let _x = 5;
```

This code will not issue a warning because the variable `_x` is never used. This is a convention that indicates to other programmers that the value is not intended to be used.

#### Ignoring Remaining Parts of a Value with `..`

We can use `..` to ignore the remaining parts of a value that we don’t need. This is especially useful in destructuring a value that has a lot of parts and we’re only interested in a few of them.

```rust
struct Point {
    x: i32,
    y: i32,
    z: i32,
}

let origin = Point { x: 0, y: 0, z: 0 };

match origin {
    Point { x, .. } => println!("x is {}", x),
}
```

This can also be used in tuples.

```rust
let numbers = (2, 4, 8, 16, 32);

match numbers {
    (first, .., last) => {
        println!("Some numbers: {}, {}", first, last);
    }
}
```

### Extra Conditionals with `Match Guards`

A `match guard` is an additional if condition specified after the pattern in a match arm that must also match, along with the pattern matching, for that arm to be chosen.

```rust
let num = Some(4);

match num {
    Some(x) if x < 5 => println!("less than five: {}", x),
    Some(x) => println!("{}", x),
    None => (),
}
```

In the code above, the `match` expression first compares `num` with the pattern `Some(x)`. If that pattern matches, the `match` expression then checks the condition `if x < 5`. If the condition matches, the code associated with that arm is executed. If the condition does not match, the code in the next arm is checked.

### `@ Bindings`

The `@` operator allows us to create a variable that holds a value at the same time we’re testing that value to see whether it matches a pattern. This is useful in `match` expressions where we want to use a value but also test it against a pattern.

```rust
enum Message {
    Hello { id: i32 },
}

let msg = Message::Hello { id: 5 };

match msg {
    Message::Hello { id: id_variable @ 3..=7 } => {
        println!("Found an id in range: {}", id_variable);
    }
    Message::Hello { id: 10..=12 } => {
        println!("Found an id in another range");
    }
    Message::Hello { id } => {
        println!("Found some other id: {}", id);
    }
}
```

In the code above, the `@` operator lets us create a variable that holds the value inside the `id` field of the `Message::Hello` variant. We can then test this value to see whether it’s within the range `3..=7` and print a message based on the result.
