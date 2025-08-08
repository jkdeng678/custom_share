import 'dart:io';
import 'dart:ui' as ui;
import 'package:custom_share/custom_share.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// The entry point of the example application.
void main() {
  runApp(const MyApp());
}

/// The main application widget for the custom_share demo.
///
/// This widget sets up the app's theme and navigates to the [ShareDemoPage].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Share Demo',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: const ShareDemoPage(),
    );
  }
}

/// A page that demonstrates sharing text, files, and images using the custom_share plugin.
///
/// This widget provides buttons to trigger sharing text, a sample text file, or a sample image
/// and displays the result in a [SnackBar].
class ShareDemoPage extends StatelessWidget {
  const ShareDemoPage({super.key});

  /// Creates a sample text file for sharing.
  ///
  /// Returns a [Future] that completes with the path to the created file.
  /// The file is stored in the temporary directory.
  Future<String> _createSampleFile() async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/sample.txt');
    await file.writeAsBytes('This is a sample file for sharing.'.codeUnits);
    debugPrint('Created file at: ${file.path}');
    return file.path;
  }

  /// Creates a sample PNG image for sharing.
  ///
  /// Returns a [Future] that completes with the path to the created image.
  /// The image is a 100x100 red square, stored in the temporary directory.
  Future<String> _createSampleImage() async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/sample.png');

    // Create a 100x100 red image
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, 100, 100));
    canvas.drawRect(Rect.fromLTWH(0, 0, 100, 100), Paint()..color = Colors.red);
    final picture = recorder.endRecording();
    final img = await picture.toImage(100, 100);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();
    await file.writeAsBytes(buffer);

    debugPrint('Created image at: ${file.path}');
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Share Demo'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                try {
                  final result = await CustomShare.shareText(
                    text: 'Hello from Custom Share!',
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Share result: $result')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error sharing text: $e')),
                    );
                  }
                }
              },
              child: const Text('Share Text'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final filePath = await _createSampleFile();
                  final result = await CustomShare.shareFile(
                    filePath: filePath,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Share result: $result')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error sharing file: $e')),
                    );
                  }
                }
              },
              child: const Text('Share Text File'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final filePath = await _createSampleImage();
                  final result = await CustomShare.shareFile(
                    filePath: filePath,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Share result: $result')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error sharing image: $e')),
                    );
                  }
                }
              },
              child: const Text('Share Image'),
            ),
          ],
        ),
      ),
    );
  }
}
