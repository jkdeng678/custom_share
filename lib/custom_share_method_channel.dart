import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'custom_share_platform_interface.dart';

class MethodChannelCustomShare extends CustomSharePlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('custom_share');

  @override
  Future<String> shareText({required String text}) async {
    try {
      return await methodChannel.invokeMethod('shareText', {'text': text}) ?? 'success';
    } catch (e) {
      return 'Error sharing text: $e';
    }
  }

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
      }) ?? 'success';
    } catch (e) {
      return 'Error sharing files: $e';
    }
  }
}