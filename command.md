# 🦀 Rust commands

## 📦 Cargo Comands

Rust uses `cargo`, the Rust package manager, for many of its operations. Here are some common `cargo` commands:

### 🏗️ Project Creation

- `cargo new <project-name>`: 🆕 Creates a new Rust project with the specified name.
- `cargo new <project-name> --vcs none`: 🆕 Creates a new Rust project without initializing a git repository.
- `cargo new <lib-name> --lib`: 📚 Creates a new Rust library.

### 🏃‍♂️ Building and Running

- `cargo build`: 🔨 Compiles the current project.
- `cargo run`: ▶️ Compiles and runs the current project.
- `cargo run > output.txt`: 📝 Compiles and runs the current project, saving the output to a text file.
- `cargo run -p <package-name>`: ▶️ Compiles and runs a specific package in a workspace.
- `cargo check`: ✅ Checks the current project for errors without producing an executable.
- `cargo build --release`: 🚀 Compiles the current project with optimizations for release.

### 📦 Dependency Management

- `cargo update`: 🔄 Updates the project's dependencies.

### 📚 Documentation

- `cargo doc --open`: 🌐 Builds documentation for the current project and opens it in a web browser.

### 🚀 Installing Binaries

- `cargo install <package-name>`: 📦 Installs a binary from the registry.

### 🧪 Testing

- `cargo test`: ✔️ Runs all tests in parallel.
- `cargo test -p <package-name>`: ✔️ Runs all tests in a specific package.
- `cargo test -- --test-threads=1`: 🧵 Runs all tests consecutively.
- `cargo test -- --show-output`: 🖥️ Runs all tests and shows output of successful tests.
- `cargo test <test-name>`: 🔍 Runs a specific test by name.
- `cargo test -- --ignored`: 🚫 Runs all tests that are marked as ignored.
- `cargo test -- --include-ignored`: 🚫✔️ Runs all tests, whether they are ignored or not.
- `cargo test --test <integration-name>`: 🧩 Runs tests in a specific integration.
- `cargo test -- --nocapture`: 📝 Runs your tests and displays the output from all tests.

### 📦 Publishing

- `cargo publish`: 📦 Publishes a package to the registry.

### 🧹 Yank

- `cargo yank --vers <version> --undo`: 🧹 Unyanks a version of a package.
- `cargo yank --vers <version>`: 🧹 Yanks a version of a package.

## 👀 Cargo Watch Commands

`cargo watch` is a utility that watches for changes in your Rust project and runs a command when changes are detected. Here are some common `cargo watch` commands:

### 🏃‍♂️ Running

- `cargo watch -x run`: ▶️ Watches your project and runs your application every time a change is detected.

### 🧪 Testing Watch

- `cargo watch -x test`: ✔️ Watches your project and runs your tests every time a change is detected.

### 🏗️ Building

- `cargo watch -x build`: 🔨 Watches your project and builds your application every time a change is detected.

### ✅ Checking

- `cargo watch -x check`: ✅ Watches your project and checks your code for errors (without compiling it) every time a change is detected.

### 📝 Custom Commands

- `cargo watch -s "command"`: 📝 Watches your project and runs the specified command every time a change is detected. Replace `"command"` with the command you want to run.

Remember to install `cargo-watch` with `cargo install cargo-watch` if you haven't done so already.
