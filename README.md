# Mobile Test Demo

A Flutter project demonstrating a robust and scalable mobile application architecture using Clean Architecture, BLoC for state management, and a multi-environment setup.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

-   Flutter SDK: Make sure you have the Flutter SDK installed. You can find instructions at [flutter.dev](https://flutter.dev/docs/get-started/install).
-   An editor like VS Code or Android Studio.

### Installation

1.  Clone the repo.
2.  Install dependencies:
    ```sh
    flutter pub get
    ```

### Running the Application

This project is set up with multiple flavors for different environments.

-   **To run the Development version (with mocked data):**
    ```sh
    flutter run --flavor dev -t lib/main_dev.dart
    ```
    The development version uses a mocked login. You can use the following credentials to log in:
    -   **Email**: `hoangduc.uit.dev@gmail.com`
    -   **Password**: `Password123@@`

-   **To run the Production version:**
    ```sh
    flutter run --flavor prod -t lib/main_prod.dart
    ```

## Project Structure

This project follows the principles of **Clean Architecture**, which separates the code into distinct layers. This promotes a separation of concerns, making the code easier to maintain, test, and scale.

The source code is organized into four main directories inside `lib/src`:

-   `core`: Contains shared code that can be used across all layers of the application. This includes:
    -   `di`: Dependency injection setup using `get_it`.
    -   `error`: Custom failure and exception classes.
    -   `network`: Network clients and interceptors (`Dio`).
    -   `storage`: Secure token storage.
    -   `utils`: Helper functions and utilities, including `formz` validators.
-   `domain`: This is the core business logic layer of the application. It is completely independent of any UI or data source implementation details.
    -   `entities`: Pure Dart objects that represent the core business models (e.g., `UserCredential`, `Contact`).
    -   `repositories`: Abstract contracts (interfaces) that define the operations required by the business logic (e.g., `AuthRepository`).
    -   `usecases`: Encapsulates a single business rule or operation (e.g., `LoginUseCase`).
-   `data`: This layer is responsible for implementing the repository contracts defined in the `domain` layer. It fetches data from various sources (remote API, local database, etc.).
    -   `datasources`: Concrete implementations that fetch data from a specific source (e.g., `AuthRemoteDataSource`).
    -   `models`: Data Transfer Objects (DTOs) that extend the domain entities and include logic for JSON serialization/deserialization.
    -   `repositories`: Concrete implementations of the repositories from the `domain` layer. They coordinate data from different data sources.
-   `presentation`: This is the UI layer of the application. It uses the BLoC pattern to manage the state of the UI and interact with the `domain` layer via use cases.
    -   `bloc`: Contains all the Business Logic Components (BLoCs) that manage the state for different parts of the UI (e.g., `AppBloc`, `LoginBloc`).
    -   `pages`: The main screens or pages of the application.
    -   `widgets`: Reusable UI components.
    -   `routes`: Navigation and routing setup using `go_router`.
    -   `theme`: Application-wide theme and styling.

## Environments

The project is configured to run in multiple environments. The entry points are:

-   `lib/main_dev.dart`: The entry point for the **development** environment. It uses mocked API responses via `Dio` interceptors, allowing for UI development and testing without a live backend.
-   `lib/main_prod.dart`: The entry point for the **production** environment. It connects to the live API.

## Libraries and Dependencies

Here is a list of the main libraries used in this project and their purpose.

### Dependencies

| Library                  | Version | Description                                                                                                   |
| ------------------------ | ------- | ------------------------------------------------------------------------------------------------------------- |
| **`go_router`**          | `^14.1.0` | A declarative routing package for Flutter that makes it easy to handle deep links and complex navigation.     |
| **`flutter_bloc`**       | `^8.1.4`  | A predictable state management library that helps implement the BLoC (Business Logic Component) pattern.        |
| **`equatable`**          | `^2.0.5`  | Simplifies equality comparisons. Used extensively in BLoC states and domain entities.                       |
| **`get_it`**             | `^7.6.0`  | A simple service locator for dependency injection, used to access repositories and other services.            |
| **`json_annotation`**    | `^4.9.0`  | Provides annotations for `json_serializable` to generate JSON serialization code.                           |
| **`dio`**                | `^5.4.0`  | A powerful HTTP client for Dart, which supports interceptors, FormData, request cancellation, etc.            |
| **`fpdart`**             | `^1.2.0`  | Provides functional programming constructs like `Either` and `TaskEither` for elegant error handling.       |
| **`formz`**              | `^0.8.0`  | A unified form validation library. Used here to manage the state and validation of the login form.            |
| **`provider`**           | `^6.1.5+1`| A dependency injection system used to provide repositories down the widget tree.                              |
| **`flutter_secure_storage`** | `^9.2.4` | Used for securely persisting sensitive data like authentication tokens.                                       |
| **`logger`**             | `^2.0.2`  | A small, easy-to-use, and extensible logger for Dart and Flutter.                                             |
| **`intl`**               | `^0.19.0` | Provides internationalization and localization facilities, including date/number formatting and parsing.      |

### Dev Dependencies

| Library               | Version  | Description                                                                                       |
| --------------------- | -------- | ------------------------------------------------------------------------------------------------- |
| **`build_runner`**    | `^2.4.6` | A build package for Dart that can be used to generate files (e.g., for `json_serializable`).      |
| **`json_serializable`** | `^6.8.0` | Automatically generates code for converting to and from JSON by annotating Dart classes.          |
| **`mocktail`**        | `^1.0.2` | A popular and easy-to-use mocking library for creating mock dependencies in tests.              |
| **`bloc_test`**       | `^9.1.5` | A testing library that makes it easy to test BLoCs and Cubits.                                    |
| **`flutter_lints`**   | `^3.0.1` | Recommended set of linter rules for Flutter apps, packages, and plugins to encourage good coding practices. |

## Testing

The project is set up for unit testing with a focus on testing each layer of the Clean Architecture independently.

-   **Domain Layer**: Use cases are tested by mocking the `AuthRepository`. This ensures the core business logic works as expected. See `test/src/domain/usecases/`.
-   **Presentation Layer**: BLoCs are tested using `bloc_test` and `mocktail`. Dependencies like use cases or repositories are mocked to isolate the UI logic and verify that the BLoC emits the correct states in response to events. See `test/src/presentation/bloc/`.

To run all unit and widget tests, execute the following command:

```sh
flutter test
```

## Code Generation

This project uses code generation for JSON serialization/deserialization. If you modify any of the `models` in the `data` layer, you will need to run the code generator to update the `.g.dart` files.

Execute the following command:

```sh
flutter pub run build_runner build --delete-conflicting-outputs
```
