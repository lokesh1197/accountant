import 'dart:developer';

import 'package:intl/intl.dart';

class Statement {
  final String account;
  final String amount;
  final String currency;

  Statement(this.account, this.amount, this.currency);
}

/// Represents a transaction based on ledger
class Transaction {
  final String dateFormat;
  final DateTime date;
  final String payee;
  final Iterable<Statement> statements;
  final Iterable<String> notes;
  final double value;
  final bool isValid;

  Transaction(
    this.date,
    this.payee,
    this.statements, {
    this.dateFormat = 'yyyy/MM/dd',
    this.value = 0,
    this.notes = const [],
    this.isValid = false,
  });

  static Transaction parse(String data) {
    log('Transaction - ' + data);
    List<String> lines = [];
    // List<String> comments = [];
    for (String line in data.split('\n')) {
      // if (line.trim()[0] == ';') {
      //   comments.add(line);
      // } else {
      lines.add(line);
      // }
    }
    List<String> splitPayee = lines[0].split(' ');
    DateTime date = DateFormat('yyyy/MM/dd').parse(splitPayee.removeAt(0));
    String payee = splitPayee.join(' ');
    bool isValid = false;
    if (payee.isNotEmpty) {
      isValid = true;
      if (payee[0] == '*' || payee[0] == '!') {
        payee = payee.substring(1).trim();
      }
    }
    Iterable<Statement> statements = lines.sublist(1).map((line) {
      List<String> params = line.split(' ');
      return Statement(params[0], params[1], params[2]);
    });
    Iterable<String> notes = [];
    double value = 0;
    return Transaction(
      date,
      payee,
      statements,
      notes: notes,
      value: value,
      isValid: isValid,
    );
  }

  getDate() {
    return DateFormat(dateFormat).format(date);
  }

  // @override
  // toString() {
  //   return '';
  // }
}
