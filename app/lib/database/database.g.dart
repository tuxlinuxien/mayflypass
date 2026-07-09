// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LocalStorageTable extends LocalStorage
    with TableInfo<$LocalStorageTable, LocalStorageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalStorageTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
  );
  static const VerificationMeta _encryptedDekMeta = const VerificationMeta(
    'encryptedDek',
  );
  @override
  late final GeneratedColumn<Uint8List> encryptedDek =
      GeneratedColumn<Uint8List>(
        'encrypted_dek',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _encryptedPayloadMeta = const VerificationMeta(
    'encryptedPayload',
  );
  @override
  late final GeneratedColumn<Uint8List> encryptedPayload =
      GeneratedColumn<Uint8List>(
        'encrypted_payload',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAtMs,
    deleted,
    encryptedDek,
    encryptedPayload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_storage';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalStorageData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMsMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    } else if (isInserting) {
      context.missing(_deletedMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalStorageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalStorageData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
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
  $LocalStorageTable createAlias(String alias) {
    return $LocalStorageTable(attachedDatabase, alias);
  }
}

class LocalStorageData extends DataClass
    implements Insertable<LocalStorageData> {
  final String id;
  final int updatedAtMs;
  final bool deleted;
  final Uint8List encryptedDek;
  final Uint8List encryptedPayload;
  const LocalStorageData({
    required this.id,
    required this.updatedAtMs,
    required this.deleted,
    required this.encryptedDek,
    required this.encryptedPayload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    map['deleted'] = Variable<bool>(deleted);
    map['encrypted_dek'] = Variable<Uint8List>(encryptedDek);
    map['encrypted_payload'] = Variable<Uint8List>(encryptedPayload);
    return map;
  }

  LocalStorageCompanion toCompanion(bool nullToAbsent) {
    return LocalStorageCompanion(
      id: Value(id),
      updatedAtMs: Value(updatedAtMs),
      deleted: Value(deleted),
      encryptedDek: Value(encryptedDek),
      encryptedPayload: Value(encryptedPayload),
    );
  }

  factory LocalStorageData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalStorageData(
      id: serializer.fromJson<String>(json['id']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      encryptedDek: serializer.fromJson<Uint8List>(json['encryptedDek']),
      encryptedPayload: serializer.fromJson<Uint8List>(
        json['encryptedPayload'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
      'deleted': serializer.toJson<bool>(deleted),
      'encryptedDek': serializer.toJson<Uint8List>(encryptedDek),
      'encryptedPayload': serializer.toJson<Uint8List>(encryptedPayload),
    };
  }

  LocalStorageData copyWith({
    String? id,
    int? updatedAtMs,
    bool? deleted,
    Uint8List? encryptedDek,
    Uint8List? encryptedPayload,
  }) => LocalStorageData(
    id: id ?? this.id,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
    deleted: deleted ?? this.deleted,
    encryptedDek: encryptedDek ?? this.encryptedDek,
    encryptedPayload: encryptedPayload ?? this.encryptedPayload,
  );
  LocalStorageData copyWithCompanion(LocalStorageCompanion data) {
    return LocalStorageData(
      id: data.id.present ? data.id.value : this.id,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
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
    return (StringBuffer('LocalStorageData(')
          ..write('id: $id, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('deleted: $deleted, ')
          ..write('encryptedDek: $encryptedDek, ')
          ..write('encryptedPayload: $encryptedPayload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAtMs,
    deleted,
    $driftBlobEquality.hash(encryptedDek),
    $driftBlobEquality.hash(encryptedPayload),
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalStorageData &&
          other.id == this.id &&
          other.updatedAtMs == this.updatedAtMs &&
          other.deleted == this.deleted &&
          $driftBlobEquality.equals(other.encryptedDek, this.encryptedDek) &&
          $driftBlobEquality.equals(
            other.encryptedPayload,
            this.encryptedPayload,
          ));
}

class LocalStorageCompanion extends UpdateCompanion<LocalStorageData> {
  final Value<String> id;
  final Value<int> updatedAtMs;
  final Value<bool> deleted;
  final Value<Uint8List> encryptedDek;
  final Value<Uint8List> encryptedPayload;
  final Value<int> rowid;
  const LocalStorageCompanion({
    this.id = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.deleted = const Value.absent(),
    this.encryptedDek = const Value.absent(),
    this.encryptedPayload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalStorageCompanion.insert({
    required String id,
    required int updatedAtMs,
    required bool deleted,
    required Uint8List encryptedDek,
    required Uint8List encryptedPayload,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAtMs = Value(updatedAtMs),
       deleted = Value(deleted),
       encryptedDek = Value(encryptedDek),
       encryptedPayload = Value(encryptedPayload);
  static Insertable<LocalStorageData> custom({
    Expression<String>? id,
    Expression<int>? updatedAtMs,
    Expression<bool>? deleted,
    Expression<Uint8List>? encryptedDek,
    Expression<Uint8List>? encryptedPayload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (deleted != null) 'deleted': deleted,
      if (encryptedDek != null) 'encrypted_dek': encryptedDek,
      if (encryptedPayload != null) 'encrypted_payload': encryptedPayload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalStorageCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAtMs,
    Value<bool>? deleted,
    Value<Uint8List>? encryptedDek,
    Value<Uint8List>? encryptedPayload,
    Value<int>? rowid,
  }) {
    return LocalStorageCompanion(
      id: id ?? this.id,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
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
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
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
    return (StringBuffer('LocalStorageCompanion(')
          ..write('id: $id, ')
          ..write('updatedAtMs: $updatedAtMs, ')
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
  late final $LocalStorageTable localStorage = $LocalStorageTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [localStorage];
}

typedef $$LocalStorageTableCreateCompanionBuilder =
    LocalStorageCompanion Function({
      required String id,
      required int updatedAtMs,
      required bool deleted,
      required Uint8List encryptedDek,
      required Uint8List encryptedPayload,
      Value<int> rowid,
    });
typedef $$LocalStorageTableUpdateCompanionBuilder =
    LocalStorageCompanion Function({
      Value<String> id,
      Value<int> updatedAtMs,
      Value<bool> deleted,
      Value<Uint8List> encryptedDek,
      Value<Uint8List> encryptedPayload,
      Value<int> rowid,
    });

class $$LocalStorageTableFilterComposer
    extends Composer<_$AppDatabase, $LocalStorageTable> {
  $$LocalStorageTableFilterComposer({
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

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
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

class $$LocalStorageTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalStorageTable> {
  $$LocalStorageTableOrderingComposer({
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

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
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

class $$LocalStorageTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalStorageTable> {
  $$LocalStorageTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );

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

class $$LocalStorageTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalStorageTable,
          LocalStorageData,
          $$LocalStorageTableFilterComposer,
          $$LocalStorageTableOrderingComposer,
          $$LocalStorageTableAnnotationComposer,
          $$LocalStorageTableCreateCompanionBuilder,
          $$LocalStorageTableUpdateCompanionBuilder,
          (
            LocalStorageData,
            BaseReferences<_$AppDatabase, $LocalStorageTable, LocalStorageData>,
          ),
          LocalStorageData,
          PrefetchHooks Function()
        > {
  $$LocalStorageTableTableManager(_$AppDatabase db, $LocalStorageTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalStorageTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalStorageTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalStorageTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<Uint8List> encryptedDek = const Value.absent(),
                Value<Uint8List> encryptedPayload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalStorageCompanion(
                id: id,
                updatedAtMs: updatedAtMs,
                deleted: deleted,
                encryptedDek: encryptedDek,
                encryptedPayload: encryptedPayload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAtMs,
                required bool deleted,
                required Uint8List encryptedDek,
                required Uint8List encryptedPayload,
                Value<int> rowid = const Value.absent(),
              }) => LocalStorageCompanion.insert(
                id: id,
                updatedAtMs: updatedAtMs,
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

typedef $$LocalStorageTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalStorageTable,
      LocalStorageData,
      $$LocalStorageTableFilterComposer,
      $$LocalStorageTableOrderingComposer,
      $$LocalStorageTableAnnotationComposer,
      $$LocalStorageTableCreateCompanionBuilder,
      $$LocalStorageTableUpdateCompanionBuilder,
      (
        LocalStorageData,
        BaseReferences<_$AppDatabase, $LocalStorageTable, LocalStorageData>,
      ),
      LocalStorageData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalStorageTableTableManager get localStorage =>
      $$LocalStorageTableTableManager(_db, _db.localStorage);
}
