import 'package:flutter/material.dart';

import 'transaction.dart';

/// Edit view for a transaction
class TransactionEditView extends StatelessWidget {
  final String data;
  // Transaction? transaction;

  TransactionEditView({Key? key, required this.data}) : super(key: key) {
    // transaction = Transaction(data);
    // debugPrint(transaction?.title);
  }

  static const routeName = '/transations/edit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
