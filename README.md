# 🍪 Cookie Empire: Real-Time Home Widget Interacted Flutter App

**Cookie Empire** is a modern take on the classic incremental clicker game, enhanced with a real-time **home widget** that lets players collect cookies directly from their home screen without opening the app. This feature is powered by **Flutter** and integrates native widgets on both **Android** and **iOS** for seamless user engagement.

---

## 🎮 Features

- **Real-Time Home Widget**:  
  Collect cookies directly from your home screen. The widget updates in real time, reflecting the current progress of the game, even when the app is closed.

- **Progressive Gameplay**:  
  Unlock various automated cookie-generating buildings (from **Grandmas** to **Temples**) and scale your empire by buying upgrades to increase your cookies per tap.

- **Persistent Game State**:  
  Your progress is automatically saved in local storage, so you can pick up right where you left off, across sessions.

- **Modern UI/UX**:  
  Designed with **Material 3** principles, the app provides an intuitive, visually appealing experience with smooth animations and a dark theme.

- **Cross-Platform Widget Support**:  
  The home widget is supported on both **Android** and **iOS** devices, ensuring a consistent experience across platforms.

---

## 🔧 Tech Stack

- **Flutter**:  
  The core app is built using **Flutter**, ensuring cross-platform support and smooth performance across both **Android** and **iOS**.

- **Android (Kotlin)**:
    - The home widget is integrated using **Kotlin** with Android's **App Widget API**.
    - **SharedPreferences** is used for storing the player’s cookie count and progress.

- **iOS (Swift)**:
    - The iOS widget is built using **WidgetKit** to manage real-time updates and display game data.
    - **UserDefaults** is used for storing player progress and syncing the widget with the app.

- **Real-Time Sync**:  
  The widget updates in real-time to ensure that players can collect cookies directly from the home screen while keeping the progress in sync with the main game.

---

## 🛠️ Setup Instructions

### 1. **Clone the Repository**

```bash
git clone https://github.com/jayawardhanadskp/CookieEmpire.git

