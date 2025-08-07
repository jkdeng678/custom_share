/// Implements the custom_share plugin using Flutter's [MethodChannel] for
/// platform-specific communication.
///
/// This class provides the concrete implementation of [CustomSharePlatform],
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
  final methodChannel = const MethodChannel('custom_share');

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
  /// final result = await MethodChannelCustomShare().shareText(text: 'Hello!');
  /// print(result); // Prints 'success' or 'Error sharing text: ...'
  /// ```
  /// Throws a [PlatformException] if the native platform share operation fails.
  @override
  Future<String> shareText({required String text}) async {
    try {
      return await methodChannel.invokeMethod('shareText', {'text': text}) ??
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
  /// final result = await MethodChannelCustomShare().shareFiles(
  ///   filePaths: ['path/to/image.png'],
  ///   text: 'My photo',
  /// );
  /// print(result); // Prints 'success' or 'Error sharing files: ...'
  /// ```
  /// Throws a [PlatformException] if the native platform share operation fails.
  @override
  Future<String> shareFiles({
    required List<String> filePaths,
    String? text,
    String mimeType = '*/*',
  }) async {
    try {
      return await methodChannel.invokeMethod('shareFiles', {
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
