/// Defines the platform interface for the custom_share plugin.
///
/// This abstract class specifies the contract for platform-specific
/// implementations of the custom_share plugin, allowing text and file
/// sharing on Android and iOS. Platform implementations (e.g., [MethodChannelCustomShare])
/// must override the abstract methods [shareText] and [shareFiles].
///
/// Example:
/// ```dart
/// CustomSharePlatform.instance = MethodChannelCustomShare();
/// final result = await CustomSharePlatform.instance.shareText(text: 'Hello!');
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
  Future<String> shareText({required String text}) {
    throw UnimplementedError('shareText() has not been implemented.');
  }

  /// Shares one or more files to social media or system share UI.
  ///
  /// [filePaths] is a list of file paths to share (required).
  /// [text] is an optional accompanying message.
  /// [mimeType] specifies the MIME type of the files (defaults to '*/*').
  ///
  /// Returns a [Future] that completes with a string indicating the result:
  /// 'success' or an error message. Platform-specific implementations must
  /// override this method.
  ///
  /// Throws [UnimplementedError] if not overridden.
  Future<String> shareFiles({
    required List<String> filePaths,
    String? text,
    String mimeType = '*/*',
  }) {
    throw UnimplementedError('shareFiles() has not been implemented.');
  }
}
