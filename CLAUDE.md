# Coding guide

## Rules that must be followed

### Applying the formatter

After modifying code, always apply the formatter.

The execution command is as follows.

```bash
dart format path/to/your/file.dart
```

### Applying Linter automatic fixes

After modifying code, always apply Linter automatic fixes.

The execution command is as follows.

```bash
dart fix --apply
```

### Resolving Linter warnings

After modifying code, always check for Linter and compiler warnings.
If warnings occur, resolve them.

### Check that tests are passing and make corrections

When modifying code, always run unit tests and make sure all tests pass.

### Adding unit tests

When you make code modifications, consider whether there is room to add unit tests.
If you can add unit tests, be sure to add them.

### Refactoring

When you make code modifications, consider whether there is room to refactor.
If you can refactor, be sure to refactor.

### Delete unnecessary code

If you have modified the code, check to see if any unnecessary code remains.
If any unnecessary code remains, delete it immediately.

### Appropriate use of SDK functions, etc.

When using new SDK functions that have not been used in the code base until now, check the following.

- Check the official documentation to make sure the usage is simple. If the usage is complicated, revise it to a simpler usage.

# Architecture

This project is an iOS and Android application, including front-end and back-end code.

## Client app

`client/` is where you put the code for the iOS and Android client app written in Flutter.

- [`./android/`](/client/android/): Product code and project settings for Android
- [`./ios/`](/client/ios/): Product code and project settings for iOS
- [`./lib/`](/client/lib/): Product code common to all OS
  - [`./data/`](/client/lib/data/): Information storage and retrieval, and interaction with the OS layer
  - [`./definition/`](/client/lib/data/definition/): Common definitions used for information storage and retrieval, and interaction with the OS layer
  - [`./model/`](/client/lib/data/model/): Domain model. Place pure data structures that are not dependent on the UI, and UI-independent `Exception`, `Error`, etc.
  - [`./repository/`](/client/lib/data/repository/): Repository. Defines the process of retaining and retrieving information while abstracting the specific destination.
  - [`./service/`](/client/lib/data/service/): Service. Defines the connection to the OS and Firebase.
- [`./ui/`](/client/lib/ui/): Defines screen drawing and display logic.
  - [`./component/`](/client/lib/ui/component/): Defines UI components shared between screens.
  - [`./feature/`](/client/lib/ui/feature/): Screens and screen logic. There are subfolders for each category.
- [`./test/`](/client/test/): Unit tests, widget tests

In this app, Swift Package Manager (SPM) is enabled and used in conjunction with CocoaPods.

SPM is enabled in Flutter itself with the following command:

```bash
flutter config --enable-swift-package-manager
```

Since SPM is a beta feature, problems may occur during builds, etc.

In that case, troubleshoot by investigating any reported issues in Flutter or considering the possibility of an unknown problem.

## Infrastructure

`infra/` is where you put the infrastructure configuration and back-end code.
