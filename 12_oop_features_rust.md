# Object Oriented Programming Features in Rust 🦀

Object-oriented programming (OOP) is a way of modeling programs. Objects as a programatic concept were introduced in the 1960s. Those objects influences Alan Kay's programming Architecture in which objects pass messages to each other. To describe this architecture, he coined the term *object-oriented programming* in 1967. Many competing definition describes what OOP is, and by some of these definitions Rust is Object Oriented, but by others it is not.

There are certain features that are commonly associated with object-oriented programming. This section will discuss how these characteristics translate into idiomatic Rust.

## Index

1. [Characteristics of OOP](#characteristics-of-oop)
2. [Using trait Object that allow for Values of Different Types](#using-trait-object-that-allow-for-values-of-different-types)
3. [Implementing an Object Oriented Design Pattern](#implementing-an-object-oriented-design-pattern)

## Characteristics of OOP

There isn't a universally agreed-upon definition in the programming community about what features a language must have to be considered object-oriented. Rust is a multi-paradigm language, influenced by many programming styles, including OOP. It also incorporates features from functional programming, such as closures and iterators, and from procedural programming, like loops and mutable variables. Typically, object-oriented languages are characterized by three main features: objects, encapsulation, and inheritance. Let's examine each of these characteristics and discuss how they are represented in Rust.

### Object Contain Data and Behavior

The book *Design Patterns: Elements of Reusable Object-Oriented Software* defines OOP this way:

> Object-oriented programs are made up of objects. An *object* packages both data and the procedures that operate on that data. The procedures are typically called methods or *operations*.

Using this definition, Rust is object-oriented: `Structs` and `Enums` have data, and `impl` block provides methods on structs and enums. Even though structs and enums with methods aren't called objects, they provide the same functionality as objects in other languages.

### Encapsulation that Hides Implementation Details

Another aspect commonly associated with OOP is the idea of *encapsulation*, which means that the implementation details of an object aren't accessible to code using that object. Therefore the only way to interact with an object is through its public API. code using the object shouldnt be able to reach into the object's internals and change data or behavior directly.

Rust control the encapsulation of data with the `pub` keyword. By default, structs, enums, and methods are private, and only accessible within the module in which they are defined. You can use the `pub` keyword to make them public. This is similar to the `public` and `private` keywords in other languages.

So with this approach, Rust provides encapsulation, which is a characteristic of OOP.

### Inheritance as a Type System and as Code Sharing

Inheritance is a mechanism whereby an object can inherit elements from another object's definition, thus gaining the parent object's data and behavior without having to define them again. Inheritance is a way to share code between different types.

If a language must have inheritance to be an object-oriented language, then Rust is not an object-oriented language. Rust doesn't have an inheritance mechanism. However, Rust has a feature named `trait` that allows you to define a set of methods that a type must implement. This is similar to interfaces in other languages. A type implementing a trait is said to provide the behavior of that trait. This is a way to share code between different types.

If you as a devloper are used to to having inheritance in your programming language toolbox, you can use Rust's `trait` feature to accomplish in some way the same thing.

The thing is this could be inheritance in a limited way and not in the traditional sense. Inheritance is a way to share code between different types, and Rust's `trait` feature accomplishes that. So, in that sense, Rust provides inheritance.

Developers use inheritance for two main reasons:

1. Reuse code: When an object inherits to another object, it gets the parent object's data and behavior. This is a way to reuse code.
2. Polymorphism: The ability to change the behavior of a method based on the type of the object that is calling the method.

Inheritance has recently fallen out of favor as programming design solution in many programming languages because it's often at risk of sharing more code than necessary. Subclasses shouldn't always share all characteristics of their parent class but will do so with inheritance. This can make a program's design less flexible. It also introduces the possibility of calling methods on subclasses that don’t make sense or that cause errors because the methods don’t apply to the subclass.

For these reasons, Rust takes the different approach of using `trait objects` instead of inheritance.

## Using trait Object that allow for Values of Different Types

Sometime we could want our library user to be able to extend the set of types thar are valid in a particular situation. For example, we could want to allow the user to define their own types that implement a particular trait. We can do this by using trait objects.

To understand how this is done we could use the next problem as an example. We need to create a gui (graphical user interface) to display diffrent types of components.

To do this in a language with inheritance, we could define a `Component` class that has a method named `draw` on it. The other classes can inherit from `Component` and override the `draw` method to provide their own implementation, but the framework could treat all of the types as if they were `Components` instance and call the `draw` method on each of them.

But because Rust doesnt have inheritance we need another way to do this.

### Defining a Trait for a Common Behavior

To implement the behaviour we want `gui` to have, we'll define a trait named `Draw` that will have one method namd draw. Then we can define a vector that takes a `trait object` that implements the `Draw` trait.

A trait object in Rust refers to a pointer that points to both an instance of a type implementing a specified trait and a table used to look up trait methods on that type at runtime. This table is often referred to as a "vtable" or "virtual method table".

When we use a trait object, the specific type of the value it refers to is not known at compile time, but the trait or traits that the type implements are known. When a method is called on the trait object, the vtable is used to map that method call to the specific implementation of the method for the actual type.

This mechanism allows for dynamic dispatch, where the exact method to be called is determined at runtime. This is in contrast to static dispatch, where the exact method to be called is known at compile time.

We create a trait object by specifying some sort of pointer, such as a reference `&` or a `Box<T>`, then the `dyn` keyword, and then specifying the relevant trait. For example, `&dyn Draw` is a trait object that holds a reference to a value of some type that implements the `Draw` trait.

We can use trait objects in place of a generic or concrete type. Wherever we use a trait object, Rust’s type system will ensure at compile time that any value used in that context will implement the trait object’s trait. Consequently, we don’t need to know all the possible types at compile time.

In Rust, we typically avoid referring to structs and enums as "objects" to differentiate them from the concept of objects in other languages. In Rust, the data (struct fields) and behavior (methods in `impl` blocks) are separate, whereas in many other languages, data and behavior are combined into a single concept often referred to as an object.

However, trait objects in Rust are more similar to objects in other languages in the sense that they combine data and behavior. A trait object points to an instance of a type and its associated method implementations.

It's important to note that trait objects differ from traditional objects in that we can't add data to a trait object. Their purpose is not to serve as general-use objects, but to enable abstraction across common behavior. This means that trait objects are used when we want to work with values of different types that share certain behaviors.

#### Defining the `Draw` Trait

In the next example we define a `Draw` trait that has one method named `draw`.

```rust
pub trait Draw {
    fn draw(&self);
}
```

#### Defining a `Screen` Struct that Holds Components of type `Draw`

We define a `Screen` struct that holds a vector of trait objects that implement the `Draw` trait with trait objects.

```rust
pub struct Screen {
    pub components: Vec<Box<dyn Draw>>,
}
```

#### Defining the `run` method on `Screen` that Calls the `draw` Method on Each Component

We define a `run` method on `Screen` that calls the `draw` method on each component.

```rust
impl Screen {
    pub fn run(&self) {
        for component in self.components.iter() {
            component.draw();
        }
    }
}
```

#### Implementing the `Draw` Trait on Types We Want to Draw

We implement the `Draw` trait on the types we want to draw.

```rust
pub struct Button {
    pub width: u32,
    pub height: u32,
    pub label: String,
}

impl Draw for Button {
    fn draw(&self) {
        // code to actually draw a button
    }
}

pub struct SelectBox {
    pub width: u32,
    pub height: u32,
    pub options: Vec<String>,
}

impl Draw for SelectBox {
    fn draw(&self) {
        // code to actually draw a select box
    }
}
```

The `Button` and `SelectBox` types implement the `Draw` trait, but each type has its own properties and methods.

#### Using the `Screen` Struct to Hold Components and Run the `run` Method

We use the `Screen` struct to hold components and run the `run` method.

```rust
fn main() {
    let screen = Screen {
        components: vec![
            Box::new(SelectBox {
                width: 75,
                height: 10,
                options: vec![
                    String::from("Yes"),
                    String::from("Maybe"),
                    String::from("No"),
                ],
            }),
            Box::new(Button {
                width: 50,
                height: 10,
                label: String::from("OK"),
            }),
        ],
    };

    screen.run();
}
```

### 🦆 Duck Typing and Trait Objects in Rust

When we developed the library, we didn't anticipate the addition of the `SelectBox` type. However, our `Screen` implementation was able to operate on and draw the new type because `SelectBox` implements the `Draw` trait, which means it implements the `draw` method.

This concept, being concerned only with the methods a value responds to rather than the value's concrete type, is akin to the concept of duck typing in dynamically typed languages. The saying goes: if it walks like a duck and quacks like a duck, then it must be a duck! In the implementation of `run` on `Screen`, `run` doesn't need to know the concrete type of each component. It doesn't check whether a component is an instance of a `Button` or a `SelectBox`, it just calls the `draw` method on the component. By specifying `Box<dyn Draw>` as the type of the values in the `components` vector, we've defined `Screen` to need values that we can call the `draw` method on.

The advantage of using trait objects and Rust's type system to write code similar to code using duck typing is that we never have to check whether a value implements a particular method at runtime or worry about getting errors if a value doesn't implement a method but we call it anyway. Rust won't compile our code if the values don't implement the traits that the trait objects need.

### Dynamic Dispatch, Trait Objects, and Performance in Rust

In Rust, when we use trait objects, we're opting for dynamic dispatch. Dynamic dispatch is a process where the specific method to be called on an object is determined at runtime. This process, known as "lookup", incurs a runtime cost. This is in contrast to static dispatch used by the Generics that implements a process called monomorphization, where the specific method to be called is known at compile time, eliminating the need for lookup and its associated runtime cost.

Dynamic dispatch also has implications for compiler optimizations. One such optimization is inlining, where the compiler replaces a function call with the body of the called function. This can make the program faster by eliminating the overhead of the function call. However, with dynamic dispatch, the compiler can't know at compile time which specific method will be called, preventing it from inlining the method's code. This means that some potential optimizations that could be achieved through inlining are not possible with dynamic dispatch.

Despite these considerations, the use of trait objects in Rust provides extra flexibility. They allow you to interact with different types through the same trait interface. This is a trade-off to consider when designing your Rust programs: the flexibility of trait objects and dynamic dispatch comes with a slight runtime cost and potential loss of optimization opportunities.

## Implementing an Object Oriented Design Pattern

The state pattern is a design pattern used in object-oriented programming. The core idea of this pattern is that a certain value can exist in a set of predefined states. These states are represented by individual state objects.

The behavior of the value changes depending on its current state. This means that the same value can exhibit different behaviors under different states. This allows an object to alter its behavior at runtime without changing its class or relying on large monolithic conditional statements.

To see how to implement this patter go to the projects folder and open the `oop_features/blog` folder there you find this project.
