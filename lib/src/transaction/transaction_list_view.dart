import 'dart:io';

import 'package:flutter/material.dart';

import 'transaction.dart';
import 'transaction_edit_view.dart';

/// Displays a list of Transactions.
class TransactionListView extends StatefulWidget {
  final List<Transaction> transactions = [];
  final String filePath;
  static const routeName = '/transactions';

  TransactionListView({
    Key? key,
    this.filePath = '',
  }) : super(key: key) {
    debugPrint('FilePath: ' + filePath);
    String data = File(filePath)
        .readAsStringSync()
        .split('\n')
        .where((line) => line.isEmpty || line[0] != ';')
        .join('\n');
    for (String partData in data.split('\n\n')) {
      Transaction transaction = Transaction.parse(partData);
      if (transaction.isValid) {
        transactions.add(Transaction.parse(partData));
      }
    }
    // (() async {
    //   String data = await File(filePath).readAsString();
    //   for (var transaction in data.split('\n\n')) {
    //     transactions.add(Transaction(transaction));
    //   }
    // })();
  }

  @override
  TransactionListViewState createState() => TransactionListViewState();
}

class TransactionListViewState extends State<TransactionListView> {
  Future<void> _editDate(BuildContext context, int index) async {
    DateTime initialDate = widget.transactions[index].date;
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2018),
        lastDate: DateTime.now());
    if (picked != null && picked != initialDate) {
      setState(() {
        // widget.transactions[index].date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: ListView.builder(
        restorationId: 'transactionListView',
        itemCount: widget.transactions.length,
        itemBuilder: (BuildContext context, int index) {
          final transaction = widget.transactions[index];
          int a = 255;
          int r = transaction.value <= 0 ? 255 : 0;
          int g = transaction.value >= 0 ? 255 : 0;
          int b = 0;

          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              OutlinedButton(
                onPressed: () => _editDate(context, index),
                child: Text(transaction.getDate()),
              ),
              const SizedBox(width: 10),
              Flexible(
                fit: FlexFit.tight,
                child: OutlinedButton(
                  onPressed: () => {
                    Navigator.restorablePushNamed(
                      context,
                      TransactionEditView.routeName,
                      arguments: transaction.toString(),
                    )
                  },
                  child: Text(
                    transaction.payee,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => {},
                child: Text(
                  transaction.value.toString(),
                  style: TextStyle(color: Color.fromARGB(a, r, g, b)),
                ),
              ),
            ],
          );

          // return ListTile(
          //     title: Text(transaction.date + ' ' + transaction.title),
          //     // leading: const CircleAvatar(
          //     //   foregroundImage: AssetImage('assets/images/flutter_logo.png'),
          //     // ),
          //     onTap: () {
          //       Navigator.restorablePushNamed(
          //         context,
          //         TransactionEditView.routeName,
          //         arguments: transaction.data,
          //       );
          //     });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Add transaction button pressed');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
