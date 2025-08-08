/// Defines the platform interface for the custom_share plugin.
///
/// This file specifies the contract for platform-specific implementations
/// of the custom_share plugin, allowing text and file sharing on Android and iOS.
/// Platform implementations (e.g., [MethodChannelCustomShare]) must override
/// the static methods [shareText] and [shareFile].
///
/// Example:
/// ```dart
/// CustomSharePlatform.instance = MethodChannelCustomShare();
/// final result = await CustomSharePlatform.shareText(text: 'Hello!');
/// ```
library;
import 'custom_share_method_channel.dart';

/// An abstract class defining the interface for sharing content on different platforms.
abstract class CustomSharePlatform {
  /// The singleton instance of the platform implementation.
  ///
  /// By default, this is set to [MethodChannelCustomShare], but it can be
  /// overridden for testing or custom implementations.
  static CustomSharePlatform instance = MethodChannelCustomShare();

  /// Shares a text message to social media or system share UI.
  ///
  /// [text] is the main content to share (required).
  ///
  /// Returns a [Future] that completes with a string indicating the result:
  /// 'success' or an error message. Platform-specific implementations must
  /// override this method.
  ///
  /// Throws [UnimplementedError] if not overridden.
  static Future<String> shareText({required String text}) {
    throw UnimplementedError('shareText() has not been implemented.');
  }

  /// Shares a single file to social media or system share UI.
  ///
  /// [filePath] is the path to the file to share (required).
  /// [mimeType] specifies the MIME type of the file (e.g., 'image/png').
  ///
  /// Returns a [Future] that completes with a string indicating the result:
  /// 'success' or an error message. Platform-specific implementations must
  /// override this method.
  ///
  /// Throws [UnimplementedError] if not overridden.
  static Future<String> shareFile({required String filePath, required String mimeType}) {
    throw UnimplementedError('shareFile() has not been implemented.');
  }
}