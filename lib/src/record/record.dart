import 'dart:io' show File;

import 'package:path/path.dart' as p;

/// Represents a list of transactions from a whole ledger file
class Record {
  final File file;
  String name = '';
  Record(this.file) {
    name = p.basenameWithoutExtension(file.path);
    name = name.replaceFirst(name[0], name[0].toUpperCase());
  }

  String get path {
    return file.path;
  }

  @override
  String toString() {
    return name;
  }
}

parse(String text) {
  // text.split('\n\n').map((String t) => Transaction(t));
}
