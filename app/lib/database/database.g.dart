// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class Storage extends Table with TableInfo<Storage, StorageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Storage(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT CURRENT_TIMESTAMP',
    defaultValue: const CustomExpression('CURRENT_TIMESTAMP'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT CURRENT_TIMESTAMP',
    defaultValue: const CustomExpression('CURRENT_TIMESTAMP'),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT FALSE',
    defaultValue: const CustomExpression('FALSE'),
  );
  static const VerificationMeta _encryptedDekMeta = const VerificationMeta(
    'encryptedDek',
  );
  late final GeneratedColumn<Uint8List> encryptedDek =
      GeneratedColumn<Uint8List>(
        'encrypted_dek',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL',
      );
  static const VerificationMeta _encryptedPayloadMeta = const VerificationMeta(
    'encryptedPayload',
  );
  late final GeneratedColumn<Uint8List> encryptedPayload =
      GeneratedColumn<Uint8List>(
        'encrypted_payload',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL',
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    createdAt,
    updatedAt,
    version,
    deleted,
    encryptedDek,
    encryptedPayload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'storage';
  @override
  VerificationContext validateIntegrity(
    Insertable<StorageData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('encrypted_dek')) {
      context.handle(
        _encryptedDekMeta,
        encryptedDek.isAcceptableOrUnknown(
          data['encrypted_dek']!,
          _encryptedDekMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_encryptedDekMeta);
    }
    if (data.containsKey('encrypted_payload')) {
      context.handle(
        _encryptedPayloadMeta,
        encryptedPayload.isAcceptableOrUnknown(
          data['encrypted_payload']!,
          _encryptedPayloadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_encryptedPayloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, accountId};
  @override
  StorageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StorageData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      encryptedDek: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}encrypted_dek'],
      )!,
      encryptedPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}encrypted_payload'],
      )!,
    );
  }

  @override
  Storage createAlias(String alias) {
    return Storage(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(id, account_id)'];
  @override
  bool get dontWriteConstraints => true;
}

class StorageData extends DataClass implements Insertable<StorageData> {
  final String id;
  final String accountId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final bool deleted;
  final Uint8List encryptedDek;
  final Uint8List encryptedPayload;
  const StorageData({
    required this.id,
    required this.accountId,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.deleted,
    required this.encryptedDek,
    required this.encryptedPayload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['deleted'] = Variable<bool>(deleted);
    map['encrypted_dek'] = Variable<Uint8List>(encryptedDek);
    map['encrypted_payload'] = Variable<Uint8List>(encryptedPayload);
    return map;
  }

  StorageCompanion toCompanion(bool nullToAbsent) {
    return StorageCompanion(
      id: Value(id),
      accountId: Value(accountId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      deleted: Value(deleted),
      encryptedDek: Value(encryptedDek),
      encryptedPayload: Value(encryptedPayload),
    );
  }

  factory StorageData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StorageData(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['account_id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      version: serializer.fromJson<int>(json['version']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      encryptedDek: serializer.fromJson<Uint8List>(json['encrypted_dek']),
      encryptedPayload: serializer.fromJson<Uint8List>(
        json['encrypted_payload'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'account_id': serializer.toJson<String>(accountId),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'deleted': serializer.toJson<bool>(deleted),
      'encrypted_dek': serializer.toJson<Uint8List>(encryptedDek),
      'encrypted_payload': serializer.toJson<Uint8List>(encryptedPayload),
    };
  }

  StorageData copyWith({
    String? id,
    String? accountId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    bool? deleted,
    Uint8List? encryptedDek,
    Uint8List? encryptedPayload,
  }) => StorageData(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    deleted: deleted ?? this.deleted,
    encryptedDek: encryptedDek ?? this.encryptedDek,
    encryptedPayload: encryptedPayload ?? this.encryptedPayload,
  );
  StorageData copyWithCompanion(StorageCompanion data) {
    return StorageData(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      encryptedDek: data.encryptedDek.present
          ? data.encryptedDek.value
          : this.encryptedDek,
      encryptedPayload: data.encryptedPayload.present
          ? data.encryptedPayload.value
          : this.encryptedPayload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StorageData(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('deleted: $deleted, ')
          ..write('encryptedDek: $encryptedDek, ')
          ..write('encryptedPayload: $encryptedPayload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    createdAt,
    updatedAt,
    version,
    deleted,
    $driftBlobEquality.hash(encryptedDek),
    $driftBlobEquality.hash(encryptedPayload),
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StorageData &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.deleted == this.deleted &&
          $driftBlobEquality.equals(other.encryptedDek, this.encryptedDek) &&
          $driftBlobEquality.equals(
            other.encryptedPayload,
            this.encryptedPayload,
          ));
}

class StorageCompanion extends UpdateCompanion<StorageData> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<bool> deleted;
  final Value<Uint8List> encryptedDek;
  final Value<Uint8List> encryptedPayload;
  final Value<int> rowid;
  const StorageCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.deleted = const Value.absent(),
    this.encryptedDek = const Value.absent(),
    this.encryptedPayload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StorageCompanion.insert({
    required String id,
    required String accountId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required int version,
    this.deleted = const Value.absent(),
    required Uint8List encryptedDek,
    required Uint8List encryptedPayload,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       version = Value(version),
       encryptedDek = Value(encryptedDek),
       encryptedPayload = Value(encryptedPayload);
  static Insertable<StorageData> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<bool>? deleted,
    Expression<Uint8List>? encryptedDek,
    Expression<Uint8List>? encryptedPayload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (deleted != null) 'deleted': deleted,
      if (encryptedDek != null) 'encrypted_dek': encryptedDek,
      if (encryptedPayload != null) 'encrypted_payload': encryptedPayload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StorageCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<bool>? deleted,
    Value<Uint8List>? encryptedDek,
    Value<Uint8List>? encryptedPayload,
    Value<int>? rowid,
  }) {
    return StorageCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      deleted: deleted ?? this.deleted,
      encryptedDek: encryptedDek ?? this.encryptedDek,
      encryptedPayload: encryptedPayload ?? this.encryptedPayload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (encryptedDek.present) {
      map['encrypted_dek'] = Variable<Uint8List>(encryptedDek.value);
    }
    if (encryptedPayload.present) {
      map['encrypted_payload'] = Variable<Uint8List>(encryptedPayload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StorageCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('deleted: $deleted, ')
          ..write('encryptedDek: $encryptedDek, ')
          ..write('encryptedPayload: $encryptedPayload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final Storage storage = Storage(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [storage];
}

typedef $StorageCreateCompanionBuilder =
    StorageCompanion Function({
      required String id,
      required String accountId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required int version,
      Value<bool> deleted,
      required Uint8List encryptedDek,
      required Uint8List encryptedPayload,
      Value<int> rowid,
    });
typedef $StorageUpdateCompanionBuilder =
    StorageCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> deleted,
      Value<Uint8List> encryptedDek,
      Value<Uint8List> encryptedPayload,
      Value<int> rowid,
    });

class $StorageFilterComposer extends Composer<_$AppDatabase, Storage> {
  $StorageFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get encryptedDek => $composableBuilder(
    column: $table.encryptedDek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get encryptedPayload => $composableBuilder(
    column: $table.encryptedPayload,
    builder: (column) => ColumnFilters(column),
  );
}

class $StorageOrderingComposer extends Composer<_$AppDatabase, Storage> {
  $StorageOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get encryptedDek => $composableBuilder(
    column: $table.encryptedDek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get encryptedPayload => $composableBuilder(
    column: $table.encryptedPayload,
    builder: (column) => ColumnOrderings(column),
  );
}

class $StorageAnnotationComposer extends Composer<_$AppDatabase, Storage> {
  $StorageAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<Uint8List> get encryptedDek => $composableBuilder(
    column: $table.encryptedDek,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get encryptedPayload => $composableBuilder(
    column: $table.encryptedPayload,
    builder: (column) => column,
  );
}

class $StorageTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Storage,
          StorageData,
          $StorageFilterComposer,
          $StorageOrderingComposer,
          $StorageAnnotationComposer,
          $StorageCreateCompanionBuilder,
          $StorageUpdateCompanionBuilder,
          (StorageData, BaseReferences<_$AppDatabase, Storage, StorageData>),
          StorageData,
          PrefetchHooks Function()
        > {
  $StorageTableManager(_$AppDatabase db, Storage table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $StorageFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $StorageOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $StorageAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<Uint8List> encryptedDek = const Value.absent(),
                Value<Uint8List> encryptedPayload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StorageCompanion(
                id: id,
                accountId: accountId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                deleted: deleted,
                encryptedDek: encryptedDek,
                encryptedPayload: encryptedPayload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required int version,
                Value<bool> deleted = const Value.absent(),
                required Uint8List encryptedDek,
                required Uint8List encryptedPayload,
                Value<int> rowid = const Value.absent(),
              }) => StorageCompanion.insert(
                id: id,
                accountId: accountId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                deleted: deleted,
                encryptedDek: encryptedDek,
                encryptedPayload: encryptedPayload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $StorageProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Storage,
      StorageData,
      $StorageFilterComposer,
      $StorageOrderingComposer,
      $StorageAnnotationComposer,
      $StorageCreateCompanionBuilder,
      $StorageUpdateCompanionBuilder,
      (StorageData, BaseReferences<_$AppDatabase, Storage, StorageData>),
      StorageData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $StorageTableManager get storage => $StorageTableManager(_db, _db.storage);
}
