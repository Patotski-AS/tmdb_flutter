# tmdb_flutter

Клиент TMDB на Flutter, перенос приложения tmdb_kmp. В этой ветке только
каркас: тема, маршруты-заглушки, HTTP-клиент и хранилище сессии.

Нужен Flutter 3.47 или новее (Dart 3.13).

Запросы к API идут с заголовком `Authorization: Bearer`. Это ключ доступа
API v4, не параметр `api_key`. Настоящий ключ в репозиторий не попадает.

## Запуск

1. Скопируйте пример конфигурации:

```powershell
copy config\dart_defines.json.example config\dart_defines.json
```

2. В `config/dart_defines.json` замените `your_access_token_here` на ключ
   доступа API v4 со страницы
   <https://www.themoviedb.org/settings/api>.

3. Запустите приложение:

```powershell
flutter run --dart-define-from-file=config/dart_defines.json
```

В Android Studio конфигурация запуска `main.dart` уже передаёт этот аргумент. Рядом с ней выберите устройство и нажмите Run. Flutter SDK для сборки — `C:\Users\user\flutter-3.47.7`, Android SDK — `X:\AppData\Local\Android\Sdk`. Оба пути записаны в `android/local.properties`.

Пустой ключ и плейсхолдер `your_access_token_here` считаются незаданным
ключом. Приложение покажет экран с этой инструкцией и не упадёт.
