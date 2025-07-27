[![ru](https://img.shields.io/badge/lang-ru-blue)](https://github.com/this-xkit/Flowvy/blob/main/README.md)
[![en](https://img.shields.io/badge/lang-en-red)](https://github.com/this-xkit/Flowvy/blob/main/README.en.md)

# Flowvy

<p align="center">
  <img src="https://github.com/this-xkit/Flowvy/blob/main/assets/images/icon.png" alt="Логотип Flowvy" width="100">
</p>

<p align="center">
  <strong>Современный кроссплатформенный клиент для Clash.</strong>
  <br>
  С акцентом на улучшенный пользовательский опыт и интеграцию с современными панелями управления, такими как <a href="https://github.com/remnawave/panel">Remnawave</a>.
</p>

<p align="center">
  <img src="https://github.com/this-xkit/Flowvy/blob/main/assets/images/screenshot_2.png" alt="Скриншот Flowvy" width="800">
</p>

## О проекте

**Flowvy** — это сильно модифицированная версия проекта с открытым исходным кодом [FlClash](https://github.com/chen08209/FlClash), ориентированная на улучшение пользовательского опыта и добавление уникального функционала для продвинутых пользователей.

---

## ✨ Возможности

* **Расширенная интеграция с панелями:** Встроенная поддержка **HWID** для панелей управления (например, Remnawave).
* **Динамические уведомления:** Получение важных сообщений от провайдера (например, об окончании подписки или лимите устройств) прямо в интерфейсе приложения.
* **Умные настройки по умолчанию:** Преднастроенные параметры для быстрого запуска без лишней конфигурации.
* **Русская локализация:** Полный перевод интерфейса и установщика на русский язык.

---

## 🚀 Начало работы

Готовые сборки для всех платформ доступны на странице [**Releases**](https://github.com/this-xkit/Flowvy/releases).

---

## 🛠️ Сборка из исходников

Если вы хотите собрать проект самостоятельно, выполните следующие шаги.

### 1. Предварительные требования

Убедитесь, что у вас установлены все необходимые инструменты:

* [**Flutter SDK**](https://flutter.dev/docs/get-started/install)
* [**Go**](https://go.dev/dl/)
* [**Rust**](https://www.rust-lang.org/tools/install)
* **Git**

А также инструменты для вашей целевой платформы:

* **Для Windows:** [**Visual Studio**](https://visualstudio.microsoft.com/downloads/) с рабочей нагрузкой **"Разработка настольных приложений на C++"**, и [**Inno Setup**](https://jrsoftware.org/isinfo.php).
* **Для Android:** **Android SDK** и **Android NDK**.
* **Для Linux:** Пакеты `libayatana-appindicator3-dev` и `libkeybinder-3.0-dev`.

### 2. Клонирование репозитория

```bash
# Клонируем репозиторий
git clone https://github.com/this-xkit/Flowvy.git

# Переходим в каталог проекта
cd Flowvy

# Загружаем Clash.Meta core и другие зависимости. Не пропускайте этот шаг!
git submodule update --init --recursive
```

### 3. Установка зависимостей проекта

Перед первой сборкой нужно скачать все пакеты Dart:

```bash
flutter pub get
```

### 4. Запуск сборки

Используйте встроенный скрипт `setup.dart` для сборки под нужную платформу. Для большинства современных ПК используется архитектура `amd64`.

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

Убедитесь, что установлена переменная окружения `ANDROID_NDK`.

```bash
dart .\setup.dart android
```