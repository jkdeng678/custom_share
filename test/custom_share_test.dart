import 'package:custom_share/custom_share.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('shareText returns success', () async {
    final result = await CustomShare().shareText(text: 'test');
    expect(result, 'success');
  });

  test('shareFiles returns success', () async {
    final result = await CustomShare().shareFiles(filePaths: ['/path/to/file']);
    expect(result, 'success');
  });
}
