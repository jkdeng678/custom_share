import 'package:custom_share/custom_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

/// A page that demonstrates sharing text and files using the custom_share plugin.
///
/// This widget provides buttons to trigger sharing text or a sample file
/// and displays the result in a [SnackBar].
class ShareDemoPage extends StatelessWidget {
  const ShareDemoPage({super.key});

  /// Creates a sample text file for sharing.
  ///
  /// Returns a [Future] that completes with the path to the created file.
  /// The file is stored in the application documents directory (on desktop)
  /// or temporary directory (on mobile).
  Future<String> _createSampleFile() async {
    final directory = kIsWeb
        ? null
        : await (Platform.isMacOS || Platform.isWindows || Platform.isLinux
              ? getApplicationDocumentsDirectory()
              : getTemporaryDirectory());
    final file = File('${directory!.path}/sample.txt');
    await file.writeAsString('This is a sample file for sharing.');
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
                final result = await CustomShare().shareText(
                  text: 'Hello from Custom Share!',
                );
                if (context.mounted) {
                  // Check if widget is mounted
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Share result: $result')),
                  );
                }
              },
              child: const Text('Share Text'),
            ),
            TextButton(
              onPressed: () async {
                final filePath = await _createSampleFile();
                final result = await CustomShare().shareFiles(
                  filePaths: [filePath],
                  text: 'Sharing a sample file',
                  mimeType: 'text/plain',
                );
                if (context.mounted) {
                  // Check if widget is mounted
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Share result: $result')),
                  );
                }
              },
              child: const Text('Share File'),
            ),
          ],
        ),
      ),
    );
  }
}
