# Structs in Rust 🦀

A `struct` is a custom data type that lets you name and package together multiple related values that make up a meaningful group.

## Index

1. [Defining and Instantiating Structs](#defining-and-instantiating-structs)
    - [Tuple Structs](#tuple-structs)
    - [Unit-Like Structs Without Any Fields](#unit-like-structs-without-any-fields)
1. [Method Syntax](#method-syntax)
    - [Methods](#methods)
    - [The difference between rust and c++ or c](#the-difference-between-rust-and-c-or-c)
    - [Getter and Setter Methods](#getter-and-setter-methods)
    - [Associated Functions](#associated-functions)

## Defining and Instantiating Structs

To define a struct, we enter the keyword `struct` and name the entire struct. Inside curly brackets, we define the names and types of the pieces of data, which we call `fields`. We can then create an instance of the struct by specifying concrete values for each field.

```rust
struct User {
    username: String,
    email: String,
    sign_in_count: u64,
    active: bool,
}
```

To use the struct after it´s defined, we need to create an instance of that struct. We create an instance by stating the name of the struct and then add curly brackets containing key: value pairs, where the keys are the names of the fields and the values are the data we want to store in those fields.

```rust
fn main() {
    let user1 = User {
        email: String::from("john@mail.com"),
        username: String::from("john"),
        active: true,
        sign_in_count: 1,
    };
}
```

To get a specific value from a struct, we can use dot notation.

```rust
fn main() {
    let user1 = User {
        email: String::from("john@mail.com"),
        username: String::from("john"),
        active: true,
        sign_in_count: 1,
    };
}
```

Also you can build a new instance from another instance using struct update syntax.

```rust
fn main() {
    let user1 = User {
        email: String::from("john@mail.com"),
        username: String::from("john"),
        active: true,
        sign_in_count: 1,
    };

    let user2 = User {
        email: String::from("johana@mail.com"),
        username: String::from("johana"),
        ..user1
    };
}
```

### `Tuple Structs`

The tuple structs are useful when you want to give the whole tuple a name and make the tuple be a different type from other tuples and naming each field as in a regular struct would be verbose or redundant.

```rust
struct Color(i32, i32, i32);

struct Point(i32, i32, i32);

fn main() {
    let black = Color(0, 0, 0);
    let origin = Point(0, 0, 0);
}
```

### `Unit-Like Structs Without Any Fields`

You can also define structs that don’t have any fields! These are called `unit-like structs` because they behave similarly to `()`, the unit type. Unit-like structs can be useful in situations in which you need to implement a trait on some type but don’t have any data that you want to store in the type itself.

```rust
struct User;
```

## Method Syntax

### `Methods`

Methods are similar to functions: they’re declared with the fn keyword and their name, they can have parameters and a return value, and they contain some code that is run when they’re called from somewhere else. However, methods are different from functions in that they’re defined within the context of a struct (or an enum or a trait object), and their first parameter is always `self`, which represents the instance of the struct the method is being called on.

```rust
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
}

fn main() {
    let rect1 = Rectangle {
        width: 30,
        height: 50,
    };

    println!(
        "The area of the rectangle is {} square pixels.",
        rect1.area()
    );
}
```

The `&self` parameter is a reference to the instance of the struct we called the method on. This syntax lets us use the instance inside the method without having to take ownership of the instance. If we wanted to change the instance that we’ve called the method on as part of what the method does, we’d use `&mut self` as the first parameter.

### `The difference between rust and c++ or c`

Is important to understand that in Rust the rect instance automatically makes a reference of itself to borrow when we call a method with `&self` or `&mut self` as the first parameter, so the example below:

```rust
fn main() {
    let rect = Rectangle {
        width: 30,
        height: 50,
    };

    println!(
        "The area of the rectangle is {} square pixels.",
        rect.area()
    );
}
```

is the same as this:

```rust
fn main() {
    let rect = Rectangle {
        width: 30,
        height: 50,
    };

    println!(
        "The area of the rectangle is {} square pixels.",
        (&rect).area()
    );
}
```

and to this:

```rust
fn main() {
    let rect = Rectangle {
        width: 30,
        height: 50,
    };

    println!(
        "The area of the rectangle is {} square pixels.",
        Rectangle::area(&rect)
    );
}
```

diffrently to c++ or c that to reference a method you need to use the `->` operator, in rust you use the `.` operator.

```c++
int main() {
    Rectangle rect = {30, 50};

    printf("The area of the rectangle is %d square pixels.", rect -> area());
}
```

### `Getter` and `Setter` Methods

Method can have the same name as other fields in the struct.

```rust
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }

    fn width(&self) -> u32 {
        self.width
    }
}
```

This is used to return the value of the field and is called `getter`. Also we can have `setter` methods to change the value of the fields.

```rust

struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }

    fn width(&self) -> u32 {
        self.width
    }

    fn set_width(&mut self, width: u32) {
        self.width = width;
    }
}
```

### `Associated Functions`

Another useful feature of impl blocks is that we’re allowed to define functions within impl blocks that don’t take `self` as a parameter. These are called `associated functions` because they’re associated with the struct. They’re still functions, not methods, because they don’t have an instance of the struct to work with. Associated functions are often used for constructors that will return a new instance of the struct.

```rust
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn square(size: u32) -> Rectangle {
        Rectangle {
            width: size,
            height: size,
        }
    }
}

fn main() {
    let sq = Rectangle::square(3);
}
```
