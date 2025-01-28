# Macros in Rust 🦀

The macros are commonly use, but we don't exactly know what a macro is. Im sure that through all your adventure in Rust, you have used the macro `println!` and `vec!` but you don't know how they work. In this chapter, we will see what a macro is and how to create one.

The term *macro* refers to a family of features in Rust: *declarative* macros with `macro_rules!` and three kind of *procedural* macros:

- Custom `#[derive]` macros, that specify code added with the `derive` attribute used on structs and enums.
- Attribute-like macros that define custom attributes usable on any item.
- Function-like macros that look like functions calls but operate on the tokens specified as their arguments.

## The Difference Between Macros and Functions

Fundamentally, `macros` are a way of writing code that writes other code, which is known as *metaprogramming*. For example the `derive` attribute defined before a struct or enum generates an implementation of various traits for the struct or enum. Is for sure you have also use the `println!` and `vec!` macros. All these macros *expand* to produce more code than the code you've written manually.

**Metaprogramming** is useful for reducing the amount of code you have to write and maintain, which is also what function does. However macros have some aditional features that functions don't.

A function signature must declare the number and type of parameters the function has. Macros on the other hand, can take a variable of parameters: we can call `println!("Hello, world!)` with one argument or `println("hello, {}", "world")` with various arguments. Also, macros are expanded before the compiler the compiler interprets the meaning of the code, so a macro can, for example, implement a trait on a given type. A function can't, because it gets called at runtime and a trait needs to be implemented at compile time.

The downside to implementing a macro instead of a function is that the macro definition are more complex than function definition because just imagine how comple would be write code that writes more code for you. Due to this indirection, macros definitions are generally more difficult to read, understand, and maintain that function definition.

Another important difference between macros and functions is that you must define macros or bring them into scope *before* you can call them in a file, as opposed to functions you can define anywhere and call anywhere.

## Declarative Macros with `macro_rules!` for General Metaprogramming

To define a macro, you use the `macro_rules!` construct. Let's explore how to use a `macro_rules!` by looking at how the `vec!` macro to create a new vector with particular values. For example, the following macro creates a new vector containing three integers:

```rust
let v: Vec<u32> = vec![1, 2, 3];
```

We could also use the `vec!` macro to create a vector. We wouldn't be able to use a function to do the same because we wouldn't know the number or type of values up front

In the next example is slightly simplified definition of the `vec!` macro:

```rust
#[macro_export]
macro_rules! vec {
    ( $( $x: expr ), * ) => {
        {
            let mut temp_vec = Vec::new();
            $(
                temp_vec.push($x);
            )*
            temp_vec
        }
    };
}
```

>**Note**: The actual definition of the `vec!` macro in the standard library includes code to preallocate the correct amount of memory up front. That code is an optimization that we don't need to include in our example that we dont include here to make the example simpler.

The `#[macro_export]` annotation indicates that this macro should be made available whenever the crate in which the macro is defined is brought into scope. Without this annotation, the macro can't be brought into scope.

We then start the macro definition with the `macro_rules!` and the name of the macro we're defining *without* the exclamation mark. The name, in this case `vec`, is followed by curly brackets denoting the body of the macro definition.

The structure in the `vec!` body is similar to the structure of a `match` expression. here we have one arm with the pattern `( $( $x:expr), *)`, followed by `=>` and the block of code associated with this pattern. If the pattern matches, the associated block of code will be emitted. Given that this is the only pattern in this macro, there is only one valid way to match; any other pattern will result in an error. More complex macros can have more than one pattern.

Valid pattern syntax in macro definitions is different than the pattern syntax we use in Rust, because macro pattern are matched against Rust code structure rather than values.

In the next pattern `( $( $x: expr), * )` first we use a set of parentheses to encompass the whole pattern. We use a dollar sign `($)` to declare a variable in the macro system that will contain the Rust code matching the pattern. The dollar sign make it clear this is macro variable opposed to a regular Rust variable. Next comes a set of parentheses that captures values that match the pattern within the parentheses for use in the replacement code. Within `$()` is `$x: expr`, which matches any Rust expression and gives the expression the name `$x`.

