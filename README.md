# Collabo iOS App

## Overview
Collabo is a project management application designed for iOS devices. It seamlessly integrates with Asana, allowing users to manage their projects and tasks effectively. With a user-friendly interface, Collabo simplifies project management tasks, offering features for both fetching existing projects and tasks from Asana and creating new ones within the app.

## Features
- **Integration with Asana:** Collabo fetches projects and tasks from Asana, ensuring seamless synchronization with the user's existing workflow.
- **User Authentication:** The app utilizes Auth0 SDK for user authentication, ensuring secure access to Collabo's features.
- **MVVM Architecture:** Collabo is structured using the Model-View-ViewModel (MVVM) architecture, enhancing maintainability and scalability.
- **Frameworks:** The app utilizes both UIKit and SwiftUI frameworks, leveraging their respective strengths for different components of the app.
- **SwiftUI Onboarding:** The onboarding and user authentication flow is implemented using SwiftUI, offering a modern and intuitive user experience.
- **Custom Network Manager:** Collabo utilizes a custom network manager class, AsanaManager, written with async-await functionality for efficient API calls to Asana.

## Usage
To access Collabo, use the following credentials:
- **Email:** Rando@gmail.com
- **Password:** Karenina123

## File Structure
- **SwiftUIViews:** Contains SwiftUI views for various components of the app.
- **ViewControllers:** Houses view controllers for UIKit components and views.
- **Models:** Contains data models used throughout the application.
- **SwiftUI Components:** Custom SwiftUI components utilized within the app.
- **UIKit Components:** Custom components and views built using UIKit.

## Note
Please ensure that you have an active internet connection to utilize Collabo's features, especially for syncing with Asana projects and tasks.

Thank you for choosing Collabo for your project management needs! If you encounter any issues or have suggestions for
improvements, feel free to reach out to us. Happy collaborating! 🚀
