# **Pokedex Flutter Project**

**Pokedex Flutter** is a mobile application built with Flutter to explore Pokémon using the free [PokeAPI](https://pokeapi.co/). The app allows users to search for Pokémon, view their detailed information, and browse the entire Pokémon catalog with smooth navigation and an appealing UI.

---

## **Features**

- **Pokémon Listing:** Displays a scrollable list of Pokémon with images, names, and types.  
- **Search Functionality:** Search Pokémon by name to quickly find your favorite ones.  
- **Pokémon Details:** View in-depth details of each Pokémon, including:
  - Type information
  - Base stats
  - Abilities  
- **Type Colors:** Pokémon types are displayed with color-coded backgrounds.  
- **Lazy Loading:** Fetch additional Pokémon as the user scrolls.  

## **Screenshots**
### **Home Screen (Pokémon List)**
<img src="assets/home.png" width="300" height="auto">

### **Search Screen**
<img src="assets\search.png" width="150" height="auto">

### **Pokémon Details Screen**
<img src="assets\detail.png" width="150" height="auto">


## **Getting Started**

This project is a great way to learn Flutter development while integrating API-based data. Follow the instructions below to set up and run the application:

### **Prerequisites**

Ensure you have the following installed:
- **Flutter SDK** (version 3.0 or later)
- **Dart SDK**
- An IDE like **Android Studio**, **IntelliJ IDEA**, or **VS Code**

## Installation
1. Clone the repository:
    ```bash
    git clone <repository_url>
    ```
2. Navigate to the project directory:
    ```bash
    cd pokedex_flutter
    ```
3. Install the required dependencies:
    ```bash
    flutter pub get
    ```
4. Run the app:
    ```bash
    flutter run
    ```


## **Folder Structure**
```bash
pokedex_flutter/
├── lib/
|   ├── main.dart           # Entry point of the application
|   ├── pokemonlist/        # Pokémon list module
|   └── pokemondetail/      # Pokémon detail module
├── assets/
│   └── images/             # App images and icons
└── README.md               # Project documentation
```

## **Resources**
To learn more about Flutter, explore these helpful resources:
- [Flutter Documentation](https://docs.flutter.dev/)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)

## **Contributing**
Contributions are welcome! Feel free to submit issues or pull requests to improve the functionality and code of this project.

## **About the Project**

This project serves as an excellent example of integrating a RESTful API into a Flutter application, with a strong emphasis on UI design and dynamic state management.

Happy coding with Flutter! 🚀

---