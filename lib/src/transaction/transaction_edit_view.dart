import 'package:flutter/material.dart';

import 'transaction.dart';

/// Edit view for a transaction
class TransactionEditView extends StatelessWidget {
  final Transaction transaction;
  // Transaction? transaction;

  TransactionEditView({Key? key, required this.transaction}) : super(key: key) {
    // transaction = Transaction(data);
    // debugPrint(transaction?.title);
  }

  static const routeName = '/transations/edit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(transaction.payee),
      ),
      body: Center(
        child: Text(transaction.toString()),
      ),
    );
  }
}
