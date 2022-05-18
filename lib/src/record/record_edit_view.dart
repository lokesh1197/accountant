import 'package:flutter/material.dart';

import 'record.dart';

/// Edit view for a transaction
class RecordEditView extends StatelessWidget {
  final String? record;

  const RecordEditView({Key? key, this.record}) : super(key: key);

  static const routeName = '/records/edit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${record} Record Details'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
