// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientUpdatedAtMeta = const VerificationMeta(
    'clientUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> clientUpdatedAt =
      GeneratedColumn<DateTime>(
        'client_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    deviceId,
    clientUpdatedAt,
    updatedAt,
    createdAt,
    deletedAt,
    name,
    icon,
    color,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('client_updated_at')) {
      context.handle(
        _clientUpdatedAtMeta,
        clientUpdatedAt.isAcceptableOrUnknown(
          data['client_updated_at']!,
          _clientUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientUpdatedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      clientUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}client_updated_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String? userId;
  final String? deviceId;
  final DateTime clientUpdatedAt;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final String name;
  final String? icon;
  final String? color;
  const Category({
    required this.id,
    this.userId,
    this.deviceId,
    required this.clientUpdatedAt,
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
    required this.name,
    this.icon,
    this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      clientUpdatedAt: Value(clientUpdatedAt),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      clientUpdatedAt: serializer.fromJson<DateTime>(json['clientUpdatedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<String?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'clientUpdatedAt': serializer.toJson<DateTime>(clientUpdatedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<String?>(color),
    };
  }

  Category copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    DateTime? clientUpdatedAt,
    DateTime? updatedAt,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    Value<String?> icon = const Value.absent(),
    Value<String?> color = const Value.absent(),
  }) => Category(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    icon: icon.present ? icon.value : this.icon,
    color: color.present ? color.value : this.color,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      clientUpdatedAt: data.clientUpdatedAt.present
          ? data.clientUpdatedAt.value
          : this.clientUpdatedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    deviceId,
    clientUpdatedAt,
    updatedAt,
    createdAt,
    deletedAt,
    name,
    icon,
    color,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.deviceId == this.deviceId &&
          other.clientUpdatedAt == this.clientUpdatedAt &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String?> deviceId;
  final Value<DateTime> clientUpdatedAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String?> icon;
  final Value<String?> color;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    required DateTime clientUpdatedAt,
    required DateTime updatedAt,
    required DateTime createdAt,
    this.deletedAt = const Value.absent(),
    required String name,
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientUpdatedAt = Value(clientUpdatedAt),
       updatedAt = Value(updatedAt),
       createdAt = Value(createdAt),
       name = Value(name);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? deviceId,
    Expression<DateTime>? clientUpdatedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (deviceId != null) 'device_id': deviceId,
      if (clientUpdatedAt != null) 'client_updated_at': clientUpdatedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<String?>? deviceId,
    Value<DateTime>? clientUpdatedAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String?>? icon,
    Value<String?>? color,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (clientUpdatedAt.present) {
      map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientUpdatedAtMeta = const VerificationMeta(
    'clientUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> clientUpdatedAt =
      GeneratedColumn<DateTime>(
        'client_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _abbreviationMeta = const VerificationMeta(
    'abbreviation',
  );
  @override
  late final GeneratedColumn<String> abbreviation = GeneratedColumn<String>(
    'abbreviation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    deviceId,
    clientUpdatedAt,
    updatedAt,
    createdAt,
    deletedAt,
    name,
    abbreviation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(
    Insertable<Unit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('client_updated_at')) {
      context.handle(
        _clientUpdatedAtMeta,
        clientUpdatedAt.isAcceptableOrUnknown(
          data['client_updated_at']!,
          _clientUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientUpdatedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('abbreviation')) {
      context.handle(
        _abbreviationMeta,
        abbreviation.isAcceptableOrUnknown(
          data['abbreviation']!,
          _abbreviationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      clientUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}client_updated_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      abbreviation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abbreviation'],
      ),
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final String id;
  final String? userId;
  final String? deviceId;
  final DateTime clientUpdatedAt;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final String name;
  final String? abbreviation;
  const Unit({
    required this.id,
    this.userId,
    this.deviceId,
    required this.clientUpdatedAt,
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
    required this.name,
    this.abbreviation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || abbreviation != null) {
      map['abbreviation'] = Variable<String>(abbreviation);
    }
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      clientUpdatedAt: Value(clientUpdatedAt),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      abbreviation: abbreviation == null && nullToAbsent
          ? const Value.absent()
          : Value(abbreviation),
    );
  }

  factory Unit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      clientUpdatedAt: serializer.fromJson<DateTime>(json['clientUpdatedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      abbreviation: serializer.fromJson<String?>(json['abbreviation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'clientUpdatedAt': serializer.toJson<DateTime>(clientUpdatedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'abbreviation': serializer.toJson<String?>(abbreviation),
    };
  }

  Unit copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    DateTime? clientUpdatedAt,
    DateTime? updatedAt,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    Value<String?> abbreviation = const Value.absent(),
  }) => Unit(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    abbreviation: abbreviation.present ? abbreviation.value : this.abbreviation,
  );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      clientUpdatedAt: data.clientUpdatedAt.present
          ? data.clientUpdatedAt.value
          : this.clientUpdatedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      abbreviation: data.abbreviation.present
          ? data.abbreviation.value
          : this.abbreviation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('abbreviation: $abbreviation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    deviceId,
    clientUpdatedAt,
    updatedAt,
    createdAt,
    deletedAt,
    name,
    abbreviation,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.deviceId == this.deviceId &&
          other.clientUpdatedAt == this.clientUpdatedAt &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.abbreviation == this.abbreviation);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String?> deviceId;
  final Value<DateTime> clientUpdatedAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String?> abbreviation;
  final Value<int> rowid;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.abbreviation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    required DateTime clientUpdatedAt,
    required DateTime updatedAt,
    required DateTime createdAt,
    this.deletedAt = const Value.absent(),
    required String name,
    this.abbreviation = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientUpdatedAt = Value(clientUpdatedAt),
       updatedAt = Value(updatedAt),
       createdAt = Value(createdAt),
       name = Value(name);
  static Insertable<Unit> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? deviceId,
    Expression<DateTime>? clientUpdatedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? abbreviation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (deviceId != null) 'device_id': deviceId,
      if (clientUpdatedAt != null) 'client_updated_at': clientUpdatedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (abbreviation != null) 'abbreviation': abbreviation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitsCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<String?>? deviceId,
    Value<DateTime>? clientUpdatedAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String?>? abbreviation,
    Value<int>? rowid,
  }) {
    return UnitsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (clientUpdatedAt.present) {
      map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (abbreviation.present) {
      map['abbreviation'] = Variable<String>(abbreviation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientUpdatedAtMeta = const VerificationMeta(
    'clientUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> clientUpdatedAt =
      GeneratedColumn<DateTime>(
        'client_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
    'unit_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _basePriceMeta = const VerificationMeta(
    'basePrice',
  );
  @override
  late final GeneratedColumn<double> basePrice = GeneratedColumn<double>(
    'base_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localImagePathMeta = const VerificationMeta(
    'localImagePath',
  );
  @override
  late final GeneratedColumn<String> localImagePath = GeneratedColumn<String>(
    'local_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePendingMeta = const VerificationMeta(
    'imagePending',
  );
  @override
  late final GeneratedColumn<bool> imagePending = GeneratedColumn<bool>(
    'image_pending',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("image_pending" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    deviceId,
    clientUpdatedAt,
    updatedAt,
    createdAt,
    deletedAt,
    name,
    description,
    categoryId,
    unitId,
    basePrice,
    imagePath,
    localImagePath,
    imagePending,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('client_updated_at')) {
      context.handle(
        _clientUpdatedAtMeta,
        clientUpdatedAt.isAcceptableOrUnknown(
          data['client_updated_at']!,
          _clientUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientUpdatedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    }
    if (data.containsKey('base_price')) {
      context.handle(
        _basePriceMeta,
        basePrice.isAcceptableOrUnknown(data['base_price']!, _basePriceMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('local_image_path')) {
      context.handle(
        _localImagePathMeta,
        localImagePath.isAcceptableOrUnknown(
          data['local_image_path']!,
          _localImagePathMeta,
        ),
      );
    }
    if (data.containsKey('image_pending')) {
      context.handle(
        _imagePendingMeta,
        imagePending.isAcceptableOrUnknown(
          data['image_pending']!,
          _imagePendingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      clientUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}client_updated_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_id'],
      ),
      basePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}base_price'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      localImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_image_path'],
      ),
      imagePending: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}image_pending'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String? userId;
  final String? deviceId;
  final DateTime clientUpdatedAt;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final String name;
  final String? description;
  final String? categoryId;
  final String? unitId;
  final double? basePrice;
  final String? imagePath;
  final String? localImagePath;
  final bool imagePending;
  const Product({
    required this.id,
    this.userId,
    this.deviceId,
    required this.clientUpdatedAt,
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
    required this.name,
    this.description,
    this.categoryId,
    this.unitId,
    this.basePrice,
    this.imagePath,
    this.localImagePath,
    required this.imagePending,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || unitId != null) {
      map['unit_id'] = Variable<String>(unitId);
    }
    if (!nullToAbsent || basePrice != null) {
      map['base_price'] = Variable<double>(basePrice);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || localImagePath != null) {
      map['local_image_path'] = Variable<String>(localImagePath);
    }
    map['image_pending'] = Variable<bool>(imagePending);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      clientUpdatedAt: Value(clientUpdatedAt),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      unitId: unitId == null && nullToAbsent
          ? const Value.absent()
          : Value(unitId),
      basePrice: basePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(basePrice),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      localImagePath: localImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(localImagePath),
      imagePending: Value(imagePending),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      clientUpdatedAt: serializer.fromJson<DateTime>(json['clientUpdatedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      unitId: serializer.fromJson<String?>(json['unitId']),
      basePrice: serializer.fromJson<double?>(json['basePrice']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      localImagePath: serializer.fromJson<String?>(json['localImagePath']),
      imagePending: serializer.fromJson<bool>(json['imagePending']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'clientUpdatedAt': serializer.toJson<DateTime>(clientUpdatedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'categoryId': serializer.toJson<String?>(categoryId),
      'unitId': serializer.toJson<String?>(unitId),
      'basePrice': serializer.toJson<double?>(basePrice),
      'imagePath': serializer.toJson<String?>(imagePath),
      'localImagePath': serializer.toJson<String?>(localImagePath),
      'imagePending': serializer.toJson<bool>(imagePending),
    };
  }

  Product copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    DateTime? clientUpdatedAt,
    DateTime? updatedAt,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> unitId = const Value.absent(),
    Value<double?> basePrice = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    Value<String?> localImagePath = const Value.absent(),
    bool? imagePending,
  }) => Product(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    unitId: unitId.present ? unitId.value : this.unitId,
    basePrice: basePrice.present ? basePrice.value : this.basePrice,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    localImagePath: localImagePath.present
        ? localImagePath.value
        : this.localImagePath,
    imagePending: imagePending ?? this.imagePending,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      clientUpdatedAt: data.clientUpdatedAt.present
          ? data.clientUpdatedAt.value
          : this.clientUpdatedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      basePrice: data.basePrice.present ? data.basePrice.value : this.basePrice,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      localImagePath: data.localImagePath.present
          ? data.localImagePath.value
          : this.localImagePath,
      imagePending: data.imagePending.present
          ? data.imagePending.value
          : this.imagePending,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('unitId: $unitId, ')
          ..write('basePrice: $basePrice, ')
          ..write('imagePath: $imagePath, ')
          ..write('localImagePath: $localImagePath, ')
          ..write('imagePending: $imagePending')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    deviceId,
    clientUpdatedAt,
    updatedAt,
    createdAt,
    deletedAt,
    name,
    description,
    categoryId,
    unitId,
    basePrice,
    imagePath,
    localImagePath,
    imagePending,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.deviceId == this.deviceId &&
          other.clientUpdatedAt == this.clientUpdatedAt &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.description == this.description &&
          other.categoryId == this.categoryId &&
          other.unitId == this.unitId &&
          other.basePrice == this.basePrice &&
          other.imagePath == this.imagePath &&
          other.localImagePath == this.localImagePath &&
          other.imagePending == this.imagePending);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String?> deviceId;
  final Value<DateTime> clientUpdatedAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> categoryId;
  final Value<String?> unitId;
  final Value<double?> basePrice;
  final Value<String?> imagePath;
  final Value<String?> localImagePath;
  final Value<bool> imagePending;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.basePrice = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.localImagePath = const Value.absent(),
    this.imagePending = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    required DateTime clientUpdatedAt,
    required DateTime updatedAt,
    required DateTime createdAt,
    this.deletedAt = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.basePrice = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.localImagePath = const Value.absent(),
    this.imagePending = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientUpdatedAt = Value(clientUpdatedAt),
       updatedAt = Value(updatedAt),
       createdAt = Value(createdAt),
       name = Value(name);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? deviceId,
    Expression<DateTime>? clientUpdatedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? categoryId,
    Expression<String>? unitId,
    Expression<double>? basePrice,
    Expression<String>? imagePath,
    Expression<String>? localImagePath,
    Expression<bool>? imagePending,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (deviceId != null) 'device_id': deviceId,
      if (clientUpdatedAt != null) 'client_updated_at': clientUpdatedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (categoryId != null) 'category_id': categoryId,
      if (unitId != null) 'unit_id': unitId,
      if (basePrice != null) 'base_price': basePrice,
      if (imagePath != null) 'image_path': imagePath,
      if (localImagePath != null) 'local_image_path': localImagePath,
      if (imagePending != null) 'image_pending': imagePending,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<String?>? deviceId,
    Value<DateTime>? clientUpdatedAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? categoryId,
    Value<String?>? unitId,
    Value<double?>? basePrice,
    Value<String?>? imagePath,
    Value<String?>? localImagePath,
    Value<bool>? imagePending,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      unitId: unitId ?? this.unitId,
      basePrice: basePrice ?? this.basePrice,
      imagePath: imagePath ?? this.imagePath,
      localImagePath: localImagePath ?? this.localImagePath,
      imagePending: imagePending ?? this.imagePending,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (clientUpdatedAt.present) {
      map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (basePrice.present) {
      map['base_price'] = Variable<double>(basePrice.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (localImagePath.present) {
      map['local_image_path'] = Variable<String>(localImagePath.value);
    }
    if (imagePending.present) {
      map['image_pending'] = Variable<bool>(imagePending.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('unitId: $unitId, ')
          ..write('basePrice: $basePrice, ')
          ..write('imagePath: $imagePath, ')
          ..write('localImagePath: $localImagePath, ')
          ..write('imagePending: $imagePending, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoresTable extends Stores with TableInfo<$StoresTable, Store> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientUpdatedAtMeta = const VerificationMeta(
    'clientUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> clientUpdatedAt =
      GeneratedColumn<DateTime>(
        'client_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    deviceId,
    clientUpdatedAt,
    updatedAt,
    createdAt,
    deletedAt,
    name,
    location,
    icon,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stores';
  @override
  VerificationContext validateIntegrity(
    Insertable<Store> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('client_updated_at')) {
      context.handle(
        _clientUpdatedAtMeta,
        clientUpdatedAt.isAcceptableOrUnknown(
          data['client_updated_at']!,
          _clientUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientUpdatedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Store map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Store(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      clientUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}client_updated_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $StoresTable createAlias(String alias) {
    return $StoresTable(attachedDatabase, alias);
  }
}

class Store extends DataClass implements Insertable<Store> {
  final String id;
  final String? userId;
  final String? deviceId;
  final DateTime clientUpdatedAt;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final String name;
  final String? location;
  final String? icon;
  final String? notes;
  const Store({
    required this.id,
    this.userId,
    this.deviceId,
    required this.clientUpdatedAt,
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
    required this.name,
    this.location,
    this.icon,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  StoresCompanion toCompanion(bool nullToAbsent) {
    return StoresCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      clientUpdatedAt: Value(clientUpdatedAt),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Store.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Store(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      clientUpdatedAt: serializer.fromJson<DateTime>(json['clientUpdatedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      location: serializer.fromJson<String?>(json['location']),
      icon: serializer.fromJson<String?>(json['icon']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'clientUpdatedAt': serializer.toJson<DateTime>(clientUpdatedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'location': serializer.toJson<String?>(location),
      'icon': serializer.toJson<String?>(icon),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Store copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    DateTime? clientUpdatedAt,
    DateTime? updatedAt,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    Value<String?> location = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Store(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    location: location.present ? location.value : this.location,
    icon: icon.present ? icon.value : this.icon,
    notes: notes.present ? notes.value : this.notes,
  );
  Store copyWithCompanion(StoresCompanion data) {
    return Store(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      clientUpdatedAt: data.clientUpdatedAt.present
          ? data.clientUpdatedAt.value
          : this.clientUpdatedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      location: data.location.present ? data.location.value : this.location,
      icon: data.icon.present ? data.icon.value : this.icon,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Store(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('icon: $icon, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    deviceId,
    clientUpdatedAt,
    updatedAt,
    createdAt,
    deletedAt,
    name,
    location,
    icon,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Store &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.deviceId == this.deviceId &&
          other.clientUpdatedAt == this.clientUpdatedAt &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.location == this.location &&
          other.icon == this.icon &&
          other.notes == this.notes);
}

class StoresCompanion extends UpdateCompanion<Store> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String?> deviceId;
  final Value<DateTime> clientUpdatedAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String?> location;
  final Value<String?> icon;
  final Value<String?> notes;
  final Value<int> rowid;
  const StoresCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.location = const Value.absent(),
    this.icon = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoresCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    required DateTime clientUpdatedAt,
    required DateTime updatedAt,
    required DateTime createdAt,
    this.deletedAt = const Value.absent(),
    required String name,
    this.location = const Value.absent(),
    this.icon = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientUpdatedAt = Value(clientUpdatedAt),
       updatedAt = Value(updatedAt),
       createdAt = Value(createdAt),
       name = Value(name);
  static Insertable<Store> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? deviceId,
    Expression<DateTime>? clientUpdatedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? location,
    Expression<String>? icon,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (deviceId != null) 'device_id': deviceId,
      if (clientUpdatedAt != null) 'client_updated_at': clientUpdatedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (icon != null) 'icon': icon,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoresCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<String?>? deviceId,
    Value<DateTime>? clientUpdatedAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String?>? location,
    Value<String?>? icon,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return StoresCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      location: location ?? this.location,
      icon: icon ?? this.icon,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (clientUpdatedAt.present) {
      map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoresCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('icon: $icon, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListsTable extends ShoppingLists
    with TableInfo<$ShoppingListsTable, ShoppingList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientUpdatedAtMeta = const VerificationMeta(
    'clientUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> clientUpdatedAt =
      GeneratedColumn<DateTime>(
        'client_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storeLocationMeta = const VerificationMeta(
    'storeLocation',
  );
  @override
  late final GeneratedColumn<String> storeLocation = GeneratedColumn<String>(
    'store_location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    deviceId,
    clientUpdatedAt,
    updatedAt,
    createdAt,
    deletedAt,
    name,
    status,
    notes,
    icon,
    storeId,
    storeLocation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingList> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('client_updated_at')) {
      context.handle(
        _clientUpdatedAtMeta,
        clientUpdatedAt.isAcceptableOrUnknown(
          data['client_updated_at']!,
          _clientUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientUpdatedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    }
    if (data.containsKey('store_location')) {
      context.handle(
        _storeLocationMeta,
        storeLocation.isAcceptableOrUnknown(
          data['store_location']!,
          _storeLocationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingList(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      clientUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}client_updated_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      ),
      storeLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_location'],
      ),
    );
  }

  @override
  $ShoppingListsTable createAlias(String alias) {
    return $ShoppingListsTable(attachedDatabase, alias);
  }
}

class ShoppingList extends DataClass implements Insertable<ShoppingList> {
  final String id;
  final String? userId;
  final String? deviceId;
  final DateTime clientUpdatedAt;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final String name;
  final String status;
  final String? notes;
  final String? icon;
  final String? storeId;
  final String? storeLocation;
  const ShoppingList({
    required this.id,
    this.userId,
    this.deviceId,
    required this.clientUpdatedAt,
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
    required this.name,
    required this.status,
    this.notes,
    this.icon,
    this.storeId,
    this.storeLocation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || storeId != null) {
      map['store_id'] = Variable<String>(storeId);
    }
    if (!nullToAbsent || storeLocation != null) {
      map['store_location'] = Variable<String>(storeLocation);
    }
    return map;
  }

  ShoppingListsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      clientUpdatedAt: Value(clientUpdatedAt),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      storeId: storeId == null && nullToAbsent
          ? const Value.absent()
          : Value(storeId),
      storeLocation: storeLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(storeLocation),
    );
  }

  factory ShoppingList.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingList(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      clientUpdatedAt: serializer.fromJson<DateTime>(json['clientUpdatedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      icon: serializer.fromJson<String?>(json['icon']),
      storeId: serializer.fromJson<String?>(json['storeId']),
      storeLocation: serializer.fromJson<String?>(json['storeLocation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'clientUpdatedAt': serializer.toJson<DateTime>(clientUpdatedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'icon': serializer.toJson<String?>(icon),
      'storeId': serializer.toJson<String?>(storeId),
      'storeLocation': serializer.toJson<String?>(storeLocation),
    };
  }

  ShoppingList copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    DateTime? clientUpdatedAt,
    DateTime? updatedAt,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    String? status,
    Value<String?> notes = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    Value<String?> storeId = const Value.absent(),
    Value<String?> storeLocation = const Value.absent(),
  }) => ShoppingList(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    icon: icon.present ? icon.value : this.icon,
    storeId: storeId.present ? storeId.value : this.storeId,
    storeLocation: storeLocation.present
        ? storeLocation.value
        : this.storeLocation,
  );
  ShoppingList copyWithCompanion(ShoppingListsCompanion data) {
    return ShoppingList(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      clientUpdatedAt: data.clientUpdatedAt.present
          ? data.clientUpdatedAt.value
          : this.clientUpdatedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      icon: data.icon.present ? data.icon.value : this.icon,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      storeLocation: data.storeLocation.present
          ? data.storeLocation.value
          : this.storeLocation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingList(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('icon: $icon, ')
          ..write('storeId: $storeId, ')
          ..write('storeLocation: $storeLocation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    deviceId,
    clientUpdatedAt,
    updatedAt,
    createdAt,
    deletedAt,
    name,
    status,
    notes,
    icon,
    storeId,
    storeLocation,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingList &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.deviceId == this.deviceId &&
          other.clientUpdatedAt == this.clientUpdatedAt &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.icon == this.icon &&
          other.storeId == this.storeId &&
          other.storeLocation == this.storeLocation);
}

class ShoppingListsCompanion extends UpdateCompanion<ShoppingList> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String?> deviceId;
  final Value<DateTime> clientUpdatedAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String> status;
  final Value<String?> notes;
  final Value<String?> icon;
  final Value<String?> storeId;
  final Value<String?> storeLocation;
  final Value<int> rowid;
  const ShoppingListsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.icon = const Value.absent(),
    this.storeId = const Value.absent(),
    this.storeLocation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingListsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    required DateTime clientUpdatedAt,
    required DateTime updatedAt,
    required DateTime createdAt,
    this.deletedAt = const Value.absent(),
    required String name,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.icon = const Value.absent(),
    this.storeId = const Value.absent(),
    this.storeLocation = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientUpdatedAt = Value(clientUpdatedAt),
       updatedAt = Value(updatedAt),
       createdAt = Value(createdAt),
       name = Value(name);
  static Insertable<ShoppingList> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? deviceId,
    Expression<DateTime>? clientUpdatedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<String>? icon,
    Expression<String>? storeId,
    Expression<String>? storeLocation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (deviceId != null) 'device_id': deviceId,
      if (clientUpdatedAt != null) 'client_updated_at': clientUpdatedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (icon != null) 'icon': icon,
      if (storeId != null) 'store_id': storeId,
      if (storeLocation != null) 'store_location': storeLocation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingListsCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<String?>? deviceId,
    Value<DateTime>? clientUpdatedAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String>? status,
    Value<String?>? notes,
    Value<String?>? icon,
    Value<String?>? storeId,
    Value<String?>? storeLocation,
    Value<int>? rowid,
  }) {
    return ShoppingListsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      icon: icon ?? this.icon,
      storeId: storeId ?? this.storeId,
      storeLocation: storeLocation ?? this.storeLocation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (clientUpdatedAt.present) {
      map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (storeLocation.present) {
      map['store_location'] = Variable<String>(storeLocation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('icon: $icon, ')
          ..write('storeId: $storeId, ')
          ..write('storeLocation: $storeLocation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ListItemsTable extends ListItems
    with TableInfo<$ListItemsTable, ListItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientUpdatedAtMeta = const VerificationMeta(
    'clientUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> clientUpdatedAt =
      GeneratedColumn<DateTime>(
        'client_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shoppingListIdMeta = const VerificationMeta(
    'shoppingListId',
  );
  @override
  late final GeneratedColumn<String> shoppingListId = GeneratedColumn<String>(
    'shopping_list_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
    'unit_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitAbbrMeta = const VerificationMeta(
    'unitAbbr',
  );
  @override
  late final GeneratedColumn<String> unitAbbr = GeneratedColumn<String>(
    'unit_abbr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyPlannedMeta = const VerificationMeta(
    'qtyPlanned',
  );
  @override
  late final GeneratedColumn<double> qtyPlanned = GeneratedColumn<double>(
    'qty_planned',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _qtyBoughtMeta = const VerificationMeta(
    'qtyBought',
  );
  @override
  late final GeneratedColumn<double> qtyBought = GeneratedColumn<double>(
    'qty_bought',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    deviceId,
    clientUpdatedAt,
    updatedAt,
    createdAt,
    deletedAt,
    shoppingListId,
    productId,
    unitId,
    unitAbbr,
    name,
    qtyPlanned,
    qtyBought,
    unitPrice,
    status,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'list_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ListItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('client_updated_at')) {
      context.handle(
        _clientUpdatedAtMeta,
        clientUpdatedAt.isAcceptableOrUnknown(
          data['client_updated_at']!,
          _clientUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientUpdatedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('shopping_list_id')) {
      context.handle(
        _shoppingListIdMeta,
        shoppingListId.isAcceptableOrUnknown(
          data['shopping_list_id']!,
          _shoppingListIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shoppingListIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    }
    if (data.containsKey('unit_abbr')) {
      context.handle(
        _unitAbbrMeta,
        unitAbbr.isAcceptableOrUnknown(data['unit_abbr']!, _unitAbbrMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('qty_planned')) {
      context.handle(
        _qtyPlannedMeta,
        qtyPlanned.isAcceptableOrUnknown(data['qty_planned']!, _qtyPlannedMeta),
      );
    }
    if (data.containsKey('qty_bought')) {
      context.handle(
        _qtyBoughtMeta,
        qtyBought.isAcceptableOrUnknown(data['qty_bought']!, _qtyBoughtMeta),
      );
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      clientUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}client_updated_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      shoppingListId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shopping_list_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      ),
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_id'],
      ),
      unitAbbr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_abbr'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      qtyPlanned: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}qty_planned'],
      )!,
      qtyBought: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}qty_bought'],
      ),
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ListItemsTable createAlias(String alias) {
    return $ListItemsTable(attachedDatabase, alias);
  }
}

class ListItem extends DataClass implements Insertable<ListItem> {
  final String id;
  final String? userId;
  final String? deviceId;
  final DateTime clientUpdatedAt;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final String shoppingListId;
  final String? productId;
  final String? unitId;
  final String? unitAbbr;
  final String name;
  final double qtyPlanned;
  final double? qtyBought;
  final double? unitPrice;
  final String status;
  final String? notes;
  const ListItem({
    required this.id,
    this.userId,
    this.deviceId,
    required this.clientUpdatedAt,
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
    required this.shoppingListId,
    this.productId,
    this.unitId,
    this.unitAbbr,
    required this.name,
    required this.qtyPlanned,
    this.qtyBought,
    this.unitPrice,
    required this.status,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['shopping_list_id'] = Variable<String>(shoppingListId);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    if (!nullToAbsent || unitId != null) {
      map['unit_id'] = Variable<String>(unitId);
    }
    if (!nullToAbsent || unitAbbr != null) {
      map['unit_abbr'] = Variable<String>(unitAbbr);
    }
    map['name'] = Variable<String>(name);
    map['qty_planned'] = Variable<double>(qtyPlanned);
    if (!nullToAbsent || qtyBought != null) {
      map['qty_bought'] = Variable<double>(qtyBought);
    }
    if (!nullToAbsent || unitPrice != null) {
      map['unit_price'] = Variable<double>(unitPrice);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ListItemsCompanion toCompanion(bool nullToAbsent) {
    return ListItemsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      clientUpdatedAt: Value(clientUpdatedAt),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      shoppingListId: Value(shoppingListId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      unitId: unitId == null && nullToAbsent
          ? const Value.absent()
          : Value(unitId),
      unitAbbr: unitAbbr == null && nullToAbsent
          ? const Value.absent()
          : Value(unitAbbr),
      name: Value(name),
      qtyPlanned: Value(qtyPlanned),
      qtyBought: qtyBought == null && nullToAbsent
          ? const Value.absent()
          : Value(qtyBought),
      unitPrice: unitPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(unitPrice),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory ListItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListItem(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      clientUpdatedAt: serializer.fromJson<DateTime>(json['clientUpdatedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      shoppingListId: serializer.fromJson<String>(json['shoppingListId']),
      productId: serializer.fromJson<String?>(json['productId']),
      unitId: serializer.fromJson<String?>(json['unitId']),
      unitAbbr: serializer.fromJson<String?>(json['unitAbbr']),
      name: serializer.fromJson<String>(json['name']),
      qtyPlanned: serializer.fromJson<double>(json['qtyPlanned']),
      qtyBought: serializer.fromJson<double?>(json['qtyBought']),
      unitPrice: serializer.fromJson<double?>(json['unitPrice']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'clientUpdatedAt': serializer.toJson<DateTime>(clientUpdatedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'shoppingListId': serializer.toJson<String>(shoppingListId),
      'productId': serializer.toJson<String?>(productId),
      'unitId': serializer.toJson<String?>(unitId),
      'unitAbbr': serializer.toJson<String?>(unitAbbr),
      'name': serializer.toJson<String>(name),
      'qtyPlanned': serializer.toJson<double>(qtyPlanned),
      'qtyBought': serializer.toJson<double?>(qtyBought),
      'unitPrice': serializer.toJson<double?>(unitPrice),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  ListItem copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    DateTime? clientUpdatedAt,
    DateTime? updatedAt,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? shoppingListId,
    Value<String?> productId = const Value.absent(),
    Value<String?> unitId = const Value.absent(),
    Value<String?> unitAbbr = const Value.absent(),
    String? name,
    double? qtyPlanned,
    Value<double?> qtyBought = const Value.absent(),
    Value<double?> unitPrice = const Value.absent(),
    String? status,
    Value<String?> notes = const Value.absent(),
  }) => ListItem(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    shoppingListId: shoppingListId ?? this.shoppingListId,
    productId: productId.present ? productId.value : this.productId,
    unitId: unitId.present ? unitId.value : this.unitId,
    unitAbbr: unitAbbr.present ? unitAbbr.value : this.unitAbbr,
    name: name ?? this.name,
    qtyPlanned: qtyPlanned ?? this.qtyPlanned,
    qtyBought: qtyBought.present ? qtyBought.value : this.qtyBought,
    unitPrice: unitPrice.present ? unitPrice.value : this.unitPrice,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
  );
  ListItem copyWithCompanion(ListItemsCompanion data) {
    return ListItem(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      clientUpdatedAt: data.clientUpdatedAt.present
          ? data.clientUpdatedAt.value
          : this.clientUpdatedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      shoppingListId: data.shoppingListId.present
          ? data.shoppingListId.value
          : this.shoppingListId,
      productId: data.productId.present ? data.productId.value : this.productId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      unitAbbr: data.unitAbbr.present ? data.unitAbbr.value : this.unitAbbr,
      name: data.name.present ? data.name.value : this.name,
      qtyPlanned: data.qtyPlanned.present
          ? data.qtyPlanned.value
          : this.qtyPlanned,
      qtyBought: data.qtyBought.present ? data.qtyBought.value : this.qtyBought,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListItem(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('productId: $productId, ')
          ..write('unitId: $unitId, ')
          ..write('unitAbbr: $unitAbbr, ')
          ..write('name: $name, ')
          ..write('qtyPlanned: $qtyPlanned, ')
          ..write('qtyBought: $qtyBought, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('status: $status, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    deviceId,
    clientUpdatedAt,
    updatedAt,
    createdAt,
    deletedAt,
    shoppingListId,
    productId,
    unitId,
    unitAbbr,
    name,
    qtyPlanned,
    qtyBought,
    unitPrice,
    status,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListItem &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.deviceId == this.deviceId &&
          other.clientUpdatedAt == this.clientUpdatedAt &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt &&
          other.shoppingListId == this.shoppingListId &&
          other.productId == this.productId &&
          other.unitId == this.unitId &&
          other.unitAbbr == this.unitAbbr &&
          other.name == this.name &&
          other.qtyPlanned == this.qtyPlanned &&
          other.qtyBought == this.qtyBought &&
          other.unitPrice == this.unitPrice &&
          other.status == this.status &&
          other.notes == this.notes);
}

class ListItemsCompanion extends UpdateCompanion<ListItem> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String?> deviceId;
  final Value<DateTime> clientUpdatedAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<String> shoppingListId;
  final Value<String?> productId;
  final Value<String?> unitId;
  final Value<String?> unitAbbr;
  final Value<String> name;
  final Value<double> qtyPlanned;
  final Value<double?> qtyBought;
  final Value<double?> unitPrice;
  final Value<String> status;
  final Value<String?> notes;
  final Value<int> rowid;
  const ListItemsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.shoppingListId = const Value.absent(),
    this.productId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.unitAbbr = const Value.absent(),
    this.name = const Value.absent(),
    this.qtyPlanned = const Value.absent(),
    this.qtyBought = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ListItemsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    required DateTime clientUpdatedAt,
    required DateTime updatedAt,
    required DateTime createdAt,
    this.deletedAt = const Value.absent(),
    required String shoppingListId,
    this.productId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.unitAbbr = const Value.absent(),
    required String name,
    this.qtyPlanned = const Value.absent(),
    this.qtyBought = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientUpdatedAt = Value(clientUpdatedAt),
       updatedAt = Value(updatedAt),
       createdAt = Value(createdAt),
       shoppingListId = Value(shoppingListId),
       name = Value(name);
  static Insertable<ListItem> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? deviceId,
    Expression<DateTime>? clientUpdatedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? shoppingListId,
    Expression<String>? productId,
    Expression<String>? unitId,
    Expression<String>? unitAbbr,
    Expression<String>? name,
    Expression<double>? qtyPlanned,
    Expression<double>? qtyBought,
    Expression<double>? unitPrice,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (deviceId != null) 'device_id': deviceId,
      if (clientUpdatedAt != null) 'client_updated_at': clientUpdatedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (shoppingListId != null) 'shopping_list_id': shoppingListId,
      if (productId != null) 'product_id': productId,
      if (unitId != null) 'unit_id': unitId,
      if (unitAbbr != null) 'unit_abbr': unitAbbr,
      if (name != null) 'name': name,
      if (qtyPlanned != null) 'qty_planned': qtyPlanned,
      if (qtyBought != null) 'qty_bought': qtyBought,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ListItemsCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<String?>? deviceId,
    Value<DateTime>? clientUpdatedAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<String>? shoppingListId,
    Value<String?>? productId,
    Value<String?>? unitId,
    Value<String?>? unitAbbr,
    Value<String>? name,
    Value<double>? qtyPlanned,
    Value<double?>? qtyBought,
    Value<double?>? unitPrice,
    Value<String>? status,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return ListItemsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      productId: productId ?? this.productId,
      unitId: unitId ?? this.unitId,
      unitAbbr: unitAbbr ?? this.unitAbbr,
      name: name ?? this.name,
      qtyPlanned: qtyPlanned ?? this.qtyPlanned,
      qtyBought: qtyBought ?? this.qtyBought,
      unitPrice: unitPrice ?? this.unitPrice,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (clientUpdatedAt.present) {
      map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (shoppingListId.present) {
      map['shopping_list_id'] = Variable<String>(shoppingListId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (unitAbbr.present) {
      map['unit_abbr'] = Variable<String>(unitAbbr.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (qtyPlanned.present) {
      map['qty_planned'] = Variable<double>(qtyPlanned.value);
    }
    if (qtyBought.present) {
      map['qty_bought'] = Variable<double>(qtyBought.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListItemsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('productId: $productId, ')
          ..write('unitId: $unitId, ')
          ..write('unitAbbr: $unitAbbr, ')
          ..write('name: $name, ')
          ..write('qtyPlanned: $qtyPlanned, ')
          ..write('qtyBought: $qtyBought, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseHistoriesTable extends PurchaseHistories
    with TableInfo<$PurchaseHistoriesTable, PurchaseHistory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientUpdatedAtMeta = const VerificationMeta(
    'clientUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> clientUpdatedAt =
      GeneratedColumn<DateTime>(
        'client_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shoppingListIdMeta = const VerificationMeta(
    'shoppingListId',
  );
  @override
  late final GeneratedColumn<String> shoppingListId = GeneratedColumn<String>(
    'shopping_list_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storeLocationMeta = const VerificationMeta(
    'storeLocation',
  );
  @override
  late final GeneratedColumn<String> storeLocation = GeneratedColumn<String>(
    'store_location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchasedAtMeta = const VerificationMeta(
    'purchasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
    'purchased_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    deviceId,
    clientUpdatedAt,
    updatedAt,
    createdAt,
    deletedAt,
    shoppingListId,
    storeLocation,
    purchasedAt,
    total,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_histories';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseHistory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('client_updated_at')) {
      context.handle(
        _clientUpdatedAtMeta,
        clientUpdatedAt.isAcceptableOrUnknown(
          data['client_updated_at']!,
          _clientUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientUpdatedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('shopping_list_id')) {
      context.handle(
        _shoppingListIdMeta,
        shoppingListId.isAcceptableOrUnknown(
          data['shopping_list_id']!,
          _shoppingListIdMeta,
        ),
      );
    }
    if (data.containsKey('store_location')) {
      context.handle(
        _storeLocationMeta,
        storeLocation.isAcceptableOrUnknown(
          data['store_location']!,
          _storeLocationMeta,
        ),
      );
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
        _purchasedAtMeta,
        purchasedAt.isAcceptableOrUnknown(
          data['purchased_at']!,
          _purchasedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchasedAtMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseHistory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      clientUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}client_updated_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      shoppingListId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shopping_list_id'],
      ),
      storeLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_location'],
      ),
      purchasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_at'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
    );
  }

  @override
  $PurchaseHistoriesTable createAlias(String alias) {
    return $PurchaseHistoriesTable(attachedDatabase, alias);
  }
}

class PurchaseHistory extends DataClass implements Insertable<PurchaseHistory> {
  final String id;
  final String? userId;
  final String? deviceId;
  final DateTime clientUpdatedAt;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final String? shoppingListId;
  final String? storeLocation;
  final DateTime purchasedAt;
  final double total;
  const PurchaseHistory({
    required this.id,
    this.userId,
    this.deviceId,
    required this.clientUpdatedAt,
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
    this.shoppingListId,
    this.storeLocation,
    required this.purchasedAt,
    required this.total,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || shoppingListId != null) {
      map['shopping_list_id'] = Variable<String>(shoppingListId);
    }
    if (!nullToAbsent || storeLocation != null) {
      map['store_location'] = Variable<String>(storeLocation);
    }
    map['purchased_at'] = Variable<DateTime>(purchasedAt);
    map['total'] = Variable<double>(total);
    return map;
  }

  PurchaseHistoriesCompanion toCompanion(bool nullToAbsent) {
    return PurchaseHistoriesCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      clientUpdatedAt: Value(clientUpdatedAt),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      shoppingListId: shoppingListId == null && nullToAbsent
          ? const Value.absent()
          : Value(shoppingListId),
      storeLocation: storeLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(storeLocation),
      purchasedAt: Value(purchasedAt),
      total: Value(total),
    );
  }

  factory PurchaseHistory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseHistory(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      clientUpdatedAt: serializer.fromJson<DateTime>(json['clientUpdatedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      shoppingListId: serializer.fromJson<String?>(json['shoppingListId']),
      storeLocation: serializer.fromJson<String?>(json['storeLocation']),
      purchasedAt: serializer.fromJson<DateTime>(json['purchasedAt']),
      total: serializer.fromJson<double>(json['total']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'clientUpdatedAt': serializer.toJson<DateTime>(clientUpdatedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'shoppingListId': serializer.toJson<String?>(shoppingListId),
      'storeLocation': serializer.toJson<String?>(storeLocation),
      'purchasedAt': serializer.toJson<DateTime>(purchasedAt),
      'total': serializer.toJson<double>(total),
    };
  }

  PurchaseHistory copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    DateTime? clientUpdatedAt,
    DateTime? updatedAt,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> shoppingListId = const Value.absent(),
    Value<String?> storeLocation = const Value.absent(),
    DateTime? purchasedAt,
    double? total,
  }) => PurchaseHistory(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    shoppingListId: shoppingListId.present
        ? shoppingListId.value
        : this.shoppingListId,
    storeLocation: storeLocation.present
        ? storeLocation.value
        : this.storeLocation,
    purchasedAt: purchasedAt ?? this.purchasedAt,
    total: total ?? this.total,
  );
  PurchaseHistory copyWithCompanion(PurchaseHistoriesCompanion data) {
    return PurchaseHistory(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      clientUpdatedAt: data.clientUpdatedAt.present
          ? data.clientUpdatedAt.value
          : this.clientUpdatedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      shoppingListId: data.shoppingListId.present
          ? data.shoppingListId.value
          : this.shoppingListId,
      storeLocation: data.storeLocation.present
          ? data.storeLocation.value
          : this.storeLocation,
      purchasedAt: data.purchasedAt.present
          ? data.purchasedAt.value
          : this.purchasedAt,
      total: data.total.present ? data.total.value : this.total,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseHistory(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('storeLocation: $storeLocation, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    deviceId,
    clientUpdatedAt,
    updatedAt,
    createdAt,
    deletedAt,
    shoppingListId,
    storeLocation,
    purchasedAt,
    total,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseHistory &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.deviceId == this.deviceId &&
          other.clientUpdatedAt == this.clientUpdatedAt &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt &&
          other.shoppingListId == this.shoppingListId &&
          other.storeLocation == this.storeLocation &&
          other.purchasedAt == this.purchasedAt &&
          other.total == this.total);
}

class PurchaseHistoriesCompanion extends UpdateCompanion<PurchaseHistory> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String?> deviceId;
  final Value<DateTime> clientUpdatedAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> shoppingListId;
  final Value<String?> storeLocation;
  final Value<DateTime> purchasedAt;
  final Value<double> total;
  final Value<int> rowid;
  const PurchaseHistoriesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.shoppingListId = const Value.absent(),
    this.storeLocation = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.total = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseHistoriesCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    required DateTime clientUpdatedAt,
    required DateTime updatedAt,
    required DateTime createdAt,
    this.deletedAt = const Value.absent(),
    this.shoppingListId = const Value.absent(),
    this.storeLocation = const Value.absent(),
    required DateTime purchasedAt,
    this.total = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientUpdatedAt = Value(clientUpdatedAt),
       updatedAt = Value(updatedAt),
       createdAt = Value(createdAt),
       purchasedAt = Value(purchasedAt);
  static Insertable<PurchaseHistory> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? deviceId,
    Expression<DateTime>? clientUpdatedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? shoppingListId,
    Expression<String>? storeLocation,
    Expression<DateTime>? purchasedAt,
    Expression<double>? total,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (deviceId != null) 'device_id': deviceId,
      if (clientUpdatedAt != null) 'client_updated_at': clientUpdatedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (shoppingListId != null) 'shopping_list_id': shoppingListId,
      if (storeLocation != null) 'store_location': storeLocation,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (total != null) 'total': total,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseHistoriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<String?>? deviceId,
    Value<DateTime>? clientUpdatedAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? shoppingListId,
    Value<String?>? storeLocation,
    Value<DateTime>? purchasedAt,
    Value<double>? total,
    Value<int>? rowid,
  }) {
    return PurchaseHistoriesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      storeLocation: storeLocation ?? this.storeLocation,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      total: total ?? this.total,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (clientUpdatedAt.present) {
      map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (shoppingListId.present) {
      map['shopping_list_id'] = Variable<String>(shoppingListId.value);
    }
    if (storeLocation.present) {
      map['store_location'] = Variable<String>(storeLocation.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('storeLocation: $storeLocation, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('total: $total, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseHistoryItemsTable extends PurchaseHistoryItems
    with TableInfo<$PurchaseHistoryItemsTable, PurchaseHistoryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseHistoryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientUpdatedAtMeta = const VerificationMeta(
    'clientUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> clientUpdatedAt =
      GeneratedColumn<DateTime>(
        'client_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseHistoryIdMeta = const VerificationMeta(
    'purchaseHistoryId',
  );
  @override
  late final GeneratedColumn<String> purchaseHistoryId =
      GeneratedColumn<String>(
        'purchase_history_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitAbbrMeta = const VerificationMeta(
    'unitAbbr',
  );
  @override
  late final GeneratedColumn<String> unitAbbr = GeneratedColumn<String>(
    'unit_abbr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lineTotalMeta = const VerificationMeta(
    'lineTotal',
  );
  @override
  late final GeneratedColumn<double> lineTotal = GeneratedColumn<double>(
    'line_total',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    deviceId,
    clientUpdatedAt,
    updatedAt,
    createdAt,
    deletedAt,
    purchaseHistoryId,
    productId,
    name,
    unitAbbr,
    quantity,
    unitPrice,
    lineTotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_history_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseHistoryItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('client_updated_at')) {
      context.handle(
        _clientUpdatedAtMeta,
        clientUpdatedAt.isAcceptableOrUnknown(
          data['client_updated_at']!,
          _clientUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientUpdatedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('purchase_history_id')) {
      context.handle(
        _purchaseHistoryIdMeta,
        purchaseHistoryId.isAcceptableOrUnknown(
          data['purchase_history_id']!,
          _purchaseHistoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseHistoryIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit_abbr')) {
      context.handle(
        _unitAbbrMeta,
        unitAbbr.isAcceptableOrUnknown(data['unit_abbr']!, _unitAbbrMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    }
    if (data.containsKey('line_total')) {
      context.handle(
        _lineTotalMeta,
        lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseHistoryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseHistoryItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      clientUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}client_updated_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      purchaseHistoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_history_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unitAbbr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_abbr'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      ),
      lineTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}line_total'],
      ),
    );
  }

  @override
  $PurchaseHistoryItemsTable createAlias(String alias) {
    return $PurchaseHistoryItemsTable(attachedDatabase, alias);
  }
}

class PurchaseHistoryItem extends DataClass
    implements Insertable<PurchaseHistoryItem> {
  final String id;
  final String? userId;
  final String? deviceId;
  final DateTime clientUpdatedAt;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final String purchaseHistoryId;
  final String? productId;
  final String name;
  final String? unitAbbr;
  final double quantity;
  final double? unitPrice;
  final double? lineTotal;
  const PurchaseHistoryItem({
    required this.id,
    this.userId,
    this.deviceId,
    required this.clientUpdatedAt,
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
    required this.purchaseHistoryId,
    this.productId,
    required this.name,
    this.unitAbbr,
    required this.quantity,
    this.unitPrice,
    this.lineTotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['purchase_history_id'] = Variable<String>(purchaseHistoryId);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || unitAbbr != null) {
      map['unit_abbr'] = Variable<String>(unitAbbr);
    }
    map['quantity'] = Variable<double>(quantity);
    if (!nullToAbsent || unitPrice != null) {
      map['unit_price'] = Variable<double>(unitPrice);
    }
    if (!nullToAbsent || lineTotal != null) {
      map['line_total'] = Variable<double>(lineTotal);
    }
    return map;
  }

  PurchaseHistoryItemsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseHistoryItemsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      clientUpdatedAt: Value(clientUpdatedAt),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      purchaseHistoryId: Value(purchaseHistoryId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      name: Value(name),
      unitAbbr: unitAbbr == null && nullToAbsent
          ? const Value.absent()
          : Value(unitAbbr),
      quantity: Value(quantity),
      unitPrice: unitPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(unitPrice),
      lineTotal: lineTotal == null && nullToAbsent
          ? const Value.absent()
          : Value(lineTotal),
    );
  }

  factory PurchaseHistoryItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseHistoryItem(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      clientUpdatedAt: serializer.fromJson<DateTime>(json['clientUpdatedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      purchaseHistoryId: serializer.fromJson<String>(json['purchaseHistoryId']),
      productId: serializer.fromJson<String?>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      unitAbbr: serializer.fromJson<String?>(json['unitAbbr']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitPrice: serializer.fromJson<double?>(json['unitPrice']),
      lineTotal: serializer.fromJson<double?>(json['lineTotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'clientUpdatedAt': serializer.toJson<DateTime>(clientUpdatedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'purchaseHistoryId': serializer.toJson<String>(purchaseHistoryId),
      'productId': serializer.toJson<String?>(productId),
      'name': serializer.toJson<String>(name),
      'unitAbbr': serializer.toJson<String?>(unitAbbr),
      'quantity': serializer.toJson<double>(quantity),
      'unitPrice': serializer.toJson<double?>(unitPrice),
      'lineTotal': serializer.toJson<double?>(lineTotal),
    };
  }

  PurchaseHistoryItem copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    DateTime? clientUpdatedAt,
    DateTime? updatedAt,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? purchaseHistoryId,
    Value<String?> productId = const Value.absent(),
    String? name,
    Value<String?> unitAbbr = const Value.absent(),
    double? quantity,
    Value<double?> unitPrice = const Value.absent(),
    Value<double?> lineTotal = const Value.absent(),
  }) => PurchaseHistoryItem(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    purchaseHistoryId: purchaseHistoryId ?? this.purchaseHistoryId,
    productId: productId.present ? productId.value : this.productId,
    name: name ?? this.name,
    unitAbbr: unitAbbr.present ? unitAbbr.value : this.unitAbbr,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice.present ? unitPrice.value : this.unitPrice,
    lineTotal: lineTotal.present ? lineTotal.value : this.lineTotal,
  );
  PurchaseHistoryItem copyWithCompanion(PurchaseHistoryItemsCompanion data) {
    return PurchaseHistoryItem(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      clientUpdatedAt: data.clientUpdatedAt.present
          ? data.clientUpdatedAt.value
          : this.clientUpdatedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      purchaseHistoryId: data.purchaseHistoryId.present
          ? data.purchaseHistoryId.value
          : this.purchaseHistoryId,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      unitAbbr: data.unitAbbr.present ? data.unitAbbr.value : this.unitAbbr,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseHistoryItem(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('purchaseHistoryId: $purchaseHistoryId, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('unitAbbr: $unitAbbr, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    deviceId,
    clientUpdatedAt,
    updatedAt,
    createdAt,
    deletedAt,
    purchaseHistoryId,
    productId,
    name,
    unitAbbr,
    quantity,
    unitPrice,
    lineTotal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseHistoryItem &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.deviceId == this.deviceId &&
          other.clientUpdatedAt == this.clientUpdatedAt &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt &&
          other.purchaseHistoryId == this.purchaseHistoryId &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.unitAbbr == this.unitAbbr &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.lineTotal == this.lineTotal);
}

class PurchaseHistoryItemsCompanion
    extends UpdateCompanion<PurchaseHistoryItem> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String?> deviceId;
  final Value<DateTime> clientUpdatedAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<String> purchaseHistoryId;
  final Value<String?> productId;
  final Value<String> name;
  final Value<String?> unitAbbr;
  final Value<double> quantity;
  final Value<double?> unitPrice;
  final Value<double?> lineTotal;
  final Value<int> rowid;
  const PurchaseHistoryItemsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.purchaseHistoryId = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.unitAbbr = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseHistoryItemsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    required DateTime clientUpdatedAt,
    required DateTime updatedAt,
    required DateTime createdAt,
    this.deletedAt = const Value.absent(),
    required String purchaseHistoryId,
    this.productId = const Value.absent(),
    required String name,
    this.unitAbbr = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientUpdatedAt = Value(clientUpdatedAt),
       updatedAt = Value(updatedAt),
       createdAt = Value(createdAt),
       purchaseHistoryId = Value(purchaseHistoryId),
       name = Value(name);
  static Insertable<PurchaseHistoryItem> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? deviceId,
    Expression<DateTime>? clientUpdatedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? purchaseHistoryId,
    Expression<String>? productId,
    Expression<String>? name,
    Expression<String>? unitAbbr,
    Expression<double>? quantity,
    Expression<double>? unitPrice,
    Expression<double>? lineTotal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (deviceId != null) 'device_id': deviceId,
      if (clientUpdatedAt != null) 'client_updated_at': clientUpdatedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (purchaseHistoryId != null) 'purchase_history_id': purchaseHistoryId,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (unitAbbr != null) 'unit_abbr': unitAbbr,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (lineTotal != null) 'line_total': lineTotal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseHistoryItemsCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<String?>? deviceId,
    Value<DateTime>? clientUpdatedAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<String>? purchaseHistoryId,
    Value<String?>? productId,
    Value<String>? name,
    Value<String?>? unitAbbr,
    Value<double>? quantity,
    Value<double?>? unitPrice,
    Value<double?>? lineTotal,
    Value<int>? rowid,
  }) {
    return PurchaseHistoryItemsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      purchaseHistoryId: purchaseHistoryId ?? this.purchaseHistoryId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      unitAbbr: unitAbbr ?? this.unitAbbr,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (clientUpdatedAt.present) {
      map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (purchaseHistoryId.present) {
      map['purchase_history_id'] = Variable<String>(purchaseHistoryId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unitAbbr.present) {
      map['unit_abbr'] = Variable<String>(unitAbbr.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<double>(lineTotal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseHistoryItemsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('purchaseHistoryId: $purchaseHistoryId, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('unitAbbr: $unitAbbr, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientUpdatedAtMeta = const VerificationMeta(
    'clientUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> clientUpdatedAt =
      GeneratedColumn<DateTime>(
        'client_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entity,
    entityId,
    op,
    payloadJson,
    clientUpdatedAt,
    createdAt,
    attempts,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('client_updated_at')) {
      context.handle(
        _clientUpdatedAtMeta,
        clientUpdatedAt.isAcceptableOrUnknown(
          data['client_updated_at']!,
          _clientUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientUpdatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      clientUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}client_updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxData extends DataClass implements Insertable<SyncOutboxData> {
  final String id;
  final String entity;
  final String entityId;

  /// Wire ops: create | update | delete (server also accepts upsert).
  final String op;
  final String payloadJson;
  final DateTime clientUpdatedAt;
  final DateTime createdAt;
  final int attempts;
  final String? lastError;
  const SyncOutboxData({
    required this.id,
    required this.entity,
    required this.entityId,
    required this.op,
    required this.payloadJson,
    required this.clientUpdatedAt,
    required this.createdAt,
    required this.attempts,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity'] = Variable<String>(entity);
    map['entity_id'] = Variable<String>(entityId);
    map['op'] = Variable<String>(op);
    map['payload_json'] = Variable<String>(payloadJson);
    map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      id: Value(id),
      entity: Value(entity),
      entityId: Value(entityId),
      op: Value(op),
      payloadJson: Value(payloadJson),
      clientUpdatedAt: Value(clientUpdatedAt),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory SyncOutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxData(
      id: serializer.fromJson<String>(json['id']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String>(json['entityId']),
      op: serializer.fromJson<String>(json['op']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      clientUpdatedAt: serializer.fromJson<DateTime>(json['clientUpdatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String>(entityId),
      'op': serializer.toJson<String>(op),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'clientUpdatedAt': serializer.toJson<DateTime>(clientUpdatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  SyncOutboxData copyWith({
    String? id,
    String? entity,
    String? entityId,
    String? op,
    String? payloadJson,
    DateTime? clientUpdatedAt,
    DateTime? createdAt,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
  }) => SyncOutboxData(
    id: id ?? this.id,
    entity: entity ?? this.entity,
    entityId: entityId ?? this.entityId,
    op: op ?? this.op,
    payloadJson: payloadJson ?? this.payloadJson,
    clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  SyncOutboxData copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxData(
      id: data.id.present ? data.id.value : this.id,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      op: data.op.present ? data.op.value : this.op,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      clientUpdatedAt: data.clientUpdatedAt.present
          ? data.clientUpdatedAt.value
          : this.clientUpdatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxData(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entity,
    entityId,
    op,
    payloadJson,
    clientUpdatedAt,
    createdAt,
    attempts,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxData &&
          other.id == this.id &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.op == this.op &&
          other.payloadJson == this.payloadJson &&
          other.clientUpdatedAt == this.clientUpdatedAt &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxData> {
  final Value<String> id;
  final Value<String> entity;
  final Value<String> entityId;
  final Value<String> op;
  final Value<String> payloadJson;
  final Value<DateTime> clientUpdatedAt;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.id = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.op = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String id,
    required String entity,
    required String entityId,
    required String op,
    required String payloadJson,
    required DateTime clientUpdatedAt,
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entity = Value(entity),
       entityId = Value(entityId),
       op = Value(op),
       payloadJson = Value(payloadJson),
       clientUpdatedAt = Value(clientUpdatedAt),
       createdAt = Value(createdAt);
  static Insertable<SyncOutboxData> custom({
    Expression<String>? id,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? op,
    Expression<String>? payloadJson,
    Expression<DateTime>? clientUpdatedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (op != null) 'op': op,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (clientUpdatedAt != null) 'client_updated_at': clientUpdatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<String>? id,
    Value<String>? entity,
    Value<String>? entityId,
    Value<String>? op,
    Value<String>? payloadJson,
    Value<DateTime>? clientUpdatedAt,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return SyncOutboxCompanion(
      id: id ?? this.id,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      op: op ?? this.op,
      payloadJson: payloadJson ?? this.payloadJson,
      clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (clientUpdatedAt.present) {
      map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetaTable extends SyncMeta
    with TableInfo<$SyncMetaTable, SyncMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetaData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SyncMetaTable createAlias(String alias) {
    return $SyncMetaTable(attachedDatabase, alias);
  }
}

class SyncMetaData extends DataClass implements Insertable<SyncMetaData> {
  final String key;
  final String value;
  const SyncMetaData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SyncMetaCompanion toCompanion(bool nullToAbsent) {
    return SyncMetaCompanion(key: Value(key), value: Value(value));
  }

  factory SyncMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetaData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SyncMetaData copyWith({String? key, String? value}) =>
      SyncMetaData(key: key ?? this.key, value: value ?? this.value);
  SyncMetaData copyWithCompanion(SyncMetaCompanion data) {
    return SyncMetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetaData &&
          other.key == this.key &&
          other.value == this.value);
}

class SyncMetaCompanion extends UpdateCompanion<SyncMetaData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SyncMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SyncMetaData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SyncMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetMovementsTable extends BudgetMovements
    with TableInfo<$BudgetMovementsTable, BudgetMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountUsdMeta = const VerificationMeta(
    'amountUsd',
  );
  @override
  late final GeneratedColumn<double> amountUsd = GeneratedColumn<double>(
    'amount_usd',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    amountUsd,
    occurredAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_movements';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetMovement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('amount_usd')) {
      context.handle(
        _amountUsdMeta,
        amountUsd.isAcceptableOrUnknown(data['amount_usd']!, _amountUsdMeta),
      );
    } else if (isInserting) {
      context.missing(_amountUsdMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetMovement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      amountUsd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_usd'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BudgetMovementsTable createAlias(String alias) {
    return $BudgetMovementsTable(attachedDatabase, alias);
  }
}

class BudgetMovement extends DataClass implements Insertable<BudgetMovement> {
  final String id;
  final String label;
  final double amountUsd;
  final DateTime occurredAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BudgetMovement({
    required this.id,
    required this.label,
    required this.amountUsd,
    required this.occurredAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['amount_usd'] = Variable<double>(amountUsd);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BudgetMovementsCompanion toCompanion(bool nullToAbsent) {
    return BudgetMovementsCompanion(
      id: Value(id),
      label: Value(label),
      amountUsd: Value(amountUsd),
      occurredAt: Value(occurredAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BudgetMovement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetMovement(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      amountUsd: serializer.fromJson<double>(json['amountUsd']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'amountUsd': serializer.toJson<double>(amountUsd),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BudgetMovement copyWith({
    String? id,
    String? label,
    double? amountUsd,
    DateTime? occurredAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BudgetMovement(
    id: id ?? this.id,
    label: label ?? this.label,
    amountUsd: amountUsd ?? this.amountUsd,
    occurredAt: occurredAt ?? this.occurredAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BudgetMovement copyWithCompanion(BudgetMovementsCompanion data) {
    return BudgetMovement(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      amountUsd: data.amountUsd.present ? data.amountUsd.value : this.amountUsd,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetMovement(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('amountUsd: $amountUsd, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, label, amountUsd, occurredAt, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetMovement &&
          other.id == this.id &&
          other.label == this.label &&
          other.amountUsd == this.amountUsd &&
          other.occurredAt == this.occurredAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetMovementsCompanion extends UpdateCompanion<BudgetMovement> {
  final Value<String> id;
  final Value<String> label;
  final Value<double> amountUsd;
  final Value<DateTime> occurredAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BudgetMovementsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.amountUsd = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetMovementsCompanion.insert({
    required String id,
    required String label,
    required double amountUsd,
    required DateTime occurredAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       amountUsd = Value(amountUsd),
       occurredAt = Value(occurredAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BudgetMovement> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<double>? amountUsd,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (amountUsd != null) 'amount_usd': amountUsd,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetMovementsCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<double>? amountUsd,
    Value<DateTime>? occurredAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BudgetMovementsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      amountUsd: amountUsd ?? this.amountUsd,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (amountUsd.present) {
      map['amount_usd'] = Variable<double>(amountUsd.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetMovementsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('amountUsd: $amountUsd, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $StoresTable stores = $StoresTable(this);
  late final $ShoppingListsTable shoppingLists = $ShoppingListsTable(this);
  late final $ListItemsTable listItems = $ListItemsTable(this);
  late final $PurchaseHistoriesTable purchaseHistories =
      $PurchaseHistoriesTable(this);
  late final $PurchaseHistoryItemsTable purchaseHistoryItems =
      $PurchaseHistoryItemsTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $SyncMetaTable syncMeta = $SyncMetaTable(this);
  late final $BudgetMovementsTable budgetMovements = $BudgetMovementsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    units,
    products,
    stores,
    shoppingLists,
    listItems,
    purchaseHistories,
    purchaseHistoryItems,
    syncOutbox,
    syncMeta,
    budgetMovements,
  ];
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      Value<String?> userId,
      Value<String?> deviceId,
      required DateTime clientUpdatedAt,
      required DateTime updatedAt,
      required DateTime createdAt,
      Value<DateTime?> deletedAt,
      required String name,
      Value<String?> icon,
      Value<String?> color,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<String?> deviceId,
      Value<DateTime> clientUpdatedAt,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<String> name,
      Value<String?> icon,
      Value<String?> color,
      Value<int> rowid,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<DateTime> clientUpdatedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                userId: userId,
                deviceId: deviceId,
                clientUpdatedAt: clientUpdatedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
                deletedAt: deletedAt,
                name: name,
                icon: icon,
                color: color,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required DateTime clientUpdatedAt,
                required DateTime updatedAt,
                required DateTime createdAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                Value<String?> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                userId: userId,
                deviceId: deviceId,
                clientUpdatedAt: clientUpdatedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
                deletedAt: deletedAt,
                name: name,
                icon: icon,
                color: color,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$UnitsTableCreateCompanionBuilder =
    UnitsCompanion Function({
      required String id,
      Value<String?> userId,
      Value<String?> deviceId,
      required DateTime clientUpdatedAt,
      required DateTime updatedAt,
      required DateTime createdAt,
      Value<DateTime?> deletedAt,
      required String name,
      Value<String?> abbreviation,
      Value<int> rowid,
    });
typedef $$UnitsTableUpdateCompanionBuilder =
    UnitsCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<String?> deviceId,
      Value<DateTime> clientUpdatedAt,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<String> name,
      Value<String?> abbreviation,
      Value<int> rowid,
    });

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => column,
  );
}

class $$UnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnitsTable,
          Unit,
          $$UnitsTableFilterComposer,
          $$UnitsTableOrderingComposer,
          $$UnitsTableAnnotationComposer,
          $$UnitsTableCreateCompanionBuilder,
          $$UnitsTableUpdateCompanionBuilder,
          (Unit, BaseReferences<_$AppDatabase, $UnitsTable, Unit>),
          Unit,
          PrefetchHooks Function()
        > {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<DateTime> clientUpdatedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> abbreviation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitsCompanion(
                id: id,
                userId: userId,
                deviceId: deviceId,
                clientUpdatedAt: clientUpdatedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
                deletedAt: deletedAt,
                name: name,
                abbreviation: abbreviation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required DateTime clientUpdatedAt,
                required DateTime updatedAt,
                required DateTime createdAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                Value<String?> abbreviation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitsCompanion.insert(
                id: id,
                userId: userId,
                deviceId: deviceId,
                clientUpdatedAt: clientUpdatedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
                deletedAt: deletedAt,
                name: name,
                abbreviation: abbreviation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnitsTable,
      Unit,
      $$UnitsTableFilterComposer,
      $$UnitsTableOrderingComposer,
      $$UnitsTableAnnotationComposer,
      $$UnitsTableCreateCompanionBuilder,
      $$UnitsTableUpdateCompanionBuilder,
      (Unit, BaseReferences<_$AppDatabase, $UnitsTable, Unit>),
      Unit,
      PrefetchHooks Function()
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      Value<String?> userId,
      Value<String?> deviceId,
      required DateTime clientUpdatedAt,
      required DateTime updatedAt,
      required DateTime createdAt,
      Value<DateTime?> deletedAt,
      required String name,
      Value<String?> description,
      Value<String?> categoryId,
      Value<String?> unitId,
      Value<double?> basePrice,
      Value<String?> imagePath,
      Value<String?> localImagePath,
      Value<bool> imagePending,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<String?> deviceId,
      Value<DateTime> clientUpdatedAt,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<String> name,
      Value<String?> description,
      Value<String?> categoryId,
      Value<String?> unitId,
      Value<double?> basePrice,
      Value<String?> imagePath,
      Value<String?> localImagePath,
      Value<bool> imagePending,
      Value<int> rowid,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get basePrice => $composableBuilder(
    column: $table.basePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localImagePath => $composableBuilder(
    column: $table.localImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get imagePending => $composableBuilder(
    column: $table.imagePending,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get basePrice => $composableBuilder(
    column: $table.basePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localImagePath => $composableBuilder(
    column: $table.localImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get imagePending => $composableBuilder(
    column: $table.imagePending,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<double> get basePrice =>
      $composableBuilder(column: $table.basePrice, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get localImagePath => $composableBuilder(
    column: $table.localImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get imagePending => $composableBuilder(
    column: $table.imagePending,
    builder: (column) => column,
  );
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<DateTime> clientUpdatedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> unitId = const Value.absent(),
                Value<double?> basePrice = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> localImagePath = const Value.absent(),
                Value<bool> imagePending = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                userId: userId,
                deviceId: deviceId,
                clientUpdatedAt: clientUpdatedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
                deletedAt: deletedAt,
                name: name,
                description: description,
                categoryId: categoryId,
                unitId: unitId,
                basePrice: basePrice,
                imagePath: imagePath,
                localImagePath: localImagePath,
                imagePending: imagePending,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required DateTime clientUpdatedAt,
                required DateTime updatedAt,
                required DateTime createdAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> unitId = const Value.absent(),
                Value<double?> basePrice = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> localImagePath = const Value.absent(),
                Value<bool> imagePending = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                userId: userId,
                deviceId: deviceId,
                clientUpdatedAt: clientUpdatedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
                deletedAt: deletedAt,
                name: name,
                description: description,
                categoryId: categoryId,
                unitId: unitId,
                basePrice: basePrice,
                imagePath: imagePath,
                localImagePath: localImagePath,
                imagePending: imagePending,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$StoresTableCreateCompanionBuilder =
    StoresCompanion Function({
      required String id,
      Value<String?> userId,
      Value<String?> deviceId,
      required DateTime clientUpdatedAt,
      required DateTime updatedAt,
      required DateTime createdAt,
      Value<DateTime?> deletedAt,
      required String name,
      Value<String?> location,
      Value<String?> icon,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$StoresTableUpdateCompanionBuilder =
    StoresCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<String?> deviceId,
      Value<DateTime> clientUpdatedAt,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<String> name,
      Value<String?> location,
      Value<String?> icon,
      Value<String?> notes,
      Value<int> rowid,
    });

class $$StoresTableFilterComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoresTableOrderingComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$StoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoresTable,
          Store,
          $$StoresTableFilterComposer,
          $$StoresTableOrderingComposer,
          $$StoresTableAnnotationComposer,
          $$StoresTableCreateCompanionBuilder,
          $$StoresTableUpdateCompanionBuilder,
          (Store, BaseReferences<_$AppDatabase, $StoresTable, Store>),
          Store,
          PrefetchHooks Function()
        > {
  $$StoresTableTableManager(_$AppDatabase db, $StoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<DateTime> clientUpdatedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoresCompanion(
                id: id,
                userId: userId,
                deviceId: deviceId,
                clientUpdatedAt: clientUpdatedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
                deletedAt: deletedAt,
                name: name,
                location: location,
                icon: icon,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required DateTime clientUpdatedAt,
                required DateTime updatedAt,
                required DateTime createdAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                Value<String?> location = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoresCompanion.insert(
                id: id,
                userId: userId,
                deviceId: deviceId,
                clientUpdatedAt: clientUpdatedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
                deletedAt: deletedAt,
                name: name,
                location: location,
                icon: icon,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoresTable,
      Store,
      $$StoresTableFilterComposer,
      $$StoresTableOrderingComposer,
      $$StoresTableAnnotationComposer,
      $$StoresTableCreateCompanionBuilder,
      $$StoresTableUpdateCompanionBuilder,
      (Store, BaseReferences<_$AppDatabase, $StoresTable, Store>),
      Store,
      PrefetchHooks Function()
    >;
typedef $$ShoppingListsTableCreateCompanionBuilder =
    ShoppingListsCompanion Function({
      required String id,
      Value<String?> userId,
      Value<String?> deviceId,
      required DateTime clientUpdatedAt,
      required DateTime updatedAt,
      required DateTime createdAt,
      Value<DateTime?> deletedAt,
      required String name,
      Value<String> status,
      Value<String?> notes,
      Value<String?> icon,
      Value<String?> storeId,
      Value<String?> storeLocation,
      Value<int> rowid,
    });
typedef $$ShoppingListsTableUpdateCompanionBuilder =
    ShoppingListsCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<String?> deviceId,
      Value<DateTime> clientUpdatedAt,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<String> name,
      Value<String> status,
      Value<String?> notes,
      Value<String?> icon,
      Value<String?> storeId,
      Value<String?> storeLocation,
      Value<int> rowid,
    });

class $$ShoppingListsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeLocation => $composableBuilder(
    column: $table.storeLocation,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShoppingListsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeLocation => $composableBuilder(
    column: $table.storeLocation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShoppingListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get storeLocation => $composableBuilder(
    column: $table.storeLocation,
    builder: (column) => column,
  );
}

class $$ShoppingListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingListsTable,
          ShoppingList,
          $$ShoppingListsTableFilterComposer,
          $$ShoppingListsTableOrderingComposer,
          $$ShoppingListsTableAnnotationComposer,
          $$ShoppingListsTableCreateCompanionBuilder,
          $$ShoppingListsTableUpdateCompanionBuilder,
          (
            ShoppingList,
            BaseReferences<_$AppDatabase, $ShoppingListsTable, ShoppingList>,
          ),
          ShoppingList,
          PrefetchHooks Function()
        > {
  $$ShoppingListsTableTableManager(_$AppDatabase db, $ShoppingListsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<DateTime> clientUpdatedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> storeId = const Value.absent(),
                Value<String?> storeLocation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListsCompanion(
                id: id,
                userId: userId,
                deviceId: deviceId,
                clientUpdatedAt: clientUpdatedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
                deletedAt: deletedAt,
                name: name,
                status: status,
                notes: notes,
                icon: icon,
                storeId: storeId,
                storeLocation: storeLocation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required DateTime clientUpdatedAt,
                required DateTime updatedAt,
                required DateTime createdAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> storeId = const Value.absent(),
                Value<String?> storeLocation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListsCompanion.insert(
                id: id,
                userId: userId,
                deviceId: deviceId,
                clientUpdatedAt: clientUpdatedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
                deletedAt: deletedAt,
                name: name,
                status: status,
                notes: notes,
                icon: icon,
                storeId: storeId,
                storeLocation: storeLocation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShoppingListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingListsTable,
      ShoppingList,
      $$ShoppingListsTableFilterComposer,
      $$ShoppingListsTableOrderingComposer,
      $$ShoppingListsTableAnnotationComposer,
      $$ShoppingListsTableCreateCompanionBuilder,
      $$ShoppingListsTableUpdateCompanionBuilder,
      (
        ShoppingList,
        BaseReferences<_$AppDatabase, $ShoppingListsTable, ShoppingList>,
      ),
      ShoppingList,
      PrefetchHooks Function()
    >;
typedef $$ListItemsTableCreateCompanionBuilder =
    ListItemsCompanion Function({
      required String id,
      Value<String?> userId,
      Value<String?> deviceId,
      required DateTime clientUpdatedAt,
      required DateTime updatedAt,
      required DateTime createdAt,
      Value<DateTime?> deletedAt,
      required String shoppingListId,
      Value<String?> productId,
      Value<String?> unitId,
      Value<String?> unitAbbr,
      required String name,
      Value<double> qtyPlanned,
      Value<double?> qtyBought,
      Value<double?> unitPrice,
      Value<String> status,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$ListItemsTableUpdateCompanionBuilder =
    ListItemsCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<String?> deviceId,
      Value<DateTime> clientUpdatedAt,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<String> shoppingListId,
      Value<String?> productId,
      Value<String?> unitId,
      Value<String?> unitAbbr,
      Value<String> name,
      Value<double> qtyPlanned,
      Value<double?> qtyBought,
      Value<double?> unitPrice,
      Value<String> status,
      Value<String?> notes,
      Value<int> rowid,
    });

class $$ListItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ListItemsTable> {
  $$ListItemsTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shoppingListId => $composableBuilder(
    column: $table.shoppingListId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitAbbr => $composableBuilder(
    column: $table.unitAbbr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get qtyPlanned => $composableBuilder(
    column: $table.qtyPlanned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get qtyBought => $composableBuilder(
    column: $table.qtyBought,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ListItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ListItemsTable> {
  $$ListItemsTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shoppingListId => $composableBuilder(
    column: $table.shoppingListId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitAbbr => $composableBuilder(
    column: $table.unitAbbr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get qtyPlanned => $composableBuilder(
    column: $table.qtyPlanned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get qtyBought => $composableBuilder(
    column: $table.qtyBought,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ListItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListItemsTable> {
  $$ListItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get shoppingListId => $composableBuilder(
    column: $table.shoppingListId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<String> get unitAbbr =>
      $composableBuilder(column: $table.unitAbbr, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get qtyPlanned => $composableBuilder(
    column: $table.qtyPlanned,
    builder: (column) => column,
  );

  GeneratedColumn<double> get qtyBought =>
      $composableBuilder(column: $table.qtyBought, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$ListItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ListItemsTable,
          ListItem,
          $$ListItemsTableFilterComposer,
          $$ListItemsTableOrderingComposer,
          $$ListItemsTableAnnotationComposer,
          $$ListItemsTableCreateCompanionBuilder,
          $$ListItemsTableUpdateCompanionBuilder,
          (ListItem, BaseReferences<_$AppDatabase, $ListItemsTable, ListItem>),
          ListItem,
          PrefetchHooks Function()
        > {
  $$ListItemsTableTableManager(_$AppDatabase db, $ListItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<DateTime> clientUpdatedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> shoppingListId = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<String?> unitId = const Value.absent(),
                Value<String?> unitAbbr = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> qtyPlanned = const Value.absent(),
                Value<double?> qtyBought = const Value.absent(),
                Value<double?> unitPrice = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ListItemsCompanion(
                id: id,
                userId: userId,
                deviceId: deviceId,
                clientUpdatedAt: clientUpdatedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
                deletedAt: deletedAt,
                shoppingListId: shoppingListId,
                productId: productId,
                unitId: unitId,
                unitAbbr: unitAbbr,
                name: name,
                qtyPlanned: qtyPlanned,
                qtyBought: qtyBought,
                unitPrice: unitPrice,
                status: status,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required DateTime clientUpdatedAt,
                required DateTime updatedAt,
                required DateTime createdAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required String shoppingListId,
                Value<String?> productId = const Value.absent(),
                Value<String?> unitId = const Value.absent(),
                Value<String?> unitAbbr = const Value.absent(),
                required String name,
                Value<double> qtyPlanned = const Value.absent(),
                Value<double?> qtyBought = const Value.absent(),
                Value<double?> unitPrice = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ListItemsCompanion.insert(
                id: id,
                userId: userId,
                deviceId: deviceId,
                clientUpdatedAt: clientUpdatedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
                deletedAt: deletedAt,
                shoppingListId: shoppingListId,
                productId: productId,
                unitId: unitId,
                unitAbbr: unitAbbr,
                name: name,
                qtyPlanned: qtyPlanned,
                qtyBought: qtyBought,
                unitPrice: unitPrice,
                status: status,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ListItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ListItemsTable,
      ListItem,
      $$ListItemsTableFilterComposer,
      $$ListItemsTableOrderingComposer,
      $$ListItemsTableAnnotationComposer,
      $$ListItemsTableCreateCompanionBuilder,
      $$ListItemsTableUpdateCompanionBuilder,
      (ListItem, BaseReferences<_$AppDatabase, $ListItemsTable, ListItem>),
      ListItem,
      PrefetchHooks Function()
    >;
typedef $$PurchaseHistoriesTableCreateCompanionBuilder =
    PurchaseHistoriesCompanion Function({
      required String id,
      Value<String?> userId,
      Value<String?> deviceId,
      required DateTime clientUpdatedAt,
      required DateTime updatedAt,
      required DateTime createdAt,
      Value<DateTime?> deletedAt,
      Value<String?> shoppingListId,
      Value<String?> storeLocation,
      required DateTime purchasedAt,
      Value<double> total,
      Value<int> rowid,
    });
typedef $$PurchaseHistoriesTableUpdateCompanionBuilder =
    PurchaseHistoriesCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<String?> deviceId,
      Value<DateTime> clientUpdatedAt,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<String?> shoppingListId,
      Value<String?> storeLocation,
      Value<DateTime> purchasedAt,
      Value<double> total,
      Value<int> rowid,
    });

class $$PurchaseHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseHistoriesTable> {
  $$PurchaseHistoriesTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shoppingListId => $composableBuilder(
    column: $table.shoppingListId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeLocation => $composableBuilder(
    column: $table.storeLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchaseHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseHistoriesTable> {
  $$PurchaseHistoriesTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shoppingListId => $composableBuilder(
    column: $table.shoppingListId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeLocation => $composableBuilder(
    column: $table.storeLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseHistoriesTable> {
  $$PurchaseHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get shoppingListId => $composableBuilder(
    column: $table.shoppingListId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storeLocation => $composableBuilder(
    column: $table.storeLocation,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);
}

class $$PurchaseHistoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseHistoriesTable,
          PurchaseHistory,
          $$PurchaseHistoriesTableFilterComposer,
          $$PurchaseHistoriesTableOrderingComposer,
          $$PurchaseHistoriesTableAnnotationComposer,
          $$PurchaseHistoriesTableCreateCompanionBuilder,
          $$PurchaseHistoriesTableUpdateCompanionBuilder,
          (
            PurchaseHistory,
            BaseReferences<
              _$AppDatabase,
              $PurchaseHistoriesTable,
              PurchaseHistory
            >,
          ),
          PurchaseHistory,
          PrefetchHooks Function()
        > {
  $$PurchaseHistoriesTableTableManager(
    _$AppDatabase db,
    $PurchaseHistoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseHistoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseHistoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseHistoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<DateTime> clientUpdatedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> shoppingListId = const Value.absent(),
                Value<String?> storeLocation = const Value.absent(),
                Value<DateTime> purchasedAt = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseHistoriesCompanion(
                id: id,
                userId: userId,
                deviceId: deviceId,
                clientUpdatedAt: clientUpdatedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
                deletedAt: deletedAt,
                shoppingListId: shoppingListId,
                storeLocation: storeLocation,
                purchasedAt: purchasedAt,
                total: total,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required DateTime clientUpdatedAt,
                required DateTime updatedAt,
                required DateTime createdAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> shoppingListId = const Value.absent(),
                Value<String?> storeLocation = const Value.absent(),
                required DateTime purchasedAt,
                Value<double> total = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseHistoriesCompanion.insert(
                id: id,
                userId: userId,
                deviceId: deviceId,
                clientUpdatedAt: clientUpdatedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
                deletedAt: deletedAt,
                shoppingListId: shoppingListId,
                storeLocation: storeLocation,
                purchasedAt: purchasedAt,
                total: total,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PurchaseHistoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseHistoriesTable,
      PurchaseHistory,
      $$PurchaseHistoriesTableFilterComposer,
      $$PurchaseHistoriesTableOrderingComposer,
      $$PurchaseHistoriesTableAnnotationComposer,
      $$PurchaseHistoriesTableCreateCompanionBuilder,
      $$PurchaseHistoriesTableUpdateCompanionBuilder,
      (
        PurchaseHistory,
        BaseReferences<_$AppDatabase, $PurchaseHistoriesTable, PurchaseHistory>,
      ),
      PurchaseHistory,
      PrefetchHooks Function()
    >;
typedef $$PurchaseHistoryItemsTableCreateCompanionBuilder =
    PurchaseHistoryItemsCompanion Function({
      required String id,
      Value<String?> userId,
      Value<String?> deviceId,
      required DateTime clientUpdatedAt,
      required DateTime updatedAt,
      required DateTime createdAt,
      Value<DateTime?> deletedAt,
      required String purchaseHistoryId,
      Value<String?> productId,
      required String name,
      Value<String?> unitAbbr,
      Value<double> quantity,
      Value<double?> unitPrice,
      Value<double?> lineTotal,
      Value<int> rowid,
    });
typedef $$PurchaseHistoryItemsTableUpdateCompanionBuilder =
    PurchaseHistoryItemsCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<String?> deviceId,
      Value<DateTime> clientUpdatedAt,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<String> purchaseHistoryId,
      Value<String?> productId,
      Value<String> name,
      Value<String?> unitAbbr,
      Value<double> quantity,
      Value<double?> unitPrice,
      Value<double?> lineTotal,
      Value<int> rowid,
    });

class $$PurchaseHistoryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseHistoryItemsTable> {
  $$PurchaseHistoryItemsTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseHistoryId => $composableBuilder(
    column: $table.purchaseHistoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitAbbr => $composableBuilder(
    column: $table.unitAbbr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchaseHistoryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseHistoryItemsTable> {
  $$PurchaseHistoryItemsTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseHistoryId => $composableBuilder(
    column: $table.purchaseHistoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitAbbr => $composableBuilder(
    column: $table.unitAbbr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseHistoryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseHistoryItemsTable> {
  $$PurchaseHistoryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get purchaseHistoryId => $composableBuilder(
    column: $table.purchaseHistoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unitAbbr =>
      $composableBuilder(column: $table.unitAbbr, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);
}

class $$PurchaseHistoryItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseHistoryItemsTable,
          PurchaseHistoryItem,
          $$PurchaseHistoryItemsTableFilterComposer,
          $$PurchaseHistoryItemsTableOrderingComposer,
          $$PurchaseHistoryItemsTableAnnotationComposer,
          $$PurchaseHistoryItemsTableCreateCompanionBuilder,
          $$PurchaseHistoryItemsTableUpdateCompanionBuilder,
          (
            PurchaseHistoryItem,
            BaseReferences<
              _$AppDatabase,
              $PurchaseHistoryItemsTable,
              PurchaseHistoryItem
            >,
          ),
          PurchaseHistoryItem,
          PrefetchHooks Function()
        > {
  $$PurchaseHistoryItemsTableTableManager(
    _$AppDatabase db,
    $PurchaseHistoryItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseHistoryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseHistoryItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PurchaseHistoryItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<DateTime> clientUpdatedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> purchaseHistoryId = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> unitAbbr = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double?> unitPrice = const Value.absent(),
                Value<double?> lineTotal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseHistoryItemsCompanion(
                id: id,
                userId: userId,
                deviceId: deviceId,
                clientUpdatedAt: clientUpdatedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
                deletedAt: deletedAt,
                purchaseHistoryId: purchaseHistoryId,
                productId: productId,
                name: name,
                unitAbbr: unitAbbr,
                quantity: quantity,
                unitPrice: unitPrice,
                lineTotal: lineTotal,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required DateTime clientUpdatedAt,
                required DateTime updatedAt,
                required DateTime createdAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required String purchaseHistoryId,
                Value<String?> productId = const Value.absent(),
                required String name,
                Value<String?> unitAbbr = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double?> unitPrice = const Value.absent(),
                Value<double?> lineTotal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseHistoryItemsCompanion.insert(
                id: id,
                userId: userId,
                deviceId: deviceId,
                clientUpdatedAt: clientUpdatedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
                deletedAt: deletedAt,
                purchaseHistoryId: purchaseHistoryId,
                productId: productId,
                name: name,
                unitAbbr: unitAbbr,
                quantity: quantity,
                unitPrice: unitPrice,
                lineTotal: lineTotal,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PurchaseHistoryItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseHistoryItemsTable,
      PurchaseHistoryItem,
      $$PurchaseHistoryItemsTableFilterComposer,
      $$PurchaseHistoryItemsTableOrderingComposer,
      $$PurchaseHistoryItemsTableAnnotationComposer,
      $$PurchaseHistoryItemsTableCreateCompanionBuilder,
      $$PurchaseHistoryItemsTableUpdateCompanionBuilder,
      (
        PurchaseHistoryItem,
        BaseReferences<
          _$AppDatabase,
          $PurchaseHistoryItemsTable,
          PurchaseHistoryItem
        >,
      ),
      PurchaseHistoryItem,
      PrefetchHooks Function()
    >;
typedef $$SyncOutboxTableCreateCompanionBuilder =
    SyncOutboxCompanion Function({
      required String id,
      required String entity,
      required String entityId,
      required String op,
      required String payloadJson,
      required DateTime clientUpdatedAt,
      required DateTime createdAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$SyncOutboxTableUpdateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<String> id,
      Value<String> entity,
      Value<String> entityId,
      Value<String> op,
      Value<String> payloadJson,
      Value<DateTime> clientUpdatedAt,
      Value<DateTime> createdAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
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

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
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

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get clientUpdatedAt => $composableBuilder(
    column: $table.clientUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$SyncOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOutboxTable,
          SyncOutboxData,
          $$SyncOutboxTableFilterComposer,
          $$SyncOutboxTableOrderingComposer,
          $$SyncOutboxTableAnnotationComposer,
          $$SyncOutboxTableCreateCompanionBuilder,
          $$SyncOutboxTableUpdateCompanionBuilder,
          (
            SyncOutboxData,
            BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>,
          ),
          SyncOutboxData,
          PrefetchHooks Function()
        > {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> clientUpdatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion(
                id: id,
                entity: entity,
                entityId: entityId,
                op: op,
                payloadJson: payloadJson,
                clientUpdatedAt: clientUpdatedAt,
                createdAt: createdAt,
                attempts: attempts,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entity,
                required String entityId,
                required String op,
                required String payloadJson,
                required DateTime clientUpdatedAt,
                required DateTime createdAt,
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                id: id,
                entity: entity,
                entityId: entityId,
                op: op,
                payloadJson: payloadJson,
                clientUpdatedAt: clientUpdatedAt,
                createdAt: createdAt,
                attempts: attempts,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOutboxTable,
      SyncOutboxData,
      $$SyncOutboxTableFilterComposer,
      $$SyncOutboxTableOrderingComposer,
      $$SyncOutboxTableAnnotationComposer,
      $$SyncOutboxTableCreateCompanionBuilder,
      $$SyncOutboxTableUpdateCompanionBuilder,
      (
        SyncOutboxData,
        BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>,
      ),
      SyncOutboxData,
      PrefetchHooks Function()
    >;
typedef $$SyncMetaTableCreateCompanionBuilder =
    SyncMetaCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SyncMetaTableUpdateCompanionBuilder =
    SyncMetaCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SyncMetaTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SyncMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetaTable,
          SyncMetaData,
          $$SyncMetaTableFilterComposer,
          $$SyncMetaTableOrderingComposer,
          $$SyncMetaTableAnnotationComposer,
          $$SyncMetaTableCreateCompanionBuilder,
          $$SyncMetaTableUpdateCompanionBuilder,
          (
            SyncMetaData,
            BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaData>,
          ),
          SyncMetaData,
          PrefetchHooks Function()
        > {
  $$SyncMetaTableTableManager(_$AppDatabase db, $SyncMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetaTable,
      SyncMetaData,
      $$SyncMetaTableFilterComposer,
      $$SyncMetaTableOrderingComposer,
      $$SyncMetaTableAnnotationComposer,
      $$SyncMetaTableCreateCompanionBuilder,
      $$SyncMetaTableUpdateCompanionBuilder,
      (
        SyncMetaData,
        BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaData>,
      ),
      SyncMetaData,
      PrefetchHooks Function()
    >;
typedef $$BudgetMovementsTableCreateCompanionBuilder =
    BudgetMovementsCompanion Function({
      required String id,
      required String label,
      required double amountUsd,
      required DateTime occurredAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$BudgetMovementsTableUpdateCompanionBuilder =
    BudgetMovementsCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<double> amountUsd,
      Value<DateTime> occurredAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$BudgetMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetMovementsTable> {
  $$BudgetMovementsTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountUsd => $composableBuilder(
    column: $table.amountUsd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
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
}

class $$BudgetMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetMovementsTable> {
  $$BudgetMovementsTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountUsd => $composableBuilder(
    column: $table.amountUsd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
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
}

class $$BudgetMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetMovementsTable> {
  $$BudgetMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<double> get amountUsd =>
      $composableBuilder(column: $table.amountUsd, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BudgetMovementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetMovementsTable,
          BudgetMovement,
          $$BudgetMovementsTableFilterComposer,
          $$BudgetMovementsTableOrderingComposer,
          $$BudgetMovementsTableAnnotationComposer,
          $$BudgetMovementsTableCreateCompanionBuilder,
          $$BudgetMovementsTableUpdateCompanionBuilder,
          (
            BudgetMovement,
            BaseReferences<
              _$AppDatabase,
              $BudgetMovementsTable,
              BudgetMovement
            >,
          ),
          BudgetMovement,
          PrefetchHooks Function()
        > {
  $$BudgetMovementsTableTableManager(
    _$AppDatabase db,
    $BudgetMovementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<double> amountUsd = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetMovementsCompanion(
                id: id,
                label: label,
                amountUsd: amountUsd,
                occurredAt: occurredAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                required double amountUsd,
                required DateTime occurredAt,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BudgetMovementsCompanion.insert(
                id: id,
                label: label,
                amountUsd: amountUsd,
                occurredAt: occurredAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetMovementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetMovementsTable,
      BudgetMovement,
      $$BudgetMovementsTableFilterComposer,
      $$BudgetMovementsTableOrderingComposer,
      $$BudgetMovementsTableAnnotationComposer,
      $$BudgetMovementsTableCreateCompanionBuilder,
      $$BudgetMovementsTableUpdateCompanionBuilder,
      (
        BudgetMovement,
        BaseReferences<_$AppDatabase, $BudgetMovementsTable, BudgetMovement>,
      ),
      BudgetMovement,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$StoresTableTableManager get stores =>
      $$StoresTableTableManager(_db, _db.stores);
  $$ShoppingListsTableTableManager get shoppingLists =>
      $$ShoppingListsTableTableManager(_db, _db.shoppingLists);
  $$ListItemsTableTableManager get listItems =>
      $$ListItemsTableTableManager(_db, _db.listItems);
  $$PurchaseHistoriesTableTableManager get purchaseHistories =>
      $$PurchaseHistoriesTableTableManager(_db, _db.purchaseHistories);
  $$PurchaseHistoryItemsTableTableManager get purchaseHistoryItems =>
      $$PurchaseHistoryItemsTableTableManager(_db, _db.purchaseHistoryItems);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$SyncMetaTableTableManager get syncMeta =>
      $$SyncMetaTableTableManager(_db, _db.syncMeta);
  $$BudgetMovementsTableTableManager get budgetMovements =>
      $$BudgetMovementsTableTableManager(_db, _db.budgetMovements);
}
