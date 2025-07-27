[![ru](https://img.shields.io/badge/lang-ru-blue)](https://github.com/this-xkit/Flowvy/blob/main/README.md)
[![en](https://img.shields.io/badge/lang-en-red)](https://github.com/this-xkit/Flowvy/blob/main/README.en.md)

# Flowvy

<p align="center">
  <img src="https://github.com/this-xkit/Flowvy/blob/main/assets/images/icon.png" alt="Flowvy Logo" width="100">
</p>

<p align="center">
  <strong>Современный, мультиплатформенный клиент для Clash.</strong>
  <br>
  С акцентом на улучшенный пользовательский опыт и интеграцию с современными панелями управления, такими, как <a href="https://github.com/remnawave/panel">Remnawave</a>.
</p>

<p align="center">
  <img src="https://github.com/this-xkit/Flowvy/blob/main/assets/images/screenshot_2.png" alt="Flowvy Screenshot" width="800">
</p>

## О проекте

**Flowvy** — это глубоко модифицированный форк проекта с открытым исходным кодом [FlClash](https://github.com/chen08209/FlClash), нацеленный на улучшение пользовательского опыта и добавление уникального функционала для продвинутых пользователей.

---

## ✨ Возможности

* **Улучшенная интеграция с панелями:** Встроенная поддержка **HWID** для панелей управления (например, Remnawave).
* **Динамические анонсы:** Получайте важные сообщения от вашего провайдера (например, об окончании подписки или лимите устройств) прямо в интерфейсе приложения.
* **Продуманные дефолты:** Кастомизированные настройки "из коробки" для быстрого старта.
* **Русскоязычная локализация:** Полный перевод интерфейса и установщика.

---

## 🚀 Установка

Готовые сборки для всех платформ можно найти на странице [**Релизов**](https://github.com/this-xkit/Flowvy/releases).

---

## 🛠️ Сборка из исходников

Если вы хотите собрать проект самостоятельно, следуйте этим шагам.

### 1. Подготовка окружения

Убедитесь, что у вас установлены все необходимые инструменты:

* [**Flutter SDK**](https://flutter.dev/docs/get-started/install)
* [**Go**](https://go.dev/dl/)
* [**Rust**](https://www.rust-lang.org/tools/install)
* **Git**

А также инструменты для вашей целевой платформы:
* **Для Windows:** [**Visual Studio**](https://visualstudio.microsoft.com/downloads/) с рабочей нагрузкой **"Desktop development with C++"** и [**Inno Setup**](https://jrsoftware.org/isinfo.php).
* **Для Android:** **Android SDK** и **Android NDK**.
* **Для Linux:** `libayatana-appindicator3-dev` и `libkeybinder-3.0-dev`.

### 2. Клонирование репозитория

```bash
# Клонируем репозиторий
git clone https://github.com/this-xkit/Flowvy.git

# Переходим в папку проекта
cd Flowvy

# Скачиваем ядро Clash.Meta и другие зависимости. Не пропускайте этот шаг!
git submodule update --init --recursive
````

### 3\. Установка зависимостей проекта

Перед первой сборкой необходимо скачать все Dart-пакеты:

```bash
flutter pub get
```

### 4\. Запуск сборки

Для сборки под конкретную платформу используйте встроенный скрипт `setup.dart`. В большинстве случаев для современных ПК вам нужна архитектура `amd64`.

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

Убедитесь, что настроена переменная окружения `ANDROID_NDK`.

```bash
dart .\setup.dart android
```
