# Collabo iOS App

## Overview
Collabo is a project management application designed for iOS devices. It seamlessly integrates with Asana, allowing users to manage their projects and tasks effectively. With a user-friendly interface, Collabo simplifies project management tasks, offering features for both fetching existing projects and tasks from Asana and creating new ones within the app. Additionally, Collabo now includes personal Todo lists and a Timer feature, enhancing its functionality for individual users.

## Features
- **Integration with Asana:** Collabo fetches projects and tasks from Asana, ensuring seamless synchronization with the user's existing workflow.
- **User Authentication:** The app utilizes Auth0 SDK for user authentication, ensuring secure access to Collabo's features.
- **MVVM Architecture:** Collabo is structured using the Model-View-ViewModel (MVVM) architecture, enhancing maintainability and scalability.
- **Frameworks:** The app utilizes both UIKit and SwiftUI frameworks, leveraging their respective strengths for different components of the app.
- **SwiftUI Onboarding:** The onboarding and user authentication flow is implemented using SwiftUI, offering a modern and intuitive user experience.
- **Custom Network Manager:** Collabo utilizes a custom network manager class, AsanaManager, written with async-await functionality for efficient API calls to Asana.
- **Personal Todo Lists:** Users can now create and manage personal Todo lists within the app, enabling them to organize tasks beyond their Asana projects.
- **Timer Feature:** Collabo includes a Timer feature, allowing users to track time spent on tasks and projects directly within the app.

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

## Screenshots
<img src="https://github.com/Tparuna1/Collabo-iOS-App/assets/145837277/b2c66808-5d0f-4104-bcc0-a7dc6f7f42d5" width="200" />
<img src="https://github.com/Tparuna1/Collabo-iOS-App/assets/145837277/2b45c181-cbfd-42c6-98fd-c9a26f18fcf0" width="200" />
<img src="https://github.com/Tparuna1/Collabo-iOS-App/assets/145837277/76cd933a-04e0-4a3f-b177-da42ada2b2dd" width="200" />
<img src="https://github.com/Tparuna1/Collabo-iOS-App/assets/145837277/9571aeb6-6f96-40e0-9d62-055e311da0f0" width="200"/>

## Note
Please ensure that you have an active internet connection to utilize Collabo's features, especially for syncing with Asana projects and tasks.

Thank you for choosing Collabo for your project management needs! If you encounter any issues or have suggestions for improvements, feel free to reach out to us. Happy collaborating! 🚀
