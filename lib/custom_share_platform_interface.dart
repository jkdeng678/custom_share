import 'custom_share_method_channel.dart';

abstract class CustomSharePlatform {
  static CustomSharePlatform _instance = MethodChannelCustomShare();

  static CustomSharePlatform get instance => _instance;
  // get instance => CustomSharePlatform;

  static set instance(CustomSharePlatform instance) {
    _instance = instance;
  }

  Future<String> shareText({required String text}) {
    throw UnimplementedError('shareText() has not been implemented.');
  }

  Future<String> shareFiles({
    required List<String> filePaths,
    String? text,
    String mimeType = '*/*',
  }) {
    throw UnimplementedError('shareFiles() has not been implemented.');
  }
}