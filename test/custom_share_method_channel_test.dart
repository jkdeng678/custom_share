/// Tests for the [MethodChannelCustomShare] implementation of the custom_share plugin.
///
/// This file contains unit tests to verify the behavior of [MethodChannelCustomShare]
/// methods [shareText] and [shareFile] using a mocked [MethodChannel].
library;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_share/custom_share_method_channel.dart';

/// The entry point for the test suite.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('custom_share');

  setUp(() {
    /// Sets up a mock method call handler for the [channel].
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          channel,
          (MethodCall methodCall) async => 'success',
        );
  });

  tearDown(() {
    /// Clears the mock method call handler for the [channel].
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('shareText', () async {
    /// Tests that [shareText] returns 'success' for a valid text input.
    expect(await MethodChannelCustomShare.shareText(text: 'test'), 'success');
  });

  test('shareFile', () async {
    /// Tests that [shareFile] returns 'success' for a valid file path and MIME type.
    expect(
      await MethodChannelCustomShare.shareFile(
        filePath: '/path/to/file.png',
        mimeType: 'image/png',
      ),
      'success',
    );
  });
}
