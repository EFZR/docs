# Advanced Trait in Rust

Trait are discussed in the [previous chapter](8_Generic_Types_Traits_Lifetimes.md), were we discussed how to define and use traits. In this chapter, we will discuss some advanced features of traits in Rust.

## Index

1. [Specifying Placeholder Types in Trait Definitions with Associated Types](#specifying-placeholder-types-in-trait-definitions-with-associated-types)
    - [Difference between Associated Types and Generics](#difference-betweeen-associated-types-and-generics)
2. [Default Generic Type Parameters and Operator Overloading](#default-generic-type-parameters-and-operator-overloading)
3. [Full Qualified Syntax for Disambiguation: Calling Methods with the Same Name](#full-qualified-syntax-for-disambiguation-calling-methods-with-the-same-name)
4. [Using Supertraits to Require One Trait's Functionality Within Another Trait](#using-supertraits-to-require-one-traits-functionality-within-another-trait)
5. [Using the Newtype Pattern to Implement External Traits on External Types](#using-the-newtype-pattern-to-implement-external-traits-on-external-types)

## Specifying Placeholder Types in Trait Definitions with Associated Types

*Associated Types* connect a type placeholder with a trait such that the trait method definitions can use these placeholder types in there signature. The implementor of a trait will specify the concrete type to be used instead of the placeholder type for the particular implementation. That way we can define a trait that uses some types without needing to know exactly what those types are until the trait is implemented.

One example of a trait with an associated type is the `Iterator` trait that the standard library provides. The associated type is named `Item` and stands in for the type of the values the type implementing the `Iterator` trait is iterating over. The definition of the `Iterator` Trait is as shown in the next example:

```rust
pub trait Iterator {
    type Item;
    fn next(&mut self) -> Option<Self::Item>;
}
```

The type `Item` is a placeholder type, and the `next` method is defined to return values of type `Option<Self::Item>`. Implementors of the `Iterator` trait will specify the concrete type for `Item`, and the `next` method will return an `Option` containing a value of that concrete type.

### Difference betweeen Associated Types and Generics

Associated types might seem like a similiar concept of generics, in that the latter allow us to define a function without specifying the types of its parameters and return value. However, the difference between the two is that when using generics, the caller of the function specifies the concrete types, whereas when using associated types, the implementor of the trait specifies the concrete type.

Check the next example to differentiate between the two concepts:

```rust
impl Iterator for Counter {
    type Item = u32;
    fn next(&mut self) -> Option<Self::Item> {
        // --snip--
    }
}
```

The example shows that the `Counter` type implements the `Iterator` trait, and the `Item` type is defined as `u32`. The `next` method will return values of type `Option<Self::Item>` that is `Option<u32>`.

```rust
pub trait Iterator<T> {
    fn next(&mut self) -> Option<T>;
}
```

The difference is that when using generics as the example above we must annotate the types in each implementation of the trait; Because we can also implement `Iterator<String>` for `Counter` or any other type, we could have multiple implementations of `Iterator` for `Counter`.

In other words, when a trait has a generic parameter, it can be implemented for a type multiple times, changing the concrete types of the generic type parameters each time. When we use the `next` method on the `Counter`, we would have to provide a type annotation to indicate which which implementation of `Iterator` we want to use.

With associated types, we don't  need to annotate types because we can't implement a trait on a type multiple times. In a trait a definition with an associated type, we can only implement that trait on a type once. The trade-off is that when using the `next` method, we don't need to specify the types because we can only implement the `Iterator` trait on a type once.

Associated types also become part of the trait’s contract: implementors of the trait must provide a type to stand in for the associated type placeholder. Associated types often have a name that describes how the type will be used, and documenting the associated type in the API documentation is good practice.

## Default Generic Type Parameters and Operator Overloading

When we use generic type parameters, we can specify a default concrete type for the generic type. This eliminates the need for implementors of the trait to specify a concrete type if the default type works. You specify a default type when declaring a generic type with the `<PlaceholderType=ConcreteType>` syntax.

A great example of a situation where this technique is useful is with `operator overloading`, in which you customize the behavior of an operator (such as `+`) in particular situations.

Rust doesn't allow us to create your own operators or overload arbitrary operators, but we can overload the operations and corresponding traits listed in the standard library `std::ops` by implementing the traits associated with the operators. In the example below we overload the `+` operator to add two `Point` instances together:

```rust
use std::ops::Add;

#[derive(Debug, PartialEq, Copy, Clone)]
struct Point {
    x: i32,
    y: i32,
}

impl Add for Point {
    type Output = Point;

    fn add(self, other: Point) -> Point {
        Point {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

fn main() {
    assert_eq!(Point { x: 1, y: 0 } + Point { x: 2, y: 3 },
               Point { x: 3, y: 3 });
}
```

The `add` method add the `x` values of two `Points` instrances and `y` values of the two `Point` instances to create a new `Point`. The `Add` trait has an associated type named `Output` that determines the type returned from the `add` method.

The default generic type in this code is withint the `Add` trait, here it's the definition:

```rust
trait Add<RHS=Self> {
    type Output;

    fn add(self, rhs: RHS) -> Self::Output;
}
```

This code should look generally familiar: a trait with one method and an associated type. The new part is the `<RHS=Self>`: this syntax is called *default type parameters*. The `Rhs` generic type parameter (short for "right hand side") defines the tupe of the `rhs` parameter in the add method. If we don't specify a concrete type for `RHS` when we implement the `Add` trait, the type of `Rhs` will default to `Self`, which will be the type we're implementing `Add` on.

In before example we used the `Add` trait to add a `Point` to another `Point` we add two elements of the same type, but the add trait is flexible enough to allow us to add two elements of different types. The `RHS` generic type parameter specifies the type of the `rhs` parameter to the `add` method, and the `Output` associated type specifies the type returned from the `add` method.

Check the next example to see how to add a `Millimeters` instance to a `Meter` instance:

```rust
use std::ops::Add;

struct Millimeters(u32);
struct Meters(u32);

impl Add<Meters> for Millimeters {
    type Output = Millimeters;

    fn add(self, other: Meters) -> Millimeters {
        Millimeters(self.0 + (other.0 * 1000))
    }
}
```

To add `Millimeters` and `Meters`, we specify `impl Add<Meters> for Millimeters` to set the value of the `RHS` type parameter instead of using the default of `Self`.

## Full Qualified Syntax for Disambiguation: Calling Methods with the Same Name

Nothing in Rust prevents a trait from having a method with the same name as another trait's method, nor does Rust prevent you from implementing both traits on one type. It's also possible to implement a method directly on the type with the same name as methods from traits.

When calling methods with the same name, you'll need to tell Rust which one you want to use. Consider the next example where we've defined two traits, `Pilot` and `Wizard`, that both have a method called `fly`. We then implement both traits on a type `human` that already has method named `fly` implemented on it. Each `fly` method does something different:

```rust
trait Pilot {
    fn fly(&self);
}

trait Wizard {
    fn fly(&self);
}

struct Human;

impl Pilot for Human {
    fn fly(&self) {
        println!("This is your captain speaking.");
    }
}

impl Wizard for Human {
    fn fly(&self) {
        println!("Up!");
    }
}

impl Human {
    fn fly(&self) {
        println!("*waving arms furiously*");
    }
}
```

When we call `fly` on an instance of `Human`, the compiler defaults to calling the method implemented directly on `Human`:

```rust
fn main() {
    let person = Human;
    person.fly();
}
```

Running this code will print `*waving arms furiously*`. If we want to call the `fly` method from either the `Pilot` trait or the `Wizard` trait for a `Human`, we need to use more explicit syntax which fly method we mean:

```rust
fn main() {
    let person = Human;
    Pilot::fly(&person);
    Wizard::fly(&person);
    person.fly();
}
```

Specifying the trait name before the method name clarifies which implementation of `fly` we want to call.

Because the `fly` method in every situation takes a `self` parameter, if we had two types that both implement one trait, Rust could figure out which implementation of a trait to use based on the type of `self`.

However, associated functions that are not methods don't have a `self` parameter. When there are multiple types or traits that define non-method functions with the same function name, Rust doesn't always know which type you mean unless you use *fully qualified syntax*. Check the next example to see how to use fully qualified syntax:

```rust
trait Animal {
    fn baby_name() -> String;
}

struct Dog;

impl Dog {
    fn baby_name() -> String {
        String::from("Spot")
    }
}

impl Animal for Dog {
    fn baby_name() -> String {
        String::from("puppy")
    }
}

fn main() {
    println!("A baby dog is called a {}", Dog::baby_name());
    // println!("A baby dog is called a {}", Animal::baby_name());
}
```

In `main`, we call the `Dog::baby_name` function, which will print `A baby dog is called a Spot`.

If we uncomment the line that calls `Animal::baby_name`, we'll get an error because `Animal::baby_name` doesn't have the `self` parameter, and there could be other types that implement `Animal` trait, Rust can't figure out which implementation of `Animal::baby_name` to use.

To disambiguate and tell Rust we want to use the implemetation of `Animal` for `Dog` as opposed to the implementation of `Animal` for some other type, we need to use *fully qualified syntax*. In the exmaple below we use the fully qualified syntax to call the `baby_name` method from the `Animal` trait:

```rust
fn main() {
    println!("A baby dog is called a {}", <Dog as Animal>::baby_name());
}
```

We are providing Rust wit a type annotation within the angle brackets, which indicates we want to call the `baby_name` method from the `Animal` trait as implemented for `Dog` by saying we want to treat the `Dog` type as an `Animal` for this function call. This code would print `A baby dog is called a puppy`.

In generally, fully qualified syntax is defined as `<Type as Trait>::function(receiver_if_method, next_arg, ...);`. This syntax is used when there are two types in scope with the same name and we want to be explicit about which one to use. It's also used to specify that we want to call a method from a particular trait.

## Using Supertraits to Require One Trait's Functionality Within Another Trait

Sometimes, you might write a trait definition that depends on another trait: for a type to implement the first trait, you want to require that type to also implement the second trait. You would do this so that your trait definition can make use of the associated items of the second trait. The trait your trait definition is relying on is called a supertrait of your trait.

For example, let’s say we want to make an `OutlinePrint` trait with an `outline_print` method that will print a given value formatted so that it's framed in asterisks. That is, given a `Point` struct that implements the standard library trait `Display` to result in `(x, y)`, when we call `outline_print` on a `Point` instance that has `1` for `x` and `3` for `y`, it should print the following:

```text
**********
*        *
* (1, 3) *
*        *
**********
```

In the implementation of the `outline_print` method, we want to use the `Display` trait’s functionality. Therefore, we need to specify that the OutlinePrint trait will work only for types that also implement `Display` and provide the functionality that OutlinePrint needs. We can do that in the trait definition by specifying `OutlinePrint: Display`. This technique is similar to adding a trait bound to the trait. Listing 19-22 shows an implementation of the `OutlinePrint` trait.

```rust
use std::fmt;

trait OutlinePrint: fmt::Display {
    fn outline_print(&self) {
        let output = self.to_string();
        let len = output.len();
        println!("{}", "*".repeat(len + 4));
        println!("*{}*", " ".repeat(len + 2));
        println!("* {} *", output);
        println!("*{}*", " ".repeat(len + 2));
        println!("{}", "*".repeat(len + 4));
    }
}
```

Because we have specified that `OutlinePrint` requires the `Display` trait, we can use the `to_string` method that is automatically implemented for any type that implements the `Display` trait. If we tried to use the `to_string` without adding a colon to specifying the `Display` trait after the trait name, we would get an error saying  that no method named `to_string` found for type `&Self` in the current scope.

Check the next example to see how the error is represented:

```rust
struct Point {
    x: i32,
    y: i32,
}

impl OutlinePrint for Point {}
```

To fix this, we implement `Display` on `Point` and satisfy the constraint that `OutlinePrint` requires `Display`:

```rust
use std::fmt;

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}
```

Then implementing the `OutlinePrint` trait on `Point` will compile successfully, and we can call `outline_print` on a `Point` instance to display it within an outline of asterisks.

## Using the Newtype Pattern to Implement External Traits on External Types

Is known that becauase of the orphan rule, we're not allowed to implement external traits on external types. The *newtype* pattern is a common way to work around this restriction. The *newtype* pattern involves creating a new type in a tuple struct, and implementing the trait on that new type. The tuple struct will have one field and be a thin wrapper around the type you want to implement a trait for. This new type will allow you to implement the trait you want to implement on the external type. *Newtype* is a term that originates from the **Haskell programming language**. There is no runtime performance penalty for using this pattern, and the wrapper type is elided at compile time.

As an example, let's say we want to implement the `Display` trait on `Vec<T>`, which the orphan rule prevents us from doing directly. We can create a `Wrapper` struct that holds an instance of `Vec<T>`. Then we can implement `Display` on `Wrapper`, as shown in the next example:

```rust
use std::fmt;

struct Wrapper(Vec<String>);

impl fmt::Display for Wrapper {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "[{}]", self.0.join(", "))
    }
}

fn main() {
    let w = Wrapper(vec![String::from("hello"), String::from("world")]);
    println!("w = {}", w);
}
```

The implementation of `Display` uses `self.0` to access the inner `Vec<T>`, because `Wrapper` is a tuple struct and `Vec<T>` is the item at index 0 in the tuple. Then we can use the functionality of the `Display` type on `Wrapper`.

The downside of using this technique is that `Wrapper` is a new type, so it doesn’t have the methods of the value it’s holding. We would have to implement all the methods of `Vec<T>` directly on `Wrapper` such that the methods delegate to `self.0`, which would allow us to treat `Wrapper` exactly like a `Vec<T>`. If we wanted the new type to have every method the inner type has, implementing the `Deref` trait on the `Wrapper` to return the inner type would be a solution. If we don’t want the `Wrapper` type to have all the methods of the inner type—for example, to restrict the `Wrapper` type’s behavior—we would have to implement just the methods we do want manually.
