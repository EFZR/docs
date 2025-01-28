# Fearless Concurrency in Rust 🦀

Handling concurrent programming safely and efficiently is another of Rust's mejor goals. *Concurrent programming*, where different parts of a program execute independently, and *parallel programming*, where different parts of a program execute at the same time, are becoming increasingly important as more computers take advantage of their multiple processors. Historically, programming in these contexts has been difficult and error prone: Rust hopes to change that.

> 💡 **Note**: Concurrent and parallel programming are two paradigms that address the same problem—executing multiple tasks—but they do so in different ways. Concurrent programming allows multiple tasks to make progress independently, and these tasks may overlap in execution, but they don't necessarily progress simultaneously. On the other hand, parallel programming involves executing multiple tasks simultaneously, often with the goal of solving a larger problem more quickly.

Something intresting of concurrency in Rust is that the developement team thought the ensuring memory safety and preventing concurrency problemns, were two separate challenge to solve individually. Over time, this find out that the ownership and types systems are a powerful tool to manage concurrency issues. By leveraging ownership and type checking, many concurrency errors are compile-time errors in Rust rather than runtime errors. This is called *fearless concurrency*.

## Index

1. [Using threads to run code concurrently](#using-threads-to-run-code-concurrently)
    - [Creating a New Thread with `spawn`](#creating-a-new-thread-with-spawn)
    - [Waiting for All Threads to Finish Using `join`](#waiting-for-all-threads-to-finish-using-join)
    - [Using `move` Closures with Threads](#using-move-closures-with-threads)
2. [Using Message Passing to Transfer Data Between Threads](#using-message-passing-to-transfer-data-between-threads)
    - [Creating a New Channel with `mpsc::channel`](#creating-a-new-channel-with-mpscchannel)
    - [Sending Messages Along the Channel with `send`](#sending-messages-along-the-channel-with-send)
    - [Receiving Messages with `recv`](#receiving-messages-with-recv)
    - [Channels and ownership transference](#channels-and-ownership-transference)
    - [Sending Multiple Values and Seeing the Receiver Waiting](#sending-multiple-values-and-seeing-the-receiver-waiting)
    - [Cloning the Transmitter to Send Messages from Multiple Threads](#cloning-the-transmitter-to-send-messages-from-multiple-threads)
3. [Shared-State Concurrency](#shared-state-concurrency)
    - [Using Mutexes to Allow Access to Data from One Thread at a Time](#using-mutexes-to-allow-access-to-data-from-one-thread-at-a-time)
    - [The API of `Mutex`](#the-api-of-mutex)
    - [Atomic Reference Counting with `Arc<T>`](#atomic-reference-counting-with-arct)
    - [Sharing a `Mutex<T>` Between Multiple Threads with `Arc<T>`](#sharing-a-mutext-between-multiple-threads-with-arct)
    - [Similarities Between `Rc<T>` and `Arc<T>`](#similarities-between-rct-and-arct)
4. [Extensible Concurrency with the Sync and Send Traits](#extensible-concurrency-with-the-sync-and-send-traits)
    - [Allowing Transference of Ownership Between Threads](#allowing-transference-of-ownership-between-threads)
    - [Allowing Access from Multiple Threads with the Sync Trait](#allowing-access-from-multiple-threads-with-the-sync-trait)
    - [Implementing Send and Sync Manually Is Unsafe](#implementing-send-and-sync-manually-is-unsafe)

## Using threads to run code concurrently

In most concurrent operating systems, an executed program's code is run in a process, and the operating system manages multiple processes at once. Within your program, you can also have independent parts that run sumultaneously. The features that run these independent parts are called *threads*.

Splitting the computation in your program into multiple threads to run multiple tasks at the same time can improve performance, but it also add complexity. Because threads can run simultaneously, there's no inherent guarantee about the order in which parts of your code on different threads will run, This can lead to problems.

Different programming languages implement threads in various ways, often utilizing APIs provided by the operating system to create new threads.

In Rust, the standard library uses a 1:1 model for thread implementation. This means that for each thread you create in your Rust program, one operating system thread is used. This model provides direct control over the operating system's threads, but each thread comes with a certain amount of overhead.

There are other models of threading, such as the M:N model, where M green threads (threads managed by the runtime system of a programming language, not the operating system) are mapped to N operating system threads. This model can be more efficient because green threads are lighter weight than operating system threads, and the runtime system can manage these threads more efficiently than the operating system.

In Rust, there are crates (libraries) available that implement these other models of threading. These different models make different trade-offs compared to the 1:1 model. For example, they might provide better performance in certain situations, but they might also be more complex to use or have other drawbacks.

### Creating a New Thread with `spawn`

To create a new `Thread`, we call the `thread::spawn` function and pass it a closure containing the code we want to run in the new thread. The example in below prints some text from the main thread and some from a new thread:

```rust
use std::thread;
use std::time::Duration;

fn main() {
    thread::spawn(|| {
        for i in 1..10 {
            println!("Hi number {} from the spawned thread!", i);
            thread::sleep(Duration::from_millis(1));
        }
    });

    for i in 1..5 {
        println!("Hi number {} from the main thread", i);
        thread::sleep(Duration::from_millis(1));
    }
}
```

Note that when the main thread of a Rust program completes, all spawned threads are shut down/killed, weather or not they have finished their work. That why is possible the spawn thread was ony able to print a few numbers before the main thread shut down.

The `thread::sleep` force a thread to stop its execution for a short period of time, allowing a different thread to run. This is useful when you want to make sure a thread has time to do work before other threads run again, but this is not guaranteed: it depends on the operating system's scheduling.

### Waiting for All Threads to Finish Using `join`

In the last code the main thread finished before the spawned thread, so the spawned thread didn't have a chance to print all its numbers. We can fix this by saving the return value of `thread::spawn` in a variable. The return type of `thread::spawn` is `JoinHandle`. A `JoinHandle` is an owned value that, when we call the `join` method on it, will wait for its thread to finish.

```rust
use std::thread;
use std::time::Duration;

fn main() {
    let handle: thread::JoinHandle<()> = thread::spawn(|| {
        for i in 1..10 {
            println!("Hi number {} from the spawned thread!", i);
            thread::sleep(Duration::from_millis(1));
        }
    });

    // The main thread waits for the spawned thread to finish its job.
    // Uncommenting the line below will halt the main thread until the spawned thread completes.
    // handle.join().unwrap();

    for i in 1..5 {
        println!("Hi number {} from the main thread", i);
        thread::sleep(Duration::from_millis(1));
    }

    // The main thread waits for the spawned thread to finish using the join method.
    // The unwrap method is called to handle any potential errors.
    handle.join().unwrap();
}
```

Calling `join` on the handle blocks the thread currently running until the thread represented by the handle terminates. If the child thread panics, `join` will return an `Err` value containing the argument given to `panic`.

### Using `move` Closures with Threads

When we use the `thread::spawn` function, the spawned thread may access data from the main thread. This is a potential problem because Rust doesn't know how long the spawned thread will run, so it doesn't know if the reference to the data will always be valid. For example, the following code won't compile because the spawned thread might outlive the main thread:

```rust
use std::thread;

fn main() {
    let v = vec![1, 2, 3];

    let handle = thread::spawn(|| {
        println!("Here's a vector: {:?}", v);
    });

    handle.join().unwrap();
}
```

This would be a problem because if Rust would allow us to use `v` in the spawned thread, and the main thread finished while the spawned thread was still running, there would be a reference to an invalid vector.

To move `v` into the spawned thread, we can use the `move` keyword before the closure. This keyword changes the closure's behavior to take ownership of the values it uses in the environment. The following code will compile and work as we want:

```rust
use std::thread;

fn main() {
    let v = vec![1, 2, 3];

    let handle = thread::spawn(move || {
        println!("Here's a vector: {:?}", v);
    });

    handle.join().unwrap();
}
```

The `move` keyword is mostly used when we want to transfer ownership of a value to a the new thread, but it's also useful in other situations. For example, it's often used with threads to allow the closure to capture its environment, as we've done here.

## Using Message Passing to Transfer Data Between Threads

A prevalent approach to ensuring safe concurrency is through *message passing*. In this model, threads or actors communicate by sending each other messages containing data. This method helps prevent shared state and the associated risks.

To facilitate message-passing concurrency, Rust's standard library provides an implementation of *channels*. Channels, a common concept in concurrent programming, serve as a conduit for sending data from one thread to another.

A channel has to halves: a transmitter and a receiver. The transmitter half is the end from which we can send values into the channel, and the receiver half is the end from which we can read values out of the channel.

### Creating a New Channel with `mpsc::channel`

The `mpsc` stands for *multiple producer, single consumer*. The `std::sync::mpsc` module provides multiple-producer, single-consumer channels. This means that you can have multiple threads sending data to one thread, and the receiver will process the data in the order it's sent.

To create a new channel, we call the `mpsc::channel` function:

```rust
use std::sync::mpsc;

fn main() {
    let (tx, rx) = mpsc::channel();
}
```

The function `channel` returns a tuple, where the first element is the transmitter and the second element is the receiver. We destructured the tuple into two variables, `tx` and `rx`.

### Sending Messages Along the Channel with `send`

To send a value along the channel, we use the `send` method. The `send` method returns a `Result` type, so if the receiving end of the channel has already been dropped and there's nowhere to send a value, the `send` method will return an error.

We will create a `thread::spawn` and move the value of the transmitter into the spawned thread. Then, we'll send a message through the transmitter:

```rust
use std::sync::mpsc;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let val = String::from("hi");
        tx.send(val).unwrap();
    });
}
```

### Receiving Messages with `recv`

To receive a value from the channel, we can use the `recv` method. The `recv` method blocks the current thread and waits until a value is sent down the channel. Once a value is sent, `recv` will return it in a `Result`. When the sending end of the channel closes, `recv` will return an error to signal that no more values will be coming.

```rust
use std::sync::mpsc;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let val = String::from("hi");
        tx.send(val).unwrap();
    });

    let received = rx.recv().unwrap();
    println!("Got: {}", received);
}
```

There are two ways to receive values from other thread `recv` and `try_recv`. The `recv` method will block the current thread and wait for a value to be sent. If the sending end of the channel closes, `recv` will return an error. The `try_recv` method doesn't block, but will return a `Result` immediately: an `Ok` value holding a message if one is available and an `Err` if there aren't any messages this time.

### Channels and ownership transference

Is important to understand that while a thread is working with a value, this still bind to the rules of rust ownership. For example, the following code won't compile:

```rust
use std::sync::mpsc;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let val = String::from("hi");
        tx.send(val).unwrap();
        println!("val is {}", val);
    });

    let received = rx.recv().unwrap();
    println!("Got: {}", received);
}
```

This wont work beacuase the value `val` was moved into the `send` method, so the `println!` macro can't use it anymore. The `send` method takes ownership of its parameter, and we've moved `val` into the `send` method

> 💡 **Insight**: Attempting to send a reference from the spawned thread to the main thread would lead to a compilation error in Rust. This is because the spawned thread could potentially outlive the main thread, rendering the reference invalid. Rust's ownership rules prevent this kind of data race at compile time.

### Sending Multiple Values and Seeing the Receiver Waiting

In the before example we just sent one value from a transmiter thread to a receiver thread.

Now we are to send multiple values and see the receiver waiting for the values to be sent:

```rust
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let vals: Vec<String> = vec![
            String::from("hi"),
            String::from("from"),
            String::from("The"),
            String::from("thread"),
        ];
        for val in vals {
            tx.send(val).unwrap();
            thread::sleep(Duration::from_secs(1));
        }
    });

    for received in rx {
        println!("Got: {}", received)
    }
    
}
```

The `for` loop will receive all the values sent down the channel. When the channel is closed, the loop will end. In the main thread, we’re not calling the `recv` function explicitly anymore: instead, we’re treating `rx` as an `iterator`. For each value received, we’re printing it. When the channel is closed, iteration will end.

### Cloning the Transmitter to Send Messages from Multiple Threads

Earlier we mentioned that the `mpsc` stands for *multiple producer, single consumer*. This means that you can have multiple sending ends that produce values, but only one receiving end that consumes those values.

This can be done by cloning the transmitter, so we can have multiple threads sending messages to the same receiver:

```rust
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn main() {
    let (tx, rx) = mpsc::channel();

    let tx1 = tx.clone();

    thread::spawn(move || {
        let vals: Vec<String> = vec![
            String::from("hi"),
            String::from("from"),
            String::from("The"),
            String::from("thread"),
        ];
        for val in vals {
            tx.send(val).unwrap();
            thread::sleep(Duration::from_secs(1));
        }
    });

    thread::spawn(move || {
        let vals: Vec<String> = vec![
            String::from("more"),
            String::from("and"),
            String::from("more"),
            String::from("messages"),
        ];
        for val in vals {
            tx1.send(val).unwrap();
            thread::sleep(Duration::from_secs(1));
        }
    });

    for received in rx {
        println!("Got: {}", received)
    }
    
}
```

This time, before we create the first spawned thread, we call `clone` on the transmitter. This will give us a new transmitter we can pass to the first `spawned thread`. We pass the original transmitter to a second spawned thread. This gives us two threads, each sending different messages to the one receiver.

## Shared-State Concurrency

Message passing and shared memory represent two primary models for handling concurrency.

**Message passing** is a model where threads or processes communicate and synchronize by sending each other messages. This model is beneficial as it avoids the need for shared state, thereby preventing complex synchronization issues.

However, message passing is not the only way to handle concurrency. Another common model is **shared memory concurrency**, where multiple threads access the same memory location. This model can be more efficient than message passing in some cases, but it can also lead to issues like race conditions, where the outcome of the program depends on the relative timing of different threads' operations.

Proponents of message passing frequently advise against the use of shared memory. This caution stems from the potential complications associated with shared memory. Coordinating access to shared memory can be intricate and susceptible to errors. It's not uncommon for this complexity to lead to subtle bugs that are challenging to detect and rectify.

In Rust, channels are similar to single ownership: once you send a value down a channel, you can't use that value anymore. This is similar to how once you transfer ownership of a value in Rust, you can't use the original value anymore.

On the other hand, shared memory concurrency is like multiple ownership: multiple threads can access the same memory location at the same time. This can be complex to manage, but Rust's type system and ownership rules can help ensure that this is done correctly.

Mutexes are a common tool for managing access to shared memory. A mutex allows only one thread to access some data at a time, which can prevent race conditions. In the next section, we'll look at how mutexes can be used in Rust.

### Using Mutexes to Allow Access to Data from One Thread at a Time

*Mutex* is an abbreviation for *mutual exclusion*, as in, a mutex allows only one thread to access only one `thread` to access some data at any given time. To access the data in a mutex, a thread must first signal that it wants access by asking to acquire the mutex's lock. The lock is a data structure that is part of the mutex that keeps track of who currently has exclusive access to the data. Therefore, the mutex is described as guarding the data it holds via the locking system.

Mutexes have a reputation for being difficult to use because you have to remember two rules:

- You must attempt to acquire the lock before using the data.
- When you're done with the data, you must unlock the data so other threads can acquire the lock.

### The API of `Mutex`

As an example of how to use a `mutex`, lets start by using a mutex in a single-threaded context. This will show how to acquire the lock and modify the data. We'll then move on to a multithreaded context to see how to share the mutex between multiple threads.

```rust
use std::sync::Mutex;

fn main() {
    let m = Mutex::new(5);

    {
        let mut num = m.lock().unwrap();
        *num = 6;
    }

    println!("m = {:?}", m);
}
```

In the code above we create the `mutex<T>` with the `new` method. To access the data inside the mutex, we use the `lock` method to acquire the lock. This call will block the current thread so it can't do any work until it's our turn to have the lock. The call to `lock` would fail if another thread holding the lock panicked. In that case, the `lock` method call would return an `Err` value.

In Rust, after acquiring the lock on a `Mutex`, we can treat the return value (in this case, named `num`) as a mutable reference to the data inside. The Rust type system ensures that we acquire a lock before using the value in `m`. The type of `m` is `Mutex<i32>`, not `i32`, so we must call `lock` to be able to use the `i32` value. We can't forget; the type system won't let us access the inner `i32` otherwise.

Interestingly, `Mutex<T>` is a smart pointer. More accurately, the call to `lock` returns a smart pointer called `MutexGuard`, wrapped in a `LockResult` that we handled with the call to `unwrap`. The `MutexGuard` smart pointer implements `Deref` to point at our inner data.

Moreover, the smart pointer also has a `Drop` implementation that releases the lock automatically when a `MutexGuard` goes out of scope, which happens at the end of the inner scope. As a result, we don’t risk forgetting to release the lock and blocking the mutex from being used by other threads, because the lock release happens automatically.

### Atomic Reference Counting with `Arc<T>`

Now that we now how to use a `Mutex` to manage access to a value, we can use the `Arc<T>` type to enable multiple threads to share access to the same `Mutex<T>`.

But should keep asking ourselves:

- why do we need `Arc<T>`?

- why can't we just pass the `Mutex<T>` directly to the threads?

- What is the difference between `Arc<T>` and `Rc<T>`?

- Why not use `Arc<T>` everywhere instead of `Rc<T>`?

The answer to the first question is that `Arc<T>` is a type like `Rc<T>` that is safe to use in concurrent situations. The `Rc<T>` type is not safe for use in concurrent situations, but `Arc<T>` is. The `A` stands for *atomic*, meaning it's an atomically reference counted type.

The answer to the second question is that we can't just pass the `Mutex<T>` to another thread because Rust wouldn't know how many threads are using the `Mutex<T>`. So what occurs when we move the `Mutex<T>` to another thread this gets the ownership of the `Mutex<T>`, and Rust can't guarantee that the original thread will be alive for the entire time the other thread needs the `Mutex<T>`.

The answer to the third question is that `Rc<T>` is not safe to use in concurrent situations, but `Arc<T>` is. The `Rc<T>` type keeps track of the number of references to a value, and when that count reaches zero, the value is cleaned up. But because `Rc<T>` is not thread safe, the reference count can be corrupted in concurrent situations. The `Arc<T>` type, however, is safe to use in concurrent situations. The `A` stands for *atomic*, meaning it's an atomically reference counted type.

The answer to the fourth question is that `Arc<T>` is only necessary in concurrent situations, and using `Arc<T>` comes with a performance penalty that you don't want to pay unless you need to. In the single-threaded case, where you don't need to share ownership across threads, `Rc<T>` is the best choice.

### Sharing a `Mutex<T>` Between Multiple Threads with `Arc<T>`

To demonstrate how to share a `Mutex<T>` between multiple threads, we'll implement a program that with a for loop, creates a number of threads that will increment a counter. We'll use a `Mutex<T>` change a value between threads and `Arc<T>` to share the `Mutex<T>` between threads.

```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter: Arc<Mutex<i32>> = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();

            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result: {}", *counter.lock().unwrap());
}
```

### Similarities Between `Rc<T>` and `Arc<T>`

The `Mutex<T>` in Rust provides interior mutability, similar to the Cell family. This means that even though `counter` is immutable, we can get a mutable reference to the value inside it. This is similar to how we used `RefCell<T>` in conjunction with `Rc<T>` to allow us to mutate contents inside an `Rc<T>`. We use `Mutex<T>` to mutate contents inside an `Arc<T>`.

However, it's important to note that Rust can't protect you from all kinds of logic errors when you use `Mutex<T>`. For instance, using `Rc<T>` can lead to the risk of creating reference cycles, where two `Rc<T>` values refer to each other, causing memory leaks. Similarly, `Mutex<T>` comes with the risk of creating **deadlocks**.

Deadlocks occur when an operation needs to lock two resources and two threads have each acquired one of the locks, causing them to wait for each other indefinitely. If you're interested in **deadlocks**, you can try creating a Rust program that has a deadlock. Then, research deadlock mitigation strategies for mutexes in any language and try implementing them in Rust. The standard library API documentation for `Mutex<T>` and `MutexGuard` provides useful information on this topic.

## Extensible Concurrency with the Sync and Send Traits

Interestingly, the Rust language itself has very few concurrency features. Almost every concurrency feature we've discussed so far has been part of the standard library, not the language itself. This means that your options for handling concurrency are not limited to the language or the standard library; you can write your own concurrency features or use those written by others.

However, there are two concurrency concepts that are embedded in the language: the `std::marker` traits `Sync` and `Send`. These two traits are fundamental to Rust's concurrency model and are automatically implemented by the compiler for types that are safe to be passed between threads.

### Allowing Transference of Ownership Between Threads

The `Send` marker trait in Rust indicates that ownership of values of the type implementing `Send` can be transferred between threads. Almost every Rust type is `Send`, but there are some exceptions, including `Rc<T>`.

`Rc<T>` cannot be `Send` because if you cloned an `Rc<T>` value and tried to transfer ownership of the clone to another thread, both threads might update the reference count at the same time. This could lead to race conditions, hence `Rc<T>` is designed for use in single-threaded situations where you don’t want to pay the thread-safe performance penalty.

Therefore, Rust’s type system and trait bounds ensure that you can never accidentally send an `Rc<T>` value across threads unsafely. This is a powerful feature that helps prevent data races at compile time.ith `Send`

### Allowing Access from Multiple Threads with the Sync Trait

The `Sync` marker trait in Rust indicates that it is safe for the type implementing `Sync` to be referenced from multiple threads. In other words, any type `T` is `Sync` if `&T` (an immutable reference to `T`) is `Send`, meaning the reference can be sent safely to another thread. Similar to `Send`, primitive types are `Sync`, and types composed entirely of types that are `Sync` are also `Sync`.

The smart pointer `Rc<T>` is not `Sync` for the same reasons that it’s not `Send`. The `RefCell<T>` type (which we discussed earlier) and the family of related `Cell<T>` types are not `Sync`. The implementation of borrow checking that `RefCell<T>` does at runtime is not thread-safe. This means that `RefCell<T>` allows for mutable borrowing checked at runtime, but it does not provide guarantees across multiple threads.

### Implementing Send and Sync Manually Is Unsafe

In Rust, types that are composed of `Send` and `Sync` traits are automatically also `Send` and `Sync`. This means that we don’t have to implement those traits manually. As marker traits, they don’t even have any methods to implement. They’re just useful for enforcing invariants related to concurrency.

Manually implementing these traits involves implementing unsafe Rust code. We'll discuss using unsafe Rust code in a later chapter; for now, the important takeaway is that building new concurrent types not made up of `Send` and `Sync` parts requires careful thought to uphold the safety guarantees. This is because the compiler can't automatically verify the safety of your `Send` and `Sync` implementations, so you need to ensure that they uphold the guarantees that these traits are supposed to provide.
