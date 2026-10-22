// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HabitsTableTable extends HabitsTable
    with TableInfo<$HabitsTableTable, HabitsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subcategoryMeta = const VerificationMeta(
    'subcategory',
  );
  @override
  late final GeneratedColumn<String> subcategory = GeneratedColumn<String>(
    'subcategory',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtUtcMeta = const VerificationMeta(
    'archivedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAtUtc =
      GeneratedColumn<DateTime>(
        'archived_at_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    emoji,
    category,
    subcategory,
    createdAtUtc,
    archivedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('subcategory')) {
      context.handle(
        _subcategoryMeta,
        subcategory.isAcceptableOrUnknown(
          data['subcategory']!,
          _subcategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subcategoryMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('archived_at_utc')) {
      context.handle(
        _archivedAtUtcMeta,
        archivedAtUtc.isAcceptableOrUnknown(
          data['archived_at_utc']!,
          _archivedAtUtcMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      subcategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subcategory'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_utc'],
      )!,
      archivedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at_utc'],
      ),
    );
  }

  @override
  $HabitsTableTable createAlias(String alias) {
    return $HabitsTableTable(attachedDatabase, alias);
  }
}

class HabitsTableData extends DataClass implements Insertable<HabitsTableData> {
  final String id;
  final String title;
  final String emoji;
  final String category;
  final String subcategory;
  final DateTime createdAtUtc;
  final DateTime? archivedAtUtc;
  const HabitsTableData({
    required this.id,
    required this.title,
    required this.emoji,
    required this.category,
    required this.subcategory,
    required this.createdAtUtc,
    this.archivedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['emoji'] = Variable<String>(emoji);
    map['category'] = Variable<String>(category);
    map['subcategory'] = Variable<String>(subcategory);
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    if (!nullToAbsent || archivedAtUtc != null) {
      map['archived_at_utc'] = Variable<DateTime>(archivedAtUtc);
    }
    return map;
  }

  HabitsTableCompanion toCompanion(bool nullToAbsent) {
    return HabitsTableCompanion(
      id: Value(id),
      title: Value(title),
      emoji: Value(emoji),
      category: Value(category),
      subcategory: Value(subcategory),
      createdAtUtc: Value(createdAtUtc),
      archivedAtUtc: archivedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAtUtc),
    );
  }

  factory HabitsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      emoji: serializer.fromJson<String>(json['emoji']),
      category: serializer.fromJson<String>(json['category']),
      subcategory: serializer.fromJson<String>(json['subcategory']),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
      archivedAtUtc: serializer.fromJson<DateTime?>(json['archivedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'emoji': serializer.toJson<String>(emoji),
      'category': serializer.toJson<String>(category),
      'subcategory': serializer.toJson<String>(subcategory),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
      'archivedAtUtc': serializer.toJson<DateTime?>(archivedAtUtc),
    };
  }

  HabitsTableData copyWith({
    String? id,
    String? title,
    String? emoji,
    String? category,
    String? subcategory,
    DateTime? createdAtUtc,
    Value<DateTime?> archivedAtUtc = const Value.absent(),
  }) => HabitsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    emoji: emoji ?? this.emoji,
    category: category ?? this.category,
    subcategory: subcategory ?? this.subcategory,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    archivedAtUtc: archivedAtUtc.present
        ? archivedAtUtc.value
        : this.archivedAtUtc,
  );
  HabitsTableData copyWithCompanion(HabitsTableCompanion data) {
    return HabitsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      category: data.category.present ? data.category.value : this.category,
      subcategory: data.subcategory.present
          ? data.subcategory.value
          : this.subcategory,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      archivedAtUtc: data.archivedAtUtc.present
          ? data.archivedAtUtc.value
          : this.archivedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('emoji: $emoji, ')
          ..write('category: $category, ')
          ..write('subcategory: $subcategory, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('archivedAtUtc: $archivedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    emoji,
    category,
    subcategory,
    createdAtUtc,
    archivedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.emoji == this.emoji &&
          other.category == this.category &&
          other.subcategory == this.subcategory &&
          other.createdAtUtc == this.createdAtUtc &&
          other.archivedAtUtc == this.archivedAtUtc);
}

class HabitsTableCompanion extends UpdateCompanion<HabitsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> emoji;
  final Value<String> category;
  final Value<String> subcategory;
  final Value<DateTime> createdAtUtc;
  final Value<DateTime?> archivedAtUtc;
  final Value<int> rowid;
  const HabitsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.emoji = const Value.absent(),
    this.category = const Value.absent(),
    this.subcategory = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.archivedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsTableCompanion.insert({
    required String id,
    required String title,
    required String emoji,
    required String category,
    required String subcategory,
    required DateTime createdAtUtc,
    this.archivedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       emoji = Value(emoji),
       category = Value(category),
       subcategory = Value(subcategory),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<HabitsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? emoji,
    Expression<String>? category,
    Expression<String>? subcategory,
    Expression<DateTime>? createdAtUtc,
    Expression<DateTime>? archivedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (emoji != null) 'emoji': emoji,
      if (category != null) 'category': category,
      if (subcategory != null) 'subcategory': subcategory,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (archivedAtUtc != null) 'archived_at_utc': archivedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? emoji,
    Value<String>? category,
    Value<String>? subcategory,
    Value<DateTime>? createdAtUtc,
    Value<DateTime?>? archivedAtUtc,
    Value<int>? rowid,
  }) {
    return HabitsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      archivedAtUtc: archivedAtUtc ?? this.archivedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (subcategory.present) {
      map['subcategory'] = Variable<String>(subcategory.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    if (archivedAtUtc.present) {
      map['archived_at_utc'] = Variable<DateTime>(archivedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('emoji: $emoji, ')
          ..write('category: $category, ')
          ..write('subcategory: $subcategory, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('archivedAtUtc: $archivedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitPlanVersionsTableTable extends HabitPlanVersionsTable
    with TableInfo<$HabitPlanVersionsTableTable, HabitPlanVersionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitPlanVersionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _effectiveFromDateMeta = const VerificationMeta(
    'effectiveFromDate',
  );
  @override
  late final GeneratedColumn<String> effectiveFromDate =
      GeneratedColumn<String>(
        'effective_from_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _weekdaysMeta = const VerificationMeta(
    'weekdays',
  );
  @override
  late final GeneratedColumn<String> weekdays = GeneratedColumn<String>(
    'weekdays',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTypeMeta = const VerificationMeta(
    'targetType',
  );
  @override
  late final GeneratedColumn<String> targetType = GeneratedColumn<String>(
    'target_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<int> targetValue = GeneratedColumn<int>(
    'target_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rewardEligibleMeta = const VerificationMeta(
    'rewardEligible',
  );
  @override
  late final GeneratedColumn<bool> rewardEligible = GeneratedColumn<bool>(
    'reward_eligible',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reward_eligible" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    habitId,
    effectiveFromDate,
    weekdays,
    targetType,
    targetValue,
    unit,
    rewardEligible,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_plan_versions';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitPlanVersionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('effective_from_date')) {
      context.handle(
        _effectiveFromDateMeta,
        effectiveFromDate.isAcceptableOrUnknown(
          data['effective_from_date']!,
          _effectiveFromDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveFromDateMeta);
    }
    if (data.containsKey('weekdays')) {
      context.handle(
        _weekdaysMeta,
        weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdaysMeta);
    }
    if (data.containsKey('target_type')) {
      context.handle(
        _targetTypeMeta,
        targetType.isAcceptableOrUnknown(data['target_type']!, _targetTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_targetTypeMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetValueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('reward_eligible')) {
      context.handle(
        _rewardEligibleMeta,
        rewardEligible.isAcceptableOrUnknown(
          data['reward_eligible']!,
          _rewardEligibleMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitPlanVersionsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitPlanVersionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      effectiveFromDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effective_from_date'],
      )!,
      weekdays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weekdays'],
      )!,
      targetType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_type'],
      )!,
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_value'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      rewardEligible: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reward_eligible'],
      )!,
    );
  }

  @override
  $HabitPlanVersionsTableTable createAlias(String alias) {
    return $HabitPlanVersionsTableTable(attachedDatabase, alias);
  }
}

class HabitPlanVersionsTableData extends DataClass
    implements Insertable<HabitPlanVersionsTableData> {
  final String id;
  final String habitId;
  final String effectiveFromDate;
  final String weekdays;
  final String targetType;
  final int targetValue;
  final String unit;
  final bool rewardEligible;
  const HabitPlanVersionsTableData({
    required this.id,
    required this.habitId,
    required this.effectiveFromDate,
    required this.weekdays,
    required this.targetType,
    required this.targetValue,
    required this.unit,
    required this.rewardEligible,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['effective_from_date'] = Variable<String>(effectiveFromDate);
    map['weekdays'] = Variable<String>(weekdays);
    map['target_type'] = Variable<String>(targetType);
    map['target_value'] = Variable<int>(targetValue);
    map['unit'] = Variable<String>(unit);
    map['reward_eligible'] = Variable<bool>(rewardEligible);
    return map;
  }

  HabitPlanVersionsTableCompanion toCompanion(bool nullToAbsent) {
    return HabitPlanVersionsTableCompanion(
      id: Value(id),
      habitId: Value(habitId),
      effectiveFromDate: Value(effectiveFromDate),
      weekdays: Value(weekdays),
      targetType: Value(targetType),
      targetValue: Value(targetValue),
      unit: Value(unit),
      rewardEligible: Value(rewardEligible),
    );
  }

  factory HabitPlanVersionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitPlanVersionsTableData(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      effectiveFromDate: serializer.fromJson<String>(json['effectiveFromDate']),
      weekdays: serializer.fromJson<String>(json['weekdays']),
      targetType: serializer.fromJson<String>(json['targetType']),
      targetValue: serializer.fromJson<int>(json['targetValue']),
      unit: serializer.fromJson<String>(json['unit']),
      rewardEligible: serializer.fromJson<bool>(json['rewardEligible']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'effectiveFromDate': serializer.toJson<String>(effectiveFromDate),
      'weekdays': serializer.toJson<String>(weekdays),
      'targetType': serializer.toJson<String>(targetType),
      'targetValue': serializer.toJson<int>(targetValue),
      'unit': serializer.toJson<String>(unit),
      'rewardEligible': serializer.toJson<bool>(rewardEligible),
    };
  }

  HabitPlanVersionsTableData copyWith({
    String? id,
    String? habitId,
    String? effectiveFromDate,
    String? weekdays,
    String? targetType,
    int? targetValue,
    String? unit,
    bool? rewardEligible,
  }) => HabitPlanVersionsTableData(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    effectiveFromDate: effectiveFromDate ?? this.effectiveFromDate,
    weekdays: weekdays ?? this.weekdays,
    targetType: targetType ?? this.targetType,
    targetValue: targetValue ?? this.targetValue,
    unit: unit ?? this.unit,
    rewardEligible: rewardEligible ?? this.rewardEligible,
  );
  HabitPlanVersionsTableData copyWithCompanion(
    HabitPlanVersionsTableCompanion data,
  ) {
    return HabitPlanVersionsTableData(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      effectiveFromDate: data.effectiveFromDate.present
          ? data.effectiveFromDate.value
          : this.effectiveFromDate,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      targetType: data.targetType.present
          ? data.targetType.value
          : this.targetType,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      unit: data.unit.present ? data.unit.value : this.unit,
      rewardEligible: data.rewardEligible.present
          ? data.rewardEligible.value
          : this.rewardEligible,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitPlanVersionsTableData(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('effectiveFromDate: $effectiveFromDate, ')
          ..write('weekdays: $weekdays, ')
          ..write('targetType: $targetType, ')
          ..write('targetValue: $targetValue, ')
          ..write('unit: $unit, ')
          ..write('rewardEligible: $rewardEligible')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    habitId,
    effectiveFromDate,
    weekdays,
    targetType,
    targetValue,
    unit,
    rewardEligible,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitPlanVersionsTableData &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.effectiveFromDate == this.effectiveFromDate &&
          other.weekdays == this.weekdays &&
          other.targetType == this.targetType &&
          other.targetValue == this.targetValue &&
          other.unit == this.unit &&
          other.rewardEligible == this.rewardEligible);
}

class HabitPlanVersionsTableCompanion
    extends UpdateCompanion<HabitPlanVersionsTableData> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<String> effectiveFromDate;
  final Value<String> weekdays;
  final Value<String> targetType;
  final Value<int> targetValue;
  final Value<String> unit;
  final Value<bool> rewardEligible;
  final Value<int> rowid;
  const HabitPlanVersionsTableCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.effectiveFromDate = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.targetType = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.unit = const Value.absent(),
    this.rewardEligible = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitPlanVersionsTableCompanion.insert({
    required String id,
    required String habitId,
    required String effectiveFromDate,
    required String weekdays,
    required String targetType,
    required int targetValue,
    required String unit,
    this.rewardEligible = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       habitId = Value(habitId),
       effectiveFromDate = Value(effectiveFromDate),
       weekdays = Value(weekdays),
       targetType = Value(targetType),
       targetValue = Value(targetValue),
       unit = Value(unit);
  static Insertable<HabitPlanVersionsTableData> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<String>? effectiveFromDate,
    Expression<String>? weekdays,
    Expression<String>? targetType,
    Expression<int>? targetValue,
    Expression<String>? unit,
    Expression<bool>? rewardEligible,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (effectiveFromDate != null) 'effective_from_date': effectiveFromDate,
      if (weekdays != null) 'weekdays': weekdays,
      if (targetType != null) 'target_type': targetType,
      if (targetValue != null) 'target_value': targetValue,
      if (unit != null) 'unit': unit,
      if (rewardEligible != null) 'reward_eligible': rewardEligible,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitPlanVersionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? habitId,
    Value<String>? effectiveFromDate,
    Value<String>? weekdays,
    Value<String>? targetType,
    Value<int>? targetValue,
    Value<String>? unit,
    Value<bool>? rewardEligible,
    Value<int>? rowid,
  }) {
    return HabitPlanVersionsTableCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      effectiveFromDate: effectiveFromDate ?? this.effectiveFromDate,
      weekdays: weekdays ?? this.weekdays,
      targetType: targetType ?? this.targetType,
      targetValue: targetValue ?? this.targetValue,
      unit: unit ?? this.unit,
      rewardEligible: rewardEligible ?? this.rewardEligible,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (effectiveFromDate.present) {
      map['effective_from_date'] = Variable<String>(effectiveFromDate.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<String>(weekdays.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<String>(targetType.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<int>(targetValue.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (rewardEligible.present) {
      map['reward_eligible'] = Variable<bool>(rewardEligible.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitPlanVersionsTableCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('effectiveFromDate: $effectiveFromDate, ')
          ..write('weekdays: $weekdays, ')
          ..write('targetType: $targetType, ')
          ..write('targetValue: $targetValue, ')
          ..write('unit: $unit, ')
          ..write('rewardEligible: $rewardEligible, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyCheckInsTableTable extends DailyCheckInsTable
    with TableInfo<$DailyCheckInsTableTable, DailyCheckInsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyCheckInsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planVersionIdMeta = const VerificationMeta(
    'planVersionId',
  );
  @override
  late final GeneratedColumn<String> planVersionId = GeneratedColumn<String>(
    'plan_version_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manualValueMeta = const VerificationMeta(
    'manualValue',
  );
  @override
  late final GeneratedColumn<int> manualValue = GeneratedColumn<int>(
    'manual_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sessionSecondsMeta = const VerificationMeta(
    'sessionSeconds',
  );
  @override
  late final GeneratedColumn<int> sessionSeconds = GeneratedColumn<int>(
    'session_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _firstCompletedAtUtcMeta =
      const VerificationMeta('firstCompletedAtUtc');
  @override
  late final GeneratedColumn<DateTime> firstCompletedAtUtc =
      GeneratedColumn<DateTime>(
        'first_completed_at_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastCompletedAtUtcMeta =
      const VerificationMeta('lastCompletedAtUtc');
  @override
  late final GeneratedColumn<DateTime> lastCompletedAtUtc =
      GeneratedColumn<DateTime>(
        'last_completed_at_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    habitId,
    localDate,
    planVersionId,
    manualValue,
    sessionSeconds,
    isCompleted,
    firstCompletedAtUtc,
    lastCompletedAtUtc,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_check_ins';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyCheckInsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('plan_version_id')) {
      context.handle(
        _planVersionIdMeta,
        planVersionId.isAcceptableOrUnknown(
          data['plan_version_id']!,
          _planVersionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_planVersionIdMeta);
    }
    if (data.containsKey('manual_value')) {
      context.handle(
        _manualValueMeta,
        manualValue.isAcceptableOrUnknown(
          data['manual_value']!,
          _manualValueMeta,
        ),
      );
    }
    if (data.containsKey('session_seconds')) {
      context.handle(
        _sessionSecondsMeta,
        sessionSeconds.isAcceptableOrUnknown(
          data['session_seconds']!,
          _sessionSecondsMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('first_completed_at_utc')) {
      context.handle(
        _firstCompletedAtUtcMeta,
        firstCompletedAtUtc.isAcceptableOrUnknown(
          data['first_completed_at_utc']!,
          _firstCompletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('last_completed_at_utc')) {
      context.handle(
        _lastCompletedAtUtcMeta,
        lastCompletedAtUtc.isAcceptableOrUnknown(
          data['last_completed_at_utc']!,
          _lastCompletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {habitId, localDate},
  ];
  @override
  DailyCheckInsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyCheckInsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      planVersionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_version_id'],
      )!,
      manualValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}manual_value'],
      )!,
      sessionSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_seconds'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      firstCompletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_completed_at_utc'],
      ),
      lastCompletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_completed_at_utc'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $DailyCheckInsTableTable createAlias(String alias) {
    return $DailyCheckInsTableTable(attachedDatabase, alias);
  }
}

class DailyCheckInsTableData extends DataClass
    implements Insertable<DailyCheckInsTableData> {
  final String id;
  final String habitId;
  final String localDate;
  final String planVersionId;
  final int manualValue;
  final int sessionSeconds;
  final bool isCompleted;
  final DateTime? firstCompletedAtUtc;
  final DateTime? lastCompletedAtUtc;
  final String? note;
  const DailyCheckInsTableData({
    required this.id,
    required this.habitId,
    required this.localDate,
    required this.planVersionId,
    required this.manualValue,
    required this.sessionSeconds,
    required this.isCompleted,
    this.firstCompletedAtUtc,
    this.lastCompletedAtUtc,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['local_date'] = Variable<String>(localDate);
    map['plan_version_id'] = Variable<String>(planVersionId);
    map['manual_value'] = Variable<int>(manualValue);
    map['session_seconds'] = Variable<int>(sessionSeconds);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || firstCompletedAtUtc != null) {
      map['first_completed_at_utc'] = Variable<DateTime>(firstCompletedAtUtc);
    }
    if (!nullToAbsent || lastCompletedAtUtc != null) {
      map['last_completed_at_utc'] = Variable<DateTime>(lastCompletedAtUtc);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  DailyCheckInsTableCompanion toCompanion(bool nullToAbsent) {
    return DailyCheckInsTableCompanion(
      id: Value(id),
      habitId: Value(habitId),
      localDate: Value(localDate),
      planVersionId: Value(planVersionId),
      manualValue: Value(manualValue),
      sessionSeconds: Value(sessionSeconds),
      isCompleted: Value(isCompleted),
      firstCompletedAtUtc: firstCompletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(firstCompletedAtUtc),
      lastCompletedAtUtc: lastCompletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedAtUtc),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory DailyCheckInsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyCheckInsTableData(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      localDate: serializer.fromJson<String>(json['localDate']),
      planVersionId: serializer.fromJson<String>(json['planVersionId']),
      manualValue: serializer.fromJson<int>(json['manualValue']),
      sessionSeconds: serializer.fromJson<int>(json['sessionSeconds']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      firstCompletedAtUtc: serializer.fromJson<DateTime?>(
        json['firstCompletedAtUtc'],
      ),
      lastCompletedAtUtc: serializer.fromJson<DateTime?>(
        json['lastCompletedAtUtc'],
      ),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'localDate': serializer.toJson<String>(localDate),
      'planVersionId': serializer.toJson<String>(planVersionId),
      'manualValue': serializer.toJson<int>(manualValue),
      'sessionSeconds': serializer.toJson<int>(sessionSeconds),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'firstCompletedAtUtc': serializer.toJson<DateTime?>(firstCompletedAtUtc),
      'lastCompletedAtUtc': serializer.toJson<DateTime?>(lastCompletedAtUtc),
      'note': serializer.toJson<String?>(note),
    };
  }

  DailyCheckInsTableData copyWith({
    String? id,
    String? habitId,
    String? localDate,
    String? planVersionId,
    int? manualValue,
    int? sessionSeconds,
    bool? isCompleted,
    Value<DateTime?> firstCompletedAtUtc = const Value.absent(),
    Value<DateTime?> lastCompletedAtUtc = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => DailyCheckInsTableData(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    localDate: localDate ?? this.localDate,
    planVersionId: planVersionId ?? this.planVersionId,
    manualValue: manualValue ?? this.manualValue,
    sessionSeconds: sessionSeconds ?? this.sessionSeconds,
    isCompleted: isCompleted ?? this.isCompleted,
    firstCompletedAtUtc: firstCompletedAtUtc.present
        ? firstCompletedAtUtc.value
        : this.firstCompletedAtUtc,
    lastCompletedAtUtc: lastCompletedAtUtc.present
        ? lastCompletedAtUtc.value
        : this.lastCompletedAtUtc,
    note: note.present ? note.value : this.note,
  );
  DailyCheckInsTableData copyWithCompanion(DailyCheckInsTableCompanion data) {
    return DailyCheckInsTableData(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      planVersionId: data.planVersionId.present
          ? data.planVersionId.value
          : this.planVersionId,
      manualValue: data.manualValue.present
          ? data.manualValue.value
          : this.manualValue,
      sessionSeconds: data.sessionSeconds.present
          ? data.sessionSeconds.value
          : this.sessionSeconds,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      firstCompletedAtUtc: data.firstCompletedAtUtc.present
          ? data.firstCompletedAtUtc.value
          : this.firstCompletedAtUtc,
      lastCompletedAtUtc: data.lastCompletedAtUtc.present
          ? data.lastCompletedAtUtc.value
          : this.lastCompletedAtUtc,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyCheckInsTableData(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('localDate: $localDate, ')
          ..write('planVersionId: $planVersionId, ')
          ..write('manualValue: $manualValue, ')
          ..write('sessionSeconds: $sessionSeconds, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('firstCompletedAtUtc: $firstCompletedAtUtc, ')
          ..write('lastCompletedAtUtc: $lastCompletedAtUtc, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    habitId,
    localDate,
    planVersionId,
    manualValue,
    sessionSeconds,
    isCompleted,
    firstCompletedAtUtc,
    lastCompletedAtUtc,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyCheckInsTableData &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.localDate == this.localDate &&
          other.planVersionId == this.planVersionId &&
          other.manualValue == this.manualValue &&
          other.sessionSeconds == this.sessionSeconds &&
          other.isCompleted == this.isCompleted &&
          other.firstCompletedAtUtc == this.firstCompletedAtUtc &&
          other.lastCompletedAtUtc == this.lastCompletedAtUtc &&
          other.note == this.note);
}

class DailyCheckInsTableCompanion
    extends UpdateCompanion<DailyCheckInsTableData> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<String> localDate;
  final Value<String> planVersionId;
  final Value<int> manualValue;
  final Value<int> sessionSeconds;
  final Value<bool> isCompleted;
  final Value<DateTime?> firstCompletedAtUtc;
  final Value<DateTime?> lastCompletedAtUtc;
  final Value<String?> note;
  final Value<int> rowid;
  const DailyCheckInsTableCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.localDate = const Value.absent(),
    this.planVersionId = const Value.absent(),
    this.manualValue = const Value.absent(),
    this.sessionSeconds = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.firstCompletedAtUtc = const Value.absent(),
    this.lastCompletedAtUtc = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyCheckInsTableCompanion.insert({
    required String id,
    required String habitId,
    required String localDate,
    required String planVersionId,
    this.manualValue = const Value.absent(),
    this.sessionSeconds = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.firstCompletedAtUtc = const Value.absent(),
    this.lastCompletedAtUtc = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       habitId = Value(habitId),
       localDate = Value(localDate),
       planVersionId = Value(planVersionId);
  static Insertable<DailyCheckInsTableData> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<String>? localDate,
    Expression<String>? planVersionId,
    Expression<int>? manualValue,
    Expression<int>? sessionSeconds,
    Expression<bool>? isCompleted,
    Expression<DateTime>? firstCompletedAtUtc,
    Expression<DateTime>? lastCompletedAtUtc,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (localDate != null) 'local_date': localDate,
      if (planVersionId != null) 'plan_version_id': planVersionId,
      if (manualValue != null) 'manual_value': manualValue,
      if (sessionSeconds != null) 'session_seconds': sessionSeconds,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (firstCompletedAtUtc != null)
        'first_completed_at_utc': firstCompletedAtUtc,
      if (lastCompletedAtUtc != null)
        'last_completed_at_utc': lastCompletedAtUtc,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyCheckInsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? habitId,
    Value<String>? localDate,
    Value<String>? planVersionId,
    Value<int>? manualValue,
    Value<int>? sessionSeconds,
    Value<bool>? isCompleted,
    Value<DateTime?>? firstCompletedAtUtc,
    Value<DateTime?>? lastCompletedAtUtc,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return DailyCheckInsTableCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      localDate: localDate ?? this.localDate,
      planVersionId: planVersionId ?? this.planVersionId,
      manualValue: manualValue ?? this.manualValue,
      sessionSeconds: sessionSeconds ?? this.sessionSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      firstCompletedAtUtc: firstCompletedAtUtc ?? this.firstCompletedAtUtc,
      lastCompletedAtUtc: lastCompletedAtUtc ?? this.lastCompletedAtUtc,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (planVersionId.present) {
      map['plan_version_id'] = Variable<String>(planVersionId.value);
    }
    if (manualValue.present) {
      map['manual_value'] = Variable<int>(manualValue.value);
    }
    if (sessionSeconds.present) {
      map['session_seconds'] = Variable<int>(sessionSeconds.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (firstCompletedAtUtc.present) {
      map['first_completed_at_utc'] = Variable<DateTime>(
        firstCompletedAtUtc.value,
      );
    }
    if (lastCompletedAtUtc.present) {
      map['last_completed_at_utc'] = Variable<DateTime>(
        lastCompletedAtUtc.value,
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyCheckInsTableCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('localDate: $localDate, ')
          ..write('planVersionId: $planVersionId, ')
          ..write('manualValue: $manualValue, ')
          ..write('sessionSeconds: $sessionSeconds, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('firstCompletedAtUtc: $firstCompletedAtUtc, ')
          ..write('lastCompletedAtUtc: $lastCompletedAtUtc, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FocusSessionsTableTable extends FocusSessionsTable
    with TableInfo<$FocusSessionsTableTable, FocusSessionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startedAtUtcMeta = const VerificationMeta(
    'startedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> startedAtUtc = GeneratedColumn<DateTime>(
    'started_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeSegmentStartedAtUtcMeta =
      const VerificationMeta('activeSegmentStartedAtUtc');
  @override
  late final GeneratedColumn<DateTime> activeSegmentStartedAtUtc =
      GeneratedColumn<DateTime>(
        'active_segment_started_at_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _accumulatedSecondsMeta =
      const VerificationMeta('accumulatedSeconds');
  @override
  late final GeneratedColumn<int> accumulatedSeconds = GeneratedColumn<int>(
    'accumulated_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _plannedSecondsMeta = const VerificationMeta(
    'plannedSeconds',
  );
  @override
  late final GeneratedColumn<int> plannedSeconds = GeneratedColumn<int>(
    'planned_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtUtcMeta = const VerificationMeta(
    'endedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> endedAtUtc = GeneratedColumn<DateTime>(
    'ended_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    habitId,
    startedAtUtc,
    activeSegmentStartedAtUtc,
    accumulatedSeconds,
    plannedSeconds,
    status,
    endedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusSessionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('started_at_utc')) {
      context.handle(
        _startedAtUtcMeta,
        startedAtUtc.isAcceptableOrUnknown(
          data['started_at_utc']!,
          _startedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedAtUtcMeta);
    }
    if (data.containsKey('active_segment_started_at_utc')) {
      context.handle(
        _activeSegmentStartedAtUtcMeta,
        activeSegmentStartedAtUtc.isAcceptableOrUnknown(
          data['active_segment_started_at_utc']!,
          _activeSegmentStartedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('accumulated_seconds')) {
      context.handle(
        _accumulatedSecondsMeta,
        accumulatedSeconds.isAcceptableOrUnknown(
          data['accumulated_seconds']!,
          _accumulatedSecondsMeta,
        ),
      );
    }
    if (data.containsKey('planned_seconds')) {
      context.handle(
        _plannedSecondsMeta,
        plannedSeconds.isAcceptableOrUnknown(
          data['planned_seconds']!,
          _plannedSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedSecondsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('ended_at_utc')) {
      context.handle(
        _endedAtUtcMeta,
        endedAtUtc.isAcceptableOrUnknown(
          data['ended_at_utc']!,
          _endedAtUtcMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSessionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSessionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      startedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at_utc'],
      )!,
      activeSegmentStartedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}active_segment_started_at_utc'],
      ),
      accumulatedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accumulated_seconds'],
      )!,
      plannedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_seconds'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      endedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at_utc'],
      ),
    );
  }

  @override
  $FocusSessionsTableTable createAlias(String alias) {
    return $FocusSessionsTableTable(attachedDatabase, alias);
  }
}

class FocusSessionsTableData extends DataClass
    implements Insertable<FocusSessionsTableData> {
  final String id;
  final String habitId;
  final DateTime startedAtUtc;
  final DateTime? activeSegmentStartedAtUtc;
  final int accumulatedSeconds;
  final int plannedSeconds;
  final String status;
  final DateTime? endedAtUtc;
  const FocusSessionsTableData({
    required this.id,
    required this.habitId,
    required this.startedAtUtc,
    this.activeSegmentStartedAtUtc,
    required this.accumulatedSeconds,
    required this.plannedSeconds,
    required this.status,
    this.endedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['started_at_utc'] = Variable<DateTime>(startedAtUtc);
    if (!nullToAbsent || activeSegmentStartedAtUtc != null) {
      map['active_segment_started_at_utc'] = Variable<DateTime>(
        activeSegmentStartedAtUtc,
      );
    }
    map['accumulated_seconds'] = Variable<int>(accumulatedSeconds);
    map['planned_seconds'] = Variable<int>(plannedSeconds);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || endedAtUtc != null) {
      map['ended_at_utc'] = Variable<DateTime>(endedAtUtc);
    }
    return map;
  }

  FocusSessionsTableCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsTableCompanion(
      id: Value(id),
      habitId: Value(habitId),
      startedAtUtc: Value(startedAtUtc),
      activeSegmentStartedAtUtc:
          activeSegmentStartedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(activeSegmentStartedAtUtc),
      accumulatedSeconds: Value(accumulatedSeconds),
      plannedSeconds: Value(plannedSeconds),
      status: Value(status),
      endedAtUtc: endedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAtUtc),
    );
  }

  factory FocusSessionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSessionsTableData(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      startedAtUtc: serializer.fromJson<DateTime>(json['startedAtUtc']),
      activeSegmentStartedAtUtc: serializer.fromJson<DateTime?>(
        json['activeSegmentStartedAtUtc'],
      ),
      accumulatedSeconds: serializer.fromJson<int>(json['accumulatedSeconds']),
      plannedSeconds: serializer.fromJson<int>(json['plannedSeconds']),
      status: serializer.fromJson<String>(json['status']),
      endedAtUtc: serializer.fromJson<DateTime?>(json['endedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'startedAtUtc': serializer.toJson<DateTime>(startedAtUtc),
      'activeSegmentStartedAtUtc': serializer.toJson<DateTime?>(
        activeSegmentStartedAtUtc,
      ),
      'accumulatedSeconds': serializer.toJson<int>(accumulatedSeconds),
      'plannedSeconds': serializer.toJson<int>(plannedSeconds),
      'status': serializer.toJson<String>(status),
      'endedAtUtc': serializer.toJson<DateTime?>(endedAtUtc),
    };
  }

  FocusSessionsTableData copyWith({
    String? id,
    String? habitId,
    DateTime? startedAtUtc,
    Value<DateTime?> activeSegmentStartedAtUtc = const Value.absent(),
    int? accumulatedSeconds,
    int? plannedSeconds,
    String? status,
    Value<DateTime?> endedAtUtc = const Value.absent(),
  }) => FocusSessionsTableData(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    startedAtUtc: startedAtUtc ?? this.startedAtUtc,
    activeSegmentStartedAtUtc: activeSegmentStartedAtUtc.present
        ? activeSegmentStartedAtUtc.value
        : this.activeSegmentStartedAtUtc,
    accumulatedSeconds: accumulatedSeconds ?? this.accumulatedSeconds,
    plannedSeconds: plannedSeconds ?? this.plannedSeconds,
    status: status ?? this.status,
    endedAtUtc: endedAtUtc.present ? endedAtUtc.value : this.endedAtUtc,
  );
  FocusSessionsTableData copyWithCompanion(FocusSessionsTableCompanion data) {
    return FocusSessionsTableData(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      startedAtUtc: data.startedAtUtc.present
          ? data.startedAtUtc.value
          : this.startedAtUtc,
      activeSegmentStartedAtUtc: data.activeSegmentStartedAtUtc.present
          ? data.activeSegmentStartedAtUtc.value
          : this.activeSegmentStartedAtUtc,
      accumulatedSeconds: data.accumulatedSeconds.present
          ? data.accumulatedSeconds.value
          : this.accumulatedSeconds,
      plannedSeconds: data.plannedSeconds.present
          ? data.plannedSeconds.value
          : this.plannedSeconds,
      status: data.status.present ? data.status.value : this.status,
      endedAtUtc: data.endedAtUtc.present
          ? data.endedAtUtc.value
          : this.endedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsTableData(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('startedAtUtc: $startedAtUtc, ')
          ..write('activeSegmentStartedAtUtc: $activeSegmentStartedAtUtc, ')
          ..write('accumulatedSeconds: $accumulatedSeconds, ')
          ..write('plannedSeconds: $plannedSeconds, ')
          ..write('status: $status, ')
          ..write('endedAtUtc: $endedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    habitId,
    startedAtUtc,
    activeSegmentStartedAtUtc,
    accumulatedSeconds,
    plannedSeconds,
    status,
    endedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSessionsTableData &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.startedAtUtc == this.startedAtUtc &&
          other.activeSegmentStartedAtUtc == this.activeSegmentStartedAtUtc &&
          other.accumulatedSeconds == this.accumulatedSeconds &&
          other.plannedSeconds == this.plannedSeconds &&
          other.status == this.status &&
          other.endedAtUtc == this.endedAtUtc);
}

class FocusSessionsTableCompanion
    extends UpdateCompanion<FocusSessionsTableData> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<DateTime> startedAtUtc;
  final Value<DateTime?> activeSegmentStartedAtUtc;
  final Value<int> accumulatedSeconds;
  final Value<int> plannedSeconds;
  final Value<String> status;
  final Value<DateTime?> endedAtUtc;
  final Value<int> rowid;
  const FocusSessionsTableCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.startedAtUtc = const Value.absent(),
    this.activeSegmentStartedAtUtc = const Value.absent(),
    this.accumulatedSeconds = const Value.absent(),
    this.plannedSeconds = const Value.absent(),
    this.status = const Value.absent(),
    this.endedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocusSessionsTableCompanion.insert({
    required String id,
    required String habitId,
    required DateTime startedAtUtc,
    this.activeSegmentStartedAtUtc = const Value.absent(),
    this.accumulatedSeconds = const Value.absent(),
    required int plannedSeconds,
    required String status,
    this.endedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       habitId = Value(habitId),
       startedAtUtc = Value(startedAtUtc),
       plannedSeconds = Value(plannedSeconds),
       status = Value(status);
  static Insertable<FocusSessionsTableData> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<DateTime>? startedAtUtc,
    Expression<DateTime>? activeSegmentStartedAtUtc,
    Expression<int>? accumulatedSeconds,
    Expression<int>? plannedSeconds,
    Expression<String>? status,
    Expression<DateTime>? endedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (startedAtUtc != null) 'started_at_utc': startedAtUtc,
      if (activeSegmentStartedAtUtc != null)
        'active_segment_started_at_utc': activeSegmentStartedAtUtc,
      if (accumulatedSeconds != null) 'accumulated_seconds': accumulatedSeconds,
      if (plannedSeconds != null) 'planned_seconds': plannedSeconds,
      if (status != null) 'status': status,
      if (endedAtUtc != null) 'ended_at_utc': endedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocusSessionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? habitId,
    Value<DateTime>? startedAtUtc,
    Value<DateTime?>? activeSegmentStartedAtUtc,
    Value<int>? accumulatedSeconds,
    Value<int>? plannedSeconds,
    Value<String>? status,
    Value<DateTime?>? endedAtUtc,
    Value<int>? rowid,
  }) {
    return FocusSessionsTableCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      startedAtUtc: startedAtUtc ?? this.startedAtUtc,
      activeSegmentStartedAtUtc:
          activeSegmentStartedAtUtc ?? this.activeSegmentStartedAtUtc,
      accumulatedSeconds: accumulatedSeconds ?? this.accumulatedSeconds,
      plannedSeconds: plannedSeconds ?? this.plannedSeconds,
      status: status ?? this.status,
      endedAtUtc: endedAtUtc ?? this.endedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (startedAtUtc.present) {
      map['started_at_utc'] = Variable<DateTime>(startedAtUtc.value);
    }
    if (activeSegmentStartedAtUtc.present) {
      map['active_segment_started_at_utc'] = Variable<DateTime>(
        activeSegmentStartedAtUtc.value,
      );
    }
    if (accumulatedSeconds.present) {
      map['accumulated_seconds'] = Variable<int>(accumulatedSeconds.value);
    }
    if (plannedSeconds.present) {
      map['planned_seconds'] = Variable<int>(plannedSeconds.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (endedAtUtc.present) {
      map['ended_at_utc'] = Variable<DateTime>(endedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsTableCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('startedAtUtc: $startedAtUtc, ')
          ..write('activeSegmentStartedAtUtc: $activeSegmentStartedAtUtc, ')
          ..write('accumulatedSeconds: $accumulatedSeconds, ')
          ..write('plannedSeconds: $plannedSeconds, ')
          ..write('status: $status, ')
          ..write('endedAtUtc: $endedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FocusAllocationsTableTable extends FocusAllocationsTable
    with TableInfo<$FocusAllocationsTableTable, FocusAllocationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusAllocationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES focus_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeSecondsMeta = const VerificationMeta(
    'activeSeconds',
  );
  @override
  late final GeneratedColumn<int> activeSeconds = GeneratedColumn<int>(
    'active_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [sessionId, localDate, activeSeconds];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusAllocationsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('active_seconds')) {
      context.handle(
        _activeSecondsMeta,
        activeSeconds.isAcceptableOrUnknown(
          data['active_seconds']!,
          _activeSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activeSecondsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId, localDate};
  @override
  FocusAllocationsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusAllocationsTableData(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      activeSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active_seconds'],
      )!,
    );
  }

  @override
  $FocusAllocationsTableTable createAlias(String alias) {
    return $FocusAllocationsTableTable(attachedDatabase, alias);
  }
}

class FocusAllocationsTableData extends DataClass
    implements Insertable<FocusAllocationsTableData> {
  final String sessionId;
  final String localDate;
  final int activeSeconds;
  const FocusAllocationsTableData({
    required this.sessionId,
    required this.localDate,
    required this.activeSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['local_date'] = Variable<String>(localDate);
    map['active_seconds'] = Variable<int>(activeSeconds);
    return map;
  }

  FocusAllocationsTableCompanion toCompanion(bool nullToAbsent) {
    return FocusAllocationsTableCompanion(
      sessionId: Value(sessionId),
      localDate: Value(localDate),
      activeSeconds: Value(activeSeconds),
    );
  }

  factory FocusAllocationsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusAllocationsTableData(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      localDate: serializer.fromJson<String>(json['localDate']),
      activeSeconds: serializer.fromJson<int>(json['activeSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'localDate': serializer.toJson<String>(localDate),
      'activeSeconds': serializer.toJson<int>(activeSeconds),
    };
  }

  FocusAllocationsTableData copyWith({
    String? sessionId,
    String? localDate,
    int? activeSeconds,
  }) => FocusAllocationsTableData(
    sessionId: sessionId ?? this.sessionId,
    localDate: localDate ?? this.localDate,
    activeSeconds: activeSeconds ?? this.activeSeconds,
  );
  FocusAllocationsTableData copyWithCompanion(
    FocusAllocationsTableCompanion data,
  ) {
    return FocusAllocationsTableData(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      activeSeconds: data.activeSeconds.present
          ? data.activeSeconds.value
          : this.activeSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusAllocationsTableData(')
          ..write('sessionId: $sessionId, ')
          ..write('localDate: $localDate, ')
          ..write('activeSeconds: $activeSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sessionId, localDate, activeSeconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusAllocationsTableData &&
          other.sessionId == this.sessionId &&
          other.localDate == this.localDate &&
          other.activeSeconds == this.activeSeconds);
}

class FocusAllocationsTableCompanion
    extends UpdateCompanion<FocusAllocationsTableData> {
  final Value<String> sessionId;
  final Value<String> localDate;
  final Value<int> activeSeconds;
  final Value<int> rowid;
  const FocusAllocationsTableCompanion({
    this.sessionId = const Value.absent(),
    this.localDate = const Value.absent(),
    this.activeSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocusAllocationsTableCompanion.insert({
    required String sessionId,
    required String localDate,
    required int activeSeconds,
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       localDate = Value(localDate),
       activeSeconds = Value(activeSeconds);
  static Insertable<FocusAllocationsTableData> custom({
    Expression<String>? sessionId,
    Expression<String>? localDate,
    Expression<int>? activeSeconds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (localDate != null) 'local_date': localDate,
      if (activeSeconds != null) 'active_seconds': activeSeconds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocusAllocationsTableCompanion copyWith({
    Value<String>? sessionId,
    Value<String>? localDate,
    Value<int>? activeSeconds,
    Value<int>? rowid,
  }) {
    return FocusAllocationsTableCompanion(
      sessionId: sessionId ?? this.sessionId,
      localDate: localDate ?? this.localDate,
      activeSeconds: activeSeconds ?? this.activeSeconds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (activeSeconds.present) {
      map['active_seconds'] = Variable<int>(activeSeconds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusAllocationsTableCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('localDate: $localDate, ')
          ..write('activeSeconds: $activeSeconds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RewardsTableTable extends RewardsTable
    with TableInfo<$RewardsTableTable, RewardsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
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
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 500),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetStepsMeta = const VerificationMeta(
    'targetSteps',
  );
  @override
  late final GeneratedColumn<int> targetSteps = GeneratedColumn<int>(
    'target_steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activatedAtUtcMeta = const VerificationMeta(
    'activatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> activatedAtUtc =
      GeneratedColumn<DateTime>(
        'activated_at_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _earnedAtUtcMeta = const VerificationMeta(
    'earnedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> earnedAtUtc = GeneratedColumn<DateTime>(
    'earned_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usedAtUtcMeta = const VerificationMeta(
    'usedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> usedAtUtc = GeneratedColumn<DateTime>(
    'used_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planAtUtcMeta = const VerificationMeta(
    'planAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> planAtUtc = GeneratedColumn<DateTime>(
    'plan_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planTimezoneMeta = const VerificationMeta(
    'planTimezone',
  );
  @override
  late final GeneratedColumn<String> planTimezone = GeneratedColumn<String>(
    'plan_timezone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeNameMeta = const VerificationMeta(
    'placeName',
  );
  @override
  late final GeneratedColumn<String> placeName = GeneratedColumn<String>(
    'place_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planNoteMeta = const VerificationMeta(
    'planNote',
  );
  @override
  late final GeneratedColumn<String> planNote = GeneratedColumn<String>(
    'plan_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    emoji,
    description,
    targetSteps,
    status,
    activatedAtUtc,
    earnedAtUtc,
    usedAtUtc,
    planAtUtc,
    planTimezone,
    placeName,
    planNote,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rewards';
  @override
  VerificationContext validateIntegrity(
    Insertable<RewardsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('target_steps')) {
      context.handle(
        _targetStepsMeta,
        targetSteps.isAcceptableOrUnknown(
          data['target_steps']!,
          _targetStepsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetStepsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('activated_at_utc')) {
      context.handle(
        _activatedAtUtcMeta,
        activatedAtUtc.isAcceptableOrUnknown(
          data['activated_at_utc']!,
          _activatedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('earned_at_utc')) {
      context.handle(
        _earnedAtUtcMeta,
        earnedAtUtc.isAcceptableOrUnknown(
          data['earned_at_utc']!,
          _earnedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('used_at_utc')) {
      context.handle(
        _usedAtUtcMeta,
        usedAtUtc.isAcceptableOrUnknown(data['used_at_utc']!, _usedAtUtcMeta),
      );
    }
    if (data.containsKey('plan_at_utc')) {
      context.handle(
        _planAtUtcMeta,
        planAtUtc.isAcceptableOrUnknown(data['plan_at_utc']!, _planAtUtcMeta),
      );
    }
    if (data.containsKey('plan_timezone')) {
      context.handle(
        _planTimezoneMeta,
        planTimezone.isAcceptableOrUnknown(
          data['plan_timezone']!,
          _planTimezoneMeta,
        ),
      );
    }
    if (data.containsKey('place_name')) {
      context.handle(
        _placeNameMeta,
        placeName.isAcceptableOrUnknown(data['place_name']!, _placeNameMeta),
      );
    }
    if (data.containsKey('plan_note')) {
      context.handle(
        _planNoteMeta,
        planNote.isAcceptableOrUnknown(data['plan_note']!, _planNoteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RewardsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RewardsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      targetSteps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_steps'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      activatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}activated_at_utc'],
      ),
      earnedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}earned_at_utc'],
      ),
      usedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}used_at_utc'],
      ),
      planAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}plan_at_utc'],
      ),
      planTimezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_timezone'],
      ),
      placeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_name'],
      ),
      planNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_note'],
      ),
    );
  }

  @override
  $RewardsTableTable createAlias(String alias) {
    return $RewardsTableTable(attachedDatabase, alias);
  }
}

class RewardsTableData extends DataClass
    implements Insertable<RewardsTableData> {
  final String id;
  final String title;
  final String emoji;
  final String description;
  final int targetSteps;
  final String status;
  final DateTime? activatedAtUtc;
  final DateTime? earnedAtUtc;
  final DateTime? usedAtUtc;
  final DateTime? planAtUtc;
  final String? planTimezone;
  final String? placeName;
  final String? planNote;
  const RewardsTableData({
    required this.id,
    required this.title,
    required this.emoji,
    required this.description,
    required this.targetSteps,
    required this.status,
    this.activatedAtUtc,
    this.earnedAtUtc,
    this.usedAtUtc,
    this.planAtUtc,
    this.planTimezone,
    this.placeName,
    this.planNote,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['emoji'] = Variable<String>(emoji);
    map['description'] = Variable<String>(description);
    map['target_steps'] = Variable<int>(targetSteps);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || activatedAtUtc != null) {
      map['activated_at_utc'] = Variable<DateTime>(activatedAtUtc);
    }
    if (!nullToAbsent || earnedAtUtc != null) {
      map['earned_at_utc'] = Variable<DateTime>(earnedAtUtc);
    }
    if (!nullToAbsent || usedAtUtc != null) {
      map['used_at_utc'] = Variable<DateTime>(usedAtUtc);
    }
    if (!nullToAbsent || planAtUtc != null) {
      map['plan_at_utc'] = Variable<DateTime>(planAtUtc);
    }
    if (!nullToAbsent || planTimezone != null) {
      map['plan_timezone'] = Variable<String>(planTimezone);
    }
    if (!nullToAbsent || placeName != null) {
      map['place_name'] = Variable<String>(placeName);
    }
    if (!nullToAbsent || planNote != null) {
      map['plan_note'] = Variable<String>(planNote);
    }
    return map;
  }

  RewardsTableCompanion toCompanion(bool nullToAbsent) {
    return RewardsTableCompanion(
      id: Value(id),
      title: Value(title),
      emoji: Value(emoji),
      description: Value(description),
      targetSteps: Value(targetSteps),
      status: Value(status),
      activatedAtUtc: activatedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(activatedAtUtc),
      earnedAtUtc: earnedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(earnedAtUtc),
      usedAtUtc: usedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(usedAtUtc),
      planAtUtc: planAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(planAtUtc),
      planTimezone: planTimezone == null && nullToAbsent
          ? const Value.absent()
          : Value(planTimezone),
      placeName: placeName == null && nullToAbsent
          ? const Value.absent()
          : Value(placeName),
      planNote: planNote == null && nullToAbsent
          ? const Value.absent()
          : Value(planNote),
    );
  }

  factory RewardsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RewardsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      emoji: serializer.fromJson<String>(json['emoji']),
      description: serializer.fromJson<String>(json['description']),
      targetSteps: serializer.fromJson<int>(json['targetSteps']),
      status: serializer.fromJson<String>(json['status']),
      activatedAtUtc: serializer.fromJson<DateTime?>(json['activatedAtUtc']),
      earnedAtUtc: serializer.fromJson<DateTime?>(json['earnedAtUtc']),
      usedAtUtc: serializer.fromJson<DateTime?>(json['usedAtUtc']),
      planAtUtc: serializer.fromJson<DateTime?>(json['planAtUtc']),
      planTimezone: serializer.fromJson<String?>(json['planTimezone']),
      placeName: serializer.fromJson<String?>(json['placeName']),
      planNote: serializer.fromJson<String?>(json['planNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'emoji': serializer.toJson<String>(emoji),
      'description': serializer.toJson<String>(description),
      'targetSteps': serializer.toJson<int>(targetSteps),
      'status': serializer.toJson<String>(status),
      'activatedAtUtc': serializer.toJson<DateTime?>(activatedAtUtc),
      'earnedAtUtc': serializer.toJson<DateTime?>(earnedAtUtc),
      'usedAtUtc': serializer.toJson<DateTime?>(usedAtUtc),
      'planAtUtc': serializer.toJson<DateTime?>(planAtUtc),
      'planTimezone': serializer.toJson<String?>(planTimezone),
      'placeName': serializer.toJson<String?>(placeName),
      'planNote': serializer.toJson<String?>(planNote),
    };
  }

  RewardsTableData copyWith({
    String? id,
    String? title,
    String? emoji,
    String? description,
    int? targetSteps,
    String? status,
    Value<DateTime?> activatedAtUtc = const Value.absent(),
    Value<DateTime?> earnedAtUtc = const Value.absent(),
    Value<DateTime?> usedAtUtc = const Value.absent(),
    Value<DateTime?> planAtUtc = const Value.absent(),
    Value<String?> planTimezone = const Value.absent(),
    Value<String?> placeName = const Value.absent(),
    Value<String?> planNote = const Value.absent(),
  }) => RewardsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    emoji: emoji ?? this.emoji,
    description: description ?? this.description,
    targetSteps: targetSteps ?? this.targetSteps,
    status: status ?? this.status,
    activatedAtUtc: activatedAtUtc.present
        ? activatedAtUtc.value
        : this.activatedAtUtc,
    earnedAtUtc: earnedAtUtc.present ? earnedAtUtc.value : this.earnedAtUtc,
    usedAtUtc: usedAtUtc.present ? usedAtUtc.value : this.usedAtUtc,
    planAtUtc: planAtUtc.present ? planAtUtc.value : this.planAtUtc,
    planTimezone: planTimezone.present ? planTimezone.value : this.planTimezone,
    placeName: placeName.present ? placeName.value : this.placeName,
    planNote: planNote.present ? planNote.value : this.planNote,
  );
  RewardsTableData copyWithCompanion(RewardsTableCompanion data) {
    return RewardsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      description: data.description.present
          ? data.description.value
          : this.description,
      targetSteps: data.targetSteps.present
          ? data.targetSteps.value
          : this.targetSteps,
      status: data.status.present ? data.status.value : this.status,
      activatedAtUtc: data.activatedAtUtc.present
          ? data.activatedAtUtc.value
          : this.activatedAtUtc,
      earnedAtUtc: data.earnedAtUtc.present
          ? data.earnedAtUtc.value
          : this.earnedAtUtc,
      usedAtUtc: data.usedAtUtc.present ? data.usedAtUtc.value : this.usedAtUtc,
      planAtUtc: data.planAtUtc.present ? data.planAtUtc.value : this.planAtUtc,
      planTimezone: data.planTimezone.present
          ? data.planTimezone.value
          : this.planTimezone,
      placeName: data.placeName.present ? data.placeName.value : this.placeName,
      planNote: data.planNote.present ? data.planNote.value : this.planNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RewardsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('emoji: $emoji, ')
          ..write('description: $description, ')
          ..write('targetSteps: $targetSteps, ')
          ..write('status: $status, ')
          ..write('activatedAtUtc: $activatedAtUtc, ')
          ..write('earnedAtUtc: $earnedAtUtc, ')
          ..write('usedAtUtc: $usedAtUtc, ')
          ..write('planAtUtc: $planAtUtc, ')
          ..write('planTimezone: $planTimezone, ')
          ..write('placeName: $placeName, ')
          ..write('planNote: $planNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    emoji,
    description,
    targetSteps,
    status,
    activatedAtUtc,
    earnedAtUtc,
    usedAtUtc,
    planAtUtc,
    planTimezone,
    placeName,
    planNote,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RewardsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.emoji == this.emoji &&
          other.description == this.description &&
          other.targetSteps == this.targetSteps &&
          other.status == this.status &&
          other.activatedAtUtc == this.activatedAtUtc &&
          other.earnedAtUtc == this.earnedAtUtc &&
          other.usedAtUtc == this.usedAtUtc &&
          other.planAtUtc == this.planAtUtc &&
          other.planTimezone == this.planTimezone &&
          other.placeName == this.placeName &&
          other.planNote == this.planNote);
}

class RewardsTableCompanion extends UpdateCompanion<RewardsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> emoji;
  final Value<String> description;
  final Value<int> targetSteps;
  final Value<String> status;
  final Value<DateTime?> activatedAtUtc;
  final Value<DateTime?> earnedAtUtc;
  final Value<DateTime?> usedAtUtc;
  final Value<DateTime?> planAtUtc;
  final Value<String?> planTimezone;
  final Value<String?> placeName;
  final Value<String?> planNote;
  final Value<int> rowid;
  const RewardsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.emoji = const Value.absent(),
    this.description = const Value.absent(),
    this.targetSteps = const Value.absent(),
    this.status = const Value.absent(),
    this.activatedAtUtc = const Value.absent(),
    this.earnedAtUtc = const Value.absent(),
    this.usedAtUtc = const Value.absent(),
    this.planAtUtc = const Value.absent(),
    this.planTimezone = const Value.absent(),
    this.placeName = const Value.absent(),
    this.planNote = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardsTableCompanion.insert({
    required String id,
    required String title,
    required String emoji,
    required String description,
    required int targetSteps,
    required String status,
    this.activatedAtUtc = const Value.absent(),
    this.earnedAtUtc = const Value.absent(),
    this.usedAtUtc = const Value.absent(),
    this.planAtUtc = const Value.absent(),
    this.planTimezone = const Value.absent(),
    this.placeName = const Value.absent(),
    this.planNote = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       emoji = Value(emoji),
       description = Value(description),
       targetSteps = Value(targetSteps),
       status = Value(status);
  static Insertable<RewardsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? emoji,
    Expression<String>? description,
    Expression<int>? targetSteps,
    Expression<String>? status,
    Expression<DateTime>? activatedAtUtc,
    Expression<DateTime>? earnedAtUtc,
    Expression<DateTime>? usedAtUtc,
    Expression<DateTime>? planAtUtc,
    Expression<String>? planTimezone,
    Expression<String>? placeName,
    Expression<String>? planNote,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (emoji != null) 'emoji': emoji,
      if (description != null) 'description': description,
      if (targetSteps != null) 'target_steps': targetSteps,
      if (status != null) 'status': status,
      if (activatedAtUtc != null) 'activated_at_utc': activatedAtUtc,
      if (earnedAtUtc != null) 'earned_at_utc': earnedAtUtc,
      if (usedAtUtc != null) 'used_at_utc': usedAtUtc,
      if (planAtUtc != null) 'plan_at_utc': planAtUtc,
      if (planTimezone != null) 'plan_timezone': planTimezone,
      if (placeName != null) 'place_name': placeName,
      if (planNote != null) 'plan_note': planNote,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? emoji,
    Value<String>? description,
    Value<int>? targetSteps,
    Value<String>? status,
    Value<DateTime?>? activatedAtUtc,
    Value<DateTime?>? earnedAtUtc,
    Value<DateTime?>? usedAtUtc,
    Value<DateTime?>? planAtUtc,
    Value<String?>? planTimezone,
    Value<String?>? placeName,
    Value<String?>? planNote,
    Value<int>? rowid,
  }) {
    return RewardsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
      targetSteps: targetSteps ?? this.targetSteps,
      status: status ?? this.status,
      activatedAtUtc: activatedAtUtc ?? this.activatedAtUtc,
      earnedAtUtc: earnedAtUtc ?? this.earnedAtUtc,
      usedAtUtc: usedAtUtc ?? this.usedAtUtc,
      planAtUtc: planAtUtc ?? this.planAtUtc,
      planTimezone: planTimezone ?? this.planTimezone,
      placeName: placeName ?? this.placeName,
      planNote: planNote ?? this.planNote,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (targetSteps.present) {
      map['target_steps'] = Variable<int>(targetSteps.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (activatedAtUtc.present) {
      map['activated_at_utc'] = Variable<DateTime>(activatedAtUtc.value);
    }
    if (earnedAtUtc.present) {
      map['earned_at_utc'] = Variable<DateTime>(earnedAtUtc.value);
    }
    if (usedAtUtc.present) {
      map['used_at_utc'] = Variable<DateTime>(usedAtUtc.value);
    }
    if (planAtUtc.present) {
      map['plan_at_utc'] = Variable<DateTime>(planAtUtc.value);
    }
    if (planTimezone.present) {
      map['plan_timezone'] = Variable<String>(planTimezone.value);
    }
    if (placeName.present) {
      map['place_name'] = Variable<String>(placeName.value);
    }
    if (planNote.present) {
      map['plan_note'] = Variable<String>(planNote.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('emoji: $emoji, ')
          ..write('description: $description, ')
          ..write('targetSteps: $targetSteps, ')
          ..write('status: $status, ')
          ..write('activatedAtUtc: $activatedAtUtc, ')
          ..write('earnedAtUtc: $earnedAtUtc, ')
          ..write('usedAtUtc: $usedAtUtc, ')
          ..write('planAtUtc: $planAtUtc, ')
          ..write('planTimezone: $planTimezone, ')
          ..write('placeName: $placeName, ')
          ..write('planNote: $planNote, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RewardHabitLinksTableTable extends RewardHabitLinksTable
    with TableInfo<$RewardHabitLinksTableTable, RewardHabitLinksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardHabitLinksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rewardIdMeta = const VerificationMeta(
    'rewardId',
  );
  @override
  late final GeneratedColumn<String> rewardId = GeneratedColumn<String>(
    'reward_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rewards (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [rewardId, habitId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reward_habit_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<RewardHabitLinksTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('reward_id')) {
      context.handle(
        _rewardIdMeta,
        rewardId.isAcceptableOrUnknown(data['reward_id']!, _rewardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rewardIdMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rewardId, habitId};
  @override
  RewardHabitLinksTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RewardHabitLinksTableData(
      rewardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reward_id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
    );
  }

  @override
  $RewardHabitLinksTableTable createAlias(String alias) {
    return $RewardHabitLinksTableTable(attachedDatabase, alias);
  }
}

class RewardHabitLinksTableData extends DataClass
    implements Insertable<RewardHabitLinksTableData> {
  final String rewardId;
  final String habitId;
  const RewardHabitLinksTableData({
    required this.rewardId,
    required this.habitId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['reward_id'] = Variable<String>(rewardId);
    map['habit_id'] = Variable<String>(habitId);
    return map;
  }

  RewardHabitLinksTableCompanion toCompanion(bool nullToAbsent) {
    return RewardHabitLinksTableCompanion(
      rewardId: Value(rewardId),
      habitId: Value(habitId),
    );
  }

  factory RewardHabitLinksTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RewardHabitLinksTableData(
      rewardId: serializer.fromJson<String>(json['rewardId']),
      habitId: serializer.fromJson<String>(json['habitId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rewardId': serializer.toJson<String>(rewardId),
      'habitId': serializer.toJson<String>(habitId),
    };
  }

  RewardHabitLinksTableData copyWith({String? rewardId, String? habitId}) =>
      RewardHabitLinksTableData(
        rewardId: rewardId ?? this.rewardId,
        habitId: habitId ?? this.habitId,
      );
  RewardHabitLinksTableData copyWithCompanion(
    RewardHabitLinksTableCompanion data,
  ) {
    return RewardHabitLinksTableData(
      rewardId: data.rewardId.present ? data.rewardId.value : this.rewardId,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RewardHabitLinksTableData(')
          ..write('rewardId: $rewardId, ')
          ..write('habitId: $habitId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rewardId, habitId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RewardHabitLinksTableData &&
          other.rewardId == this.rewardId &&
          other.habitId == this.habitId);
}

class RewardHabitLinksTableCompanion
    extends UpdateCompanion<RewardHabitLinksTableData> {
  final Value<String> rewardId;
  final Value<String> habitId;
  final Value<int> rowid;
  const RewardHabitLinksTableCompanion({
    this.rewardId = const Value.absent(),
    this.habitId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardHabitLinksTableCompanion.insert({
    required String rewardId,
    required String habitId,
    this.rowid = const Value.absent(),
  }) : rewardId = Value(rewardId),
       habitId = Value(habitId);
  static Insertable<RewardHabitLinksTableData> custom({
    Expression<String>? rewardId,
    Expression<String>? habitId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rewardId != null) 'reward_id': rewardId,
      if (habitId != null) 'habit_id': habitId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardHabitLinksTableCompanion copyWith({
    Value<String>? rewardId,
    Value<String>? habitId,
    Value<int>? rowid,
  }) {
    return RewardHabitLinksTableCompanion(
      rewardId: rewardId ?? this.rewardId,
      habitId: habitId ?? this.habitId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rewardId.present) {
      map['reward_id'] = Variable<String>(rewardId.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardHabitLinksTableCompanion(')
          ..write('rewardId: $rewardId, ')
          ..write('habitId: $habitId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RewardContributionsTableTable extends RewardContributionsTable
    with
        TableInfo<
          $RewardContributionsTableTable,
          RewardContributionsTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardContributionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rewardIdMeta = const VerificationMeta(
    'rewardId',
  );
  @override
  late final GeneratedColumn<String> rewardId = GeneratedColumn<String>(
    'reward_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rewards (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _checkInIdMeta = const VerificationMeta(
    'checkInId',
  );
  @override
  late final GeneratedColumn<String> checkInId = GeneratedColumn<String>(
    'check_in_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allocatedAtUtcMeta = const VerificationMeta(
    'allocatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> allocatedAtUtc =
      GeneratedColumn<DateTime>(
        'allocated_at_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _isReversedMeta = const VerificationMeta(
    'isReversed',
  );
  @override
  late final GeneratedColumn<bool> isReversed = GeneratedColumn<bool>(
    'is_reversed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_reversed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reversedAfterUseMeta = const VerificationMeta(
    'reversedAfterUse',
  );
  @override
  late final GeneratedColumn<bool> reversedAfterUse = GeneratedColumn<bool>(
    'reversed_after_use',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reversed_after_use" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    rewardId,
    checkInId,
    allocatedAtUtc,
    isReversed,
    reversedAfterUse,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reward_contributions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RewardContributionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('reward_id')) {
      context.handle(
        _rewardIdMeta,
        rewardId.isAcceptableOrUnknown(data['reward_id']!, _rewardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rewardIdMeta);
    }
    if (data.containsKey('check_in_id')) {
      context.handle(
        _checkInIdMeta,
        checkInId.isAcceptableOrUnknown(data['check_in_id']!, _checkInIdMeta),
      );
    }
    if (data.containsKey('allocated_at_utc')) {
      context.handle(
        _allocatedAtUtcMeta,
        allocatedAtUtc.isAcceptableOrUnknown(
          data['allocated_at_utc']!,
          _allocatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_allocatedAtUtcMeta);
    }
    if (data.containsKey('is_reversed')) {
      context.handle(
        _isReversedMeta,
        isReversed.isAcceptableOrUnknown(data['is_reversed']!, _isReversedMeta),
      );
    }
    if (data.containsKey('reversed_after_use')) {
      context.handle(
        _reversedAfterUseMeta,
        reversedAfterUse.isAcceptableOrUnknown(
          data['reversed_after_use']!,
          _reversedAfterUseMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RewardContributionsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RewardContributionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rewardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reward_id'],
      )!,
      checkInId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}check_in_id'],
      ),
      allocatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}allocated_at_utc'],
      )!,
      isReversed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_reversed'],
      )!,
      reversedAfterUse: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reversed_after_use'],
      )!,
    );
  }

  @override
  $RewardContributionsTableTable createAlias(String alias) {
    return $RewardContributionsTableTable(attachedDatabase, alias);
  }
}

class RewardContributionsTableData extends DataClass
    implements Insertable<RewardContributionsTableData> {
  final String id;
  final String rewardId;
  final String? checkInId;
  final DateTime allocatedAtUtc;
  final bool isReversed;
  final bool reversedAfterUse;
  const RewardContributionsTableData({
    required this.id,
    required this.rewardId,
    this.checkInId,
    required this.allocatedAtUtc,
    required this.isReversed,
    required this.reversedAfterUse,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['reward_id'] = Variable<String>(rewardId);
    if (!nullToAbsent || checkInId != null) {
      map['check_in_id'] = Variable<String>(checkInId);
    }
    map['allocated_at_utc'] = Variable<DateTime>(allocatedAtUtc);
    map['is_reversed'] = Variable<bool>(isReversed);
    map['reversed_after_use'] = Variable<bool>(reversedAfterUse);
    return map;
  }

  RewardContributionsTableCompanion toCompanion(bool nullToAbsent) {
    return RewardContributionsTableCompanion(
      id: Value(id),
      rewardId: Value(rewardId),
      checkInId: checkInId == null && nullToAbsent
          ? const Value.absent()
          : Value(checkInId),
      allocatedAtUtc: Value(allocatedAtUtc),
      isReversed: Value(isReversed),
      reversedAfterUse: Value(reversedAfterUse),
    );
  }

  factory RewardContributionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RewardContributionsTableData(
      id: serializer.fromJson<String>(json['id']),
      rewardId: serializer.fromJson<String>(json['rewardId']),
      checkInId: serializer.fromJson<String?>(json['checkInId']),
      allocatedAtUtc: serializer.fromJson<DateTime>(json['allocatedAtUtc']),
      isReversed: serializer.fromJson<bool>(json['isReversed']),
      reversedAfterUse: serializer.fromJson<bool>(json['reversedAfterUse']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rewardId': serializer.toJson<String>(rewardId),
      'checkInId': serializer.toJson<String?>(checkInId),
      'allocatedAtUtc': serializer.toJson<DateTime>(allocatedAtUtc),
      'isReversed': serializer.toJson<bool>(isReversed),
      'reversedAfterUse': serializer.toJson<bool>(reversedAfterUse),
    };
  }

  RewardContributionsTableData copyWith({
    String? id,
    String? rewardId,
    Value<String?> checkInId = const Value.absent(),
    DateTime? allocatedAtUtc,
    bool? isReversed,
    bool? reversedAfterUse,
  }) => RewardContributionsTableData(
    id: id ?? this.id,
    rewardId: rewardId ?? this.rewardId,
    checkInId: checkInId.present ? checkInId.value : this.checkInId,
    allocatedAtUtc: allocatedAtUtc ?? this.allocatedAtUtc,
    isReversed: isReversed ?? this.isReversed,
    reversedAfterUse: reversedAfterUse ?? this.reversedAfterUse,
  );
  RewardContributionsTableData copyWithCompanion(
    RewardContributionsTableCompanion data,
  ) {
    return RewardContributionsTableData(
      id: data.id.present ? data.id.value : this.id,
      rewardId: data.rewardId.present ? data.rewardId.value : this.rewardId,
      checkInId: data.checkInId.present ? data.checkInId.value : this.checkInId,
      allocatedAtUtc: data.allocatedAtUtc.present
          ? data.allocatedAtUtc.value
          : this.allocatedAtUtc,
      isReversed: data.isReversed.present
          ? data.isReversed.value
          : this.isReversed,
      reversedAfterUse: data.reversedAfterUse.present
          ? data.reversedAfterUse.value
          : this.reversedAfterUse,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RewardContributionsTableData(')
          ..write('id: $id, ')
          ..write('rewardId: $rewardId, ')
          ..write('checkInId: $checkInId, ')
          ..write('allocatedAtUtc: $allocatedAtUtc, ')
          ..write('isReversed: $isReversed, ')
          ..write('reversedAfterUse: $reversedAfterUse')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    rewardId,
    checkInId,
    allocatedAtUtc,
    isReversed,
    reversedAfterUse,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RewardContributionsTableData &&
          other.id == this.id &&
          other.rewardId == this.rewardId &&
          other.checkInId == this.checkInId &&
          other.allocatedAtUtc == this.allocatedAtUtc &&
          other.isReversed == this.isReversed &&
          other.reversedAfterUse == this.reversedAfterUse);
}

class RewardContributionsTableCompanion
    extends UpdateCompanion<RewardContributionsTableData> {
  final Value<String> id;
  final Value<String> rewardId;
  final Value<String?> checkInId;
  final Value<DateTime> allocatedAtUtc;
  final Value<bool> isReversed;
  final Value<bool> reversedAfterUse;
  final Value<int> rowid;
  const RewardContributionsTableCompanion({
    this.id = const Value.absent(),
    this.rewardId = const Value.absent(),
    this.checkInId = const Value.absent(),
    this.allocatedAtUtc = const Value.absent(),
    this.isReversed = const Value.absent(),
    this.reversedAfterUse = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardContributionsTableCompanion.insert({
    required String id,
    required String rewardId,
    this.checkInId = const Value.absent(),
    required DateTime allocatedAtUtc,
    this.isReversed = const Value.absent(),
    this.reversedAfterUse = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rewardId = Value(rewardId),
       allocatedAtUtc = Value(allocatedAtUtc);
  static Insertable<RewardContributionsTableData> custom({
    Expression<String>? id,
    Expression<String>? rewardId,
    Expression<String>? checkInId,
    Expression<DateTime>? allocatedAtUtc,
    Expression<bool>? isReversed,
    Expression<bool>? reversedAfterUse,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rewardId != null) 'reward_id': rewardId,
      if (checkInId != null) 'check_in_id': checkInId,
      if (allocatedAtUtc != null) 'allocated_at_utc': allocatedAtUtc,
      if (isReversed != null) 'is_reversed': isReversed,
      if (reversedAfterUse != null) 'reversed_after_use': reversedAfterUse,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardContributionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? rewardId,
    Value<String?>? checkInId,
    Value<DateTime>? allocatedAtUtc,
    Value<bool>? isReversed,
    Value<bool>? reversedAfterUse,
    Value<int>? rowid,
  }) {
    return RewardContributionsTableCompanion(
      id: id ?? this.id,
      rewardId: rewardId ?? this.rewardId,
      checkInId: checkInId ?? this.checkInId,
      allocatedAtUtc: allocatedAtUtc ?? this.allocatedAtUtc,
      isReversed: isReversed ?? this.isReversed,
      reversedAfterUse: reversedAfterUse ?? this.reversedAfterUse,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (rewardId.present) {
      map['reward_id'] = Variable<String>(rewardId.value);
    }
    if (checkInId.present) {
      map['check_in_id'] = Variable<String>(checkInId.value);
    }
    if (allocatedAtUtc.present) {
      map['allocated_at_utc'] = Variable<DateTime>(allocatedAtUtc.value);
    }
    if (isReversed.present) {
      map['is_reversed'] = Variable<bool>(isReversed.value);
    }
    if (reversedAfterUse.present) {
      map['reversed_after_use'] = Variable<bool>(reversedAfterUse.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardContributionsTableCompanion(')
          ..write('id: $id, ')
          ..write('rewardId: $rewardId, ')
          ..write('checkInId: $checkInId, ')
          ..write('allocatedAtUtc: $allocatedAtUtc, ')
          ..write('isReversed: $isReversed, ')
          ..write('reversedAfterUse: $reversedAfterUse, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BadgesTableTable extends BadgesTable
    with TableInfo<$BadgesTableTable, BadgesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BadgesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earnedAtUtcMeta = const VerificationMeta(
    'earnedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> earnedAtUtc = GeneratedColumn<DateTime>(
    'earned_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _evidenceIdMeta = const VerificationMeta(
    'evidenceId',
  );
  @override
  late final GeneratedColumn<String> evidenceId = GeneratedColumn<String>(
    'evidence_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [code, earnedAtUtc, evidenceId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'badges';
  @override
  VerificationContext validateIntegrity(
    Insertable<BadgesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('earned_at_utc')) {
      context.handle(
        _earnedAtUtcMeta,
        earnedAtUtc.isAcceptableOrUnknown(
          data['earned_at_utc']!,
          _earnedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_earnedAtUtcMeta);
    }
    if (data.containsKey('evidence_id')) {
      context.handle(
        _evidenceIdMeta,
        evidenceId.isAcceptableOrUnknown(data['evidence_id']!, _evidenceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  BadgesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BadgesTableData(
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      earnedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}earned_at_utc'],
      )!,
      evidenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence_id'],
      ),
    );
  }

  @override
  $BadgesTableTable createAlias(String alias) {
    return $BadgesTableTable(attachedDatabase, alias);
  }
}

class BadgesTableData extends DataClass implements Insertable<BadgesTableData> {
  final String code;
  final DateTime earnedAtUtc;
  final String? evidenceId;
  const BadgesTableData({
    required this.code,
    required this.earnedAtUtc,
    this.evidenceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['earned_at_utc'] = Variable<DateTime>(earnedAtUtc);
    if (!nullToAbsent || evidenceId != null) {
      map['evidence_id'] = Variable<String>(evidenceId);
    }
    return map;
  }

  BadgesTableCompanion toCompanion(bool nullToAbsent) {
    return BadgesTableCompanion(
      code: Value(code),
      earnedAtUtc: Value(earnedAtUtc),
      evidenceId: evidenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(evidenceId),
    );
  }

  factory BadgesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BadgesTableData(
      code: serializer.fromJson<String>(json['code']),
      earnedAtUtc: serializer.fromJson<DateTime>(json['earnedAtUtc']),
      evidenceId: serializer.fromJson<String?>(json['evidenceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'earnedAtUtc': serializer.toJson<DateTime>(earnedAtUtc),
      'evidenceId': serializer.toJson<String?>(evidenceId),
    };
  }

  BadgesTableData copyWith({
    String? code,
    DateTime? earnedAtUtc,
    Value<String?> evidenceId = const Value.absent(),
  }) => BadgesTableData(
    code: code ?? this.code,
    earnedAtUtc: earnedAtUtc ?? this.earnedAtUtc,
    evidenceId: evidenceId.present ? evidenceId.value : this.evidenceId,
  );
  BadgesTableData copyWithCompanion(BadgesTableCompanion data) {
    return BadgesTableData(
      code: data.code.present ? data.code.value : this.code,
      earnedAtUtc: data.earnedAtUtc.present
          ? data.earnedAtUtc.value
          : this.earnedAtUtc,
      evidenceId: data.evidenceId.present
          ? data.evidenceId.value
          : this.evidenceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BadgesTableData(')
          ..write('code: $code, ')
          ..write('earnedAtUtc: $earnedAtUtc, ')
          ..write('evidenceId: $evidenceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, earnedAtUtc, evidenceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BadgesTableData &&
          other.code == this.code &&
          other.earnedAtUtc == this.earnedAtUtc &&
          other.evidenceId == this.evidenceId);
}

class BadgesTableCompanion extends UpdateCompanion<BadgesTableData> {
  final Value<String> code;
  final Value<DateTime> earnedAtUtc;
  final Value<String?> evidenceId;
  final Value<int> rowid;
  const BadgesTableCompanion({
    this.code = const Value.absent(),
    this.earnedAtUtc = const Value.absent(),
    this.evidenceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BadgesTableCompanion.insert({
    required String code,
    required DateTime earnedAtUtc,
    this.evidenceId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       earnedAtUtc = Value(earnedAtUtc);
  static Insertable<BadgesTableData> custom({
    Expression<String>? code,
    Expression<DateTime>? earnedAtUtc,
    Expression<String>? evidenceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (earnedAtUtc != null) 'earned_at_utc': earnedAtUtc,
      if (evidenceId != null) 'evidence_id': evidenceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BadgesTableCompanion copyWith({
    Value<String>? code,
    Value<DateTime>? earnedAtUtc,
    Value<String?>? evidenceId,
    Value<int>? rowid,
  }) {
    return BadgesTableCompanion(
      code: code ?? this.code,
      earnedAtUtc: earnedAtUtc ?? this.earnedAtUtc,
      evidenceId: evidenceId ?? this.evidenceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (earnedAtUtc.present) {
      map['earned_at_utc'] = Variable<DateTime>(earnedAtUtc.value);
    }
    if (evidenceId.present) {
      map['evidence_id'] = Variable<String>(evidenceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BadgesTableCompanion(')
          ..write('code: $code, ')
          ..write('earnedAtUtc: $earnedAtUtc, ')
          ..write('evidenceId: $evidenceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyReflectionsTableTable extends DailyReflectionsTable
    with TableInfo<$DailyReflectionsTableTable, DailyReflectionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyReflectionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textContentMeta = const VerificationMeta(
    'textContent',
  );
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
    'text_content',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 500),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [localDate, textContent, updatedAtUtc];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_reflections';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyReflectionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('text_content')) {
      context.handle(
        _textContentMeta,
        textContent.isAcceptableOrUnknown(
          data['text_content']!,
          _textContentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_textContentMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localDate};
  @override
  DailyReflectionsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyReflectionsTableData(
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      textContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_content'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
    );
  }

  @override
  $DailyReflectionsTableTable createAlias(String alias) {
    return $DailyReflectionsTableTable(attachedDatabase, alias);
  }
}

class DailyReflectionsTableData extends DataClass
    implements Insertable<DailyReflectionsTableData> {
  final String localDate;
  final String textContent;
  final DateTime updatedAtUtc;
  const DailyReflectionsTableData({
    required this.localDate,
    required this.textContent,
    required this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_date'] = Variable<String>(localDate);
    map['text_content'] = Variable<String>(textContent);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    return map;
  }

  DailyReflectionsTableCompanion toCompanion(bool nullToAbsent) {
    return DailyReflectionsTableCompanion(
      localDate: Value(localDate),
      textContent: Value(textContent),
      updatedAtUtc: Value(updatedAtUtc),
    );
  }

  factory DailyReflectionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyReflectionsTableData(
      localDate: serializer.fromJson<String>(json['localDate']),
      textContent: serializer.fromJson<String>(json['textContent']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localDate': serializer.toJson<String>(localDate),
      'textContent': serializer.toJson<String>(textContent),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
    };
  }

  DailyReflectionsTableData copyWith({
    String? localDate,
    String? textContent,
    DateTime? updatedAtUtc,
  }) => DailyReflectionsTableData(
    localDate: localDate ?? this.localDate,
    textContent: textContent ?? this.textContent,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
  );
  DailyReflectionsTableData copyWithCompanion(
    DailyReflectionsTableCompanion data,
  ) {
    return DailyReflectionsTableData(
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      textContent: data.textContent.present
          ? data.textContent.value
          : this.textContent,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyReflectionsTableData(')
          ..write('localDate: $localDate, ')
          ..write('textContent: $textContent, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(localDate, textContent, updatedAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyReflectionsTableData &&
          other.localDate == this.localDate &&
          other.textContent == this.textContent &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class DailyReflectionsTableCompanion
    extends UpdateCompanion<DailyReflectionsTableData> {
  final Value<String> localDate;
  final Value<String> textContent;
  final Value<DateTime> updatedAtUtc;
  final Value<int> rowid;
  const DailyReflectionsTableCompanion({
    this.localDate = const Value.absent(),
    this.textContent = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyReflectionsTableCompanion.insert({
    required String localDate,
    required String textContent,
    required DateTime updatedAtUtc,
    this.rowid = const Value.absent(),
  }) : localDate = Value(localDate),
       textContent = Value(textContent),
       updatedAtUtc = Value(updatedAtUtc);
  static Insertable<DailyReflectionsTableData> custom({
    Expression<String>? localDate,
    Expression<String>? textContent,
    Expression<DateTime>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localDate != null) 'local_date': localDate,
      if (textContent != null) 'text_content': textContent,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyReflectionsTableCompanion copyWith({
    Value<String>? localDate,
    Value<String>? textContent,
    Value<DateTime>? updatedAtUtc,
    Value<int>? rowid,
  }) {
    return DailyReflectionsTableCompanion(
      localDate: localDate ?? this.localDate,
      textContent: textContent ?? this.textContent,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (textContent.present) {
      map['text_content'] = Variable<String>(textContent.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyReflectionsTableCompanion(')
          ..write('localDate: $localDate, ')
          ..write('textContent: $textContent, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTableTable extends RemindersTable
    with TableInfo<$RemindersTableTable, RemindersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
    'hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
    'minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastErrorCodeMeta = const VerificationMeta(
    'lastErrorCode',
  );
  @override
  late final GeneratedColumn<String> lastErrorCode = GeneratedColumn<String>(
    'last_error_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    habitId,
    weekday,
    hour,
    minute,
    status,
    lastErrorCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<RemindersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('hour')) {
      context.handle(
        _hourMeta,
        hour.isAcceptableOrUnknown(data['hour']!, _hourMeta),
      );
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(
        _minuteMeta,
        minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta),
      );
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('last_error_code')) {
      context.handle(
        _lastErrorCodeMeta,
        lastErrorCode.isAcceptableOrUnknown(
          data['last_error_code']!,
          _lastErrorCodeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {habitId, weekday},
  ];
  @override
  RemindersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RemindersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      hour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hour'],
      )!,
      minute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      lastErrorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error_code'],
      ),
    );
  }

  @override
  $RemindersTableTable createAlias(String alias) {
    return $RemindersTableTable(attachedDatabase, alias);
  }
}

class RemindersTableData extends DataClass
    implements Insertable<RemindersTableData> {
  final int id;
  final String habitId;
  final int weekday;
  final int hour;
  final int minute;
  final String status;
  final String? lastErrorCode;
  const RemindersTableData({
    required this.id,
    required this.habitId,
    required this.weekday,
    required this.hour,
    required this.minute,
    required this.status,
    this.lastErrorCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['weekday'] = Variable<int>(weekday);
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastErrorCode != null) {
      map['last_error_code'] = Variable<String>(lastErrorCode);
    }
    return map;
  }

  RemindersTableCompanion toCompanion(bool nullToAbsent) {
    return RemindersTableCompanion(
      id: Value(id),
      habitId: Value(habitId),
      weekday: Value(weekday),
      hour: Value(hour),
      minute: Value(minute),
      status: Value(status),
      lastErrorCode: lastErrorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(lastErrorCode),
    );
  }

  factory RemindersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RemindersTableData(
      id: serializer.fromJson<int>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      weekday: serializer.fromJson<int>(json['weekday']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
      status: serializer.fromJson<String>(json['status']),
      lastErrorCode: serializer.fromJson<String?>(json['lastErrorCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'habitId': serializer.toJson<String>(habitId),
      'weekday': serializer.toJson<int>(weekday),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
      'status': serializer.toJson<String>(status),
      'lastErrorCode': serializer.toJson<String?>(lastErrorCode),
    };
  }

  RemindersTableData copyWith({
    int? id,
    String? habitId,
    int? weekday,
    int? hour,
    int? minute,
    String? status,
    Value<String?> lastErrorCode = const Value.absent(),
  }) => RemindersTableData(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    weekday: weekday ?? this.weekday,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
    status: status ?? this.status,
    lastErrorCode: lastErrorCode.present
        ? lastErrorCode.value
        : this.lastErrorCode,
  );
  RemindersTableData copyWithCompanion(RemindersTableCompanion data) {
    return RemindersTableData(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
      status: data.status.present ? data.status.value : this.status,
      lastErrorCode: data.lastErrorCode.present
          ? data.lastErrorCode.value
          : this.lastErrorCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RemindersTableData(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('weekday: $weekday, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('status: $status, ')
          ..write('lastErrorCode: $lastErrorCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, habitId, weekday, hour, minute, status, lastErrorCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RemindersTableData &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.weekday == this.weekday &&
          other.hour == this.hour &&
          other.minute == this.minute &&
          other.status == this.status &&
          other.lastErrorCode == this.lastErrorCode);
}

class RemindersTableCompanion extends UpdateCompanion<RemindersTableData> {
  final Value<int> id;
  final Value<String> habitId;
  final Value<int> weekday;
  final Value<int> hour;
  final Value<int> minute;
  final Value<String> status;
  final Value<String?> lastErrorCode;
  const RemindersTableCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.status = const Value.absent(),
    this.lastErrorCode = const Value.absent(),
  });
  RemindersTableCompanion.insert({
    this.id = const Value.absent(),
    required String habitId,
    required int weekday,
    required int hour,
    required int minute,
    required String status,
    this.lastErrorCode = const Value.absent(),
  }) : habitId = Value(habitId),
       weekday = Value(weekday),
       hour = Value(hour),
       minute = Value(minute),
       status = Value(status);
  static Insertable<RemindersTableData> custom({
    Expression<int>? id,
    Expression<String>? habitId,
    Expression<int>? weekday,
    Expression<int>? hour,
    Expression<int>? minute,
    Expression<String>? status,
    Expression<String>? lastErrorCode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (weekday != null) 'weekday': weekday,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
      if (status != null) 'status': status,
      if (lastErrorCode != null) 'last_error_code': lastErrorCode,
    });
  }

  RemindersTableCompanion copyWith({
    Value<int>? id,
    Value<String>? habitId,
    Value<int>? weekday,
    Value<int>? hour,
    Value<int>? minute,
    Value<String>? status,
    Value<String?>? lastErrorCode,
  }) {
    return RemindersTableCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      weekday: weekday ?? this.weekday,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      status: status ?? this.status,
      lastErrorCode: lastErrorCode ?? this.lastErrorCode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastErrorCode.present) {
      map['last_error_code'] = Variable<String>(lastErrorCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersTableCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('weekday: $weekday, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('status: $status, ')
          ..write('lastErrorCode: $lastErrorCode')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HabitsTableTable habitsTable = $HabitsTableTable(this);
  late final $HabitPlanVersionsTableTable habitPlanVersionsTable =
      $HabitPlanVersionsTableTable(this);
  late final $DailyCheckInsTableTable dailyCheckInsTable =
      $DailyCheckInsTableTable(this);
  late final $FocusSessionsTableTable focusSessionsTable =
      $FocusSessionsTableTable(this);
  late final $FocusAllocationsTableTable focusAllocationsTable =
      $FocusAllocationsTableTable(this);
  late final $RewardsTableTable rewardsTable = $RewardsTableTable(this);
  late final $RewardHabitLinksTableTable rewardHabitLinksTable =
      $RewardHabitLinksTableTable(this);
  late final $RewardContributionsTableTable rewardContributionsTable =
      $RewardContributionsTableTable(this);
  late final $BadgesTableTable badgesTable = $BadgesTableTable(this);
  late final $DailyReflectionsTableTable dailyReflectionsTable =
      $DailyReflectionsTableTable(this);
  late final $RemindersTableTable remindersTable = $RemindersTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    habitsTable,
    habitPlanVersionsTable,
    dailyCheckInsTable,
    focusSessionsTable,
    focusAllocationsTable,
    rewardsTable,
    rewardHabitLinksTable,
    rewardContributionsTable,
    badgesTable,
    dailyReflectionsTable,
    remindersTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'habits',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('habit_plan_versions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'habits',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('daily_check_ins', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'habits',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('focus_sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'focus_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('focus_allocations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'rewards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reward_habit_links', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'habits',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reward_habit_links', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'rewards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reward_contributions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'habits',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reminders', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$HabitsTableTableCreateCompanionBuilder =
    HabitsTableCompanion Function({
      required String id,
      required String title,
      required String emoji,
      required String category,
      required String subcategory,
      required DateTime createdAtUtc,
      Value<DateTime?> archivedAtUtc,
      Value<int> rowid,
    });
typedef $$HabitsTableTableUpdateCompanionBuilder =
    HabitsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> emoji,
      Value<String> category,
      Value<String> subcategory,
      Value<DateTime> createdAtUtc,
      Value<DateTime?> archivedAtUtc,
      Value<int> rowid,
    });

final class $$HabitsTableTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTableTable, HabitsTableData> {
  $$HabitsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $HabitPlanVersionsTableTable,
    List<HabitPlanVersionsTableData>
  >
  _habitPlanVersionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.habitPlanVersionsTable,
        aliasName: 'habits__id__habit_plan_versions__habit_id',
      );

  $$HabitPlanVersionsTableTableProcessedTableManager
  get habitPlanVersionsTableRefs {
    final manager = $$HabitPlanVersionsTableTableTableManager(
      $_db,
      $_db.habitPlanVersionsTable,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _habitPlanVersionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DailyCheckInsTableTable,
    List<DailyCheckInsTableData>
  >
  _dailyCheckInsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.dailyCheckInsTable,
        aliasName: 'habits__id__daily_check_ins__habit_id',
      );

  $$DailyCheckInsTableTableProcessedTableManager get dailyCheckInsTableRefs {
    final manager = $$DailyCheckInsTableTableTableManager(
      $_db,
      $_db.dailyCheckInsTable,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dailyCheckInsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $FocusSessionsTableTable,
    List<FocusSessionsTableData>
  >
  _focusSessionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.focusSessionsTable,
        aliasName: 'habits__id__focus_sessions__habit_id',
      );

  $$FocusSessionsTableTableProcessedTableManager get focusSessionsTableRefs {
    final manager = $$FocusSessionsTableTableTableManager(
      $_db,
      $_db.focusSessionsTable,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _focusSessionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RewardHabitLinksTableTable,
    List<RewardHabitLinksTableData>
  >
  _rewardHabitLinksTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.rewardHabitLinksTable,
        aliasName: 'habits__id__reward_habit_links__habit_id',
      );

  $$RewardHabitLinksTableTableProcessedTableManager
  get rewardHabitLinksTableRefs {
    final manager = $$RewardHabitLinksTableTableTableManager(
      $_db,
      $_db.rewardHabitLinksTable,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _rewardHabitLinksTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemindersTableTable, List<RemindersTableData>>
  _remindersTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.remindersTable,
    aliasName: 'habits__id__reminders__habit_id',
  );

  $$RemindersTableTableProcessedTableManager get remindersTableRefs {
    final manager = $$RemindersTableTableTableManager(
      $_db,
      $_db.remindersTable,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HabitsTableTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTableTable> {
  $$HabitsTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subcategory => $composableBuilder(
    column: $table.subcategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAtUtc => $composableBuilder(
    column: $table.archivedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> habitPlanVersionsTableRefs(
    Expression<bool> Function($$HabitPlanVersionsTableTableFilterComposer f) f,
  ) {
    final $$HabitPlanVersionsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.habitPlanVersionsTable,
          getReferencedColumn: (t) => t.habitId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HabitPlanVersionsTableTableFilterComposer(
                $db: $db,
                $table: $db.habitPlanVersionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> dailyCheckInsTableRefs(
    Expression<bool> Function($$DailyCheckInsTableTableFilterComposer f) f,
  ) {
    final $$DailyCheckInsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyCheckInsTable,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyCheckInsTableTableFilterComposer(
            $db: $db,
            $table: $db.dailyCheckInsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> focusSessionsTableRefs(
    Expression<bool> Function($$FocusSessionsTableTableFilterComposer f) f,
  ) {
    final $$FocusSessionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessionsTable,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableTableFilterComposer(
            $db: $db,
            $table: $db.focusSessionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rewardHabitLinksTableRefs(
    Expression<bool> Function($$RewardHabitLinksTableTableFilterComposer f) f,
  ) {
    final $$RewardHabitLinksTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.rewardHabitLinksTable,
          getReferencedColumn: (t) => t.habitId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RewardHabitLinksTableTableFilterComposer(
                $db: $db,
                $table: $db.rewardHabitLinksTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> remindersTableRefs(
    Expression<bool> Function($$RemindersTableTableFilterComposer f) f,
  ) {
    final $$RemindersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.remindersTable,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableTableFilterComposer(
            $db: $db,
            $table: $db.remindersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTableTable> {
  $$HabitsTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subcategory => $composableBuilder(
    column: $table.subcategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAtUtc => $composableBuilder(
    column: $table.archivedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTableTable> {
  $$HabitsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get subcategory => $composableBuilder(
    column: $table.subcategory,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get archivedAtUtc => $composableBuilder(
    column: $table.archivedAtUtc,
    builder: (column) => column,
  );

  Expression<T> habitPlanVersionsTableRefs<T extends Object>(
    Expression<T> Function($$HabitPlanVersionsTableTableAnnotationComposer a) f,
  ) {
    final $$HabitPlanVersionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.habitPlanVersionsTable,
          getReferencedColumn: (t) => t.habitId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HabitPlanVersionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.habitPlanVersionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> dailyCheckInsTableRefs<T extends Object>(
    Expression<T> Function($$DailyCheckInsTableTableAnnotationComposer a) f,
  ) {
    final $$DailyCheckInsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dailyCheckInsTable,
          getReferencedColumn: (t) => t.habitId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DailyCheckInsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.dailyCheckInsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> focusSessionsTableRefs<T extends Object>(
    Expression<T> Function($$FocusSessionsTableTableAnnotationComposer a) f,
  ) {
    final $$FocusSessionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.focusSessionsTable,
          getReferencedColumn: (t) => t.habitId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FocusSessionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.focusSessionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> rewardHabitLinksTableRefs<T extends Object>(
    Expression<T> Function($$RewardHabitLinksTableTableAnnotationComposer a) f,
  ) {
    final $$RewardHabitLinksTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.rewardHabitLinksTable,
          getReferencedColumn: (t) => t.habitId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RewardHabitLinksTableTableAnnotationComposer(
                $db: $db,
                $table: $db.rewardHabitLinksTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> remindersTableRefs<T extends Object>(
    Expression<T> Function($$RemindersTableTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.remindersTable,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.remindersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTableTable,
          HabitsTableData,
          $$HabitsTableTableFilterComposer,
          $$HabitsTableTableOrderingComposer,
          $$HabitsTableTableAnnotationComposer,
          $$HabitsTableTableCreateCompanionBuilder,
          $$HabitsTableTableUpdateCompanionBuilder,
          (HabitsTableData, $$HabitsTableTableReferences),
          HabitsTableData,
          PrefetchHooks Function({
            bool habitPlanVersionsTableRefs,
            bool dailyCheckInsTableRefs,
            bool focusSessionsTableRefs,
            bool rewardHabitLinksTableRefs,
            bool remindersTableRefs,
          })
        > {
  $$HabitsTableTableTableManager(_$AppDatabase db, $HabitsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> subcategory = const Value.absent(),
                Value<DateTime> createdAtUtc = const Value.absent(),
                Value<DateTime?> archivedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsTableCompanion(
                id: id,
                title: title,
                emoji: emoji,
                category: category,
                subcategory: subcategory,
                createdAtUtc: createdAtUtc,
                archivedAtUtc: archivedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String emoji,
                required String category,
                required String subcategory,
                required DateTime createdAtUtc,
                Value<DateTime?> archivedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsTableCompanion.insert(
                id: id,
                title: title,
                emoji: emoji,
                category: category,
                subcategory: subcategory,
                createdAtUtc: createdAtUtc,
                archivedAtUtc: archivedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HabitsTableTable, HabitsTableData>(table),
                  $$HabitsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                habitPlanVersionsTableRefs = false,
                dailyCheckInsTableRefs = false,
                focusSessionsTableRefs = false,
                rewardHabitLinksTableRefs = false,
                remindersTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (habitPlanVersionsTableRefs) db.habitPlanVersionsTable,
                    if (dailyCheckInsTableRefs) db.dailyCheckInsTable,
                    if (focusSessionsTableRefs) db.focusSessionsTable,
                    if (rewardHabitLinksTableRefs) db.rewardHabitLinksTable,
                    if (remindersTableRefs) db.remindersTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (habitPlanVersionsTableRefs)
                        await $_getPrefetchedData<
                          HabitsTableData,
                          $HabitsTableTable,
                          HabitPlanVersionsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$HabitsTableTableReferences
                              ._habitPlanVersionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HabitsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).habitPlanVersionsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.habitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dailyCheckInsTableRefs)
                        await $_getPrefetchedData<
                          HabitsTableData,
                          $HabitsTableTable,
                          DailyCheckInsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$HabitsTableTableReferences
                              ._dailyCheckInsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HabitsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).dailyCheckInsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.habitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (focusSessionsTableRefs)
                        await $_getPrefetchedData<
                          HabitsTableData,
                          $HabitsTableTable,
                          FocusSessionsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$HabitsTableTableReferences
                              ._focusSessionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HabitsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).focusSessionsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.habitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rewardHabitLinksTableRefs)
                        await $_getPrefetchedData<
                          HabitsTableData,
                          $HabitsTableTable,
                          RewardHabitLinksTableData
                        >(
                          currentTable: table,
                          referencedTable: $$HabitsTableTableReferences
                              ._rewardHabitLinksTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HabitsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).rewardHabitLinksTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.habitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (remindersTableRefs)
                        await $_getPrefetchedData<
                          HabitsTableData,
                          $HabitsTableTable,
                          RemindersTableData
                        >(
                          currentTable: table,
                          referencedTable: $$HabitsTableTableReferences
                              ._remindersTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HabitsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.habitId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$HabitsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTableTable,
      HabitsTableData,
      $$HabitsTableTableFilterComposer,
      $$HabitsTableTableOrderingComposer,
      $$HabitsTableTableAnnotationComposer,
      $$HabitsTableTableCreateCompanionBuilder,
      $$HabitsTableTableUpdateCompanionBuilder,
      (HabitsTableData, $$HabitsTableTableReferences),
      HabitsTableData,
      PrefetchHooks Function({
        bool habitPlanVersionsTableRefs,
        bool dailyCheckInsTableRefs,
        bool focusSessionsTableRefs,
        bool rewardHabitLinksTableRefs,
        bool remindersTableRefs,
      })
    >;
typedef $$HabitPlanVersionsTableTableCreateCompanionBuilder =
    HabitPlanVersionsTableCompanion Function({
      required String id,
      required String habitId,
      required String effectiveFromDate,
      required String weekdays,
      required String targetType,
      required int targetValue,
      required String unit,
      Value<bool> rewardEligible,
      Value<int> rowid,
    });
typedef $$HabitPlanVersionsTableTableUpdateCompanionBuilder =
    HabitPlanVersionsTableCompanion Function({
      Value<String> id,
      Value<String> habitId,
      Value<String> effectiveFromDate,
      Value<String> weekdays,
      Value<String> targetType,
      Value<int> targetValue,
      Value<String> unit,
      Value<bool> rewardEligible,
      Value<int> rowid,
    });

final class $$HabitPlanVersionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $HabitPlanVersionsTableTable,
          HabitPlanVersionsTableData
        > {
  $$HabitPlanVersionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HabitsTableTable _habitIdTable(_$AppDatabase db) =>
      db.habitsTable.createAlias('habit_plan_versions__habit_id__habits__id');

  $$HabitsTableTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableTableManager(
      $_db,
      $_db.habitsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HabitPlanVersionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $HabitPlanVersionsTableTable> {
  $$HabitPlanVersionsTableTableFilterComposer({
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

  ColumnFilters<String> get effectiveFromDate => $composableBuilder(
    column: $table.effectiveFromDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get rewardEligible => $composableBuilder(
    column: $table.rewardEligible,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableTableFilterComposer get habitId {
    final $$HabitsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableFilterComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitPlanVersionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitPlanVersionsTableTable> {
  $$HabitPlanVersionsTableTableOrderingComposer({
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

  ColumnOrderings<String> get effectiveFromDate => $composableBuilder(
    column: $table.effectiveFromDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rewardEligible => $composableBuilder(
    column: $table.rewardEligible,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableTableOrderingComposer get habitId {
    final $$HabitsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableOrderingComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitPlanVersionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitPlanVersionsTableTable> {
  $$HabitPlanVersionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get effectiveFromDate => $composableBuilder(
    column: $table.effectiveFromDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get rewardEligible => $composableBuilder(
    column: $table.rewardEligible,
    builder: (column) => column,
  );

  $$HabitsTableTableAnnotationComposer get habitId {
    final $$HabitsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitPlanVersionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitPlanVersionsTableTable,
          HabitPlanVersionsTableData,
          $$HabitPlanVersionsTableTableFilterComposer,
          $$HabitPlanVersionsTableTableOrderingComposer,
          $$HabitPlanVersionsTableTableAnnotationComposer,
          $$HabitPlanVersionsTableTableCreateCompanionBuilder,
          $$HabitPlanVersionsTableTableUpdateCompanionBuilder,
          (HabitPlanVersionsTableData, $$HabitPlanVersionsTableTableReferences),
          HabitPlanVersionsTableData,
          PrefetchHooks Function({bool habitId})
        > {
  $$HabitPlanVersionsTableTableTableManager(
    _$AppDatabase db,
    $HabitPlanVersionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitPlanVersionsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$HabitPlanVersionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HabitPlanVersionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<String> effectiveFromDate = const Value.absent(),
                Value<String> weekdays = const Value.absent(),
                Value<String> targetType = const Value.absent(),
                Value<int> targetValue = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<bool> rewardEligible = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitPlanVersionsTableCompanion(
                id: id,
                habitId: habitId,
                effectiveFromDate: effectiveFromDate,
                weekdays: weekdays,
                targetType: targetType,
                targetValue: targetValue,
                unit: unit,
                rewardEligible: rewardEligible,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String habitId,
                required String effectiveFromDate,
                required String weekdays,
                required String targetType,
                required int targetValue,
                required String unit,
                Value<bool> rewardEligible = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitPlanVersionsTableCompanion.insert(
                id: id,
                habitId: habitId,
                effectiveFromDate: effectiveFromDate,
                weekdays: weekdays,
                targetType: targetType,
                targetValue: targetValue,
                unit: unit,
                rewardEligible: rewardEligible,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $HabitPlanVersionsTableTable,
                    HabitPlanVersionsTableData
                  >(table),
                  $$HabitPlanVersionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.habitId,
                        referencedTable: $$HabitPlanVersionsTableTableReferences
                            ._habitIdTable(db),
                        referencedColumn:
                            $$HabitPlanVersionsTableTableReferences
                                ._habitIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HabitPlanVersionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitPlanVersionsTableTable,
      HabitPlanVersionsTableData,
      $$HabitPlanVersionsTableTableFilterComposer,
      $$HabitPlanVersionsTableTableOrderingComposer,
      $$HabitPlanVersionsTableTableAnnotationComposer,
      $$HabitPlanVersionsTableTableCreateCompanionBuilder,
      $$HabitPlanVersionsTableTableUpdateCompanionBuilder,
      (HabitPlanVersionsTableData, $$HabitPlanVersionsTableTableReferences),
      HabitPlanVersionsTableData,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$DailyCheckInsTableTableCreateCompanionBuilder =
    DailyCheckInsTableCompanion Function({
      required String id,
      required String habitId,
      required String localDate,
      required String planVersionId,
      Value<int> manualValue,
      Value<int> sessionSeconds,
      Value<bool> isCompleted,
      Value<DateTime?> firstCompletedAtUtc,
      Value<DateTime?> lastCompletedAtUtc,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$DailyCheckInsTableTableUpdateCompanionBuilder =
    DailyCheckInsTableCompanion Function({
      Value<String> id,
      Value<String> habitId,
      Value<String> localDate,
      Value<String> planVersionId,
      Value<int> manualValue,
      Value<int> sessionSeconds,
      Value<bool> isCompleted,
      Value<DateTime?> firstCompletedAtUtc,
      Value<DateTime?> lastCompletedAtUtc,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$DailyCheckInsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DailyCheckInsTableTable,
          DailyCheckInsTableData
        > {
  $$DailyCheckInsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HabitsTableTable _habitIdTable(_$AppDatabase db) =>
      db.habitsTable.createAlias('daily_check_ins__habit_id__habits__id');

  $$HabitsTableTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableTableManager(
      $_db,
      $_db.habitsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DailyCheckInsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DailyCheckInsTableTable> {
  $$DailyCheckInsTableTableFilterComposer({
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

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planVersionId => $composableBuilder(
    column: $table.planVersionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get manualValue => $composableBuilder(
    column: $table.manualValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionSeconds => $composableBuilder(
    column: $table.sessionSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstCompletedAtUtc => $composableBuilder(
    column: $table.firstCompletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCompletedAtUtc => $composableBuilder(
    column: $table.lastCompletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableTableFilterComposer get habitId {
    final $$HabitsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableFilterComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyCheckInsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyCheckInsTableTable> {
  $$DailyCheckInsTableTableOrderingComposer({
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

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planVersionId => $composableBuilder(
    column: $table.planVersionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get manualValue => $composableBuilder(
    column: $table.manualValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionSeconds => $composableBuilder(
    column: $table.sessionSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstCompletedAtUtc => $composableBuilder(
    column: $table.firstCompletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCompletedAtUtc => $composableBuilder(
    column: $table.lastCompletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableTableOrderingComposer get habitId {
    final $$HabitsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableOrderingComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyCheckInsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyCheckInsTableTable> {
  $$DailyCheckInsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get planVersionId => $composableBuilder(
    column: $table.planVersionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get manualValue => $composableBuilder(
    column: $table.manualValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sessionSeconds => $composableBuilder(
    column: $table.sessionSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get firstCompletedAtUtc => $composableBuilder(
    column: $table.firstCompletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastCompletedAtUtc => $composableBuilder(
    column: $table.lastCompletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$HabitsTableTableAnnotationComposer get habitId {
    final $$HabitsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyCheckInsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyCheckInsTableTable,
          DailyCheckInsTableData,
          $$DailyCheckInsTableTableFilterComposer,
          $$DailyCheckInsTableTableOrderingComposer,
          $$DailyCheckInsTableTableAnnotationComposer,
          $$DailyCheckInsTableTableCreateCompanionBuilder,
          $$DailyCheckInsTableTableUpdateCompanionBuilder,
          (DailyCheckInsTableData, $$DailyCheckInsTableTableReferences),
          DailyCheckInsTableData,
          PrefetchHooks Function({bool habitId})
        > {
  $$DailyCheckInsTableTableTableManager(
    _$AppDatabase db,
    $DailyCheckInsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyCheckInsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyCheckInsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyCheckInsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<String> planVersionId = const Value.absent(),
                Value<int> manualValue = const Value.absent(),
                Value<int> sessionSeconds = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> firstCompletedAtUtc = const Value.absent(),
                Value<DateTime?> lastCompletedAtUtc = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyCheckInsTableCompanion(
                id: id,
                habitId: habitId,
                localDate: localDate,
                planVersionId: planVersionId,
                manualValue: manualValue,
                sessionSeconds: sessionSeconds,
                isCompleted: isCompleted,
                firstCompletedAtUtc: firstCompletedAtUtc,
                lastCompletedAtUtc: lastCompletedAtUtc,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String habitId,
                required String localDate,
                required String planVersionId,
                Value<int> manualValue = const Value.absent(),
                Value<int> sessionSeconds = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> firstCompletedAtUtc = const Value.absent(),
                Value<DateTime?> lastCompletedAtUtc = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyCheckInsTableCompanion.insert(
                id: id,
                habitId: habitId,
                localDate: localDate,
                planVersionId: planVersionId,
                manualValue: manualValue,
                sessionSeconds: sessionSeconds,
                isCompleted: isCompleted,
                firstCompletedAtUtc: firstCompletedAtUtc,
                lastCompletedAtUtc: lastCompletedAtUtc,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyCheckInsTableTable, DailyCheckInsTableData>(
                    table,
                  ),
                  $$DailyCheckInsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.habitId,
                        referencedTable: $$DailyCheckInsTableTableReferences
                            ._habitIdTable(db),
                        referencedColumn: $$DailyCheckInsTableTableReferences
                            ._habitIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DailyCheckInsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyCheckInsTableTable,
      DailyCheckInsTableData,
      $$DailyCheckInsTableTableFilterComposer,
      $$DailyCheckInsTableTableOrderingComposer,
      $$DailyCheckInsTableTableAnnotationComposer,
      $$DailyCheckInsTableTableCreateCompanionBuilder,
      $$DailyCheckInsTableTableUpdateCompanionBuilder,
      (DailyCheckInsTableData, $$DailyCheckInsTableTableReferences),
      DailyCheckInsTableData,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$FocusSessionsTableTableCreateCompanionBuilder =
    FocusSessionsTableCompanion Function({
      required String id,
      required String habitId,
      required DateTime startedAtUtc,
      Value<DateTime?> activeSegmentStartedAtUtc,
      Value<int> accumulatedSeconds,
      required int plannedSeconds,
      required String status,
      Value<DateTime?> endedAtUtc,
      Value<int> rowid,
    });
typedef $$FocusSessionsTableTableUpdateCompanionBuilder =
    FocusSessionsTableCompanion Function({
      Value<String> id,
      Value<String> habitId,
      Value<DateTime> startedAtUtc,
      Value<DateTime?> activeSegmentStartedAtUtc,
      Value<int> accumulatedSeconds,
      Value<int> plannedSeconds,
      Value<String> status,
      Value<DateTime?> endedAtUtc,
      Value<int> rowid,
    });

final class $$FocusSessionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FocusSessionsTableTable,
          FocusSessionsTableData
        > {
  $$FocusSessionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HabitsTableTable _habitIdTable(_$AppDatabase db) =>
      db.habitsTable.createAlias('focus_sessions__habit_id__habits__id');

  $$HabitsTableTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableTableManager(
      $_db,
      $_db.habitsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $FocusAllocationsTableTable,
    List<FocusAllocationsTableData>
  >
  _focusAllocationsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.focusAllocationsTable,
        aliasName: 'focus_sessions__id__focus_allocations__session_id',
      );

  $$FocusAllocationsTableTableProcessedTableManager
  get focusAllocationsTableRefs {
    final manager = $$FocusAllocationsTableTableTableManager(
      $_db,
      $_db.focusAllocationsTable,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _focusAllocationsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FocusSessionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $FocusSessionsTableTable> {
  $$FocusSessionsTableTableFilterComposer({
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

  ColumnFilters<DateTime> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get activeSegmentStartedAtUtc => $composableBuilder(
    column: $table.activeSegmentStartedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accumulatedSeconds => $composableBuilder(
    column: $table.accumulatedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAtUtc => $composableBuilder(
    column: $table.endedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableTableFilterComposer get habitId {
    final $$HabitsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableFilterComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> focusAllocationsTableRefs(
    Expression<bool> Function($$FocusAllocationsTableTableFilterComposer f) f,
  ) {
    final $$FocusAllocationsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.focusAllocationsTable,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FocusAllocationsTableTableFilterComposer(
                $db: $db,
                $table: $db.focusAllocationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$FocusSessionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusSessionsTableTable> {
  $$FocusSessionsTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get activeSegmentStartedAtUtc => $composableBuilder(
    column: $table.activeSegmentStartedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accumulatedSeconds => $composableBuilder(
    column: $table.accumulatedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAtUtc => $composableBuilder(
    column: $table.endedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableTableOrderingComposer get habitId {
    final $$HabitsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableOrderingComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusSessionsTableTable> {
  $$FocusSessionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get activeSegmentStartedAtUtc => $composableBuilder(
    column: $table.activeSegmentStartedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get accumulatedSeconds => $composableBuilder(
    column: $table.accumulatedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAtUtc => $composableBuilder(
    column: $table.endedAtUtc,
    builder: (column) => column,
  );

  $$HabitsTableTableAnnotationComposer get habitId {
    final $$HabitsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> focusAllocationsTableRefs<T extends Object>(
    Expression<T> Function($$FocusAllocationsTableTableAnnotationComposer a) f,
  ) {
    final $$FocusAllocationsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.focusAllocationsTable,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FocusAllocationsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.focusAllocationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$FocusSessionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusSessionsTableTable,
          FocusSessionsTableData,
          $$FocusSessionsTableTableFilterComposer,
          $$FocusSessionsTableTableOrderingComposer,
          $$FocusSessionsTableTableAnnotationComposer,
          $$FocusSessionsTableTableCreateCompanionBuilder,
          $$FocusSessionsTableTableUpdateCompanionBuilder,
          (FocusSessionsTableData, $$FocusSessionsTableTableReferences),
          FocusSessionsTableData,
          PrefetchHooks Function({bool habitId, bool focusAllocationsTableRefs})
        > {
  $$FocusSessionsTableTableTableManager(
    _$AppDatabase db,
    $FocusSessionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusSessionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusSessionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusSessionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<DateTime> startedAtUtc = const Value.absent(),
                Value<DateTime?> activeSegmentStartedAtUtc =
                    const Value.absent(),
                Value<int> accumulatedSeconds = const Value.absent(),
                Value<int> plannedSeconds = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> endedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsTableCompanion(
                id: id,
                habitId: habitId,
                startedAtUtc: startedAtUtc,
                activeSegmentStartedAtUtc: activeSegmentStartedAtUtc,
                accumulatedSeconds: accumulatedSeconds,
                plannedSeconds: plannedSeconds,
                status: status,
                endedAtUtc: endedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String habitId,
                required DateTime startedAtUtc,
                Value<DateTime?> activeSegmentStartedAtUtc =
                    const Value.absent(),
                Value<int> accumulatedSeconds = const Value.absent(),
                required int plannedSeconds,
                required String status,
                Value<DateTime?> endedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsTableCompanion.insert(
                id: id,
                habitId: habitId,
                startedAtUtc: startedAtUtc,
                activeSegmentStartedAtUtc: activeSegmentStartedAtUtc,
                accumulatedSeconds: accumulatedSeconds,
                plannedSeconds: plannedSeconds,
                status: status,
                endedAtUtc: endedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FocusSessionsTableTable, FocusSessionsTableData>(
                    table,
                  ),
                  $$FocusSessionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({habitId = false, focusAllocationsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (focusAllocationsTableRefs) db.focusAllocationsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (habitId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.habitId,
                            referencedTable: $$FocusSessionsTableTableReferences
                                ._habitIdTable(db),
                            referencedColumn:
                                $$FocusSessionsTableTableReferences
                                    ._habitIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (focusAllocationsTableRefs)
                        await $_getPrefetchedData<
                          FocusSessionsTableData,
                          $FocusSessionsTableTable,
                          FocusAllocationsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$FocusSessionsTableTableReferences
                              ._focusAllocationsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FocusSessionsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).focusAllocationsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FocusSessionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusSessionsTableTable,
      FocusSessionsTableData,
      $$FocusSessionsTableTableFilterComposer,
      $$FocusSessionsTableTableOrderingComposer,
      $$FocusSessionsTableTableAnnotationComposer,
      $$FocusSessionsTableTableCreateCompanionBuilder,
      $$FocusSessionsTableTableUpdateCompanionBuilder,
      (FocusSessionsTableData, $$FocusSessionsTableTableReferences),
      FocusSessionsTableData,
      PrefetchHooks Function({bool habitId, bool focusAllocationsTableRefs})
    >;
typedef $$FocusAllocationsTableTableCreateCompanionBuilder =
    FocusAllocationsTableCompanion Function({
      required String sessionId,
      required String localDate,
      required int activeSeconds,
      Value<int> rowid,
    });
typedef $$FocusAllocationsTableTableUpdateCompanionBuilder =
    FocusAllocationsTableCompanion Function({
      Value<String> sessionId,
      Value<String> localDate,
      Value<int> activeSeconds,
      Value<int> rowid,
    });

final class $$FocusAllocationsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FocusAllocationsTableTable,
          FocusAllocationsTableData
        > {
  $$FocusAllocationsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FocusSessionsTableTable _sessionIdTable(_$AppDatabase db) => db
      .focusSessionsTable
      .createAlias('focus_allocations__session_id__focus_sessions__id');

  $$FocusSessionsTableTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$FocusSessionsTableTableTableManager(
      $_db,
      $_db.focusSessionsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FocusAllocationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $FocusAllocationsTableTable> {
  $$FocusAllocationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activeSeconds => $composableBuilder(
    column: $table.activeSeconds,
    builder: (column) => ColumnFilters(column),
  );

  $$FocusSessionsTableTableFilterComposer get sessionId {
    final $$FocusSessionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableTableFilterComposer(
            $db: $db,
            $table: $db.focusSessionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusAllocationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusAllocationsTableTable> {
  $$FocusAllocationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeSeconds => $composableBuilder(
    column: $table.activeSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  $$FocusSessionsTableTableOrderingComposer get sessionId {
    final $$FocusSessionsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableTableOrderingComposer(
            $db: $db,
            $table: $db.focusSessionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusAllocationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusAllocationsTableTable> {
  $$FocusAllocationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<int> get activeSeconds => $composableBuilder(
    column: $table.activeSeconds,
    builder: (column) => column,
  );

  $$FocusSessionsTableTableAnnotationComposer get sessionId {
    final $$FocusSessionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.focusSessionsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FocusSessionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.focusSessionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$FocusAllocationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusAllocationsTableTable,
          FocusAllocationsTableData,
          $$FocusAllocationsTableTableFilterComposer,
          $$FocusAllocationsTableTableOrderingComposer,
          $$FocusAllocationsTableTableAnnotationComposer,
          $$FocusAllocationsTableTableCreateCompanionBuilder,
          $$FocusAllocationsTableTableUpdateCompanionBuilder,
          (FocusAllocationsTableData, $$FocusAllocationsTableTableReferences),
          FocusAllocationsTableData,
          PrefetchHooks Function({bool sessionId})
        > {
  $$FocusAllocationsTableTableTableManager(
    _$AppDatabase db,
    $FocusAllocationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusAllocationsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$FocusAllocationsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FocusAllocationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<int> activeSeconds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusAllocationsTableCompanion(
                sessionId: sessionId,
                localDate: localDate,
                activeSeconds: activeSeconds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required String localDate,
                required int activeSeconds,
                Value<int> rowid = const Value.absent(),
              }) => FocusAllocationsTableCompanion.insert(
                sessionId: sessionId,
                localDate: localDate,
                activeSeconds: activeSeconds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $FocusAllocationsTableTable,
                    FocusAllocationsTableData
                  >(table),
                  $$FocusAllocationsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$FocusAllocationsTableTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$FocusAllocationsTableTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FocusAllocationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusAllocationsTableTable,
      FocusAllocationsTableData,
      $$FocusAllocationsTableTableFilterComposer,
      $$FocusAllocationsTableTableOrderingComposer,
      $$FocusAllocationsTableTableAnnotationComposer,
      $$FocusAllocationsTableTableCreateCompanionBuilder,
      $$FocusAllocationsTableTableUpdateCompanionBuilder,
      (FocusAllocationsTableData, $$FocusAllocationsTableTableReferences),
      FocusAllocationsTableData,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$RewardsTableTableCreateCompanionBuilder =
    RewardsTableCompanion Function({
      required String id,
      required String title,
      required String emoji,
      required String description,
      required int targetSteps,
      required String status,
      Value<DateTime?> activatedAtUtc,
      Value<DateTime?> earnedAtUtc,
      Value<DateTime?> usedAtUtc,
      Value<DateTime?> planAtUtc,
      Value<String?> planTimezone,
      Value<String?> placeName,
      Value<String?> planNote,
      Value<int> rowid,
    });
typedef $$RewardsTableTableUpdateCompanionBuilder =
    RewardsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> emoji,
      Value<String> description,
      Value<int> targetSteps,
      Value<String> status,
      Value<DateTime?> activatedAtUtc,
      Value<DateTime?> earnedAtUtc,
      Value<DateTime?> usedAtUtc,
      Value<DateTime?> planAtUtc,
      Value<String?> planTimezone,
      Value<String?> placeName,
      Value<String?> planNote,
      Value<int> rowid,
    });

final class $$RewardsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $RewardsTableTable, RewardsTableData> {
  $$RewardsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $RewardHabitLinksTableTable,
    List<RewardHabitLinksTableData>
  >
  _rewardHabitLinksTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.rewardHabitLinksTable,
        aliasName: 'rewards__id__reward_habit_links__reward_id',
      );

  $$RewardHabitLinksTableTableProcessedTableManager
  get rewardHabitLinksTableRefs {
    final manager = $$RewardHabitLinksTableTableTableManager(
      $_db,
      $_db.rewardHabitLinksTable,
    ).filter((f) => f.rewardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _rewardHabitLinksTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RewardContributionsTableTable,
    List<RewardContributionsTableData>
  >
  _rewardContributionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.rewardContributionsTable,
        aliasName: 'rewards__id__reward_contributions__reward_id',
      );

  $$RewardContributionsTableTableProcessedTableManager
  get rewardContributionsTableRefs {
    final manager = $$RewardContributionsTableTableTableManager(
      $_db,
      $_db.rewardContributionsTable,
    ).filter((f) => f.rewardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _rewardContributionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RewardsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RewardsTableTable> {
  $$RewardsTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSteps => $composableBuilder(
    column: $table.targetSteps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get activatedAtUtc => $composableBuilder(
    column: $table.activatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get earnedAtUtc => $composableBuilder(
    column: $table.earnedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get usedAtUtc => $composableBuilder(
    column: $table.usedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get planAtUtc => $composableBuilder(
    column: $table.planAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planTimezone => $composableBuilder(
    column: $table.planTimezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planNote => $composableBuilder(
    column: $table.planNote,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> rewardHabitLinksTableRefs(
    Expression<bool> Function($$RewardHabitLinksTableTableFilterComposer f) f,
  ) {
    final $$RewardHabitLinksTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.rewardHabitLinksTable,
          getReferencedColumn: (t) => t.rewardId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RewardHabitLinksTableTableFilterComposer(
                $db: $db,
                $table: $db.rewardHabitLinksTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> rewardContributionsTableRefs(
    Expression<bool> Function($$RewardContributionsTableTableFilterComposer f)
    f,
  ) {
    final $$RewardContributionsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.rewardContributionsTable,
          getReferencedColumn: (t) => t.rewardId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RewardContributionsTableTableFilterComposer(
                $db: $db,
                $table: $db.rewardContributionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RewardsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RewardsTableTable> {
  $$RewardsTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSteps => $composableBuilder(
    column: $table.targetSteps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get activatedAtUtc => $composableBuilder(
    column: $table.activatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get earnedAtUtc => $composableBuilder(
    column: $table.earnedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get usedAtUtc => $composableBuilder(
    column: $table.usedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get planAtUtc => $composableBuilder(
    column: $table.planAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planTimezone => $composableBuilder(
    column: $table.planTimezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planNote => $composableBuilder(
    column: $table.planNote,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RewardsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RewardsTableTable> {
  $$RewardsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetSteps => $composableBuilder(
    column: $table.targetSteps,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get activatedAtUtc => $composableBuilder(
    column: $table.activatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get earnedAtUtc => $composableBuilder(
    column: $table.earnedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get usedAtUtc =>
      $composableBuilder(column: $table.usedAtUtc, builder: (column) => column);

  GeneratedColumn<DateTime> get planAtUtc =>
      $composableBuilder(column: $table.planAtUtc, builder: (column) => column);

  GeneratedColumn<String> get planTimezone => $composableBuilder(
    column: $table.planTimezone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get placeName =>
      $composableBuilder(column: $table.placeName, builder: (column) => column);

  GeneratedColumn<String> get planNote =>
      $composableBuilder(column: $table.planNote, builder: (column) => column);

  Expression<T> rewardHabitLinksTableRefs<T extends Object>(
    Expression<T> Function($$RewardHabitLinksTableTableAnnotationComposer a) f,
  ) {
    final $$RewardHabitLinksTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.rewardHabitLinksTable,
          getReferencedColumn: (t) => t.rewardId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RewardHabitLinksTableTableAnnotationComposer(
                $db: $db,
                $table: $db.rewardHabitLinksTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> rewardContributionsTableRefs<T extends Object>(
    Expression<T> Function($$RewardContributionsTableTableAnnotationComposer a)
    f,
  ) {
    final $$RewardContributionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.rewardContributionsTable,
          getReferencedColumn: (t) => t.rewardId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RewardContributionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.rewardContributionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RewardsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RewardsTableTable,
          RewardsTableData,
          $$RewardsTableTableFilterComposer,
          $$RewardsTableTableOrderingComposer,
          $$RewardsTableTableAnnotationComposer,
          $$RewardsTableTableCreateCompanionBuilder,
          $$RewardsTableTableUpdateCompanionBuilder,
          (RewardsTableData, $$RewardsTableTableReferences),
          RewardsTableData,
          PrefetchHooks Function({
            bool rewardHabitLinksTableRefs,
            bool rewardContributionsTableRefs,
          })
        > {
  $$RewardsTableTableTableManager(_$AppDatabase db, $RewardsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RewardsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RewardsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> targetSteps = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> activatedAtUtc = const Value.absent(),
                Value<DateTime?> earnedAtUtc = const Value.absent(),
                Value<DateTime?> usedAtUtc = const Value.absent(),
                Value<DateTime?> planAtUtc = const Value.absent(),
                Value<String?> planTimezone = const Value.absent(),
                Value<String?> placeName = const Value.absent(),
                Value<String?> planNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardsTableCompanion(
                id: id,
                title: title,
                emoji: emoji,
                description: description,
                targetSteps: targetSteps,
                status: status,
                activatedAtUtc: activatedAtUtc,
                earnedAtUtc: earnedAtUtc,
                usedAtUtc: usedAtUtc,
                planAtUtc: planAtUtc,
                planTimezone: planTimezone,
                placeName: placeName,
                planNote: planNote,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String emoji,
                required String description,
                required int targetSteps,
                required String status,
                Value<DateTime?> activatedAtUtc = const Value.absent(),
                Value<DateTime?> earnedAtUtc = const Value.absent(),
                Value<DateTime?> usedAtUtc = const Value.absent(),
                Value<DateTime?> planAtUtc = const Value.absent(),
                Value<String?> planTimezone = const Value.absent(),
                Value<String?> placeName = const Value.absent(),
                Value<String?> planNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardsTableCompanion.insert(
                id: id,
                title: title,
                emoji: emoji,
                description: description,
                targetSteps: targetSteps,
                status: status,
                activatedAtUtc: activatedAtUtc,
                earnedAtUtc: earnedAtUtc,
                usedAtUtc: usedAtUtc,
                planAtUtc: planAtUtc,
                planTimezone: planTimezone,
                placeName: placeName,
                planNote: planNote,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RewardsTableTable, RewardsTableData>(table),
                  $$RewardsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                rewardHabitLinksTableRefs = false,
                rewardContributionsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (rewardHabitLinksTableRefs) db.rewardHabitLinksTable,
                    if (rewardContributionsTableRefs)
                      db.rewardContributionsTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (rewardHabitLinksTableRefs)
                        await $_getPrefetchedData<
                          RewardsTableData,
                          $RewardsTableTable,
                          RewardHabitLinksTableData
                        >(
                          currentTable: table,
                          referencedTable: $$RewardsTableTableReferences
                              ._rewardHabitLinksTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RewardsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).rewardHabitLinksTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.rewardId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rewardContributionsTableRefs)
                        await $_getPrefetchedData<
                          RewardsTableData,
                          $RewardsTableTable,
                          RewardContributionsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$RewardsTableTableReferences
                              ._rewardContributionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RewardsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).rewardContributionsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.rewardId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RewardsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RewardsTableTable,
      RewardsTableData,
      $$RewardsTableTableFilterComposer,
      $$RewardsTableTableOrderingComposer,
      $$RewardsTableTableAnnotationComposer,
      $$RewardsTableTableCreateCompanionBuilder,
      $$RewardsTableTableUpdateCompanionBuilder,
      (RewardsTableData, $$RewardsTableTableReferences),
      RewardsTableData,
      PrefetchHooks Function({
        bool rewardHabitLinksTableRefs,
        bool rewardContributionsTableRefs,
      })
    >;
typedef $$RewardHabitLinksTableTableCreateCompanionBuilder =
    RewardHabitLinksTableCompanion Function({
      required String rewardId,
      required String habitId,
      Value<int> rowid,
    });
typedef $$RewardHabitLinksTableTableUpdateCompanionBuilder =
    RewardHabitLinksTableCompanion Function({
      Value<String> rewardId,
      Value<String> habitId,
      Value<int> rowid,
    });

final class $$RewardHabitLinksTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RewardHabitLinksTableTable,
          RewardHabitLinksTableData
        > {
  $$RewardHabitLinksTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RewardsTableTable _rewardIdTable(_$AppDatabase db) =>
      db.rewardsTable.createAlias('reward_habit_links__reward_id__rewards__id');

  $$RewardsTableTableProcessedTableManager get rewardId {
    final $_column = $_itemColumn<String>('reward_id')!;

    final manager = $$RewardsTableTableTableManager(
      $_db,
      $_db.rewardsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rewardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $HabitsTableTable _habitIdTable(_$AppDatabase db) =>
      db.habitsTable.createAlias('reward_habit_links__habit_id__habits__id');

  $$HabitsTableTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableTableManager(
      $_db,
      $_db.habitsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RewardHabitLinksTableTableFilterComposer
    extends Composer<_$AppDatabase, $RewardHabitLinksTableTable> {
  $$RewardHabitLinksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$RewardsTableTableFilterComposer get rewardId {
    final $$RewardsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rewardId,
      referencedTable: $db.rewardsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardsTableTableFilterComposer(
            $db: $db,
            $table: $db.rewardsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HabitsTableTableFilterComposer get habitId {
    final $$HabitsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableFilterComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardHabitLinksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RewardHabitLinksTableTable> {
  $$RewardHabitLinksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$RewardsTableTableOrderingComposer get rewardId {
    final $$RewardsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rewardId,
      referencedTable: $db.rewardsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardsTableTableOrderingComposer(
            $db: $db,
            $table: $db.rewardsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HabitsTableTableOrderingComposer get habitId {
    final $$HabitsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableOrderingComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardHabitLinksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RewardHabitLinksTableTable> {
  $$RewardHabitLinksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$RewardsTableTableAnnotationComposer get rewardId {
    final $$RewardsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rewardId,
      referencedTable: $db.rewardsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.rewardsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HabitsTableTableAnnotationComposer get habitId {
    final $$HabitsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardHabitLinksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RewardHabitLinksTableTable,
          RewardHabitLinksTableData,
          $$RewardHabitLinksTableTableFilterComposer,
          $$RewardHabitLinksTableTableOrderingComposer,
          $$RewardHabitLinksTableTableAnnotationComposer,
          $$RewardHabitLinksTableTableCreateCompanionBuilder,
          $$RewardHabitLinksTableTableUpdateCompanionBuilder,
          (RewardHabitLinksTableData, $$RewardHabitLinksTableTableReferences),
          RewardHabitLinksTableData,
          PrefetchHooks Function({bool rewardId, bool habitId})
        > {
  $$RewardHabitLinksTableTableTableManager(
    _$AppDatabase db,
    $RewardHabitLinksTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardHabitLinksTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RewardHabitLinksTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RewardHabitLinksTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> rewardId = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardHabitLinksTableCompanion(
                rewardId: rewardId,
                habitId: habitId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String rewardId,
                required String habitId,
                Value<int> rowid = const Value.absent(),
              }) => RewardHabitLinksTableCompanion.insert(
                rewardId: rewardId,
                habitId: habitId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $RewardHabitLinksTableTable,
                    RewardHabitLinksTableData
                  >(table),
                  $$RewardHabitLinksTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({rewardId = false, habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (rewardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.rewardId,
                        referencedTable: $$RewardHabitLinksTableTableReferences
                            ._rewardIdTable(db),
                        referencedColumn: $$RewardHabitLinksTableTableReferences
                            ._rewardIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (habitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.habitId,
                        referencedTable: $$RewardHabitLinksTableTableReferences
                            ._habitIdTable(db),
                        referencedColumn: $$RewardHabitLinksTableTableReferences
                            ._habitIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RewardHabitLinksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RewardHabitLinksTableTable,
      RewardHabitLinksTableData,
      $$RewardHabitLinksTableTableFilterComposer,
      $$RewardHabitLinksTableTableOrderingComposer,
      $$RewardHabitLinksTableTableAnnotationComposer,
      $$RewardHabitLinksTableTableCreateCompanionBuilder,
      $$RewardHabitLinksTableTableUpdateCompanionBuilder,
      (RewardHabitLinksTableData, $$RewardHabitLinksTableTableReferences),
      RewardHabitLinksTableData,
      PrefetchHooks Function({bool rewardId, bool habitId})
    >;
typedef $$RewardContributionsTableTableCreateCompanionBuilder =
    RewardContributionsTableCompanion Function({
      required String id,
      required String rewardId,
      Value<String?> checkInId,
      required DateTime allocatedAtUtc,
      Value<bool> isReversed,
      Value<bool> reversedAfterUse,
      Value<int> rowid,
    });
typedef $$RewardContributionsTableTableUpdateCompanionBuilder =
    RewardContributionsTableCompanion Function({
      Value<String> id,
      Value<String> rewardId,
      Value<String?> checkInId,
      Value<DateTime> allocatedAtUtc,
      Value<bool> isReversed,
      Value<bool> reversedAfterUse,
      Value<int> rowid,
    });

final class $$RewardContributionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RewardContributionsTableTable,
          RewardContributionsTableData
        > {
  $$RewardContributionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RewardsTableTable _rewardIdTable(_$AppDatabase db) => db.rewardsTable
      .createAlias('reward_contributions__reward_id__rewards__id');

  $$RewardsTableTableProcessedTableManager get rewardId {
    final $_column = $_itemColumn<String>('reward_id')!;

    final manager = $$RewardsTableTableTableManager(
      $_db,
      $_db.rewardsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rewardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RewardContributionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RewardContributionsTableTable> {
  $$RewardContributionsTableTableFilterComposer({
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

  ColumnFilters<String> get checkInId => $composableBuilder(
    column: $table.checkInId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get allocatedAtUtc => $composableBuilder(
    column: $table.allocatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isReversed => $composableBuilder(
    column: $table.isReversed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reversedAfterUse => $composableBuilder(
    column: $table.reversedAfterUse,
    builder: (column) => ColumnFilters(column),
  );

  $$RewardsTableTableFilterComposer get rewardId {
    final $$RewardsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rewardId,
      referencedTable: $db.rewardsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardsTableTableFilterComposer(
            $db: $db,
            $table: $db.rewardsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardContributionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RewardContributionsTableTable> {
  $$RewardContributionsTableTableOrderingComposer({
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

  ColumnOrderings<String> get checkInId => $composableBuilder(
    column: $table.checkInId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get allocatedAtUtc => $composableBuilder(
    column: $table.allocatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isReversed => $composableBuilder(
    column: $table.isReversed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reversedAfterUse => $composableBuilder(
    column: $table.reversedAfterUse,
    builder: (column) => ColumnOrderings(column),
  );

  $$RewardsTableTableOrderingComposer get rewardId {
    final $$RewardsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rewardId,
      referencedTable: $db.rewardsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardsTableTableOrderingComposer(
            $db: $db,
            $table: $db.rewardsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardContributionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RewardContributionsTableTable> {
  $$RewardContributionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get checkInId =>
      $composableBuilder(column: $table.checkInId, builder: (column) => column);

  GeneratedColumn<DateTime> get allocatedAtUtc => $composableBuilder(
    column: $table.allocatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isReversed => $composableBuilder(
    column: $table.isReversed,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reversedAfterUse => $composableBuilder(
    column: $table.reversedAfterUse,
    builder: (column) => column,
  );

  $$RewardsTableTableAnnotationComposer get rewardId {
    final $$RewardsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rewardId,
      referencedTable: $db.rewardsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.rewardsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardContributionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RewardContributionsTableTable,
          RewardContributionsTableData,
          $$RewardContributionsTableTableFilterComposer,
          $$RewardContributionsTableTableOrderingComposer,
          $$RewardContributionsTableTableAnnotationComposer,
          $$RewardContributionsTableTableCreateCompanionBuilder,
          $$RewardContributionsTableTableUpdateCompanionBuilder,
          (
            RewardContributionsTableData,
            $$RewardContributionsTableTableReferences,
          ),
          RewardContributionsTableData,
          PrefetchHooks Function({bool rewardId})
        > {
  $$RewardContributionsTableTableTableManager(
    _$AppDatabase db,
    $RewardContributionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardContributionsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RewardContributionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RewardContributionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rewardId = const Value.absent(),
                Value<String?> checkInId = const Value.absent(),
                Value<DateTime> allocatedAtUtc = const Value.absent(),
                Value<bool> isReversed = const Value.absent(),
                Value<bool> reversedAfterUse = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardContributionsTableCompanion(
                id: id,
                rewardId: rewardId,
                checkInId: checkInId,
                allocatedAtUtc: allocatedAtUtc,
                isReversed: isReversed,
                reversedAfterUse: reversedAfterUse,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String rewardId,
                Value<String?> checkInId = const Value.absent(),
                required DateTime allocatedAtUtc,
                Value<bool> isReversed = const Value.absent(),
                Value<bool> reversedAfterUse = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardContributionsTableCompanion.insert(
                id: id,
                rewardId: rewardId,
                checkInId: checkInId,
                allocatedAtUtc: allocatedAtUtc,
                isReversed: isReversed,
                reversedAfterUse: reversedAfterUse,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $RewardContributionsTableTable,
                    RewardContributionsTableData
                  >(table),
                  $$RewardContributionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({rewardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (rewardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.rewardId,
                        referencedTable:
                            $$RewardContributionsTableTableReferences
                                ._rewardIdTable(db),
                        referencedColumn:
                            $$RewardContributionsTableTableReferences
                                ._rewardIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RewardContributionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RewardContributionsTableTable,
      RewardContributionsTableData,
      $$RewardContributionsTableTableFilterComposer,
      $$RewardContributionsTableTableOrderingComposer,
      $$RewardContributionsTableTableAnnotationComposer,
      $$RewardContributionsTableTableCreateCompanionBuilder,
      $$RewardContributionsTableTableUpdateCompanionBuilder,
      (RewardContributionsTableData, $$RewardContributionsTableTableReferences),
      RewardContributionsTableData,
      PrefetchHooks Function({bool rewardId})
    >;
typedef $$BadgesTableTableCreateCompanionBuilder =
    BadgesTableCompanion Function({
      required String code,
      required DateTime earnedAtUtc,
      Value<String?> evidenceId,
      Value<int> rowid,
    });
typedef $$BadgesTableTableUpdateCompanionBuilder =
    BadgesTableCompanion Function({
      Value<String> code,
      Value<DateTime> earnedAtUtc,
      Value<String?> evidenceId,
      Value<int> rowid,
    });

class $$BadgesTableTableFilterComposer
    extends Composer<_$AppDatabase, $BadgesTableTable> {
  $$BadgesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get earnedAtUtc => $composableBuilder(
    column: $table.earnedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidenceId => $composableBuilder(
    column: $table.evidenceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BadgesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BadgesTableTable> {
  $$BadgesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get earnedAtUtc => $composableBuilder(
    column: $table.earnedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidenceId => $composableBuilder(
    column: $table.evidenceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BadgesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BadgesTableTable> {
  $$BadgesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<DateTime> get earnedAtUtc => $composableBuilder(
    column: $table.earnedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get evidenceId => $composableBuilder(
    column: $table.evidenceId,
    builder: (column) => column,
  );
}

class $$BadgesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BadgesTableTable,
          BadgesTableData,
          $$BadgesTableTableFilterComposer,
          $$BadgesTableTableOrderingComposer,
          $$BadgesTableTableAnnotationComposer,
          $$BadgesTableTableCreateCompanionBuilder,
          $$BadgesTableTableUpdateCompanionBuilder,
          (
            BadgesTableData,
            BaseReferences<_$AppDatabase, $BadgesTableTable, BadgesTableData>,
          ),
          BadgesTableData,
          PrefetchHooks Function()
        > {
  $$BadgesTableTableTableManager(_$AppDatabase db, $BadgesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BadgesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BadgesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BadgesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> code = const Value.absent(),
                Value<DateTime> earnedAtUtc = const Value.absent(),
                Value<String?> evidenceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BadgesTableCompanion(
                code: code,
                earnedAtUtc: earnedAtUtc,
                evidenceId: evidenceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String code,
                required DateTime earnedAtUtc,
                Value<String?> evidenceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BadgesTableCompanion.insert(
                code: code,
                earnedAtUtc: earnedAtUtc,
                evidenceId: evidenceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BadgesTableTable, BadgesTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BadgesTableTable,
                    BadgesTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BadgesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BadgesTableTable,
      BadgesTableData,
      $$BadgesTableTableFilterComposer,
      $$BadgesTableTableOrderingComposer,
      $$BadgesTableTableAnnotationComposer,
      $$BadgesTableTableCreateCompanionBuilder,
      $$BadgesTableTableUpdateCompanionBuilder,
      (
        BadgesTableData,
        BaseReferences<_$AppDatabase, $BadgesTableTable, BadgesTableData>,
      ),
      BadgesTableData,
      PrefetchHooks Function()
    >;
typedef $$DailyReflectionsTableTableCreateCompanionBuilder =
    DailyReflectionsTableCompanion Function({
      required String localDate,
      required String textContent,
      required DateTime updatedAtUtc,
      Value<int> rowid,
    });
typedef $$DailyReflectionsTableTableUpdateCompanionBuilder =
    DailyReflectionsTableCompanion Function({
      Value<String> localDate,
      Value<String> textContent,
      Value<DateTime> updatedAtUtc,
      Value<int> rowid,
    });

class $$DailyReflectionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DailyReflectionsTableTable> {
  $$DailyReflectionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyReflectionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyReflectionsTableTable> {
  $$DailyReflectionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyReflectionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyReflectionsTableTable> {
  $$DailyReflectionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );
}

class $$DailyReflectionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyReflectionsTableTable,
          DailyReflectionsTableData,
          $$DailyReflectionsTableTableFilterComposer,
          $$DailyReflectionsTableTableOrderingComposer,
          $$DailyReflectionsTableTableAnnotationComposer,
          $$DailyReflectionsTableTableCreateCompanionBuilder,
          $$DailyReflectionsTableTableUpdateCompanionBuilder,
          (
            DailyReflectionsTableData,
            BaseReferences<
              _$AppDatabase,
              $DailyReflectionsTableTable,
              DailyReflectionsTableData
            >,
          ),
          DailyReflectionsTableData,
          PrefetchHooks Function()
        > {
  $$DailyReflectionsTableTableTableManager(
    _$AppDatabase db,
    $DailyReflectionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyReflectionsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DailyReflectionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DailyReflectionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> localDate = const Value.absent(),
                Value<String> textContent = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyReflectionsTableCompanion(
                localDate: localDate,
                textContent: textContent,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localDate,
                required String textContent,
                required DateTime updatedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => DailyReflectionsTableCompanion.insert(
                localDate: localDate,
                textContent: textContent,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $DailyReflectionsTableTable,
                    DailyReflectionsTableData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DailyReflectionsTableTable,
                    DailyReflectionsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyReflectionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyReflectionsTableTable,
      DailyReflectionsTableData,
      $$DailyReflectionsTableTableFilterComposer,
      $$DailyReflectionsTableTableOrderingComposer,
      $$DailyReflectionsTableTableAnnotationComposer,
      $$DailyReflectionsTableTableCreateCompanionBuilder,
      $$DailyReflectionsTableTableUpdateCompanionBuilder,
      (
        DailyReflectionsTableData,
        BaseReferences<
          _$AppDatabase,
          $DailyReflectionsTableTable,
          DailyReflectionsTableData
        >,
      ),
      DailyReflectionsTableData,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableTableCreateCompanionBuilder =
    RemindersTableCompanion Function({
      Value<int> id,
      required String habitId,
      required int weekday,
      required int hour,
      required int minute,
      required String status,
      Value<String?> lastErrorCode,
    });
typedef $$RemindersTableTableUpdateCompanionBuilder =
    RemindersTableCompanion Function({
      Value<int> id,
      Value<String> habitId,
      Value<int> weekday,
      Value<int> hour,
      Value<int> minute,
      Value<String> status,
      Value<String?> lastErrorCode,
    });

final class $$RemindersTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RemindersTableTable,
          RemindersTableData
        > {
  $$RemindersTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HabitsTableTable _habitIdTable(_$AppDatabase db) =>
      db.habitsTable.createAlias('reminders__habit_id__habits__id');

  $$HabitsTableTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableTableManager(
      $_db,
      $_db.habitsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RemindersTableTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastErrorCode => $composableBuilder(
    column: $table.lastErrorCode,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableTableFilterComposer get habitId {
    final $$HabitsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableFilterComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastErrorCode => $composableBuilder(
    column: $table.lastErrorCode,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableTableOrderingComposer get habitId {
    final $$HabitsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableOrderingComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get lastErrorCode => $composableBuilder(
    column: $table.lastErrorCode,
    builder: (column) => column,
  );

  $$HabitsTableTableAnnotationComposer get habitId {
    final $$HabitsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTableTable,
          RemindersTableData,
          $$RemindersTableTableFilterComposer,
          $$RemindersTableTableOrderingComposer,
          $$RemindersTableTableAnnotationComposer,
          $$RemindersTableTableCreateCompanionBuilder,
          $$RemindersTableTableUpdateCompanionBuilder,
          (RemindersTableData, $$RemindersTableTableReferences),
          RemindersTableData,
          PrefetchHooks Function({bool habitId})
        > {
  $$RemindersTableTableTableManager(
    _$AppDatabase db,
    $RemindersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<int> hour = const Value.absent(),
                Value<int> minute = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> lastErrorCode = const Value.absent(),
              }) => RemindersTableCompanion(
                id: id,
                habitId: habitId,
                weekday: weekday,
                hour: hour,
                minute: minute,
                status: status,
                lastErrorCode: lastErrorCode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String habitId,
                required int weekday,
                required int hour,
                required int minute,
                required String status,
                Value<String?> lastErrorCode = const Value.absent(),
              }) => RemindersTableCompanion.insert(
                id: id,
                habitId: habitId,
                weekday: weekday,
                hour: hour,
                minute: minute,
                status: status,
                lastErrorCode: lastErrorCode,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemindersTableTable, RemindersTableData>(table),
                  $$RemindersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.habitId,
                        referencedTable: $$RemindersTableTableReferences
                            ._habitIdTable(db),
                        referencedColumn: $$RemindersTableTableReferences
                            ._habitIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RemindersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTableTable,
      RemindersTableData,
      $$RemindersTableTableFilterComposer,
      $$RemindersTableTableOrderingComposer,
      $$RemindersTableTableAnnotationComposer,
      $$RemindersTableTableCreateCompanionBuilder,
      $$RemindersTableTableUpdateCompanionBuilder,
      (RemindersTableData, $$RemindersTableTableReferences),
      RemindersTableData,
      PrefetchHooks Function({bool habitId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HabitsTableTableTableManager get habitsTable =>
      $$HabitsTableTableTableManager(_db, _db.habitsTable);
  $$HabitPlanVersionsTableTableTableManager get habitPlanVersionsTable =>
      $$HabitPlanVersionsTableTableTableManager(
        _db,
        _db.habitPlanVersionsTable,
      );
  $$DailyCheckInsTableTableTableManager get dailyCheckInsTable =>
      $$DailyCheckInsTableTableTableManager(_db, _db.dailyCheckInsTable);
  $$FocusSessionsTableTableTableManager get focusSessionsTable =>
      $$FocusSessionsTableTableTableManager(_db, _db.focusSessionsTable);
  $$FocusAllocationsTableTableTableManager get focusAllocationsTable =>
      $$FocusAllocationsTableTableTableManager(_db, _db.focusAllocationsTable);
  $$RewardsTableTableTableManager get rewardsTable =>
      $$RewardsTableTableTableManager(_db, _db.rewardsTable);
  $$RewardHabitLinksTableTableTableManager get rewardHabitLinksTable =>
      $$RewardHabitLinksTableTableTableManager(_db, _db.rewardHabitLinksTable);
  $$RewardContributionsTableTableTableManager get rewardContributionsTable =>
      $$RewardContributionsTableTableTableManager(
        _db,
        _db.rewardContributionsTable,
      );
  $$BadgesTableTableTableManager get badgesTable =>
      $$BadgesTableTableTableManager(_db, _db.badgesTable);
  $$DailyReflectionsTableTableTableManager get dailyReflectionsTable =>
      $$DailyReflectionsTableTableTableManager(_db, _db.dailyReflectionsTable);
  $$RemindersTableTableTableManager get remindersTable =>
      $$RemindersTableTableTableManager(_db, _db.remindersTable);
}
