

// 无web支持
import 'dart:async';
import 'package:flutter/services.dart';

class CustomShare {
  static const MethodChannel _channel = MethodChannel('custom_share');

  Future<String> shareText({required String text}) async {
    try {
      return await _channel.invokeMethod('shareText', {'text': text}) ?? 'success';
    } catch (e) {
      return 'Error sharing text: $e';
    }
  }

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
      }) ?? 'success';
    } catch (e) {
      return 'Error sharing files: $e';
    }
  }
}