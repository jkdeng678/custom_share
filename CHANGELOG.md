# Changelog

## 1.0.8
- dart format .

## 1.0.7
- Renamed shareFiles to shareFile, changed filePaths to filePath (single file), removed text parameter, and added automatic MIME type detection using path: ^1.9.1 and mime: ^2.0.0.
- Made CustomShare methods static for direct calls (e.g., CustomShare.shareFile).

## 1.0.6
- Fixed formatting issues in `lib/custom_share.dart`, `lib/custom_share_method_channel.dart`, and other files using `dart format`.
- Resolved static analysis issues for code health.

## 1.0.5
- Fixed `deprecated_member_use` in `test/custom_share_method_channel_test.dart` by updating to `TestDefaultBinaryMessengerBinding`.
- Added DartDoc comments to tests for improved documentation.

## 1.0.4
- Fixed `dangling_library_doc_comments` in `example/lib/main.dart` by removing library-level comment.
- Preserved DartDoc comments on classes and methods in example app.

## 1.0.3
- Fixed `use_build_context_synchronously` in `example/lib/main.dart` by adding `mounted` checks.
- Added DartDoc comments to `example/lib/main.dart` for improved documentation.
- Fixed `unnecessary_library_name` in `lib/` files.
- Updated deprecated `setMockMethodCallHandler` in tests to use `TestDefaultBinaryMessengerBinding`.

## 1.0.1
- Added DartDoc comments to all public APIs for improved documentation.
- Enabled `public_member_api_docs` lint to ensure API documentation coverage.

## 1.0.0
- Initial release of `custom_share`.
- Supports sharing text and URLs on Android and iOS.
- Includes example app in the `example/` folder.

## 0.0.1
- Initial release.
- Supports text and file sharing on Android, iOS, macOS, Windows, Linux, and (No Web support).