# Firebase CLI Commands Documentation

Welcome to the Firebase CLI Commands Documentation! This guide will help you navigate through the most common Firebase CLI commands and provide a quick reference for interacting with Firebase services like Hosting, Firestore, Functions, and more.

---

## Index

1. [firebase init](#firebase-init)
2. [firebase init emulator](#firebase-init-emulator)
3. [firebase deploy](#firebase-deploy)
4. [firebase serve](#firebase-serve)
5. [firebase login](#firebase-login)
6. [firebase logout](#firebase-logout)
7. [firebase use](#firebase-use)
8. [firebase functions:log](#firebase-functionslog)
9. [firebase hosting:channel:deploy](#firebase-hostingchanneldeploy)
10. [firebase database:get](#firebase-databaseget)
11. [firebase firestore:indexes](#firebase-firestoreindexes)
12. [firebase emulators:start](#firebase-emulatorsstart)
13. [firebase firestore:export](#firebase-firestoreexport)
14. [firebase functions:shell](#firebase-functionsshell)

---

## Command Descriptions

### 1. **`firebase init`**
   - **Purpose:** Initializes a Firebase project in your local directory.
   - **Usage:**
     ```bash
     firebase init
     ```
   - **Description:** This command helps set up Firebase services (Firestore, Functions, Hosting, etc.) for your project. It creates the necessary configuration files and folders for your Firebase project in the current directory.

### 2. **`firebase init emulator`**
   - **Purpose:** Initializes Firebase Emulators for local development.
   - **Usage:**
     ```bash
     firebase init emulators
     ```
   - **Description:** This command helps you set up Firebase emulators for services such as Firestore, Functions, Realtime Database, and Hosting, allowing you to run Firebase locally.

### 3. **`firebase deploy`**
   - **Purpose:** Deploys your Firebase project to the cloud.
   - **Usage:**
     ```bash
     firebase deploy
     ```
   - **Description:** This command uploads your code and configurations (for Hosting, Functions, Firestore, etc.) to Firebase, making them live on the web.

### 4. **`firebase serve`**
   - **Purpose:** Starts a local Firebase server to serve your Firebase project (similar to the `firebase hosting:serve` command).
   - **Usage:**
     ```bash
     firebase serve
     ```
   - **Description:** This command allows you to test your Firebase Hosting locally before deploying. You can also emulate other services like Firestore and Functions locally.

### 5. **`firebase login`**
   - **Purpose:** Logs into Firebase with your Google account.
   - **Usage:**
     ```bash
     firebase login
     ```
   - **Description:** Logs into Firebase with your Google account credentials. It’s required for accessing Firebase projects and deploying them.

### 6. **`firebase logout`**
   - **Purpose:** Logs out from Firebase CLI.
   - **Usage:**
     ```bash
     firebase logout
     ```
   - **Description:** Logs you out from Firebase on the command line.

### 7. **`firebase use`**
   - **Purpose:** Selects the Firebase project to use.
   - **Usage:**
     ```bash
     firebase use --add
     ```
   - **Description:** This command allows you to select which Firebase project to use in your current directory. You can also use `firebase use <projectId>` to specify a project manually.

### 8. **`firebase functions:log`**
   - **Purpose:** View logs for Firebase Functions.
   - **Usage:**
     ```bash
     firebase functions:log
     ```
   - **Description:** This command outputs the logs for Firebase Functions, allowing you to monitor your function's execution.

### 9. **`firebase hosting:channel:deploy`**
   - **Purpose:** Deploys your site to a preview channel.
   - **Usage:**
     ```bash
     firebase hosting:channel:deploy <channelId>
     ```
   - **Description:** This command helps deploy your Firebase Hosting site to a preview channel, useful for staging or testing.

### 10. **`firebase database:get`**
   - **Purpose:** Retrieves data from the Firebase Realtime Database.
   - **Usage:**
     ```bash
     firebase database:get /path/to/data
     ```
   - **Description:** This command fetches data from your Firebase Realtime Database. It can be used to back up data or inspect it from the command line.

### 11. **`firebase firestore:indexes`**
   - **Purpose:** Manages Firestore indexes.
   - **Usage:**
     ```bash
     firebase firestore:indexes
     ```
   - **Description:** Lists, creates, or deletes Firestore indexes directly from the Firebase CLI.

### 12. **`firebase emulators:start`**
   - **Purpose:** Starts Firebase emulators for local testing.
   - **Usage:**
     ```bash
     firebase emulators:start
     ```
   - **Description:** Starts all the Firebase emulators that you have initialized, such as Firestore, Functions, Realtime Database, etc., for local testing.

### 13. **`firebase firestore:export`**
   - **Purpose:** Exports Firestore data to a Cloud Storage bucket.
   - **Usage:**
     ```bash
     firebase firestore:export gs://<bucketName>
     ```
   - **Description:** Exports Firestore data to a specified Google Cloud Storage bucket for backup or migration purposes.

### 14. **`firebase functions:shell`**
   - **Purpose:** Starts the Firebase Functions emulator shell.
   - **Usage:**
     ```bash
     firebase functions:shell
     ```
   - **Description:** Starts a local emulator shell for testing Firebase Functions locally before deployment.

