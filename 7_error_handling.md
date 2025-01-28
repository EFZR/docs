# Error handling in rust 🦀

In this chapter, we're going to talk about how Rust handles errors. There are two main kinds of errors in Rust:

- Errors you can fix, called 'recoverable errors'
- Errors you can't fix, called 'unrecoverable errors'

Let's dive in and learn more about them.

## Index

1. [Unrecoverable errors with `panic!`](#unrecoverable-errors-with-panic)
    - [Unwinding the stack or aborting in response to a panic](#unwinding-the-stack-or-aborting-in-response-to-a-panic)
    - [`panic!`](#panic)
    - [Using a `panic!` Backtrace](#using-a-panic-backtrace)
1. [Recoverable errors with `Result`](#recoverable-errors-with-result)
    - [Matching on Different Errors](#matching-on-different-errors)
    - [Shortcuts for Panic on Error: `unwrap` and `expect` and `unwrap_or_else`](#shortcuts-for-panic-on-error-unwrap-and-expect-and-unwrap_or_else)
    - [Propagating Errors](#propagating-errors)
        - [A shortcut for propagating errors: the `?` operator](#a-shortcut-for-propagating-errors)
        - [Where the `?` operator can be used](#where-the-shortcut-operator-can-be-used)

## Unrecoverable errors with `panic!`

Sometimes, bad things happen in your code, and there’s nothing you can do about it. In these cases, Rust has the panic! macro. There are two ways to cause a panic in practice: by taking an action that causes our code to panic (such as accessing an array past the end) or by explicitly calling the panic! macro.

### `Unwinding` the stack or `aborting` in response to a `panic`

When the `panic!` macro executes, your program will start `unwinding`, a process by which Rust walks back up the `stack` and cleans up the data from each function it encounters. But if this cleanup process doesn’t provide you with enough information, or if it takes significantly more time and resources than you want to spend, you can opt to immediately abort the program, which ends the program without cleaning up.

When a program in Rust encounters an error and 'panics', it has two ways to deal with it: `unwinding` or `aborting`.

1. **Unwinding**: This is what happens by default. When a panic occurs, Rust starts 'unwinding' the stack. This means it looks at all the functions that the program was in the middle of when the error happened, cleans up all their data, and then exits. This allows the program to keep running and handle the error.

2. **Aborting**: This is a more drastic way of dealing with errors. Instead of cleaning up, the program just stops right away. This makes the program stop faster, and the final program file is smaller because it doesn't need the code for unwinding. But it also means the program doesn't get a chance to handle the error.

You can choose between unwinding and aborting by changing your `Cargo.toml` file. By default, Rust unwinds the stack on a panic, but if you want it to abort instead, you can add `panic = 'abort'` to your `Cargo.toml` file under the `[profile]` section.

```toml
[profile.release]
panic = 'abort'
```

### `panic!`

Lets try calling the `panic!` macro in our code.

```rust
fn main() {
    panic!("crash and burn");
}
```

When you run this code, you'll see the following output:

```sh
thread 'main' panicked at 'crash and burn', src/main.rs:2:5
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

### Using a `panic!` Backtrace

Let’s look at another example to see what it’s like when a panic! call comes from a library because of a bug in our code instead of from our code calling the macro directly.

```rust
fn main() {
    let v = vec![1, 2, 3];

    v[99];
}
```

When you run this code, you'll see the following output:

```sh
thread 'main' panicked at 'index out of bounds: the len is 3 but the index is 99', src/main.rs:3:5
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

If you can see what the note is telling you, you can run the program again with the `RUST_BACKTRACE` environment variable set to any value. This will give you a backtrace of exactly

After changing the  backtrace value to 1, you'll see the following output:

```sh
stack backtrace:
   0: rust_begin_unwind
             at /rustc/e092d0b6b43f2de967af0887873151bb1c0b18d3/library/std/src/panicking.rs:584:5
   1: core::panicking::panic_fmt
             at /rustc/e092d0b6b43f2de967af0887873151bb1c0b18d3/library/core/src/panicking.rs:142:14
   2: core::panicking::panic_bounds_check
             at /rustc/e092d0b6b43f2de967af0887873151bb1c0b18d3/library/core/src/panicking.rs:84:5
   3: <usize as core::slice::index::SliceIndex<[T]>>::index
             at /rustc/e092d0b6b43f2de967af0887873151bb1c0b18d3/library/core/src/slice/index.rs:242:10
   4: core::slice::index::<impl core::ops::index::Index<I> for [T]>::index
             at /rustc/e092d0b6b43f2de967af0887873151bb1c0b18d3/library/core/src/slice/index.rs:18:9
   5: <alloc::vec::Vec<T,A> as core::ops::index::Index<I>>::index
             at /rustc/e092d0b6b43f2de967af0887873151bb1c0b18d3/library/alloc/src/vec/mod.rs:2591:9
   6: panic::main
             at ./src/main.rs:4:5
   7: core::ops::function::FnOnce::call_once
             at /rustc/e092d0b6b43f2de967af0887873151bb1c0b18d3/library/core/src/ops/function.rs:248:5
note: Some details are omitted, run with `RUST_BACKTRACE=full` for a verbose backtrace.
```

Now with this backtrace, you can see exactly where the panic occurred. This can be very helpful when debugging your code.

## Recoverable errors with `Result`

Most errors aren’t serious enough to require the program to stop entirely. Sometimes, when a function fails, it’s for a reason that you can easily interpret and respond to.

For example, if you try to open a file and that operation fails because the file doesn’t exist, you might want to create the file instead of terminating the process. Rust groups these kinds of errors into a type called `Result`, which is an `enum` that has two variants:

- `Ok`: An `Ok` result contains a success value.
- `Err`: An `Err` result contains an error value.

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

Lets call a function that returns a `Result` type.

```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt");
}
```

The return type of File::open is a `Result<T, E>`. The generic parameter `T` has been filled in by the implementation of `File::open` with the type of the success value, std::fs::File, which is a file handle. The type of `E` used in the error value is `std::io::Error`. This return type means the call to `File::open` might succeed and return a file handle that we can read from or write to. The function call also might fail: for example, the file might not exist, or we might not have permission to access the file. The `File::open` function needs to have a way to tell us whether it succeeded or failed and at the same time give us either the file handle or error information. This information is exactly what the Result enum conveys.

We need to add to the code in the figure above to take different actions depending on the value File::open returns. Below shows one way to handle the Result using a basic tool, the `match` expression:

```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt");

    let f = match f {
        Ok(file) => file,
        Err(error) => {
            panic!("There was a problem opening the file: {:?}", error)
        },
    };
}
```

### Matching on Different Errors

The code above will panic no matter what the error is. We might want to handle different kinds of errors in different ways. For example, if the file doesn’t exist, we might want to create the file and return the handle to the new file. If the file is corrupted, we might want to print a message to the user and exit the program. We can use different variants of `Err` to have `match` handle different errors in different ways.

```rust
use std::fs::File;
use std::io::ErrorKind;

fn main() {
    let f = File::open("hello.txt");

    let f = match f {
        Ok(file) => file,
        Err(error) match error.kind() {
            ErrorKind::NotFound => match File::create("hello.txt") {
                Ok(fc) => fc,
                Err(e) => {
                    panic!("Tried to create file but there was a problem: {:?}", e)
                },
            },
            other_error => {
                panic!("There was a problem opening the file: {:?}", other_error)
            },
        },
    };
}
```

The type of the value that `File::open` returns inside the `Err` variant is `io::Error`, which is a struct provided by the standard library. This struct has a method kind that we can call to get an `io::ErrorKind` value. The enum `io::ErrorKind` is provided by the standard library and has variants representing the different kinds of errors that might result from an io operation. The variant we want to use is `ErrorKind::NotFound`, which indicates the file we’re trying to open doesn’t exist yet. So we match on `f`, but we also have an inner match on `error.kind()`.

The condition we want to check in the inner match is whether the value returned by `error.kind()` is the NotFound variant of the ErrorKind enum. If it is, we try to create the file with `File::create`. However, because `File::create` could also fail, we need a second arm in the inner match expression. When the file can’t be created, a different error message is printed. The second arm of the outer match stays the same, so the program panics on any error besides the missing file error.

### Shortcuts for Panic on Error: `unwrap` and `expect` and `unwrap_or_else`

Using match works well enough, but it can be a bit verbose and doesn’t always communicate intent well. The `Result<T, E>` type has many helper methods defined on it to do various, more specific tasks. The `unwrap` method is a shortcut method implemented just like the match expression we wrote above. If the Result value is the Ok variant, `unwrap` will return the value inside the `Ok`. If the Result is the Err variant, `unwrap` will call the panic! macro for us. Here is an example of `unwrap` in action:

```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt").unwrap();
}
```

If we run this code without a `hello.txt` file, we’ll see an error message from the `panic!` call that the `unwrap` method makes:

```sh
thread 'main' panicked at 'called `Result::unwrap()` on an `Err` value: Os { code: 2, kind: NotFound, message: "No such file or directory" }', src/main.rs:3:30
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

Similarly, the expect method lets us also choose the `panic!` error message. Using `expect` instead of `unwrap` and providing good error messages can convey your intent and make tracking down the source of a `panic` easier. The syntax of expect looks like this:

```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt").expect("Failed to open hello.txt");
}
```

If we run this code without a `hello.txt` file, we’ll see an error message from the `panic!` call that the `expect` method makes:

```sh
thread 'main' panicked at 'Failed to open hello.txt: Os { code: 2, kind: NotFound, message: "No such file or directory" }', src/main.rs:3:30
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

The `unwrap_or_else` method is similar to `unwrap`, but instead of panicking on an `Err`, it allows us to define our own error handling. Here is an example of `unwrap_or_else` in action:

```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt").unwrap_or_else(|error| {
        if error.kind() == ErrorKind::NotFound {
            File::create("hello.txt").unwrap_or_else(|error| {
                panic!("Tried to create file but there was a problem: {:?}", error)
            })
        } else {
            panic!("There was a problem opening the file: {:?}", error)
        }
    });
}
```

### Propagating Errors

When you’re writing a function whose implementation calls something that might fail, instead of handling the error within this function, you can return the error to the calling code so that it can decide what to do. This is known as `propagating` the error and gives more control to the calling code, where there might be more information or logic that dictates how the error should be handled than what you have available in the context of your code.

```rust
use std::io;
use std::fs::File;


fn read_username_from_file() -> Result<String, io::Error> {
    let f = File::open("hello.txt");

    let mut f = match f {
        Ok(file) => file,
        Err(e) => return Err(e),
    };

    let mut s = String::new();

    match f.read_to_string(&mut s) {
        Ok(_) => Ok(s),
        Err(e) => Err(e),
    }
}
```

The `read_username_from_file` function in Rust is used to read a username from a file named "hello.txt". The function signature is `fn read_username_from_file() -> Result<String, io::Error>`, indicating that it returns a `Result` type that contains either a `String` (in the case of success) or an `io::Error` (in the case of failure).

Here's a step-by-step explanation of the function:

1. `let f = File::open("hello.txt");` - This line attempts to open the file "hello.txt". The `File::open` function returns a `Result<File, io::Error>`. If the file is opened successfully, it returns `Ok(file)`, otherwise it returns `Err(e)` where `e` is the error.

2. The `match` statement is used to handle the `Result` returned by `File::open`. If the file is opened successfully (`Ok(file)`), the file is assigned to `f`. If there is an error (`Err(e)`), the function immediately returns the error.

3. `let mut s = String::new();` - This line creates a new, empty string `s`.

4. `f.read_to_string(&mut s)` - This line attempts to read the entire contents of the file into the string `s`. This function also returns a `Result<usize, io::Error>`. If the read operation is successful, it returns `Ok(_)` where `_` is the number of bytes that were read. If there is an error, it returns `Err(e)`.

5. The second `match` statement handles the `Result` returned by `f.read_to_string`. If the read operation is successful (`Ok(_)`), it returns `Ok(s)` where `s` is the string containing the contents of the file. If there is an error (`Err(e)`), it returns the error.

The pattern of propagating errors is so common that rust provides the `?` operator to make this easier. Here's how you can rewrite the `read_username_from_file` function using the `?` operator:

### A shortcut for propagating errors

The next code example uses the same implementation of `read_username_from_file` as the previous example, but it uses the `?` operator to make the code more concise:

```rust
use std::io;
use std::fs::File;

fn read_username_from_file() -> Result<String, io::Error> {
    let mut f = File::open("hello.txt")?;
    let mut s = String::new();
    f.read_to_string(&mut s)?;
    Ok(s)
}
```

The `?` placed after a `Result` value is defined to work in almost the same way as the match expressions we defined to handle the `Result` values. If the value of the `Result` is an `Ok`, the value inside the `Ok` will get returned from this expression, and the program will continue. If the value is an `Err`, the `Err` will be returned from the whole function as if we had used the return keyword so the error value gets propagated to the calling code.

The `?` operator eliminates a lot of boilerplate and makes this function’s implementation simpler. We could even shorten this code further by chaining method calls immediately after the `?`, which is one of the big benefits of using the `?` operator.

```rust
use std::io;
use std::fs::File;

fn read_username_from_file() -> Result<String, io::Error> {
    let mut username = String::new();

    File::open("hello.txt")?.read_to_string(&mut username)?;

    Ok(username)
}
```

This code is equivalent to the previous example, but it’s more concise. The `?` operator eliminates the need for the match statements, and the error handling is more straightforward.

Below we show you a way to make this function even shorter by using the `fs::read_to_string` function that opens the file, creates a new `String`, reads the contents of the file, puts the contents into that `String`, and returns it.

```rust
use std::io;
use std::fs;

fn read_username_from_file() -> Result<String, io::Error> {
    fs::read_to_string("hello.txt")
}
```

#### Where the shortcut operator can be used

The `?` operator can only be used in functions that have a return type of `Result`, because it is defined to work in the same way as the match expression we defined to handle the `Result` values. The `?` operator can only be used in functions that return `Result` because it is defined to work in the same way as the match expression we defined to handle the `Result` values. Using the `?` operator in a function that returns `Result` is the same as using a match expression. If the value of the `Result` is an `Ok`, the value inside the `Ok` will get returned from this expression, and the program will continue. If the value is an `Err`, the `Err` will be returned from the whole function as if we had used the return keyword so the error value gets propagated to the calling code.

#### Using the `?` operator in `Option`

The `?` operator can also be used with `Option`. It works in the same way as with `Result`, except that it returns from the whole function if the value is `None`. Here is an example:

```rust
fn get_first_word(s: &str) -> Option<&str> {
    let mut iter = s.split_whitespace();
    let first = iter.next()?;
    Some(first)
}
```