The comma following `$()` indicates that a literal comma separator character could optionally appear after the code that matches the code inside `$()`. The `*` specifies that the pattern matches zero or more times depending on how many times the pattern matches. The `$x` is replaced with each expression matched. When we call this macro with `vec![1, 2, 3];`, the code generated that replaces this macro call will be the following.:

```rust
{
    let mut temp_vec = Vec::new();
    temp_vec.push(1);
    temp_vec.push(2);
    temp_vec.push(3);
    temp_vec
}
```

We've defined a macro that can take any number of arguments of any type and can generate code to create a vector containing the specified elements.

## Procedural Macro for Generating Code from Attributes

The second form of macors id the *procedural macro*, which acts more like a function (and is a type of procedure). Procedural macros accept some code as input, operate on that code, and produce some code as output rather than matching against patterns and replacing the code with other code as [declarative macros do](#declarative-macros-with-macro_rules-for-general-metaprogramming). The three kinds of procedural macros are custom derive macros, attribute-like macros, and function-like macros, and all works in a similar fashion way.

When creating procedural macros, the definitions must reside in their own crate with a special crate type. This is for complex technical reasons that Rust teams plans to eliminate in the future. In the example below we show how to define a procedural macro, where `some_attribute` is a placeholder for using a specific macro variety.

```rust
use proc_macro;

#[some_attribute]
pub fn some_name(input: TokenStream) -> TokenStream {
}
```

The function that defines a procedural macro takes a `TokenStream` as an input and produces a `TokenStream` as an output. The `TokenStream` type is defined by the `proc_macro` crate that is included with Rust and represents a sequence of tokens. This is the core of the macro: the source code that the macros is operating on makes up the input `TokenStream`, and the code the macro produces is the output `TokenStream`. The function has also an attribute attached to it that specifies which kind of procdefural macro we're creating. We can have multiple kinds of procedural macros in the same crate.

### How to Write a Custom `derive` Macro

Let's create a named `hello_macro` that defines a trait named `HelloMacro` with one associated function named `hello_macro`. Rather than making our users implement the `HelloMacro` trait for each of their types, we'll provide a procedural macro so users can annotate their type with `#[derive(HelloMacro)]` to get a default implementation of the hello_macro function. The default implementation of the `hello_macro` function print `Hello, Macro! My name is TypeName!` where `TypeName` is the name of the type on which this trait is implemented. In other words, we'll write a crate that enables another programmer to write code like this:

```rust
use hello_macro::HelloMacro;
use hello_macro_derive::HelloMacro;

#[derive(HelloMacro)]
struct Pancakes;

fn main() {
    Pancakes::hello_macro();
}
```

This code will print `Hello, Macro! My name is Pancakes!`.

#### Creating the `hello_macro` Library Crate

We will create the crate hello_macro:

```powershell
cargo new hello_macro --lib --vcs none
```

Next we will define the trait `HelloMacro` in the `src/lib.rs` file:

```rust
pub trait HelloMacro {
    fn hello_macro();
}
```

#### Creating the `hello_macro_derive` Library Crate

Our two crates are thightly related, so we create the procedural macro crate within the directory of the `hello_macro` crate. If we change the trait definition in `hello_macro`, we'll have to change the implementation of the procedural macro in `hello_macro_derive` as well.

```powershell
cargo new hello_macro_derive --lib --vcs none
```

>**note:** The two crate will need to be published separately, and programmers using this crates will need to add both as dependencies and bring both into scope with `use`. We could instead have the `hello_macro` crate use the `hello_macro_derive` crate as a dependency and re-export the procedural macro code. However, the way we've structured the project makes it possible for programmers to use the `hello_macro` even if they don't want the `derive` functionality.

We need to declare the `hello_macro_derive` crate as a procedural macro crate. We'll also need functionality from the `syn` and `quote` crates. In Cargo.toml of the `hello_macro_derive` crate, we add the following dependencies:

```toml
[lib]
proc-macro = true

[dependencies]
syn = "1.0"
quote = "1.0"
```

#### Defining the Procedural Macro

In the `src/lib.rs` file of the `hello_macro_derive` crate, we define the procedural macro:

```rust
use proc_macro::TokenStream;
use quote::quote;
use syn;

#[proc_macro_derive(HelloMacro)]
pub fn hello_macro_derive(input: TokenStream) -> TokenStream {
    // Construct a representation of Rust code as a syntax tree
    // that we can manipulate
    let ast = syn::parse(input).unwrap();

    // Build the trait implementation
    impl_hello_macro(&ast)
}
```

Notice that we have split the code into the `hello_macro_derive` function, which is responsible for parsing the `TokenStream`, and the `impl_hello_macro` function, which is responsible for transforming the syntax tree: This makes writing a procedural macro more convenient. The code in the outer function (`hello_macro_derive` in this case) will be the same for almost every procedural macro crate you see or create. The code you specify in the body of the inner function (`impl_hello_macro` in this case) will be different depending on your procedural macro's purpose.

We've introduced three new crates: `proc_macro`, `syn`, and `quote`. The `proc_macro` crate comes with Rust, so we didn't need to add that to the dependencies in *Cargo.toml*. The `proc_macro` crate is the compiler's API that allows us to read and manipulate Rust code from our code.

The `syn` crate parses Rust code from a string into a data structure that we can perform operations on. The `quote` crate turns `syn` data structures back into Rust code. These crates make it much simpler to parse any sort of Rust code we might want to handle: writing a full parser for Rust code is no simple task.

The `hello_macro_derive` function will be called when a user of our library specifies `#[derive(HelloMacro)]` on a type. This is possible because we've annotated the `hello_macro_derive` function with `proc_macro_derive` and specified the name `HelloMacro`, which matches our trait name; this is the convention most procedural macros follow.

The `hello_macro_derive` function first converts the input from a `TokenStream` to a data structure that we can then interpret and perform operations on. This is where `syn` comes into play. The `parse` function in `syn` takes a `TokenStream` and returns a `DeriveInput` struct representing the parsed Rust code. The next example shows the relevant parts of the `DeriveInput` struct we get from parsing the `struct Pancakes;` string:

```rust
DeriveInput {
    // --snip--

    ident: Ident {
        ident: "Pancakes",
        span: #0 bytes(95..103)
    },
    data: Struct(
        DataStruct {
            struct_token: Struct,
            fields: Unit,
            semi_token: Some(
                Semi
            )
        }
    )
}
```

The field of this struct show that the Rust code we0ve parsed is a unit struct with the `ident` (identifier, meaning the name) of `Pancakes`.

Soon we'll define the `impl_hello_macro` function, which is where we'll build the new Rust code we want to include. But before we do, note that the output for our derive macro is also a `TokenStream`. The returned `TokenStream` is added to the code that our crate user writes, so when they compile their crate, they'll get the extra functionality that we provide in the modified `TokenStream`.

You might have noticed that we’re calling `unwrap` to cause the `hello_macro_derive` function to panic if the call to the `syn::parse` function fails here. It’s necessary for our procedural macro to panic on errors because `proc_macro_derive` functions must return `TokenStream` rather than `Result` to conform to the procedural macro API. We’ve simplified this example by using `unwrap;` in production code, you should provide more specific error messages about what went wrong by using `panic!` or `expect`.

#### Implementing the `HelloMacro` Trait

In the `impl_hello_macro` function, we'll generate the code that implements the `HelloMacro` trait for the type the user annotated with `#[derive(HelloMacro)]`. The `quote` crate provides the `quote!` macro that makes generating the Rust code much easier. The `quote!` macro is similar to the `format!` macro we've used before, but instead of generating a `String`, it generates a `TokenStream`.

```rust
fn impl_hello_macro(ast: &syn::DeriveInput) -> TokenStream {
    let name = &ast.ident;
    let gen = quote! {
        impl HelloMacro for #name {
            fn hello_macro() {
                println!("Hello, Macro! My name is {}", stringify!(#name));
            }
        }
    };
    gen.into()
}
```

The `impl_hello_macro` function takes a `DeriveInput` struct as an argument and returns a `TokenStream`. The `DeriveInput` struct is the result of parsing the Rust code that our macro is being applied to. The `DeriveInput` struct has an `ident` field that holds the name of the type the macro is being applied to. We use this name in the `quote!` macro to generate the implementation of the `HelloMacro` trait for the type.

The `quote!` macro generates the actual implementation. The `#name` syntax is how we substitute the `name` variable into the quote. The `stringify!` macro converts an `ident` into a string. The `gen.into()` at the end of the function is necessary to convert the `TokenStream` returned by `quote!` into the `TokenStream` that the `proc_macro_derive` function expects.

#### Using the `hello_macro` and `hello_macro_derive` Crates

Let's construct a new crate named `Pancake`, which will utilize the functionality provided by the `hello_macro` and `hello_macro_derive` crates:

```powershell
cargo new pancake --vcs none
```

To incorporate the functionality of the `hello_macro` and `hello_macro_derive` crates, we must list them as dependencies in our `Cargo.toml` file:

```toml
[dependencies]
hello_macro = { path = "hello_macro" }
hello_macro_derive = { path = "hello_macro_derive" }
```

Next, we need to import the `HelloMacro` trait into the `src/main.rs` file of the `pancake` crate:

```rust
use hello_macro::HelloMacro;
use hello_macro_derive::HelloMacro;
```

Now, by applying the `#[derive(HelloMacro)]` annotation to the `Pancakes` struct, we can implement the `HelloMacro` trait for `Pancakes`:

```rust
#[derive(HelloMacro)]
struct Pancakes;

fn main() {
    Pancakes::hello_macro();
}
```

Now executing the `pancake` crate, the message `Hello, Macro! My name is Pancakes!` will be displayed.

### Attribute-like Macros

Attribute-like macros are similar to custom derive macros, but instead of generating code for the `derive` attribute, they allow you to create new attributes. They're also more flexible: `derive` only works for structs and enums; attributes can be applied to other items as well, such as functions. Here's an example of using an attribute-like macro: say you have an attribute named `route` that annotates functions when using a web application framework:

```rust
#[route(GET, "/")]
fn index() {
    // --snip--
}
```

This `#[route]` attribute would be defined by the framework as a procedural macro. The signature of the macro definition function would look like this:

```rust
#[proc_macro_attribute]
pub fn route(attr: TokenStream, item: TokenStream) -> TokenStream {
    // -- snip --
}
```

Here, we have two parameters of type `TokenStream`. The first is for the contents of the attribute: the `GET, "/"` part. The second is the body of the item the attribute is attached to: in this case, `fn index() { // --snip-- }` and the rest of the function's body.

Other than that, attribute-like macros work the same way as custom derive macros: you create a crate with the `proc_macro` crate type and implement a function that generates the code you want!

### Function-like - Macros

Function-like macros define macros that look like function calls. Similar to `macro_rules!` macros, they're more flexible than functions: for example, they can take an unknown number of arguments. However, `macro_rules!` macros can be defined only using the match-like syntax we discussed in the section [Declarative Macros with `macro_rules!` for General Metaprogramming](#declarative-macros-with-macro_rules-for-general-metaprogramming) earlier. Function-like macros take a `TokenStream` parameter and their definition manipulates that `TokenStream` using Rust code as the other two types of procedural macros do. An example of a function-like macro is an `sql!` macro that might be called like so:

```rust
let sql = sql!(SELECT * FROM posts WHERE id = 1);
```

This macro would parse the SQL statement inside it and check that it's syntactically correct, which is much more complex processing than a `macro_rules!` macro can do. The `sql!` macro would be defined like this:

```rust
#[proc_macro]
pub fn sql(input: TokenStream) -> TokenStream {
    // --snip--
}
```

This definition is similar to the custom derive macro's signature: we receive the tokens that are inside the parentheses and return the code we want to generate.
