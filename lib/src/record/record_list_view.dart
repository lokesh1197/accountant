import 'dart:io' show Directory, File;

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../settings/settings_view.dart';
import 'record.dart';
import 'record_edit_view.dart';
import '../transaction/transaction_list_view.dart';

class RecordListView extends StatefulWidget {
  final String path;
  final List<Record> records = [];

  static const routeName = '/records';

  RecordListView({Key? key, this.path = ''}) : super(key: key) {
    debugPrint('Record List View: ' + path);
    Directory(path).listSync().forEach((file) {
      if (p.extension(file.path) == '.dat') {
        records.add(Record(file as File));
        debugPrint('File(ledger): ' + file.path);
      }
    });
  }

  @override
  RecordListViewState createState() => RecordListViewState();
}

/// Displays a list of Records.
class RecordListViewState extends State<RecordListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Records'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.settings),
        //     onPressed: () {
        //       Navigator.restorablePushNamed(context, SettingsView.routeName);
        //     },
        //   ),
        // ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'recordListView',
        itemCount: widget.records.length,
        itemBuilder: (BuildContext context, int index) {
          final record = widget.records[index];

          return ListTile(
              title: Text(record.toString()),
              // leading: const CircleAvatar(
              //   // Display the Flutter Logo image asset.
              //   foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              // ),
              onLongPress: () {
                Navigator.restorablePushNamed(
                  context,
                  RecordEditView.routeName,
                  arguments: record.name,
                );
              },
              onTap: () {
                Navigator.restorablePushNamed(
                  context,
                  TransactionListView.routeName,
                  arguments: record.path,
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Add record button pressed');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
