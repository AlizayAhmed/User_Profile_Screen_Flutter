# 🌐 Week 4: API Integration and Networking

## 📡 About This Update
This update expands the original login/signup app (Week 1) to include API integration, networking, and a user profile page. The app now fetches user and task data from the public [JSONPlaceholder](https://jsonplaceholder.typicode.com/) API, parses JSON responses, and displays them in the UI with robust error handling and loading indicators.

## 🚀 New Features (Week 4)
- 🔗 **API Integration:** Fetches user and todo data from JSONPlaceholder using the `http` package.
- 🧑 **Profile Page:** Displays user details (name, email, and placeholder avatar) fetched from the API.
- 📋 **Task List:** Shows a list of todos for the user, parsed from JSON and displayed in a ListView.
- ⚠️ **Error Handling:** Displays error messages in the UI if API requests fail.
- ⏳ **Loading Indicators:** Shows a loading spinner while data is being fetched.
- 🔄 **Network State Management:** Handles loading, success, and error states for all API calls.

## 🛠️ Technologies Used (Week 4)
- **http** - For making RESTful API requests
- **JSON Parsing** - Dart's `dart:convert` for decoding API responses
- **ListView** - For displaying lists of data
- **SnackBar** - For error messages
- **CircularProgressIndicator** - For loading spinners

## 📂 Updated Project Structure
```
lib/
├── main.dart                # App entry point, navigation, and authentication
├── models/
│   ├── user_model.dart      # User model for JSON parsing
│   └── todo_model.dart      # Todo model for JSON parsing
├── screens/
│   └── user_profile_page.dart # Profile page with API integration
├── services/
│   └── api_service.dart     # Handles all API/network requests
├── widgets/
│   ├── profile_tab.dart     # Profile tab UI
│   └── tasks_tab.dart       # Tasks tab UI
```

## 🧑‍💻 How API Integration Works
- The app uses the `http` package to send GET requests to JSONPlaceholder.
- Responses are parsed from JSON into Dart models (`User`, `Todo`).
- Data is displayed in the profile and tasks screens using ListView and custom widgets.
- Errors during network requests are caught and shown to the user via SnackBar.
- A loading spinner is shown while waiting for API responses.

## 🖼️ User Profile Example
- **Name** and **email** are fetched from the API.
- **Profile picture** uses user initials or a placeholder avatar (since JSONPlaceholder does not provide images).

## 🛡️ Error Handling & Loading
- All API calls are wrapped in try/catch blocks.
- If a request fails, a user-friendly error message is shown.
- While waiting for data, a `CircularProgressIndicator` is displayed.

## 📖 Learning Outcomes (Week 4)
- Making HTTP requests in Flutter
- Parsing and displaying JSON data
- Building responsive UIs with ListView
- Implementing robust error handling
- Managing loading and error states in the UI
- Expanding an app from basic authentication to full API-driven features






