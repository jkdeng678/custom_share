/// A Flutter plugin for sharing content to social media and system share UI
/// on Android and iOS platforms.
///
/// This library provides a simple interface to share text and files using
/// native platform share dialogs, such as [ACTION_SEND] on Android and
/// [UIActivityViewController] on iOS.
///
/// Example:
/// ```dart
/// import 'package:custom_share/custom_share.dart';
///
/// void main() async {
///   final result = await CustomShare().shareText(text: 'Hello, world!');
///   print(result);
/// }
library;

import 'dart:async';
import 'package:flutter/services.dart';

/// A class that provides methods to share content on Android and iOS.
///
/// Use this class to share text or files to social media apps or the system
/// share UI. All methods are asynchronous and interact with native platform
/// code via a [MethodChannel].
class CustomShare {
  static const MethodChannel _channel = MethodChannel('custom_share');

  /// Shares a text message to social media or system share UI.
  ///
  /// [text] is the main content to share (required).
  ///
  /// Returns a [Future] that completes with a string indicating the result:
  /// 'success' if the share operation was successful, or an error message
  /// if it failed.
  ///
  /// Example:
  /// ```dart
  /// final result = await CustomShare().shareText(text: 'Check out my app!');
  /// print(result); // Prints 'success' or 'Error sharing text: ...'
  /// ```
  /// Throws a [PlatformException] if the native platform share operation fails.
  Future<String> shareText({required String text}) async {
    try {
      return await _channel.invokeMethod('shareText', {'text': text}) ??
          'success';
    } catch (e) {
      return 'Error sharing text: $e';
    }
  }

  /// Shares one or more files to social media or system share UI.
  ///
  /// [filePaths] is a list of file paths to share (required).
  /// [text] is an optional accompanying message.
  /// [mimeType] specifies the MIME type of the files (defaults to '*/*').
  ///
  /// Returns a [Future] that completes with a string indicating the result:
  /// 'success' if the share operation was successful, or an error message
  /// if it failed.
  ///
  /// Example:
  /// ```dart
  /// final result = await CustomShare().shareFiles(
  ///   filePaths: ['path/to/image.png'],
  ///   text: 'My photo',
  ///   mimeType: 'image/png',
  /// );
  /// print(result); // Prints 'success' or 'Error sharing files: ...'
  /// ```
  /// Throws a [PlatformException] if the native platform share operation fails.
  Future<String> shareFiles({
    required List<String> filePaths,
    String? text,
    String mimeType = '*/*',
  }) async {
    try {
      return await _channel.invokeMethod('shareFiles', {
            'filePaths': filePaths,
            'text': text,
            'mimeType': mimeType,
          }) ??
          'success';
    } catch (e) {
      return 'Error sharing files: $e';
    }
  }
}
