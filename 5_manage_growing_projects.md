# Managing Growing Projects with packages, crates and modules in rust 🦀

In Rust, the organization and structure of your code is facilitated through the use of packages, crates, modules, and paths. These elements play a crucial role in managing growing projects and maintaining clean, readable code.

- **Packages**: A package is the largest organizational unit in Rust. It contains a `Cargo.toml` file which describes how to build the package's crates. A package can contain at most one library crate and any number of binary crates.

- **Crates**: A crate is a compilation unit in Rust. It can be either a binary, which is executable, or a library, which contains reusable code that can be incorporated into other programs.

- **Modules**: Modules allow you to group related definitions together, making your code more organized and readable. They also control the privacy of items, as items in a module are private by default.

- **Paths**: Paths in Rust allow you to name an item, such as a struct, function, or module, so that it can be used elsewhere in the code. They are a way of navigating through modules and crates to access items.

Understanding and effectively using these elements is key to managing and organizing your Rust code, especially as your projects grow in size and complexity.

## Index

1. [Packages and Crates](#packages-and-crates)
2. [Defining a Module to contol scope and privacy](#defining-a-module-to-contol-scope-and-privacy)
    - [Modules cheat sheet](#modules-cheat-sheet)
3. [Paths for referring to an item in the module tree](#paths-for-referring-to-an-item-in-the-module-tree)
    - [Exposing Paths with the `pub` keyword](#exposing-paths-with-the-pub-keyword)
    - [Starting realtive paths with `super`](#starting-realtive-paths-with-super)
    - [Making `Structs` and `Enums` Public](#making-structs-and-enums-public)
4. [Bringing Paths into Scope with the `use` keyword](#bringing-paths-into-scope-with-the-use-keyword)
    - [Creating Idiomatic use Paths](#creating-idiomatic-use-paths)
    - [Re-exporting Names with `pub use`](#re-exporting-names-with-pub-use)
    - [Using External Packages](#using-external-packages)
    - [Using nested paths to clean up large `use` lists](#using-nested-paths-to-clean-up-large-use-lists)
    - [The glob Operator](#the-glob-operator)

## Packages and Crates

A crate is the smallest amount of code that can be compiled into a `binary` or `library`. A package is one or more crates that provide a set of functionality.

`Binary crates` are programs you can compile to an executable that you can run, such as a command-line program or a server. Each must have a function called main that defines what happens when the executable runs. All the crates we’ve created so far have been binary crates.

`Library crates` are used to create reusable code. They don’t have a main function, and they can’t be compiled into an executable. Their purpose is to be used as a dependency by other programs.

A **package** is a bundle of one or more crates that provides a set of functionality. A package contains a Cargo.toml file that describes how to build those crates.

>**Fun fact:** Cargo is actually a package that contains the binary crate for the command-line tool you’ve been using to build your code. The Cargo package also contains a library crate that the binary crate depends on. Other projects can depend on the Cargo library crate to use the same logic the Cargo command-line tool uses.

In the `Cargo.toml` file, we encounter an instance of a package that implicitly refers to the `src/main.rs` file. This file serves as the crate root, which is the starting point for the Rust compiler. The crate root forms the root module of your crate (a module being a collection of related functionalities). Because the `src/main.rs` file is inherently understood to be the crate root, it is not explicitly mentioned in the package.

A crate root is essentially a source file from which the Rust compiler begins its operations. It forms the basis of your crate's module structure, making it the root module of your crate.

Interestingly, a package in Rust can contain multiple binary crates. This is achieved by placing files in the `src/bin` directory. Each file in this directory will be compiled as a separate binary crate, thereby allowing a single package to house multiple, independent executable programs.

## Defining a Module to contol scope and privacy

In this section we will learn how to use modules to control the scope and privacy of items in our code. We will also learn how to define modules and nested modules.

### `Modules cheat sheet`

1. **start from the crate root:** When compiling a crate, the compiler first looks in the crate root file (usually src/lib.rs for a library crate or src/main.rs for a binary crate) for code to compile.

2. **declaring modules:** Declaring modules: In the crate root file, you can declare new modules; say, you declare a “garden” module with `mod garden;`. The compiler will look for the module’s code in these places:
    - Inline, within curly brackets that replace the semicolon after the mod statement
    - A file named **`src/garden.rs`** or **`src/garden/mod.rs`**

3. **declaring nested modules:** In any file other than the crate root, you can declare submodules. For example, you might declare `mod vegetables;` in src/garden.rs. The compiler will look for the submodule’s code within the directory named for the parent module in these places:
    - Inline, within curly brackets that replace the semicolon after the mod statement
    - A file named **`src/garden/vegetable.rs`** or **`src/garden/vegetable/mod.rs`**

4. **paths to code in modules:** Once a module is part of your crate, you can refer to code in that module from anywhere else in that same crate, as long as the privacy rules allow, using the path to the code. For example, an `Asparagus` type in the garden vegetables module would be found at **`crate::garden::vegetables::Asparagus`**.

5. **private vs public:** Code within a module is private from its parent modules by default. To make a module public, declare it with **`pub mod`** instead of **`mod`**. To make items within a public module public as well, use pub before their declarations.

6. **The `use` keyword:** Within a scope, the `use` keyword creates shortcuts to items to reduce repetition of long paths. In any scope that can refer to **`crate::garden::vegetables::Asparagus`**, you can create a shortcut with **`use crate::garden::vegetables::Asparagus;`** and from then on you only need to write Asparagus to make use of that type in the scope.

Here we create a binary crate named backyard that illustrates these rules. The crate’s directory, also named backyard, contains these files and directories:

```bash
backyard
├── Cargo.toml
├── Cargo.lock
└── src
    ├── garden
    │   └── vegetables.rs
    ├── garden.rs
    └── main.rs
```

Filename: `src/main.rs`

```rust
use crate::garden::vegetables::Asparagus;

pub mod garden;

fn main() {
    let plant = Asparagus {};
    println!("I'm growing {:?}!", plant);
}
```

Filename: `src/garden.rs`

```rust
pub mod vegetables;
```

Filename: `src/garden/vegetables.rs`

```rust
#[derive(Debug)]
pub struct Asparagus {
    pub name: String,
    pub spear_count: i32,
}
```

### `Grouping Related code in Modules`

Modules let us organize code within a crate for readability and easy reuse. Modules also allow us to control the privacy of items, because code within a module is private by default. Private items are internal implementation details not available for outside use. We can choose to make modules and the items within them public, which exposes them to allow external code to use and depend on them.

As an example, let’s write a library crate that provides the functionality of a restaurant. We’ll define the signatures of functions but leave their bodies empty to concentrate on the organization of the code, rather than the implementation of a restaurant.

In the restaurant industry, some parts of a restaurant are referred to as front of house and others as back of house. Front of house is where customers are; this encompasses where the hosts seat customers, servers take orders and payment, and bartenders make drinks. Back of house is where the chefs and cooks work in the kitchen, dishwashers clean up, and managers do administrative work.

To structure our crate in this way, we can organize its functions into nested modules. Create a new library named restaurant by running **`cargo new restaurant --lib;`**.

Filename: `src/lib.rs`

```rust
mod front_of_house {
    mod hosting {
        fn add_to_waitlist() {}

        fn seat_at_table() {}
    }

    mod serving {
        fn take_order() {}

        fn serve_order() {}

        fn take_payment() {}
    }
}
```

Earlier, we mentioned that `src/main.rs` and `src/lib.rs` are called crate roots. The reason for their name is that the contents of either of these two files form a module named crate at the root of the crate’s module structure, known as the module tree:

```bash
crate
 └── front_of_house
     ├── hosting
     │   ├── add_to_waitlist
     │   └── seat_at_table
     └── serving
         ├── take_order
         ├── serve_order
         └── take_payment
```

## Paths for referring to an item in the module tree

To show your rust program where to find an item in the module tree, you use a path in the form of `foo::bar::baz`. A path can take two forms:

- An **`absolute path`** starts from a crate root by using a `crate name` if it is an external crate or the `crate` keyword if it is the current crate.
- A **`relative path`** starts from the current module and uses self, super, or an identifier in the current module.

To understand how paths works is important to understand the module tree. The module tree is a way of organizing your code. It’s like a file system’s directory tree: files live in directories, and directories can have other directories as children. The module tree is similar, but it defines Rust modules instead of files and directories.

Taking the restaurant example, the module tree would look like this:

```bash
crate
 └── front_of_house
     ├── hosting
     │   ├── add_to_waitlist
     │   └── seat_at_table
     └── serving
         ├── take_order
         ├── serve_order
         └── take_payment
```

To call a function in the `add_to_waitlist` function, we can make it this way:

```rust
pub fn eat_at_restaurant() {
    // Absolute path
    crate::front_of_house::hosting::add_to_waitlist();

    // Relative path
    front_of_house::hosting::add_to_waitlist();
}
```

Even though the path is correctly is important to know that modules, structs, enums, and functions are private by default. To make an item or path public, you can add the `pub` keyword in front of it.

That is why the last code is not working, because the `add_to_waitlist` function is private.

### Exposing Paths with the `pub` keyword

To allow external code to use a path, you can make the path public. This is done by adding the `pub` keyword in front of the path. This technique is used to expose the path to the `add_to_waitlist` function.

```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}

        fn seat_at_table() {}
    }

    mod serving {
        fn take_order() {}

        fn serve_order() {}

        fn take_payment() {}
    }
}
```

>**Note:** Is you are interest in sharing you library crate so other projects can use your code, your public api should be well documented and easy to use. This is a good practice to make your code more reusable and easy to understand. see [The Rust API Guidelines](https://rust-lang.github.io/api-guidelines/) for more information.

### Starting realtive paths with `super`

We can construct relative paths that begin in the parent module, rather than the current module or the crate root, by using super at the start of the path. This is like starting a filesystem path with the .. syntax. Using super allows us to reference an item that we know is in the parent module, which can make rearranging the module tree easier when the module is closely related to the parent, but the parent might be moved elsewhere in the module tree someday.

```rust
fn serve_order() {}

mod back_of_house {
    fn fix_incorrect_order() {
        cook_order();
        super::serve_order();
    }

    fn cook_order() {}
}
```

### Making `Structs` and `Enums` Public

You can also use the `pub` keyword to make structs, enums, and other items public. By default, structs and enums are private, so you need to make them public if you want to use them in external code. Just that the behaviour of the `pub` is different between the `struct` and `enum` fields.

The `struct` can be made public, but the fields are private by default. You can make the fields public by adding the `pub` keyword before each field.

```rust
mod back_of_house {
    pub struct Breakfast {
        pub toast: String,
        seasonal_fruit: String,
    }

    impl Breakfast {
        pub fn summer(toast: &str) -> Breakfast {
            Breakfast {
                toast: String::from(toast),
                seasonal_fruit: String::from("peaches"),
            }
        }
    }
}
```

The `enum` can be made public, but all its variants are public by default. You can make each variant private by starting it with the `pub` keyword.

```rust
mod back_of_house {
    pub enum Appetizer {
        Soup,
        Salad,
    }
}
```

Logicly this is done because enum are not so useful if the variants are private, but the `struct` is useful to make the fields private by default, because you can control the access to the fields and make the struct more secure.

## Bringing Paths into Scope with the `use` keyword

It could be a little bit annoying to write the full path every time you want to use a function, struct, or enum. To solve this problem, you can bring a path into scope with the `use` keyword. This is like creating a shortcut to the path, so you can use it more easily.

```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}
```

### `Creating Idiomatic use Paths`

You might be wondering why we don't directly bring the `add_to_waitlist` function into scope. The reason lies in Rust's idiomatic practices. It's considered more idiomatic to specify the parent module when calling a function, rather than bringing individual functions into scope. This approach provides clarity about the function's origin. If we were to bring in just the functions, it could lead to confusion about which parent module they belong to.

```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

use crate::front_of_house::hosting::add_to_waitlist;

pub fn eat_at_restaurant() {
    add_to_waitlist();
    add_to_waitlist();
    add_to_waitlist();
}
```

Contrastingly, when importing structs, enums, and other items using the `use` keyword, it's considered idiomatic in Rust to specify the full path. This practice provides clarity and avoids potential conflicts with items of the same name from different modules. Refer to the figure below, which demonstrates the idiomatic way to bring the `HashMap` struct from Rust's standard library into the scope of a binary crate. This approach ensures that it's clear we're using the `HashMap` from the standard library, and not a local or third-party version.

```rust
use std::collections::HashMap;

fn main() {
    let mut map = HashMap::new();
    map.insert(1, 2);
}
```

The exception to this idiom is if we’re bringing two items with the same name into scope with use statements, because Rust doesn’t allow that. Listing 7-15 shows how to bring two Result types into scope that have the same name but different parent modules and how to refer to them.

```rust
use std::fmt;
use std::io;

fn function1() -> fmt::Result {
    // --snip--
}

fn function2() -> io::Result<()> {
    // --snip--
}
```

Another solution to this problem is to use the `as` keyword to create an alias for the path. This technique is useful when you want to bring two items with the same name into scope.

```rust
use std::fmt::Result;
use std::io::Result as IoResult;

fn function1() -> Result {
    // --snip--
}

fn function2() -> IoResult<()> {
    // --snip--
}
```

### Re-exporting Names with `pub use`

When you bring a name into scope with the `use` keyword, the name available in the new scope is private. To enable the name to be public, you can combine `pub` and `use`. This technique is called re-exporting because you're bringing an item into scope and making it public.

```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

pub use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}
```

Before this change, external code would have to call the add_to_waitlist function by using the path `restaurant::front_of_house::hosting::add_to_waitlist()`. Now that this pub use has re-exported the hosting module from the root module, external code can now use the path `restaurant::hosting::add_to_waitlist()` instead.

### `Using External Packages`

When you want to use an external package, you can add it to your `Cargo.toml` file. This file is used to describe how to build your package, and it also contains metadata about your package. The `Cargo.toml` file is the manifest file for Rust projects. It contains all the metadata that Cargo needs to compile your package.

```toml
[dependencies]
rand = "0.8.3"
```

After adding the package to your `Cargo.toml` file, you can use the `use` keyword to bring the package into scope. This allows you to use the package's functions, structs, and enums in your code.

```rust
use rand::Rng;

fn main() {
    let secret_number = rand::thread_rng().gen_range(1..101);
    println!("The secret number is: {}", secret_number);
}
```

Members of the Rust community have made many packages available at crates.io, and pulling any of them into your package involves these same steps: listing them in your package’s Cargo.toml file and using use to bring items from their crates into scope.

### Using nested paths to clean up large `use` lists

When you bring a path into scope with the `use` keyword, you can use a nested path to clean up large `use` lists. This technique is useful when you want to bring multiple items from the same path into scope.

```rust
use std::collections::HashMap;
use std::fmt;
use std::io;
```

This code can be cleaned up by using a nested path to bring the `fmt` and `io` modules into scope.

```rust
use std::{collections::HashMap, fmt, io};
```

This technique is especially useful when you want to bring multiple items from the same path into scope. It can help to clean up your code and make it more readable.

We can use a nested path at any level in a path, which is useful when combining two use statements that share a subpath.

```rust
use std::io;
use std::io::Write;
```

This code can be cleaned up by using a nested path to bring the `io` module into scope.

```rust
use std::io::{self, Write};
```

### `The glob Operator`

To bring all the public items of a path into scope, you can use the `glob` operator. This technique is useful when you want to bring all the public items of a path into scope.

```rust
use std::collections::*;
```
