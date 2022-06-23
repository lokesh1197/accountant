import 'dart:io' show Directory;

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart' show FilePicker;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

import 'record/record_list_view.dart';

/// Startup view
class StartupView extends StatelessWidget {
  const StartupView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Startup Screen'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Create New', style: TextStyle(fontSize: 30)),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(15))),
              onPressed: () {
                debugPrint('Pressed: Create New 1');
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              child: const Text('Use Existing', style: TextStyle(fontSize: 30)),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(15))),
              onPressed: () async {
                debugPrint('Pressed: Use Existing');
                String? path = await FilePicker.platform.getDirectoryPath(
                    dialogTitle:
                        'Select the directory containing ledger files');

                Directory directory = await getApplicationDocumentsDirectory();
                Hive.init(directory.path);
                var box = await Hive.openBox('mybox');
                box.put('name', 'Lokesh');
                var name = box.get('name');
                debugPrint('Name: $name');

                if (path != null) {
                  debugPrint('Path: ' + path);
                  Navigator.restorablePushNamed(
                      context, RecordListView.routeName,
                      arguments: path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
