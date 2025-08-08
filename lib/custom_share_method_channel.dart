/// Implements the custom_share plugin using Flutter's [MethodChannel] for
/// platform-specific communication.
///
/// This file provides the concrete implementation of [CustomSharePlatform],
/// enabling text and file sharing on Android and iOS via native platform
/// share dialogs.
library;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'custom_share_platform_interface.dart';

/// A platform-specific implementation of [CustomSharePlatform] using [MethodChannel].
class MethodChannelCustomShare extends CustomSharePlatform {
  /// The method channel used to communicate with native platform code.
  ///
  /// This field is marked with [@visibleForTesting] to allow testing overrides.
  @visibleForTesting
  static const MethodChannel methodChannel = MethodChannel('custom_share');

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
  /// final result = await MethodChannelCustomShare.shareText(text: 'Hello!');
  /// print(result); // Prints 'success' or 'Error sharing text: ...'
  /// ```
  /// Throws a [PlatformException] if the native platform share operation fails.
  static Future<String> shareText({required String text}) async {
    try {
      return await methodChannel.invokeMethod('shareText', {'text': text}) ?? 'success';
    } catch (e) {
      return 'Error sharing text: $e';
    }
  }

  /// Shares a single file to social media or system share UI.
  ///
  /// [filePath] is the path to the file to share (required).
  /// [mimeType] specifies the MIME type of the file (e.g., 'image/png').
  ///
  /// Returns a [Future] that completes with a string indicating the result:
  /// 'success' if the share operation was successful, or an error message
  /// if it failed.
  ///
  /// Example:
  /// ```dart
  /// final result = await MethodChannelCustomShare.shareFile(
  ///   filePath: 'path/to/image.png',
  ///   mimeType: 'image/png',
  /// );
  /// print(result); // Prints 'success' or 'Error sharing file: ...'
  /// ```
  /// Throws a [PlatformException] if the native platform share operation fails.
  static Future<String> shareFile({required String filePath, required String mimeType}) async {
    try {
      return await methodChannel.invokeMethod('shareFile', {
        'filePath': filePath,
        'mimeType': mimeType,
      }) ?? 'success';
    } catch (e) {
      return 'Error sharing file: $e';
    }
  }
}