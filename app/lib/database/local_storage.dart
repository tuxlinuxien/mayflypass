import 'package:drift/drift.dart';

class LocalStorage extends Table {
  late final id = text()();
  late final version = integer()();
  late final deleted = boolean()();
  late final encryptedDek = blob()();
  late final encryptedPayload = blob()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
