[![ru](https://img.shields.io/badge/lang-ru-blue)](https://github.com/this-xkit/Flowvy/blob/main/README.md)
[![en](https://img.shields.io/badge/lang-en-red)](https://github.com/this-xkit/Flowvy/blob/main/README.en.md)

# Flowvy

<p align="center">
  <img src="https://github.com/this-xkit/Flowvy/blob/main/assets/images/icon.png" alt="Flowvy Logo" width="150">
</p>

<p align="center">
  <strong>A modern, cross-platform client for Clash.</strong>
  <br>
  With a focus on improved user experience and integration with modern control panels like <a href="https://github.com/remnawave/panel">Remnawave</a>.
</p>

<p align="center">
  <img src="https://github.com/this-xkit/Flowvy/blob/main/assets/images/screenshot_2.png" alt="Flowvy Screenshot" width="800">
</p>

## About The Project

**Flowvy** is a heavily modified fork of the open-source project [FlClash](https://github.com/chen08209/FlClash), aimed at improving the user experience and adding unique functionality for advanced users.

---

## ✨ Features

* **Enhanced Panel Integration:** Built-in **HWID** support for control panels (e.g., Remnawave).
* **Dynamic Announcements:** Receive important messages from your provider (e.g., about subscription expiration or device limits) directly in the application's UI.
* **Smart Defaults:** Customized out-of-the-box settings for a quick start.
* **Russian Localization:** Full translation of the interface and installer.

---

## 🚀 Getting Started

Pre-built binaries for all platforms can be found on the [**Releases**](https://github.com/this-xkit/Flowvy/releases) page.

---

## 🛠️ Building From Source

If you want to build the project yourself, follow these steps.

### 1. Prerequisites

Ensure you have all the necessary tools installed:

* [**Flutter SDK**](https://flutter.dev/docs/get-started/install)
* [**Go**](https://go.dev/dl/)
* [**Rust**](https://www.rust-lang.org/tools/install)
* **Git**

As well as the tools for your target platform:
* **For Windows:** [**Visual Studio**](https://visualstudio.microsoft.com/downloads/) with the **"Desktop development with C++"** workload and [**Inno Setup**](https://jrsoftware.org/isinfo.php).
* **For Android:** **Android SDK** and **Android NDK**.
* **For Linux:** `libayatana-appindicator3-dev` and `libkeybinder-3.0-dev`.

### 2. Cloning the Repository

```bash
# Clone the repository
git clone https://github.com/this-xkit/Flowvy.git

# Navigate to the project directory
cd Flowvy

# Download the Clash.Meta core and other dependencies. Do not skip this step!
git submodule update --init --recursive
````

### 3\. Install Project Dependencies

Before the first build, you need to fetch all Dart packages:

```bash
flutter pub get
```

### 4\. Running the Build

Use the built-in `setup.dart` script to build for a specific platform. For most modern PCs, you will need the `amd64` architecture.

#### Windows

```bash
dart .\setup.dart windows --arch <arm64 | amd64>
```

#### Linux

```bash
dart .\setup.dart linux --arch <arm64 | amd64>
```

#### macOS

```bash
dart .\setup.dart macos --arch <arm64 | amd64>
```

#### Android

Ensure the `ANDROID_NDK` environment variable is set.

```bash
dart .\setup.dart android
```
