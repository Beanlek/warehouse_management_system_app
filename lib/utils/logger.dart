import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> saveLogToFile(String log) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/debug_log.txt');

    await file.writeAsString('$log\n', mode: FileMode.append);
    print('Log saved to: ${file.path}');
  } catch (e) {
    print('Error saving log: $e');
  }
}
