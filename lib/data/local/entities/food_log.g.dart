// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFoodLogCollection on Isar {
  IsarCollection<FoodLog> get foodLogs => this.collection();
}

const FoodLogSchema = CollectionSchema(
  name: r'FoodLog',
  id: -1012088423414645589,
  properties: {
    r'calories': PropertySchema(
      id: 0,
      name: r'calories',
      type: IsarType.double,
    ),
    r'carbs': PropertySchema(
      id: 1,
      name: r'carbs',
      type: IsarType.double,
    ),
    r'fat': PropertySchema(
      id: 2,
      name: r'fat',
      type: IsarType.double,
    ),
    r'fiber': PropertySchema(
      id: 3,
      name: r'fiber',
      type: IsarType.double,
    ),
    r'foodName': PropertySchema(
      id: 4,
      name: r'foodName',
      type: IsarType.string,
    ),
    r'healthScore': PropertySchema(
      id: 5,
      name: r'healthScore',
      type: IsarType.long,
    ),
    r'imagePath': PropertySchema(
      id: 6,
      name: r'imagePath',
      type: IsarType.string,
    ),
    r'isSynced': PropertySchema(
      id: 7,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'itemCount': PropertySchema(
      id: 8,
      name: r'itemCount',
      type: IsarType.long,
    ),
    r'mealType': PropertySchema(
      id: 9,
      name: r'mealType',
      type: IsarType.string,
    ),
    r'modifierCalories': PropertySchema(
      id: 10,
      name: r'modifierCalories',
      type: IsarType.double,
    ),
    r'modifierCarbs': PropertySchema(
      id: 11,
      name: r'modifierCarbs',
      type: IsarType.double,
    ),
    r'modifierFat': PropertySchema(
      id: 12,
      name: r'modifierFat',
      type: IsarType.double,
    ),
    r'modifierProtein': PropertySchema(
      id: 13,
      name: r'modifierProtein',
      type: IsarType.double,
    ),
    r'modifiers': PropertySchema(
      id: 14,
      name: r'modifiers',
      type: IsarType.stringList,
    ),
    r'nutriaComment': PropertySchema(
      id: 15,
      name: r'nutriaComment',
      type: IsarType.string,
    ),
    r'portionSize': PropertySchema(
      id: 16,
      name: r'portionSize',
      type: IsarType.double,
    ),
    r'protein': PropertySchema(
      id: 17,
      name: r'protein',
      type: IsarType.double,
    ),
    r'supabaseId': PropertySchema(
      id: 18,
      name: r'supabaseId',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 19,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'totalCalories': PropertySchema(
      id: 20,
      name: r'totalCalories',
      type: IsarType.double,
    ),
    r'totalCarbs': PropertySchema(
      id: 21,
      name: r'totalCarbs',
      type: IsarType.double,
    ),
    r'totalFat': PropertySchema(
      id: 22,
      name: r'totalFat',
      type: IsarType.double,
    ),
    r'totalFiber': PropertySchema(
      id: 23,
      name: r'totalFiber',
      type: IsarType.double,
    ),
    r'totalProtein': PropertySchema(
      id: 24,
      name: r'totalProtein',
      type: IsarType.double,
    ),
    r'userId': PropertySchema(
      id: 25,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _foodLogEstimateSize,
  serialize: _foodLogSerialize,
  deserialize: _foodLogDeserialize,
  deserializeProp: _foodLogDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _foodLogGetId,
  getLinks: _foodLogGetLinks,
  attach: _foodLogAttach,
  version: '3.1.0+1',
);

int _foodLogEstimateSize(
  FoodLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.foodName.length * 3;
  {
    final value = object.imagePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.mealType.length * 3;
  bytesCount += 3 + object.modifiers.length * 3;
  {
    for (var i = 0; i < object.modifiers.length; i++) {
      final value = object.modifiers[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.nutriaComment;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.supabaseId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _foodLogSerialize(
  FoodLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.calories);
  writer.writeDouble(offsets[1], object.carbs);
  writer.writeDouble(offsets[2], object.fat);
  writer.writeDouble(offsets[3], object.fiber);
  writer.writeString(offsets[4], object.foodName);
  writer.writeLong(offsets[5], object.healthScore);
  writer.writeString(offsets[6], object.imagePath);
  writer.writeBool(offsets[7], object.isSynced);
  writer.writeLong(offsets[8], object.itemCount);
  writer.writeString(offsets[9], object.mealType);
  writer.writeDouble(offsets[10], object.modifierCalories);
  writer.writeDouble(offsets[11], object.modifierCarbs);
  writer.writeDouble(offsets[12], object.modifierFat);
  writer.writeDouble(offsets[13], object.modifierProtein);
  writer.writeStringList(offsets[14], object.modifiers);
  writer.writeString(offsets[15], object.nutriaComment);
  writer.writeDouble(offsets[16], object.portionSize);
  writer.writeDouble(offsets[17], object.protein);
  writer.writeString(offsets[18], object.supabaseId);
  writer.writeDateTime(offsets[19], object.timestamp);
  writer.writeDouble(offsets[20], object.totalCalories);
  writer.writeDouble(offsets[21], object.totalCarbs);
  writer.writeDouble(offsets[22], object.totalFat);
  writer.writeDouble(offsets[23], object.totalFiber);
  writer.writeDouble(offsets[24], object.totalProtein);
  writer.writeString(offsets[25], object.userId);
}

FoodLog _foodLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FoodLog();
  object.calories = reader.readDouble(offsets[0]);
  object.carbs = reader.readDouble(offsets[1]);
  object.fat = reader.readDouble(offsets[2]);
  object.fiber = reader.readDouble(offsets[3]);
  object.foodName = reader.readString(offsets[4]);
  object.healthScore = reader.readLong(offsets[5]);
  object.id = id;
  object.imagePath = reader.readStringOrNull(offsets[6]);
  object.isSynced = reader.readBool(offsets[7]);
  object.itemCount = reader.readLong(offsets[8]);
  object.mealType = reader.readString(offsets[9]);
  object.modifierCalories = reader.readDouble(offsets[10]);
  object.modifierCarbs = reader.readDouble(offsets[11]);
  object.modifierFat = reader.readDouble(offsets[12]);
  object.modifierProtein = reader.readDouble(offsets[13]);
  object.modifiers = reader.readStringList(offsets[14]) ?? [];
  object.nutriaComment = reader.readStringOrNull(offsets[15]);
  object.portionSize = reader.readDouble(offsets[16]);
  object.protein = reader.readDouble(offsets[17]);
  object.supabaseId = reader.readStringOrNull(offsets[18]);
  object.timestamp = reader.readDateTime(offsets[19]);
  object.totalCalories = reader.readDouble(offsets[20]);
  object.totalCarbs = reader.readDouble(offsets[21]);
  object.totalFat = reader.readDouble(offsets[22]);
  object.totalFiber = reader.readDouble(offsets[23]);
  object.totalProtein = reader.readDouble(offsets[24]);
  object.userId = reader.readString(offsets[25]);
  return object;
}

P _foodLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readStringList(offset) ?? []) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readDouble(offset)) as P;
    case 17:
      return (reader.readDouble(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readDateTime(offset)) as P;
    case 20:
      return (reader.readDouble(offset)) as P;
    case 21:
      return (reader.readDouble(offset)) as P;
    case 22:
      return (reader.readDouble(offset)) as P;
    case 23:
      return (reader.readDouble(offset)) as P;
    case 24:
      return (reader.readDouble(offset)) as P;
    case 25:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _foodLogGetId(FoodLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _foodLogGetLinks(FoodLog object) {
  return [];
}

void _foodLogAttach(IsarCollection<dynamic> col, Id id, FoodLog object) {
  object.id = id;
}

extension FoodLogQueryWhereSort on QueryBuilder<FoodLog, FoodLog, QWhere> {
  QueryBuilder<FoodLog, FoodLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FoodLogQueryWhere on QueryBuilder<FoodLog, FoodLog, QWhereClause> {
  QueryBuilder<FoodLog, FoodLog, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FoodLogQueryFilter
    on QueryBuilder<FoodLog, FoodLog, QFilterCondition> {
  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> caloriesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> caloriesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> caloriesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> caloriesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> carbsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'carbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> carbsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'carbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> carbsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'carbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> carbsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'carbs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> fatEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> fatGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> fatLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> fatBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> fiberEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fiber',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> fiberGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fiber',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> fiberLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fiber',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> fiberBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fiber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'foodName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'foodName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foodName',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'foodName',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> healthScoreEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'healthScore',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> healthScoreGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'healthScore',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> healthScoreLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'healthScore',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> healthScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'healthScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> imagePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imagePath',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> imagePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imagePath',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> imagePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> imagePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> imagePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> imagePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> imagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> imagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> imagePathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> imagePathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> isSyncedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> itemCountEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemCount',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> itemCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemCount',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> itemCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemCount',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> itemCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> mealTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mealType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> mealTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mealType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> mealTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mealType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> mealTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mealType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> mealTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mealType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> mealTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mealType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> mealTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mealType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> mealTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mealType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> mealTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mealType',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> mealTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mealType',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifierCaloriesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modifierCalories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      modifierCaloriesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modifierCalories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      modifierCaloriesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modifierCalories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifierCaloriesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modifierCalories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifierCarbsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modifierCarbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      modifierCarbsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modifierCarbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifierCarbsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modifierCarbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifierCarbsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modifierCarbs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifierFatEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modifierFat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifierFatGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modifierFat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifierFatLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modifierFat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifierFatBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modifierFat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifierProteinEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modifierProtein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      modifierProteinGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modifierProtein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifierProteinLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modifierProtein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifierProteinBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modifierProtein',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifiersElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      modifiersElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      modifiersElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifiersElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modifiers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      modifiersElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      modifiersElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      modifiersElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifiersElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modifiers',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      modifiersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modifiers',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      modifiersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modifiers',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifiersLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modifiers',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifiersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modifiers',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifiersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modifiers',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifiersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modifiers',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      modifiersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modifiers',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> modifiersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modifiers',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> nutriaCommentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nutriaComment',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      nutriaCommentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nutriaComment',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> nutriaCommentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nutriaComment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      nutriaCommentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nutriaComment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> nutriaCommentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nutriaComment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> nutriaCommentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nutriaComment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> nutriaCommentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nutriaComment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> nutriaCommentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nutriaComment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> nutriaCommentContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nutriaComment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> nutriaCommentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nutriaComment',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> nutriaCommentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nutriaComment',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      nutriaCommentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nutriaComment',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> portionSizeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'portionSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> portionSizeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'portionSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> portionSizeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'portionSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> portionSizeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'portionSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> proteinEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'protein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> proteinGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'protein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> proteinLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'protein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> proteinBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'protein',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> supabaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'supabaseId',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> supabaseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'supabaseId',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> supabaseIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> supabaseIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> supabaseIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> supabaseIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'supabaseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> supabaseIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> supabaseIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> supabaseIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> supabaseIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'supabaseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> supabaseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supabaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> supabaseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'supabaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> timestampEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalCaloriesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCalories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      totalCaloriesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCalories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalCaloriesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCalories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalCaloriesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCalories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalCarbsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCarbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalCarbsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCarbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalCarbsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCarbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalCarbsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCarbs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalFatEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalFat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalFatGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalFat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalFatLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalFat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalFatBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalFat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalFiberEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalFiber',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalFiberGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalFiber',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalFiberLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalFiber',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalFiberBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalFiber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalProteinEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalProtein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalProteinGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalProtein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalProteinLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalProtein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> totalProteinBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalProtein',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> userIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> userIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension FoodLogQueryObject
    on QueryBuilder<FoodLog, FoodLog, QFilterCondition> {}

extension FoodLogQueryLinks
    on QueryBuilder<FoodLog, FoodLog, QFilterCondition> {}

extension FoodLogQuerySortBy on QueryBuilder<FoodLog, FoodLog, QSortBy> {
  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByFat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fat', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByFatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fat', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByFiber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiber', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByFiberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiber', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByFoodName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodName', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByFoodNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodName', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByHealthScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthScore', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByHealthScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthScore', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByItemCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCount', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByItemCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCount', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByMealType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByMealTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByModifierCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifierCalories', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByModifierCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifierCalories', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByModifierCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifierCarbs', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByModifierCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifierCarbs', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByModifierFat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifierFat', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByModifierFatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifierFat', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByModifierProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifierProtein', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByModifierProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifierProtein', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByNutriaComment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nutriaComment', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByNutriaCommentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nutriaComment', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByPortionSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portionSize', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByPortionSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portionSize', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortBySupabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortBySupabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByTotalCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCalories', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByTotalCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCalories', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByTotalCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCarbs', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByTotalCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCarbs', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByTotalFat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFat', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByTotalFatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFat', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByTotalFiber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFiber', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByTotalFiberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFiber', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByTotalProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalProtein', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByTotalProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalProtein', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension FoodLogQuerySortThenBy
    on QueryBuilder<FoodLog, FoodLog, QSortThenBy> {
  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByFat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fat', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByFatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fat', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByFiber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiber', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByFiberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiber', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByFoodName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodName', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByFoodNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodName', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByHealthScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthScore', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByHealthScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthScore', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByItemCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCount', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByItemCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCount', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByMealType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByMealTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByModifierCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifierCalories', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByModifierCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifierCalories', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByModifierCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifierCarbs', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByModifierCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifierCarbs', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByModifierFat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifierFat', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByModifierFatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifierFat', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByModifierProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifierProtein', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByModifierProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifierProtein', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByNutriaComment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nutriaComment', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByNutriaCommentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nutriaComment', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByPortionSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portionSize', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByPortionSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portionSize', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenBySupabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenBySupabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByTotalCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCalories', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByTotalCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCalories', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByTotalCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCarbs', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByTotalCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCarbs', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByTotalFat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFat', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByTotalFatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFat', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByTotalFiber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFiber', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByTotalFiberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFiber', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByTotalProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalProtein', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByTotalProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalProtein', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension FoodLogQueryWhereDistinct
    on QueryBuilder<FoodLog, FoodLog, QDistinct> {
  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calories');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carbs');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByFat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fat');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByFiber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fiber');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByFoodName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'foodName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByHealthScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'healthScore');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByImagePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByItemCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemCount');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByMealType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mealType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByModifierCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modifierCalories');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByModifierCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modifierCarbs');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByModifierFat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modifierFat');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByModifierProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modifierProtein');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByModifiers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modifiers');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByNutriaComment(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nutriaComment',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByPortionSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'portionSize');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'protein');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctBySupabaseId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supabaseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByTotalCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCalories');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByTotalCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCarbs');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByTotalFat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalFat');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByTotalFiber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalFiber');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByTotalProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalProtein');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension FoodLogQueryProperty
    on QueryBuilder<FoodLog, FoodLog, QQueryProperty> {
  QueryBuilder<FoodLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> caloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calories');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> carbsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carbs');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> fatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fat');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> fiberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fiber');
    });
  }

  QueryBuilder<FoodLog, String, QQueryOperations> foodNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'foodName');
    });
  }

  QueryBuilder<FoodLog, int, QQueryOperations> healthScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'healthScore');
    });
  }

  QueryBuilder<FoodLog, String?, QQueryOperations> imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }

  QueryBuilder<FoodLog, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<FoodLog, int, QQueryOperations> itemCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemCount');
    });
  }

  QueryBuilder<FoodLog, String, QQueryOperations> mealTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mealType');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> modifierCaloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modifierCalories');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> modifierCarbsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modifierCarbs');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> modifierFatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modifierFat');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> modifierProteinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modifierProtein');
    });
  }

  QueryBuilder<FoodLog, List<String>, QQueryOperations> modifiersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modifiers');
    });
  }

  QueryBuilder<FoodLog, String?, QQueryOperations> nutriaCommentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nutriaComment');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> portionSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'portionSize');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> proteinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'protein');
    });
  }

  QueryBuilder<FoodLog, String?, QQueryOperations> supabaseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supabaseId');
    });
  }

  QueryBuilder<FoodLog, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> totalCaloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCalories');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> totalCarbsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCarbs');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> totalFatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalFat');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> totalFiberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalFiber');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> totalProteinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalProtein');
    });
  }

  QueryBuilder<FoodLog, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
