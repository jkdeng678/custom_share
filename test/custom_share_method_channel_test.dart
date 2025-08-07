/// Tests for the [MethodChannelCustomShare] implementation of the custom_share plugin.
///
/// This file contains unit tests to verify the behavior of [MethodChannelCustomShare]
/// methods [shareText] and [shareFiles] using a mocked [MethodChannel].
library;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_share/custom_share_method_channel.dart';

/// The entry point for the test suite.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('custom_share');
  MethodChannelCustomShare platform = MethodChannelCustomShare();

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
    expect(await platform.shareText(text: 'test'), 'success');
  });

  test('shareFiles', () async {
    /// Tests that [shareFiles] returns 'success' for a valid file path list.
    expect(await platform.shareFiles(filePaths: ['/path/to/file']), 'success');
  });
}
