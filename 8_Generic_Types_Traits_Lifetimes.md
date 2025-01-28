# Generic Types, Traits and Lifetimes

Every programming language has tools for effectively handling the duplication of concepts. In Rust, one such tool is generics: abstract stand-ins for concrete types or other properties. We can express the behavior of generics or how they relate to other generics without knowing what will be in their place when compiling and running the code.

## Index

1. [Generic Data Types](#generic-data-types)
    - [In Function Definitions](#in-function-definitions)
    - [In Struct Definitions](#in-struct-definitions)
    - [In Enum Definitions](#in-enum-definitions)
    - [In Method Definitions](#in-method-definitions)
    - [Performance of Code Using Generics](#performance-of-code-using-generics)
2. [Traits: Defining Shared Behavior](#traits)
    - [Defining a Trait](#defining-a-trait)
    - [Implementing a Trait on a Type](#implementing-a-trait-on-a-type)
        - [Orphan Rule](#orphan-rule)
    - [Default Implementations](#default-implementations)
    - [Traits as parameters](#traits-as-parameters)
        - [Trait Bound Syntax](#trait-bound-syntax)
        - [Specifying Multiple Trait Bounds with the `plus` Syntax](#specifying-multiple-trait-bounds-with-the-plus-syntax)
        - [Clearer Trait Bounds with `where` Clauses](#clearer-trait-bounds-with-where-clauses)
    - [Returning `Types` that Implement `Traits`](#returning-types-that-implement-traits)
    - [Using `trait` Bounds to Conditionally Implement Methods](#using-trait-bounds-to-conditionally-implement-methods)
    - [Conclusion: The Power of Traits in Rust](#conclusion-the-power-of-traits-in-rust)
3. [Validating references with lifetime](#lifetimes)
    - [Preventing Dangling References with Lifetimes](#preventing-dangling-references-with-lifetimes)
    - [Borrow Checker](#borrow-checker)
    - [Generic Lifetimes in Functions](#generic-lifetimes-in-functions)
    - [Lifetime Annotation Syntax](#lifetime-annotations-syntax)
    - [Lifetime annotations in function signatures](#lifetime-annotations-in-function-signatures)
    - [Thinking in Terms of Lifetimes](#thinking-in-terms-of-lifetimes)
    - [Lifetime Annotations in Struct Definitions](#lifetime-annotations-in-struct-definitions)
    - [Lifetime Elision](#lifetime-elision)
    - [Lifetime Annotations in Method Definitions](#lifetime-annotations-in-method-definitions)
    - [Static Lifetime](#static-lifetime)
    - [Generic Type Parameters, Trait Bounds, and Lifetimes Together](#generic-type-parameters-trait-bounds-and-lifetimes-together)

## Generic Data Types

We use generics to create definitions for items like function signatures or structs, which we can then use with many different concrete data types. Let’s first look at how to define functions, structs, enums, and methods using generics. Then we’ll discuss how generics affect code performance.

### In `Function` Definitions

When defining a function that uses `generics`, we place the `generics` in the signature of the function where we would usually specify the data types of the `parameters` and `return` value. Doing so makes our code more flexible and provides more functionality to callers of our function while preventing code duplication.

Below we show two functions that both find the largest value in a slice. We'll then combine these into a single function that uses `generics`.

```rust
fn largest_i32(list: &[i32]) -> i32 {
    let mut largest = list[0];

    for &item in list.iter() {
        if item > largest {
            largest = item;
        }
    }

    largest
}

fn largest_char(list: &[char]) -> char {
    let mut largest = list[0];

    for &item in list.iter() {
        if item > largest {
            largest = item;
        }
    }

    largest
}

fn main() {
    let number_list = vec![34, 50, 25, 100, 65];

    let result = largest_i32(&number_list);
    println!("The largest number is {}", result);

    let char_list = vec!['y', 'm', 'a', 'q'];

    let result = largest_char(&char_list);
    println!("The largest char is {}", result);
}
```

The `largest_i32` and `largest_char` functions are almost identical. They differ only in the types of their parameters and return values. We can avoid duplicating code by using `generics` to define a function that takes any type that can be compared and that we can use to find the largest reference.

```rust
use std::cmp::PartialOrd;

fn largest<T: PartialOrd + Copy>(list: &[T]) -> &T {
    let mut largest = &list[0];

    for number in list {
        if number > largest {
            largest = number;
        }
    }

    largest
}

fn main() {
    let number_list: Vec<i32> = vec![34, 50, 199, 89, 61];

    let result = largest(&number_list);

    println!("The largest number is: {result}");

    let char_list: Vec<char> = vec!['a', 'b', 'c'];

    let result = largest(&char_list);

    println!("The largest character is: {result}");
}
```

### In `Struct` Definitions

We can also define structs to use a generic type parameter in one or more fields using the `<>` syntax. Listing 10-6 defines a `Point<T>` struct to hold x and y coordinate values of any type.

```rust
struct Point<T> {
    x: T,
    y: T,
}

fn main() {
    let integer = Point { x: 5, y: 10 };
    let float = Point { x: 1.0, y: 4.0 };
}
```

The syntax for using generics in `struct` definitions is similar to that used in function definitions. First, we declare the name of the type parameter inside `<>` just after the name of the `struct`. Then we use the generic type in the `struct` definition where we would otherwise specify concrete data types.

Note that because we’ve used only one generic type to define `Point<T>`, this definition says that the `Point<T>` struct is generic over some type T, and the fields x and y are both that same type, whatever that type may be. If we create an instance of a `Point<T>` that has values of different types, our code won’t compile if we define values for x and y that are of different types, just like the example below.

```rust
struct Point<T> {
    x: T,
    y: T,
}

fn main() {
    let wont_work = Point { x: 5, y: 4.0 };
}
```

To define a `Point` struct where `x` and `y` are both generics but could have different types, we can use multiple generic type parameters. For example, in the example below, we change the definition of Point to be generic over types `T` and `U` where `x` is of type `T` and `y` is of type `U`.

```rust
struct Point<T, U> {
    x: T,
    y: U,
}

fn main() {
    let both_integer = Point { x: 5, y: 10 };
    let both_float = Point { x: 1.0, y: 4.0 };
    let integer_and_float = Point { x: 5, y: 4.0 };
}
```

### In `Enum` Definitions

As we did with structs, we can define `enums` to hold generic data types in their variants. Let’s take another look at the `Option<T>` enum that the standard library provides:

```rust
enum Option<T> {
    Some(T),
    None,
}
```

This definition should now make more sense to you. As you can see, the `Option<T>` enum is generic over type T and has two variants: Some, which holds one value of type T, and a None variant that doesn’t hold any value. By using the `Option<T>` enum, we can express the abstract concept of an optional value, and because `Option<T>` is generic, we can use this abstraction no matter what the type of the optional value is.

Enums can use `multiple generic` types as well. The definition of the Result is an exmpale of this.

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

>**note:** When you recognize situations in your code with multiple struct or enum definitions that differ only in the types of the values they hold, you can avoid duplication by using generic types instead.

### In `Method` Definitions

We can implement methods on structs and enums and use generic types in their definitions, too. Listing 10-9 shows a method named `x` on the `Point<T>` struct that returns a reference to the `x` field of a `Point<T>` instance.

```rust
struct Point<T> {
    x: T,
    y: T,
}

impl<T> Point<T> {
    fn x(&self) -> &T {
        &self.x
    }
}

fn main() {
    let p = Point { x: 5, y: 10 };

    println!("p.x = {}", p.x());
}
```

The `impl` block in the example defines methods on a type. In this case, the `impl` block holds the `Point` struct definition, and within the `impl` block, we define the methods on `Point<T>`. The `impl` block specifies `T`, so we can use the `Point` struct to define a `Point<i32>` instance or a `Point<f64>` instance. The method `x` returns a reference to the `x` field, which is a reference to a value of type `T`.

>**note:** Note that we have to declare `T` just after impl so we can use `T` to specify that we’re implementing methods on the type `Point<T>`. By declaring `T` as a generic type after `impl`, Rust can identify that the type in the angle brackets in `Point` is a generic type rather than a concrete type. We could have chosen a different name for this generic parameter than the generic parameter declared in the struct definition `T`, but using the same name is conventional. Methods written within an impl that declares the generic type will be defined on any instance of the type, no matter what concrete type ends up substituting for the generic type.

We can also specify constraints on generic types when defining methods on the type. We could, for example, implement methods only on `Point<f32>` instances rather than on `Point<T>` instances with any generic type. In the example below we use the concrete type `f32`, meaning we don’t declare any types after impl.

```rust
impl Point<f32> {
    fn distance_from_origin(&self) -> f32 {
        (self.x.powi(2) + self.y.powi(2)).sqrt()
    }
}
```

Generic type parameters in a struct definition aren’t always the same as those you use in that same `struct’s` method signatures. In the example below uses the generic types `X1` and `Y1` for the Point struct and `X2 Y2` for the mixup method signature to make the example clearer. The method creates a new Point instance with the `x` value from the self Point (of type `X1`) and the `y` value from the passed-in Point (of type `Y2`).

```rust
struct Point<X1, Y1> {
    x: X1,
    y: Y1,
}

impl<X1, Y1> Point<X1, Y1> {
    fn mixup<X2, Y2>(self, other: Point<X2, Y2>) -> Point<X1, Y2> {
        Point {
            x: self.x,
            y: other.y,
        }
    }
}

fn main() {
    let p1 = Point { x: 5, y: 10.4 };
    let p2 = Point { x: "Hello", y: 'c' };

    let p3 = p1.mixup(p2);

    println!("p3.x = {}, p3.y = {}", p3.x, p3.y);
}
```

The point of this example is to show that the generic type parameters for a struct definition and its method signature don’t have to be the same. The method’s generic type parameters are declared after `impl` and used after the method name. The struct’s generic type parameters are declared after the struct name and used after the struct name throughout the definition.

### `Performance of Code Using Generics`

Rust accomplishes `generics` in such a way that your code doesn’t run any slower using `generic` types than it would with concrete types. When Rust compiles your code, it performs `monomorphization` to create specific implementations of the `generic` code at compile time. The monomorphized code is the result of the compiler filling in the concrete types that are used when generic code is called. In this process, the compiler does the opposite of the steps we used to define a generic function. When the generic function is called, the compiler finds the concrete types that are used in the code and generates the code for the specific types.

This process is called `monomorphization`, which is the process of turning generic code into specific code by filling in the concrete types that are used when compiled. The code that results from `monomorphization` is the same as if we had written out all the concrete types by hand. Monomorphization is what allows Rust to provide the benefits of generics without any runtime cost.

>`monomorphization`: a compile-time process where polymorphic functions are replaced by many monomorphic functions for each unique instantiation.

## Traits

A `trait` in Rust represents a set of behaviors or capabilities that types can share. It allows us to define shared behavior in an abstract manner. On the other hand, `trait bounds` are a way to constrain generic types to those that implement a particular trait, thus ensuring that they exhibit certain behavior. This allows us to use methods and properties defined in the trait on the generic types.

>**note:** Traits are similar to a feature often called interfaces in other languages, although with some differences.

### `Defining a Trait`

A `type's` behavior consists of the methods we can call on that type. Different types share the same behavior if they implement the same `trait`. Trait definitions are a way to group method signature together to define a set of behaviors necessary to accomplish some purpose.

>***note:*** In this context, `structs` are referred to as `types`. This is because `structs` in Rust represent a definable set of data that can be instantiated to create objects, much like types in other languages.

```rust
pub trait Summary {
    fn summarize(&self) -> String;
}
```

In this example, we define a `Summary` trait that includes a single method, `summarize`. This method takes a reference to `self` and returns a `String`. To implement the `Summary` trait for a specific type, we provide an implementation block for that type. Since we've only defined the method signature in the trait without providing a concrete implementation, any type that implements `Summary` must provide its own specific implementation of the `summarize` method.

### `Implementing a Trait on a Type`

Now that we've defined the `Summary` trait, we can implement it on a type. In the example below, we implement the `Summary` trait on the `NewsArticle` and `Tweet` types.

```rust
pub struct NewsArticle {
    pub headline: String,
    pub location: String,
    pub author: String,
    pub content: String,
}

impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!("{}, by {} ({})", self.headline, self.author, self.location)
    }
}

pub struct Tweet {
    pub username: String,
    pub content: String,
    pub reply: bool,
    pub retweet: bool,
}

impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("{}: {}", self.username, self.content)
    }
}
```

In the example above we implement the `Summary` trait on the `NewsArticle` and `Tweet` types. As explained earlier every time we implement a trait on a type, we must provide an implementation for each method defined in the trait. In this case, we provide an implementation for the `summarize` method for both types.

Here is an example on how to use the `Type` implemented by the trait `Summary`.

```rust
use aggregator::{Summary, NewsArticle, Tweet};

fn main() {
    let tweet = Tweet {
        username: String::from("horse_ebooks"),
        content: String::from("of course, as you probably already know, people"),
        reply: false,
        retweet: false,
    };

    println!("1 new tweet: {}", tweet.summarize());

    let article = NewsArticle {
        headline: String::from("Penguins win the Stanley Cup Championship!"),
        location: String::from("Pittsburgh, PA, USA"),
        author: String::from("Iceburgh"),
        content: String::from("The Pittsburgh Penguins once again are the best hockey team in the NHL."),
    };

    println!("New article available! {}", article.summarize());
}
```

> **Note:** In Rust, the `use` statement is employed to bring the `Summary` trait into the current scope. This is a crucial step because it enables us to use the `summarize` method directly on instances of the `Tweet` and `NewsArticle` types. Even though these types implement the `Summary` trait, the trait's methods aren't automatically in scope. By using the `use` statement, we ensure that Rust is aware of the `summarize` method, thereby avoiding potential namespace conflicts and enhancing code clarity.

#### Orphan Rule

The `orphan rule` is a rule that states that we can implement a trait on a type only if either **the trait or the type is local to our crate**. This rule ensures that other people's code can't break your code, and vice versa. This rule is one of the reasons that Rust's trait system is powerful and flexible, and it also prevents a common error that happens in other languages: the `diamond problem`.

The **diamond problem** is a well-known issue in programming languages that support multiple inheritance, a feature that allows a class to inherit behaviors and attributes from more than one superclass.

The problem arises when a class (`D`) inherits from two classes (`B` and `C`) that have a common superclass (`A`). Here's a diagram to illustrate:

```powershell
     A
    / \
   B   C
    \ /
     D
```

In this scenario, if there is a method in `A` that both `B` and `C` have overridden, and `D` does not override it, an ambiguity arises: should `D` inherit the method from `B` or `C`?

This is known as the diamond problem. Different languages handle this problem in different ways. For instance, C++ allows the programmer to specify which method `D` should inherit using scope resolution. Java, on the other hand, avoids the problem entirely by only allowing single inheritance.

Rust also avoids the diamond problem by not supporting multiple inheritance. Instead, Rust uses traits (similar to interfaces in other languages), and a struct can implement multiple traits. However, if two traits have a method with the same name, and a struct tries to use that method without specifying which trait it comes from, the compiler will produce an error. This forces the programmer to explicitly specify which trait's method they want to use, thereby avoiding the diamond problem.

### `Default Implementations`

Sometimes is useful to have default behavior for some or all of the methods in a trait. Then, as we implement the trait on a particular type, we can keep or override each method’s default behavior.

```rust
pub trait Summary {
    fn summarize(&self) -> String {
        String::from("(Read more...)")
    }
}
```

In the example above, we define a `Summary` trait with a `summarize` method that has a default implementation. This default implementation returns a `String` that says `"(Read more...)"`. Now, if we implement the `Summary` trait on a type and don't provide an implementation for the `summarize` method, the default implementation will be used. This is implemented with an empyt `impl block` just as the example below.

```rust
pub struct NewsArticle {
    pub headline: String,
    pub location: String,
    pub author: String,
    pub content: String,
}

impl Summary for NewsArticle {
    // We don't need to provide an implementation for the summarize method
    // because we are using the default implementation
}
```

Default implementation can call other methods in the same trait, even if those other methods don't have a default implementation. In this way, a trait can have a lot of useful functionality and only require implementors to specify a small part of it.

```rust
pub trait Summary {
    fn summarize_author(&self) -> String;

    fn summarize(&self) -> String {
        format!("(Read more from {}...)", self.summarize_author())
    }
}

pub struct NewsArticle {
    pub headline: String,
    pub location: String,
    pub author: String,
    pub content: String,
}

impl Summary for NewsArticle {
    fn summarize_author(&self) -> String {
        format!("@{}", self.author)
    }
}
```

After we define `summarize_author` we can can call `summarize` on instance `NewsArticle` struct, and the default implementation of `summarize` will call the definition of `summarize_author` that we've provided.

```rust
let news = NewsArticle {
    headline: String::from("Criminal assault"),
    location: String::from("Milky way"),
    author: String::from("Your mommy"),
    content: String::from("Criminal theft realized by some unidentified alien."),
};

println!("New article available! {}", news.summarize());
```

### `Traits as parameters`

Now that we have studied about the `traits` and how to implement them on a `type`, we can explore how to use traits to define a function that accepts many different types. We'll use the `Summary` trait we implemented earlier to define a notify function that calls the `summarize` method on its `item` parameter, which is of some type that implements the `Summary` trait.

```rust
pub fn notify(item: &impl Summary) {
    println!("Breaking news! {}", item.summarize());
}
```

Instead of a concrete type for the item parameter, we specify the impl keyword and the trait name. This parameter accepts any type that implements the specified trait.

Codes that calls the `notify` function with a different type like `i32` or `String` will not compile because they don't implement the `Summary` Trait.

#### Trait Bound Syntax

The `impl Trait` syntax in Rust is a convenient and concise in certain cases. However, it's actually a shorthand for a more verbose form known as a `trait bound`. The `trait bound` syntax provides more flexibility and can handle more complex cases. It explicitly states that a generic type must implement a particular trait.

```rust
pub fn notify<T: Summary>(item: &T) {
    println!("Breaking news! {}", item.summarize());
}
```

The longer form, known as `trait bound`, is just like the previous example but with more details. We specify the trait bounds right after the generic type parameter, inside angle brackets, and after a colon.

While `impl Trait` is handy and leads to cleaner code in simple scenarios, the more detailed `trait bound` syntax can handle complex situations. For instance, if we have two parameters that both implement the `Summary` trait, we would use the `trait bound` syntax.

```rust
pub fn notify(item1: &impl Summary, item2: &impl Summary) {
    println!("Breaking news! {}", item1.summarize());
    println!("Breaking news! {}", item2.summarize());
}
```

The `impl Trait` syntax is suitable when we want to allow `item1` and `item2` to be of different types, provided that both types implement the `Summary` trait. However, if we want to ensure that both parameters are of the exact same type, we need to use a `trait bound`. This enforces that `item1` and `item2` are not just any types that implement `Summary`, but are also the same type.

```rust
pub fn notify<T:Summary>(item1: &T, item2: &T) {
    println!("Breaking news! {}", item1.summarize());
    println!("Breaking news! {}", item2.summarize());
}
```

The generic type `T` used for `item1` and `item2` means that both parameters must be of the same type. Whatever specific type you pass as `item1`, you must also pass as `item2`.

#### Specifying Multiple Trait Bounds with the `plus` Syntax

We can also specify more than one trait bound. Say we wanted `notify` to use dispaly formatting as well as the `summarize` on item: we specify in the notify definition that item must implement both `Summary` and `Display`. We can do this using the `+` syntax.

```rust
pub fn notify(item: &(impl Summary + Display)) {
    println!("Breaking news! {}", item.summarize());
    println!("Breaking news! {}", item);
}
```

The `+` syntax is also valid with `trait bounds` on generic types:

```rust
pub fn notify<T: Summary + Display>(item: &T) {
    println!("Breaking news! {}", item.summarize());
    println!("Breaking news! {}", item);
}
```

With the two trait bounds specified, the body of notify can use the `Summary` and `Display` trait behaviours.

#### Clearer Trait Bounds with `where` Clauses

When a function has many generic parameters, each with its own trait bounds, the function signature can become cluttered and hard to read. To solve this, Rust provides a `where` clause. This allows us to list the trait bounds separately, after the function signature, making the code cleaner and easier to understand. So instead of writing this:

```rust
fn some_function<T: Display + Clone, U: Clone + Debug>(t: &T, u: &U) -> i32 {
    // function body
}
```

We can use a `where` clause to specify the trait bounds after the function signature:

```rust
fn some_function<T, U>(t: &T, u: &U) -> i32
where
    T: Display + Clone,
    U: Clone + Debug,
{
    // function body
}
```

This function signature is much cleaner and easier to read. The `where` clause comes after the function signature and the parameter list. Inside the `where` clause, we specify the types for which we want to require trait bounds. We can use a `where` clause to specify trait bounds on multiple types, as shown in the example above.

### Returning `Types` that Implement `Traits`

We can also use the `impl Trait` syntax in the return posirion ro return a valuew of some type that implements a trait, as shown here:

```rust
fn returns_summarizable() -> impl Summary {
    Tweet {
        username: String::from("horse_ebooks"),
        content: String::from(
            "of course, as you probably already know, people",
        ),
        reply: false,
        retweet: false,
    }
}
```

The implementation would look like this:

```rust
fn main() {
    let tweet = returns_summarizable();

    println!("1 new tweet: {}", tweet.summarize());
}
```

By using `impl Summary` for the return type, we specify that the `returns_summarizable` function returns some type that implements the `Summary` trait without naming the concrete type. In this case `returns_summarizable` returns a `Tweet`, but the code calling this function doesn't know that.

The `impl Trait` syntax is very helpful when dealing with closures and iterators. These often produce types that are either known only to the compiler or are too lengthy to write out. By using `impl Trait`, you can simply state that a function returns a type that implements the `Iterator` trait, without having to specify the exact type.

However, you can only use `impl Trait` if you are returning a single type. For example, you can't use `impl Trait` if you want to return a `Tweet` or a `NewsArticle` depending on some condition.

### Using `trait` Bounds to Conditionally Implement Methods

By using a trait bound with an `impl` block that uses generics type parameters, we can implement methods conditionally for types that implement the specified traits. For example, the type `Pair<T>` always implements the `new` function to return a new instance of `Pair<T>`. But in the next `impl` block, `Pair<T>` only implements the `cmp_display` method if its inner type `T` implements the `PartialOrd` trait that enables comparison and the `Display` trait that enables printing.

```rust
use std::fmt::Display;

struct Pair<T> {
    x: T,
    y: T,
}

impl<T> Pair<T> {
    fn new(x: T, y: T) -> Self {
        Self { x, y }
    }
}

impl<T: Display + PartialOrd> Pair<T> {
    fn cmp_display(&self) {
        if self.x >= self.y {
            println!("The largest member is x = {}", self.x);
        } else {
            println!("The largest member is y = {}", self.y);
        }
    }
}
```

We can also conditionally implement a trait for any type that implements another trait. Implementations of a trait on any type that satisfies the trait bounds are called `blanket implementations` and are extensively used in the Rust standard library.

>**note:** The standard library: `std` library provides a `blanket implementation` of the `ToString` trait on any type that implements the `Display` trait. This implementation means that we can call the `to_string` method defined by the `ToString` trait on any type that implements the `Display` trait. The `impl` block in the standard library looks like this:

```rust
impl<T: Display> ToString for T {
    // --snip--
}
```

Because the standard library has this `blanket implementation`, we can call the `to_string` method defined by the `ToString` trait on any type that implements the `Display` trait. For example, we can call the `to_string` method on a `u32` because `u32` implements `Display`:

```rust
let s = 3.to_string();
```

### Conclusion: The Power of Traits in Rust

Traits in Rust are a powerful tool that allow us to define shared behavior across multiple types. They enable us to use generics effectively, reducing code duplication and ensuring specific behaviors for these types.

Traits provide several key advantages:

1. **Compile-time Checks:** Rust uses traits and trait bounds to catch errors during compilation, not at runtime. This means we must resolve these issues before the code can even run, enhancing reliability.

2. **Improved Performance:** Compile-time checking eliminates the need for runtime behavior checks. This results in improved performance without sacrificing the flexibility offered by generics.

3. **Conditional Method Implementation:** Traits allow us to conditionally implement methods for types that implement specific traits. This adds a layer of flexibility and control over our types' behaviors.

4. **Simplifying Complex Types with `impl Trait`:** The `impl Trait` syntax is particularly useful when dealing with complex types like closures and iterators. It allows us to state that a function returns a type that implements a specific trait, without having to specify the exact type.

In conclusion, traits are a fundamental part of Rust's approach to ensuring type safety and code reusability. They provide a balance between performance and flexibility that makes Rust a powerful language for systems programming.

## Lifetimes

`Lifetimes` represent another form of `generics` that we've been utilizing. Rather than ensuring that a type has the behavior we want, lifetimes guarantee that references remain valid for the `duration they are required`.

In Rust, both lifetimes and types are often inferred by the compiler. This means that you usually don't need to specify them explicitly. However, there are cases where you need to provide more information to the compiler.

Just like you sometimes need to specify the type of a variable when it can't be inferred, you also need to specify lifetimes when the compiler can't determine them. This typically happens when a function deals with multiple references in a way that could be interpreted differently depending on the lifetimes of those references.

In these cases, Rust requires us to use generic lifetime parameters to clearly define the relationship between the lifetimes of the references. This helps Rust ensure that the references will be valid when they are used at runtime.

### Preventing `Dangling References` with `Lifetimes`

The main aim of lifetimes is to prevent `dangling references`, which cause a program to reference data other than the data it's intended to reference. This can lead to undefined behavior, memory corruption, and other serious issues.

Rust prevents `dangling references` by the `borrow checker`, which compares the lifetimes of references to the lifetimes of the data they refer to. If the `borrow checker` determines that a reference's lifetime is longer than the data it refers to, it will prevent the code from compiling.

>**dangling reference**: is a reference that points to a location in memory that no longer holds valid data. This situation can occur when the data the reference points to has been moved or deallocated while the reference is still in use.

### `Borrow Checker`

The rust compiler has a `borrow checker` that compares scopes to determine whether all borrows are valid. The `borrow checker` is the part of the compiler that enforces the `lifetimes` of references. It is the reason why we need to specify lifetimes in some cases. In the next example we'll see how the `borrow checker` works.

```rust
fn main() {
    let x = 5;            // ----------+-- 'b
                          //           |
    let r = &x;           // --+-- 'a  |
                          //   |       |
    println!("r: {}", r); //   |       |
                          // --+       |
} 
```

In this example, we have a variable `x` that holds the value `5` and a reference `r` to `x`. The lifetimes of `x` and `r` are compared by the `borrow checker` to ensure that `r` remains valid for as long as it's used. Here, `x` has a larger lifetime, denoted as `'b`, which exceeds `'a`, the lifetime of `r`. This means `r` can safely reference `x` because Rust knows that the reference in `r` will always be valid as long as `x` is valid. In this specific case, `r` is valid for the duration of the `println!` statement, allowing the code to compile successfully.

### `Generic Lifetimes` in Functions

To understand how lifetimes work in functions, let's consider a simple example. In the following code, we define a function `longest` that takes two string slices and returns the longer of the two.

```rust
fn longest(x: &str, y: &str) -> &str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

fn main() {
    let string1 = String::from("abcd");

    let string2 = "xyz";

    let result = longest(string1.as_str(), string2);

    println!("The longest string is {}", result);
}
```

The `longest` function shown above won't compile. The reason is that when we define this function, we don't know the actual values that will be passed in, so we can't determine if the `if` or `else` case will execute.

More importantly, we don't know the lifetimes of the references that will be passed in. This means we can't ensure that the reference we return will always be valid. The borrow checker can't figure this out either, because it doesn't know how the lifetimes of `x` and `y` relate to the lifetime of the return value.

To solve this problem, we need to add generic lifetime parameters. These parameters define the relationship between the references, allowing the borrow checker to verify that the references will be valid when used.

Consider the following example to understand how the `longest` function could potentially result in a dangling reference:

```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

fn main() {
    let string1 = String::from("long string is long");
    let result;
    {
        let string2 = String::from("xyz");
        result = longest(string1.as_str(), string2.as_str());
    }
    println!("The longest string is {}", result);
}
```

In this example, `string2` is declared within a block, which means its lifetime is limited to that block. If `string2` is shorter than `string1`, the `longest` function will return a reference to `string2`. However, `string2` is dropped as soon as its enclosing block ends, while `result` is still holding a reference to it. This would lead to a dangling reference when we try to use `result` in the `println!` statement.

Fortunately, Rust's borrow checker prevents this from happening. It checks the lifetimes of the references and ensures that `result` does not outlive the data it refers to. In this case, it would not allow the code to compile, thus avoiding the creation of a dangling reference.

### `Lifetime Annotations syntax`

Lifetime annotations are a way to tell Rust how different references in your code relate to each other. They don't make any reference live longer or shorter. They're like a promise to the Rust compiler: "Trust me, this reference will always be valid when I use it."

Just like you can use generic types to let a function work with any type, you can use generic lifetimes to let a function work with references of any lifetime. This makes your functions more flexible.

Lifetime annotations have a slightly unusual syntax: the names of lifetime parameters must start with an apostrophe (`'`) and are usually all lowercase and very short, like generic types. Most people use the name `'a` for the first lifetime annotation. We place lifetime parameter annotations after the `&` of a reference, using a space to separate the annotation from the reference’s type.

```rust
&i32        // a reference
&'a i32     // a reference with an explicit lifetime
&'a mut i32 // a mutable reference with an explicit lifetime
```

### `Lifetime Annotations in Function Signatures`

To use lifetime annotations in function signatures, we need to declare the generic lifetime parameters inside angle brackets between the function name and the parameter list, just as we did with generic type parameters.

We want the signature to express the following constraint: The returned reference will be valid as long as both the parameters are valid. This is the relationship between lifetimes of the parameters and the return value. We'll name the lifetime `'a` and then add it to each reference, as shown in the example below.

```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```

So to understand the lifetime annotations in the `longest` function, check the code below:

```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {  // ----------+-- 'a
        x                   //           |
    } else {                //           |
        y                   //           |
    }                       // ----------+
}
```

### `Thinking in Terms of Lifetimes`

The way in which you need to specify lifetime parameters depends on what your function doing.

>**Note:** When returning a reference from a function, the lifetime parameter for the return type needs to match the lifetime parameter for one of the parameters. If the reference returned does not refer to one of the parameters, it must refer to a value created within this function. However, this would be a dangling reference because the value will go out of scope at the end of the function.

### `Lifetime Annotations in Struct Definitions`

The `structs` we’ve defined all hold owned types. We can define structs to hold references, but in that case we would **need to add a lifetime annotation on every reference** in the struct’s definition.

```rust
struct ImportantExcerpt<'a> {
    part: &'a str,
}

fn main() {
    let novel = String::from("Call me Ishmael. Some years ago...");
    let first_sentence = novel.split('.').next().expect("Could not find a '.'");
    let i = ImportantExcerpt { part: first_sentence };
}
```

In this `ImportantExcerpt` struct, `'a` is a generic lifetime parameter. The `part` field is a string slice (`&str`), which is a reference, so it has a lifetime. The lifetime of `part` is the same as `'a`.

The data `part` is referencing must not be dropped before the `ImportantExcerpt` instance is dropped. If the data `part` is referencing is dropped, then `part` would be a dangling reference, which is not allowed.

The lifetime `'a` in the struct definition is a way of telling Rust: "The data that `part` is referencing will live at least as long as the `ImportantExcerpt` instance." This way, Rust can ensure at compile time that the reference in `part` will always be valid as long as the `ImportantExcerpt` instance is in use.

### `Lifetime elision`

Lifetime elision is a feature in Rust that allows you to omit explicit lifetime annotations in certain scenarios. The Rust compiler has a set of rules it follows to infer lifetimes when they're not explicitly specified. This makes the code less verbose and easier to read.

Here are the rules for lifetime elision:

1. Each parameter that is a reference gets its own lifetime parameter. For example, a function with two parameters `&str` and `&str` would have lifetimes `'a` and `'b`, respectively.

2. If there is exactly one input lifetime parameter, that lifetime is assigned to all output lifetime parameters. This is common for functions that take a reference and return a reference, like `fn first_word(s: &str) -> &str`.

3. If there are multiple input lifetime parameters, but one of them is `&self` or `&mut self` because this is a method, the lifetime of `self` is assigned to all output lifetime parameters. This is common for methods that return a reference to something in `self`.

These rules cover the majority of cases you'll encounter. If your code doesn't fit these rules, you'll need to manually annotate lifetimes. This is necessary to ensure that the Rust compiler can verify that all the references in your code are valid and won't lead to dangling references.

### Lifetime Annotations in `Method` Definitions

When implementing methods on a struct that includes lifetimes, we use a syntax similar to that of generic type parameters.

```rust
struct ImportantExcerpt<'a> {
    part: &'a str,
}

impl <'a> impl ImportantExcerpt<'a> {
    fn level(&self) -> i32 {
        3
    }
}
```

> **Note:** Explicitly specifying the lifetime of the parameters inside the `impl` block for the `level` method is not necessary due to Rust's lifetime elision rules. These rules allow Rust to infer the correct lifetimes in certain scenarios, simplifying the code.

### `Static Lifetime`

One special lifetime we need to discuss is `'static`, which denotes that the affected reference can live for the entire duration of the program. All string literals have the 'static lifetime, which we can annotate as follows:

```rust
let s: &'static str = "I have a static lifetime.";
```

The text of this string is stored directly in the program's binary, which is always available. Therefore, the lifetime of all string literals is `'static`.

In Rust, you may encounter suggestions to use the `'static` lifetime in error messages. The `'static` lifetime is a special lifetime that represents the entire duration of the program. A reference with `'static` lifetime is guaranteed to be valid for the entire duration of the program.

However, it's important to carefully consider whether the reference you're working with is actually intended to live for the entire duration of your program before specifying `'static` as its lifetime.

Most of the time, if you're seeing a suggestion to use the `'static` lifetime, it's because you're trying to do something that would result in a dangling reference or there's a mismatch between the lifetimes you've specified. A dangling reference is a reference that points to data that has been dropped, which is not allowed in Rust.

In such cases, the solution is usually not to specify the `'static` lifetime, but to fix the underlying problem that's causing the dangling reference or the lifetime mismatch. This might involve changing how you're handling your data to ensure that references remain valid for as long as they're in use, or adjusting the lifetimes you've specified to correctly reflect the lifetimes of your data.

### Generic Type Parameters, Trait Bounds, and Lifetimes Together

Let’s briefly look at the syntax of specifying generic type parameters, trait bounds, and lifetimes all in one function!

```rust
use std::fmt::Display;

fn longest_with_an_announcement<'a, T>(
    x: &'a str,
    y: &'a str,
    ann: T,
) -> &'a str
where
    T: Display,
{
    println!("Announcement! {}", ann);
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```

This is the `longest` function that returns the `longer` of `two string slices`. But now it has an extra parameter named `ann` of the generic type `T`, which can be filled in by any type that implements the `Display` trait as specified by the `where` clause. This extra parameter will be printed using `{}`, which is why the Display trait bound is necessary. Because lifetimes are a type of generic, the declarations of the lifetime parameter 'a and the generic type parameter `T` go in the same list inside the angle brackets after the function name.
