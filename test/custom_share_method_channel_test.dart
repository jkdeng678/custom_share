import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_share/custom_share_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('custom_share');
  MethodChannelCustomShare platform = MethodChannelCustomShare();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async => 'success');
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('shareText', () async {
    expect(await platform.shareText(text: 'test'), 'success');
  });

  test('shareFiles', () async {
    expect(await platform.shareFiles(filePaths: ['/path/to/file']), 'success');
  });
}