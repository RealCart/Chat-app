# Flutter Chat Application

A Flutter chat application built following **Clean Architecture** principles. This project is designed to be robust, maintainable, and scalable by clearly separating concerns and adhering to a well-organized architecture.

---

## Overview

This chat application is built using Flutter and leverages a set of powerful libraries to handle core functionalities such as user authentication, real-time messaging, image handling, and state management. By implementing Clean Architecture, the project is divided into distinct layers:

- **Presentation Layer:** Handles UI components and user interactions.
- **Domain Layer:** Contains business logic, use cases, and entity definitions.
- **Data Layer:** Manages data sources including remote APIs and local databases.

---

## Clean Architecture

The project adheres to Clean Architecture principles by separating concerns into layers:

- **Presentation:** Uses `flutter_bloc` for state management and `go_router` for navigation.
- **Domain:** Business logic is isolated from external dependencies, making the application easier to test and maintain.
- **Data:** Interacts with Firebase services (`firebase_core`, `firebase_auth`, `cloud_firestore`) and handles media using `image_picker` and `flutter_image_compress`.

This structure makes it easier to manage dependencies, scale the app, and maintain the codebase over time.

---

## Key Libraries and Their Roles

- **cupertino_icons: ^1.0.8**  
  Provides a set of icons following the iOS design language, enhancing the UI experience.

- **firebase_core: ^3.12.1**  
  Initializes and connects the Flutter app with Firebase.

- **firebase_auth: ^5.5.1**  
  Handles user authentication, including sign-in and registration flows.

- **cloud_firestore: ^5.6.5**  
  Facilitates real-time data storage and synchronization for chat messages.

- **image_picker: ^1.1.2**  
  Allows users to select images from the device gallery or camera, useful for sending photos in chat.

- **get_it: ^8.0.3**  
  Implements dependency injection to manage instances and improve code modularity.

- **dartz: ^0.10.1**  
  Provides functional programming tools, aiding in error handling and functional transformations.

- **flutter_bloc: ^9.1.0**  
  Implements the BLoC (Business Logic Component) pattern, ensuring a clear separation between UI and business logic.

- **flutter_svg: ^2.0.17**  
  Renders SVG images, enabling scalable vector graphics in the UI.

- **flutter_image_compress: ^2.4.0**  
  Optimizes images by compressing them before upload, enhancing performance.

- **go_router: ^14.8.1**  
  Manages navigation and routing throughout the application.

---

## Getting Started

### Prerequisites

- Flutter SDK installed ([Flutter Installation Guide](https://flutter.dev/docs/get-started/install))
- A Firebase project set up with Authentication and Firestore enabled.

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/flutter_chat_app.git
   cd flutter_chat_app
   ```
   
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Configure Firebase:**
  ```bash
  Follow the instructions to add your Firebase configuration files (google-services.json for Android, GoogleService-Info.plist for iOS) to the project.
  ```
4. **Run the app:**
  ```bash
  flutter run
  ```

### Features
    User Authentication: Secure sign-up and login using Firebase Authentication.
    
    Real-time Messaging: Instant messaging with Firestore for real-time updates.
    
    Image Sharing: Select and compress images before sending them in chat.
    
    Clean Architecture: Well-organized codebase with clear separation of concerns.
    
    State Management: Efficiently manage state using the BLoC pattern.
    
    Dependency Injection: Simplified dependency management with get_it.
    
    Responsive UI: Adaptive design that works on various devices.

### Project Structure
    A brief overview of the project structure:

    ```markdown
        /lib
          /data
            - models/
            - repositories/
            - firebase/
          /domain
            - entities/
            - usecases/
          /presentation
            - blocs/
            - pages/
            - widgets/
          main.dart
    ```
