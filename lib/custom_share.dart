/// A Flutter plugin for sharing content to social media and system share UI
/// on Android and iOS platforms.
///
/// This file provides a simple interface to share text and a single file using
/// native platform share dialogs, such as [ACTION_SEND] on Android and
/// [UIActivityViewController] on iOS.
///
/// Example:
/// ```dart
/// import 'package:custom_share/custom_share.dart';
///
/// void main() async {
///   final result = await CustomShare.shareText(text: 'Hello, world!');
///   print(result);
///   final fileResult = await CustomShare.shareFile(filePath: 'path/to/image.png');
///   print(fileResult);
/// }
library;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mime/mime.dart';

/// A class that provides static methods to share content on Android and iOS.
///
/// Use this class to share text or a single file to social media apps or the system
/// share UI. All methods are static and asynchronous, interacting with native platform
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
  /// final result = await CustomShare.shareText(text: 'Check out my app!');
  /// print(result); // Prints 'success' or 'Error sharing text: ...'
  /// ```
  /// Throws a [PlatformException] if the native platform share operation fails.
  static Future<String> shareText({required String text}) async {
    try {
      return await _channel.invokeMethod('shareText', {'text': text}) ??
          'success';
    } catch (e) {
      return 'Error sharing text: $e';
    }
  }

  /// Shares a single file to social media or system share UI.
  ///
  /// [filePath] is the path to the file to share (required).
  ///
  /// The MIME type is automatically detected using the file extension.
  /// Falls back to '*/*' if the MIME type cannot be determined.
  ///
  /// Returns a [Future] that completes with a string indicating the result:
  /// 'success' if the share operation was successful, or an error message
  /// if it failed.
  ///
  /// Example:
  /// ```dart
  /// final result = await CustomShare.shareFile(filePath: 'path/to/image.png');
  /// print(result); // Prints 'success' or 'Error sharing file: ...'
  /// ```
  /// Throws a [PlatformException] if the native platform share operation fails.
  static Future<String> shareFile({required String filePath}) async {
    try {
      final mimeType = _getMimeType(filePath);
      return await _channel.invokeMethod('shareFile', {
            'filePath': filePath,
            'mimeType': mimeType,
          }) ??
          'success';
    } catch (e) {
      return 'Error sharing file: $e';
    }
  }

  /// Determines the MIME type based on the file extension.
  ///
  /// [filePath] is the path to the file.
  ///
  /// Returns a MIME type string (e.g., 'image/png') or '*/*' if unknown.
  static String _getMimeType(String filePath) {
    return lookupMimeType(filePath) ?? '*/*';
  }
}
