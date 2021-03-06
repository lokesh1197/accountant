import 'package:intl/intl.dart';

class Statement {
  final String account;
  final String amount;
  final String currency;
  final bool isComment;
  final String comment;

  // TODO: make is user configurable
  int maxLength = 80;

  Statement(this.account, this.amount, this.currency,
      {this.isComment = false, this.comment = ''});

  static Statement parseString(String line) {
    line = line.trim();
    if (line[0] == ';') {
      return Statement('', '0.00', '', isComment: true, comment: line);
    }
    List<String> params = line.split(RegExp('\\s+'));
    return Statement(params[0], params[1], params[2]);
  }

  @override
  String toString() {
    if (isComment) return comment;

    // TODO: consider case when tabLength is non-positive
    int noOfSpaces =
        maxLength - (account.length + amount.length + 1 + currency.length);
    return [account, List.filled(noOfSpaces, ' ').join(), amount, ' ', currency]
        .join();
  }
}

/// Represents a transaction based on ledger
/// Contains an array of Statements(Income/Expenditure) and notes with total amount zero
class Transaction {
  final String dateFormat;
  final DateTime date;
  final String payee;
  final Iterable<Statement> statements;
  final String value;

  Transaction(
    this.date,
    this.payee,
    this.statements,
    this.value, {
    // TODO: make it user configurable
    this.dateFormat = 'yyyy/MM/dd',
  });

  static Transaction parseString(String data) {
    List<String> lines = [];
    for (String line in data.split('\n')) {
      lines.add(line);
    }
    List<String> splitPayee = lines[0].split(' ');
    DateTime date = DateFormat('yyyy/MM/dd').parse(splitPayee.removeAt(0));
    String payee = splitPayee.join(' ');

    if (payee.isEmpty) {
      throw const FormatException(
          'Unable to parse transaction: Payee is empty');
    }

    if (payee[0] == '*' || payee[0] == '!') {
      payee = payee.substring(1).trim();
    }

    Iterable<Statement> statements = lines.sublist(1).map((line) {
      return Statement.parseString(line);
    });
    String value = statements
        .map((s) {
          double? parsedValue = double.tryParse(s.amount);
          return parsedValue.runtimeType == double ? parsedValue : 0;
        })
        .where((amount) {
          return amount != null && amount > 0;
        })
        .fold(0, (p, c) => p + c > 0 ? c : 0)
        .toString();
    // double value = 0;

    return Transaction(
      date,
      payee,
      statements,
      value,
    );
  }

  @override
  String toString() {
    return [getDate() + ' ' + payee, ...statements.map((s) => s.toString())]
        .join('\n');
  }

  // static Transaction parseJson() {}
  // static String toJson() {}

  getDate() {
    return DateFormat(dateFormat).format(date);
  }

  getAccountAmountChanges() {
    const accounts = {};
    for (Statement statement in statements.where((s) => !s.isComment)) {
      accounts[statement.account] = statement.amount;
    }
    return accounts;
  }
}
