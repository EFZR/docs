# Common collections in rust 🦀

Rust standard libraries contain a number of collections that are used to store multiple values. Unlike the built-in arrays and tuples, the data these collections point to is stored on the heap, which means the amount of data does not need to be known at compile time and can grow or shrink as the program runs.

## Index

1. [Storing list of values with vectors](#storing-list-of-values-with-vectors)
    - [Creating a new vector](#creating-a-new-vector)
    - [Updating a vector](#updating-a-vector)
    - [Reading elements of a vector](#reading-elements-of-a-vector)
        - [Using indexing syntax](#using-indexing-syntax)
        - [Using the `get` method](#using-the-get-method)
    - [Iterating over the values in a vector](#iterating-over-the-values-in-a-vector)
    - [Using an enum to store multiple types](#using-an-enum-to-store-multiple-types)
    - [vector methods](#vector-methods)
2. [Storing UTF-8 encoded text with strings](#storing-utf-8-encoded-text-with-strings)
    - [Creating a new string](#creating-a-new-string)
    - [Updating a string](#updating-a-string)
    - [Concatenating strings](#concatenating-strings)
        - [Concatenating with the `+` operator](#concatenating-with-the-plus-operator)
        - [Concatenating with the `format!` macro](#concatenating-with-the-format-macro)
    - [Indexing into strings](#indexing-into-strings)
        - [Understanding String Indexing and UTF-8 Encoding in Rust](#understanding-string-indexing-and-utf-8-encoding-in-rust)
        - [Bytes and Scalar Values and Grapheme Clusters! Oh My](#bytes-and-scalar-values-and-grapheme-clusters-oh-my)
    - [Slicing Strings](#slicing-strings)
    - [Methods for Iterating Over Strings](#methods-for-iterating-over-strings)
    - [String methods](#string-methods)
3. [Storing keys with values using hash maps](#storing-keys-with-values-using-hash-maps)
    - [Creating a new hash map](#creating-a-new-hash-map)
    - [Accesing values in a hash map](#accesing-values-in-a-hash-map)
    - [Iterating over the values in a hash map](#iterating-over-the-values-in-a-hash-map)
    - [Hash maps and ownership](#hash-maps-and-ownership)
    - [Updating a hash map](#updating-a-hash-map)
        - [Overwriting a value](#overwriting-a-value)
        - [Adding a Key and Value Only If a Key Isn’t Present](#adding-a-key-and-value-only-if-a-key-isnt-present)
        - [Updating a Value Based on the Old Value](#updating-a-value-based-on-the-old-value)
    - [hash map methods](#hash-map-methods)
4. [Exercises](#exercises)

## Storing list of values with vectors

Vectors allows you to store more than one value in a single data structure that puts all the values next to each other in memory. Vectors can only store values of the same type.

### `Creating a new vector`

To create a new vector we will call the `Vec::new` function and then use the `push` method to add elements to the vector.

```rust
fn main() {
    let v: Vec<i32> = Vec::new();
}
```

We added the type annotation `: Vec<i32>` because we're creating an empty vector and Rust doesn't know what kind of elements we intend to store. To create a new vector with initial values, we can use the `vec!` macro.

```rust
fn main() {
    let v = vec![1, 2, 3, 4, 5];
}
```

### `Updating a vector`

To create a vector and add elements to the vector, we can use the `push` method. To remove elements from the vector, we can use the `pop` method.

```rust
fn main() {
    let mut v = vec![1, 2, 3, 4, 5];
    v.push(6);
    v.push(7);
    v.push(8);
    let popped = v.pop();
}
```

### `Reading elements of a vector`

There are two ways to reference a value stored in a vector: using indexing syntax or the `get` method with a reference to the index.

#### Using indexing syntax

We can get the value of a vector element by using the index of the element. The index is a non-negative integer. If we try to access an element using an index that is out of bounds, Rust will panic.

```rust
fn main() {
    let v = vec![1, 2, 3, 4, 5];
    let third: &i32 = &v[2];
}
```

>**Note:** In the provided code snippet, we're interacting with a vector `v` that holds integers. When we aim to access a specific element in the vector, we utilize the reference operator (`&`). Even though the integer values in this case implement the `Copy` trait and are therefore copied rather than moved, the reference operator is still crucial. Without it, if the vector contained a type that doesn't implement the `Copy` trait, the value would be moved out of the vector and would no longer belong to it. This could lead to unexpected behavior and potential errors. Therefore, using the reference operator ensures safe and predictable access to vector elements.

```rust
    let mut v = vec![1, 2, 3, 4, 5];

    let first = &v[0];

    v.push(6);

    println!("The first element is: {first}");
```

The code above will result in a compilation error because the reference to the first element is still in use when we try to push a new element onto the vector. The `push` method might need to allocate new memory and copy the old elements to the new space, and if that happens, the reference to the first element would be pointing to deallocated memory.

#### Using the `get` method

The get method returns an Option<&T>. If the index is out of bounds, it returns None. If the index is valid, it returns a reference to the element.

```rust
fn main() {
    let v = vec![1, 2, 3, 4, 5];
    match v.get(2) {
        Some(third) => println!("The third element is {}", third),
        None => println!("There is no third element."),
    }
}
```

### `Iterating over the values in a vector`

We can iterate over the values in a vector using a for loop.

```rust
fn main() {
    let v = vec![100, 32, 57];
    for i in &v {
        println!("{}", i);
    }
}
```

We can also iterate over mutable references to each element in a mutable vector.

```rust
fn main() {
    let mut v = vec![100, 32, 57];
    for i in &mut v {
        *i += 50;
    }
}
```

>**Note:** Iterating in a vector using a for loop is a safe operation. The for loop will not let you mutate the vector, This is because removing an element from a vector while it's being iterated over would change the length of the vector, which could lead to unexpected behavior or runtime errors.

### `Using an enum to store multiple types`

Vectors can only store values that are the same type. This can be inconvenient; there are definitely use cases for needing to store a list of items of different types. Fortunately, the variants of an enum are defined under the same enum type, so when we need one type to represent elements of different types, we can define and use an enum!

```rust
enum SpreadsheetCell {
    Int(i32),
    Float(f64),
    Text(String),
}

fn main() {
    let row = vec![
        SpreadsheetCell::Int(3),
        SpreadsheetCell::Text(String::from("blue")),
        SpreadsheetCell::Float(10.12),
    ];
}
```

>**Note:** if you don’t know the exhaustive set of types a program will get at runtime to store in a vector, the `enum` technique won’t work. Instead, you can use a `trait` object

### `vector methods`

- `push`: Adds an element to the end of a vector.
- `pop`: Removes the last element from a vector and returns it.
- `get`: Returns an Option<&T>.
- `iter`: Returns an iterator over the elements of the vector.
- `iter_mut`: Returns an iterator that allows modifying each value.
- `len`: Returns the number of elements in the vector.
- `is_empty`: Returns true if the vector contains no elements.
- `remove`: Removes the element at the specified index and returns it.
- `truncate`: Shortens the vector, keeping the first n elements and dropping the rest.
- `retain`: Retains only the elements specified by the predicate.

## Storing UTF-8 encoded text with strings

Rust only has one type of string in the core language, which is the string slice `str` that is usually seen in its borrowed form `&str`. The `String` type, which is provided by the **standard library** rather than coded into the core language, is a growable, mutable, owned, UTF-8 encoded string type.

### `Creating a new string`

Many of the same function of `Vec` can be used with `String` as well, because String is actually implemented as a wrapper around a vector of bytes with some extra guarantees, restrictions, and capabilities. We can create a new empty string with the `String::new` function, and we can create a new string with initial data using the `to_string` method.

```rust
let mut s = String::new();
```

we can also use the `to_string` method to create a new string from a string literal.

```rust
let data = "initial contents";
let s = data.to_string();
```

or we can use the `String::from` function to create a new string from a string literal.

```rust
let data = "initial contents";
let s = String::from(data);
```

### `Updating a string`

We can append to a string with the `push_str` method, and we can append a single character with the `push` method.

```rust
let mut s = String::from("foo");
s.push_str("bar");
s.push('l');
```

### `Concatenating strings`

We can concatenate two strings with the `+` operator or the `format!` macro.

#### Concatenating with the plus operator

```rust
let s1 = String::from("Hello, ");
let s2 = String::from("world!");
let s3 = s1 + &s2;
```

>**Note:** The `+` operator in Rust employs the `add` method, which takes ownership of `s1` and borrows `s2`. This behavior is due to the method signature for `add`, which includes two parameters: `self` and `s: &str`. Here, `self` refers to `s1` and is moved, while `s2` is borrowed. But how does this work when `&s2` is actually a `&String`, not a `&str`? The answer lies in a feature of Rust's type system known as *deref coercion*. When Rust encounters the `+` operator, it automatically coerces the `&String` argument into a `&str` argument. This allows the `add` method to work seamlessly with both `String` and `str` types.
>
>```rust
>fn add(self, s: &str) -> String {
>    // implementation
>}
>```

#### Concatenating with the `format!` macro

The `+` operator uses the `add` method, which takes ownership of `s1` and borrows `s2`. The `format!` macro returns a `String` and does not take ownership of any of its parameters.

```rust
let s1 = String::from("tic");
let s2 = String::from("tac");
let s3 = String::from("toe");
let s = format!("{}-{}-{}", s1, s2, s3);
```

### `Indexing into strings`

#### Understanding String Indexing and UTF-8 Encoding in Rust

In many other programming languages indexing in strings is allowed, but in Rust, it is not allowed. This is because `strings` are a collection of bytes, and in Rust, indexing is only allowed for collections of elements of the same type.

In the case of `strings` are wrapper over a `Vec<u8>`, and the `Vec<u8>` is a collection of bytes, so indexing into a string would return a byte, not a character. This could lead to unexpected behavior.

To understand more this check the following example:

```rust
let hello = String::from("hola");
```

In this case the length of the string is 4 bytes long. Each of these letters takes 1 byte when encoded in UTF-8. The following line may surprise you:

```rust
let hello = String::from("Здравствуйте");
```

Asked how long the string is, you might say 12. In fact, Rust’s answer is 24: that’s the number of bytes it takes to encode “Здравствуйте” in UTF-8, because each Unicode scalar value in that string takes 2 bytes of storage. Therefore, an index into the string’s bytes will not always correlate to a valid Unicode scalar value. To demonstrate, consider this invalid Rust code:

```rust
let hello = "Здравствуйте";
let answer = &hello[0];
```

You already know that answer will not be З, the first letter. When encoded in `UTF-8`, the first byte of З is 208 and the second is 151, so it would seem that answer should in fact be 208, but 208 is not a valid character on its own. Returning 208 is likely not what a user would want if they asked for the first letter of this string; however, that’s the only data that Rust has at byte index 0. Users generally don’t want the byte value returned, even if the string contains only Latin letters: if `&"hello"[0]` were valid code that returned the byte value, it would return `104`, not `h`.

The answer, then, is that to avoid returning an unexpected value and causing bugs that might not be discovered immediately, Rust doesn’t compile this code at all and prevents misunderstandings early in the development process.

#### Bytes and Scalar Values and Grapheme Clusters! Oh My

Another point about UTF-8 is that there are actually three relevant ways to look at strings from Rust’s perspective: as bytes, scalar values, and grapheme clusters (the closest thing to what we would call letters).

If we look at the Hindi word “नमस्ते” written in the Devanagari script, it is stored as a vector of u8 values that looks like this:

```rust
[224, 164, 168, 224, 164, 174, 224, 164, 184, 224, 165, 141, 224, 164, 164, 224, 165, 135]
```

That’s 18 bytes and is how computers ultimately store this data. If we look at them as Unicode scalar values, which are what Rust’s char type is, those bytes look like this:

```rust
['न', 'म', 'स', '्', 'त', 'े']
```

There are six char values here, but the fourth and sixth are not letters: they’re diacritics that don’t make sense on their own. Finally, if we look at them as grapheme clusters, we’d get what a person would call the four letters that make up the Hindi word:

```rust
["न", "म", "स्", "ते"]
```

Rust provides different ways of interpreting the raw string data that computers store so that each program can choose the interpretation it needs, no matter what human language the data is in.

One more reason why Rust doesn't let us use an index to get a character from a `String` is because indexing is usually expected to be a quick operation, taking the same amount of time no matter how large the string is. However, with a `String` in Rust, this isn't possible. To find a character at a certain index, Rust would have to start at the beginning of the string and count up to that index. This could take longer for larger strings, so the time it takes would not be constant. To avoid this potential slowdown, Rust doesn't allow indexing into strings.

### `Slicing Strings`

Indexing into a string is often a bad idea because it’s not clear what the return type of the string-indexing operation should be: a byte value, a character, a grapheme cluster, or a string slice. If you really need to use indices to create string slices, therefore, Rust asks you to be more specific.

Rather than indexing using `[]` with a single number, you can use `[]` with a range to create a string slice containing particular bytes:

```rust
let hello = "Здравствуйте";
let s = &hello[0..4];
```

Here, s will be a &str that contains the first 4 bytes of the string. Earlier, we mentioned that each of these characters was 2 bytes, which means s will be Зд.

### `Methods for Iterating Over Strings`

The best way to operate on pieces of strings is to be explicit about whether you want characters or bytes.

#### Bytes

The `bytes` method returns a sequence of bytes. This is one way to get a sequence of bytes from a string.

```rust
for b in "Зд".bytes() {
    println!("{b}");
}
```

This code will print the four bytes that make up the two characters in the string.

```bash
208
151
208
180
```

#### Characters

The `chars` method returns a sequence of characters. This is one way to get a sequence of characters from a string.

```rust
for c in "Зд".chars() {
    println!("{c}");
}
```

This code will print the two characters in the string.

```bash
З
д
```

### `String methods`

- `push_str`: Appends a string slice to a `String`.
- `push`: Appends a single character to a `String`.
- `format!`: Returns a `String` with the formatted text.
- `len`: Returns the length of a `String`, in bytes, not the number of characters.
- `is_empty`: Returns true if the `String` is empty.
- `replace`: Replaces a string with another string.
- `split`: Splits a `String` into a substring by a pattern.
- `trim`: Removes leading and trailing whitespace from a `String`.
- `to_lowercase`: Converts a `String` to lowercase.
- `to_uppercase`: Converts a `String` to uppercase.
- `contains`: Returns true if a `String` contains a substring.
- `starts_with`: Returns true if a `String` starts with a substring.
- `ends_with`: Returns true if a `String` ends with a substring.

## Storing keys with values using hash maps

The type `HashMap<K, V>` stores a mapping of keys of type `K` to values of type `V`. It does this via a hashing function, which determines how it places these keys and values into memory. This allows for extremely fast lookups, as the hash map can quickly determine where the value for a given key is stored.

### `Creating a new hash map`

One way to create a hash map is with the `new` method and then use the `insert` method to add elements to the hash map.

```rust
use std::collections::HashMap;

fn main() {
    let mut scores = HashMap::new();
    scores.insert(String::from("Blue"), 10);
    scores.insert(String::from("Yellow"), 50);
}
```

>**Note:** We need to first `use` the `HashMap` from the collections portion of the standard library. Of our three common collections, this one is the least often used, so it’s not included in the features brought into scope automatically in the prelude. Like vectors, hash maps are homogeneous: all of the keys must have the same type as each other, and all of the values must have the same type.

### `Accesing values in a hash map`

We can get a value out of the hash map by providing its key to the `get` method.

```rust
use std::collections::HashMap;

fn main() {
    let mut scores = HashMap::new();
    scores.insert(String::from("Blue"), 10);
    scores.insert(String::from("Yellow"), 50);

    let team_name = String::from("Blue");
    let score = scores.get(&team_name).copied().unwrap_or(0);
}
```

>Here, score will have the value that’s associated with the Blue team, and the result will be 10. The get method returns an `Option<&V>;` if there’s no value for that key in the hash map, get will return `None`. This program handles the Option by calling `copied` to get an `Option<i32>` rather than an `Option<&i32>`, then `unwrap_or` to set score to zero if scores doesn't have an entry for the key.

### `Iterating over the values in a hash map`

We can iterate over each key/value pair in a hash map using a for loop.

```rust
use std::collections::HashMap;

fn main() {
    let mut scores = HashMap::new();
    scores.insert(String::from("Blue"), 10);
    scores.insert(String::from("Yellow"), 50);

    for (key, value) in &scores {
        println!("{key}: {value}");
    }
}
```

The code above will print:

```bash
Blue: 10
Yellow: 50
```

### `Hash maps and ownership`

For types that implement the `Copy` trait, like `i32`, the values are copied into the hash map. For owned values like `String`, the values will be moved and the hash map will be the owner of those values.

```rust
use std::collections::HashMap;

fn main() {
    let field_name = String::from("Favorite color");
    let field_value = String::from("Blue");

    let mut map = HashMap::new();
    map.insert(field_name, field_value);
    // field_name and field_value are invalid at this point
}
```

>**Note:** The `insert` method takes ownership of the key and value. The values will be moved into the hash map and the variables will be invalid after the call to `insert`.

### `Updating a hash map`

A `HashMap` in Rust allows you to store multiple key-value pairs. The number of these pairs can grow as needed, hence it's called a 'growable' collection. However, within this collection, each key must be unique and can only be associated with one value at any given time. If you try to insert a new value for an existing key, the old value will be replaced with the new one.

On the other hand, the values in the `HashMap` don't have to be unique. This means that multiple keys can be associated with the same value. For instance, in a `HashMap` storing scores for different teams, both "Blue" team and "Yellow" team could have a score of 10. This is what is meant by 'not vice versa'.

#### Overwriting a value

If we insert a key and a value into a hash map and then insert that same key with a different value, the value associated with that key will be replaced.

```rust
use std::collections::HashMap;

fn main() {
    let mut scores = HashMap::new();
    scores.insert(String::from("Blue"), 10);
    scores.insert(String::from("Blue"), 25);

    println!("{:?}", scores);
}
```

The code above will print:

```bash
{"Blue": 25}
```

#### Adding a Key and Value Only If a Key Isn’t Present

It’s common to check whether a particular key has a value and, if it doesn’t, to insert a value for it. Hash maps have a special API for this called `entry` that takes the key you want to check as a parameter.

```rust
use std::collections::HashMap;

fn main() {
    let mut scores = HashMap::new();
    scores.insert(String::from("Blue"), 10);

    scores.entry(String::from("Yellow")).or_insert(50);
    scores.entry(String::from("Blue")).or_insert(50);

    println!("{:?}", scores);
}
```

>**note:** The `entry` method returns an enum called `Entry` that represents a value that might or might not exist. The `or_insert` method on `Entry` is defined to return a mutable reference to the value `&mut i32` for the corresponding `Entry` key if that key exists, and if not, inserts the parameter as the new value for this key and returns a mutable reference to the new value. This technique is much cleaner than writing the logic ourselves and, in addition, plays more nicely with the borrow checker.

The code above will print:

```bash
{"Blue": 10, "Yellow": 50}
```

#### Updating a Value Based on the Old Value

Another common use case for hash maps is to update a value based on the old value. For example, counting the occurrences of words in a text.

```rust
use std::collections::HashMap;

fn main() {
    let text = "hello world wonderful world";

    let mut map = HashMap::new();

    for word in text.split_whitespace() {
        let count = map.entry(word).or_insert(0);
        *count += 1;
    }

    println!("{:?}", map);
}
```

>**note:** The `split_whitespace` method returns an iterator over sub-slices, separated by whitespace, of the value in text. The `or_insert` method returns a mutable reference `(&mut V)` to the value for the specified key. Here we store that mutable reference in the `count` variable, so in order to assign to that value, we must first `dereference` count using the asterisk (*). The mutable reference goes out of scope at the end of the for loop, so all of these changes are safe and allowed by the borrowing rules.

The code above will print:

```bash
{"hello": 1, "world": 2, "wonderful": 1}
```

### `hash map methods`

- `insert`: Adds a key-value pair to the map. If the key already exists, the value is updated.
- `get`: Returns an Option<&V>.
- `iter`: Returns an iterator over the key-value pairs in the map.
- `iter_mut`: Returns an iterator that allows modifying each value.
- `len`: Returns the number of elements in the map.
- `is_empty`: Returns true if the map contains no elements.
- `remove`: Removes a key from the map and returns its value.
- `clear`: Removes all elements from the map.
- `contains_key`: Returns true if the map contains the specified key.
- `entry`: Returns an Entry API that represents a value that might or might not exist.
- `or_insert`: Inserts a key with a default value if it doesn't exist.
- `or_insert_with`: Inserts a key with a value calculated from a function if it doesn't exist.
- `SipHasher`: The default hasher for HashMap is currently SipHasher, but this is subject to change. The SipHash algorithm is designed to be fast and secure, but it is not cryptographically secure. If you need a cryptographically secure hash function, you should use a crate like ring that provides implementations of the SHA-2 algorithm.

## Exercises

1. Given a list of integers, use a vector and return the median (when sorted, the value in the middle position) and mode (the value that occurs most often; a hash map will be helpful here) of the list.

    ```rust
    use std::collections::HashMap;

    fn main() {
        let list = vec![1, 2, 3, 4, 5, 6, 7, 8, 9];
        let mut mode_map = HashMap::new();
        let mut mode = 0;

        for &number in &list {
            let count = mode_map.entry(number).or_insert(0);
            *count += 1;
            if *count > mode {
                mode = *count;
            }
        }

        let median = list[list.len() / 2];
        let mut mode_value = 0;

        for (key, value) in &mode_map {
            if *value == mode {
                mode_value = *key;
            }
        }

        println!("The median is: {median}");
        println!("The mode is: {mode_value}");
    }
    ```

1. Convert strings to pig latin. The first consonant of each word is moved to the end of the word and “ay” is added, so “first” becomes “irst-fay.” Words that start with a vowel have “hay” added to the end instead (“apple” becomes “apple-hay”). Keep in mind the details about UTF-8 encoding!

    ```rust
    fn main() {
        let words: Vec<&str> = vec!["first", "apple", "hello", "world"];
        let vowels: Vec<char> = vec!['a', 'e', 'i', 'o', 'u'];

        let mut new_words: Vec<String> = Vec::new();

        for word in words {
            let first_char: char = word.chars().next().unwrap();
            if vowels.contains(&first_char) {
                new_words.push(format!("{}-hay", word));
            } else {
                new_words.push(format!("{}-{}ay", &word[1..], first_char));
            }
        }

        println!("{:?}", new_words);
    }
    ```

    But I do it this way

    ```rust
    fn main() {
        let vowel_bytes: Vec<u8> = vec![97, 101, 105, 111, 117];
        let word: String = String::from("apple");
        let word: String = word.to_lowercase();
        let letter: &u8 = &word[0..1].as_bytes()[0];

        if vowel_bytes.contains(letter) {
            let ans:String = format!("{}-{}", word, "hay");
            println!("{ans}")
        } else {
            let body_word: &str = &word[1..];
            let letter: char = *letter as char;
            let ans: String = format!("{}-{}{}", body_word, letter, "ay");
            println!("{ans}")
        }
    }
    ```

1. Using a hash map and vectors, create a text interface to allow a user to add employee names to a department in a company. For example, “Add Sally to Engineering” or “Add Amir to Sales.” Then let the user retrieve a list of all people in a department or all people in the company by department, sorted alphabetically.

    ```rust
    use std::{
    collections::HashMap,
    io::{self, Write},
    };

    fn main() {
        println!("\nemployee registration\n");
    
        let mut employee_department: HashMap<String, Vec<String>> = HashMap::new();
    
        loop {
            println!("Menu Options");
            println!("1. Add a new employee to a department");
            println!("2. Read all employees from a department");
            println!("3. Exit\n");
    
            let mut option: String = String::new();
            print!("Please choose an option: ");
            io::stdout().flush().unwrap();
            io::stdin()
                .read_line(&mut option)
                .expect("Failed to readline");
    
            match option.trim().parse() {
                Ok(1) => add_employee(&mut employee_department),
                Ok(2) => read_employees(&employee_department),
                Ok(3) => break,
                _ => continue,
            };
        }
    }
    
    fn add_employee(employee_department: &mut HashMap<String, Vec<String>>) {
        let mut department: String = String::new();
        print!("\nEnter the department name: ");
        io::stdout().flush().unwrap();
        io::stdin()
            .read_line(&mut department)
            .expect("Failed to read line");
    
        let mut employee: String = String::new();
        print!("Enter the employee name: ");
        io::stdout().flush().unwrap();
        io::stdin()
            .read_line(&mut employee)
            .expect("Failed to read line");
    
        let employee = employee.trim().to_string();
        let department = department.trim().to_string();
    
        let employee_vector: &mut Vec<String> =
            employee_department.entry(department).or_insert(Vec::new());
        employee_vector.push(employee);
    
        println!("Employee added succesfully\n");
    }
    
    fn read_employees(employee_department: &HashMap<String, Vec<String>>) {
        println!("\nType one of the next departments: \n");
    
        for (k, _) in employee_department {
            println!("{k}");
        }
    
        let mut department: String = String::new();
        print!("\nEnter the department name: ");
        io::stdout().flush().unwrap();
        io::stdin()
            .read_line(&mut department)
            .expect("Failed to readline");
    
        let department = department.trim().to_string();
        let employees = employee_department.get(&department);
    
        match employees {
            Some(e) => println!("\n{:?}\n", e),
            None => println!("Sorry we were not able to find that department.\n"),
        }
    }
    ```
