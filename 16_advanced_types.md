# Advanced Types in Rust 🦀

## Index

1. [Creating Type Synonyms with Type Aliases](#creating-type-synonyms-with-type-aliases)
2. [The Never Type that Never Returns](#the-never-type-that-never-returns)
3. [Dynamically Sized Types and the Sized Trait](#dynamically-sized-types-and-the-sized-trait)

## Creating Type Synonyms with Type Aliases

Rust provides the ability to declare *type alias* to give an existing type another name. For this we use the `type` keyword. For example we can create the alias `kilometers` to `i32` like so:

```rust
type kilometers = i32;
```

Now, the alias `Kilometer` is `synonym` for `i32`. Values that have the type `Kilometer` will be treated as `i32` as the example below:

```rust
fn main() {
    type Kilometers = i32;
    
    let x: i32 = 5;
    let y: Kilometers = 10;

    println!("x + y = {}", x + y);
}
```

Becauase `Kilometers` and `i32` are the same type, we can add values of both of types and we can pass `Kiloweters` values to funtions that takes parameters of type `i32` without getting an error from the compiler.

The main use case for type synonym is to reduce repetition. For example, we might have lengthy type like this:

```rust
Box<dyn Fn() + Send + 'static'>
```

Writtin this lengthy type in function signatures and as type annotation all over the code can be tiresome and error prone. Imagine having a project having full of this type

```rust
let f: Box<dyn Fn() + Send + 'static> = Box::new(|| println!("hi"));

fn takes_long_type(f: Box<dyn Fn() + Send + 'static>) {
    // --snip--
}

fn returns_long_type() -> Box<dyn Fn() + Send + 'static> {
    // --snip--
}
```

A type aliases make this code more manageable:

```rust
fn main() {
    type thunk = Box<dyn Fn() + Send + 'static>;

    let f: thunk = Box::new(|| println!("hi"));

    fn takes_long_type(f: thunk) {
        // --snip--
    }

    fn returns_long_type() -> thunk {
        // --snip--
    }
}
```

This code is much easier to read and write! Choosing a meaningful name for a type alias can help communicate your intent as well.

This example is used in the project `rust-axum-intro` in the `.\error.rs\` file creating a type alias for `Result<T, E>`, that can be used in the entire project.

Instead of using the type `Result<T, E>` in the entire project, we can create a type alias for it, like so:

```rust
pub type Result<T> = std::result::Result<T, Error>;

pub enum Error {
    LoginFail,

    // Model errors.
    TicketDeleteFailIdNotFound { id: u64 },

    // Auth Errors
    AuthFailNoAuthTokenCookies,
    AuthFailTokenWrongFormat,
    AuthFailCtxNotInRequestExt,
}
```

In the previous code we were able to create a type alias to manage the return of the `Result<T>` that would work as a `Result<T, Error>`. This way we could keep using the behavior of the `Result<T, Error>` without having to write the entire type in the entire project. We alse create an `enum` with the types of errors that could have in the project.

## The Never Type that Never Returns

Rust has an special type named `!` that's in type theory lingo as the *empty type* becauase it has no value. Rustaceans prefer to call it the *never type* because it stands in the place of the return value of functions that never return. Here is an example:

```rust
fn bar() -> ! {
    // --snip--
}
```

This code is read as the "function `bar` returns never". Functions that return never are called *diverging functions*. We can create values of the type `!` so `bar` can never return.

### Examples of Never Return values

In the example below we would show some example where the never type is used:

```rust
let guess: u32 = match guess.trim().parse() {
    Ok(num) => num,
    Err(_) => continue,
};
```

Is known that in a match we need to return the same values, so how those the example above works?

First of all we need to understand that the `continue` statement returns a `!` value, So when Rust compiler computes that one of the values of the match is a `!` it will infer that the type of the match is the type of the other value, in this case `u32`.

The formal type to explain this is that the `!` can be coerced into any other type. This is because the `!` type has no values, and a value needs to be coerced into a type that has a value. So, for example, `!` can be coerced into `i32` and `String` and any other type.

Other expression that has the the `!` value is the `loop`:

```rust
println!("forever, ");
loop {
    println!("and ever, ");
}
```

here the loop never returns so `!` is the value of the expression, until we have `break` statement.

## Dynamically Sized Types and the Sized Trait  

Rust needs to know certain details about its type, such as how much space to allocate for a value of a particular type. This leaves one corner of its type a little confusing at first: the concept of *dynamically sized types (DSTs)*. These types let us write code using values whose size we can know only at runtime.

Let's dig into the details of a dynamically sized type have used called `str`. `str` is a DST, we can't know its size at compile time, so we can't create a variable of type `str` directly, consider the next example:

```rust
let s1: str = "Hello, world!";
let s2: str = "How's it going?";
```

Rust need to know how much to memory allocate for any of the partcular type, and all of a type must use the same amount of memory. If Rust allowed us to write this code, this two values `str` would need to take up the same amount of space, but they don't. `s1` needs 12 bytes of memory, `s2` needs 15 bytes. This is why we can not create a variable holding a *dynamically sized type*.

In this case we use a `&T` Reference, that is a single value that stores the memory address of where the `T` is located, a `&str` is two values: the address of the `str` and its length. As such, we can know the size of a `&str` value at compile time: it's twice the size of a memory address. That is, we always know the size of a reference `&T`, no matter how long the `T` is. In general, this is the way to use values of *dynamically sized types* in Rust: put them behind a reference.

The golden rule of dynamically sized types is that we must always put values of dynamically sized types behind a pointer of some kind.

We can combine `&str` with all kinds of pointers: for example, `Box<str>`, `Rc<str>`, `Arc<str>`, `&str`, `&mut str`, `mutex<str>` `*const str`, and `*mut str`.

Every trait is a dynamically sized type we can refer to by using the name of the trait. For example to use trait objects, we use the `dyn` keyword and put it behind a pointer for example we can use them behind a pointer: `Box<dyn Trait>`, `Rc<dyn Trait>`, `Arc<dyn Trait>`, `&dyn Trait`, `&mut dyn Trait`, `mutex<dyn Trait>`, `*const dyn Trait`, and `*mut dyn Trait`.

To work with DST's, Rust provides the `Sized` trait to determine whether or not a type's size is known at compile time. This trait is automatically implemented for everything whose size is known at compile time. In addition, Rust implicitly adds a bound on `Sized` to every generic function.

```rust
fn generic<T>(t: T) {
    // --snip--
}
```

is actually treated as though we had written this:

```rust
fn generic<T: Sized>(t: T) {
    // --snip--
}
```

By default, generic funtions will only work on types that have a known size at compile time. However, you can use the following special syntax to relax this restriction:

```rust
fn generic<T: ?Sized>(t: &T) {
    // --snip--
}
```

A trait bound on `?Sized` means `T` may or may not be `Sized` and this notation overrides the default that generic types must have a known size at compile time. The `?Trait` syntax with this meaning is only available for the `Sized` trait.

Also note that we switched the type of `t` from `T` to `&T`. Because the type might not be `Sized`, and because in compile time the size of the is not known, we need to use a reference.
