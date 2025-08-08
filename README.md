# Custom Share

A Flutter plugin for sharing text and files via **NATIVE SHARE UI**, supporting Android , iOS, macOS, Windows, Linux.

## Features
- Share text, URLs, and files to popular social media apps.
- Use NATIVE SHARE UI.
- Easy-to-use API for developers.

## Installation
Add the following to your `pubspec.yaml`:
```yaml
dependencies:
  custom_share: ^1.0.8
```

Run:
```bash
flutter pub get
```

## Usage
```dart
import 'package:custom_share/custom_share.dart';

// Share text
final result = await CustomShare.shareText(text: 'Hello from Custom Share!');
print('Share result: $result');

// Share a file
final filePath = '/path/to/sample.txt';
final fileResult = await CustomShare.shareFile(
  filePath: filePath,
);
print('File share result: $fileResult');
```

## Screenshots
Below are some screenshots of the `custom_share` plugin in action:

![Android Screenshot](https://github.com/jkdeng678/custom_share/blob/main/screenshots/Android.png?raw=true)
![macOS Screenshot](https://github.com/jkdeng678/custom_share/blob/main/screenshots/macOS.png?raw=true)
![iOS Screenshot](https://github.com/jkdeng678/custom_share/blob/main/screenshots/IOS.png?raw=true)

## Example
See the `example/` folder for a sample Flutter app demonstrating the usage of this plugin.

## Issues
Please file any issues or feature requests on the [GitHub issue tracker](https://github.com/jkdeng678/custom_share/issues).

## License
BSD-3-Clause