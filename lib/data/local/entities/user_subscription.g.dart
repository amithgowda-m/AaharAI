// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_subscription.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserSubscriptionCollection on Isar {
  IsarCollection<UserSubscription> get userSubscriptions => this.collection();
}

const UserSubscriptionSchema = CollectionSchema(
  name: r'UserSubscription',
  id: 950687617358749933,
  properties: {
    r'autoRenew': PropertySchema(
      id: 0,
      name: r'autoRenew',
      type: IsarType.bool,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dailyChatCount': PropertySchema(
      id: 2,
      name: r'dailyChatCount',
      type: IsarType.long,
    ),
    r'dailyScanCount': PropertySchema(
      id: 3,
      name: r'dailyScanCount',
      type: IsarType.long,
    ),
    r'endDate': PropertySchema(
      id: 4,
      name: r'endDate',
      type: IsarType.dateTime,
    ),
    r'isActive': PropertySchema(
      id: 5,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'lastResetDate': PropertySchema(
      id: 6,
      name: r'lastResetDate',
      type: IsarType.dateTime,
    ),
    r'startDate': PropertySchema(
      id: 7,
      name: r'startDate',
      type: IsarType.dateTime,
    ),
    r'subscriptionType': PropertySchema(
      id: 8,
      name: r'subscriptionType',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 10,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _userSubscriptionEstimateSize,
  serialize: _userSubscriptionSerialize,
  deserialize: _userSubscriptionDeserialize,
  deserializeProp: _userSubscriptionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userSubscriptionGetId,
  getLinks: _userSubscriptionGetLinks,
  attach: _userSubscriptionAttach,
  version: '3.1.0+1',
);

int _userSubscriptionEstimateSize(
  UserSubscription object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.subscriptionType.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _userSubscriptionSerialize(
  UserSubscription object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.autoRenew);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.dailyChatCount);
  writer.writeLong(offsets[3], object.dailyScanCount);
  writer.writeDateTime(offsets[4], object.endDate);
  writer.writeBool(offsets[5], object.isActive);
  writer.writeDateTime(offsets[6], object.lastResetDate);
  writer.writeDateTime(offsets[7], object.startDate);
  writer.writeString(offsets[8], object.subscriptionType);
  writer.writeDateTime(offsets[9], object.updatedAt);
  writer.writeString(offsets[10], object.userId);
}

UserSubscription _userSubscriptionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserSubscription();
  object.autoRenew = reader.readBool(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.dailyChatCount = reader.readLong(offsets[2]);
  object.dailyScanCount = reader.readLong(offsets[3]);
  object.endDate = reader.readDateTimeOrNull(offsets[4]);
  object.id = id;
  object.isActive = reader.readBool(offsets[5]);
  object.lastResetDate = reader.readDateTime(offsets[6]);
  object.startDate = reader.readDateTime(offsets[7]);
  object.subscriptionType = reader.readString(offsets[8]);
  object.updatedAt = reader.readDateTime(offsets[9]);
  object.userId = reader.readString(offsets[10]);
  return object;
}

P _userSubscriptionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userSubscriptionGetId(UserSubscription object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userSubscriptionGetLinks(UserSubscription object) {
  return [];
}

void _userSubscriptionAttach(
    IsarCollection<dynamic> col, Id id, UserSubscription object) {
  object.id = id;
}

extension UserSubscriptionQueryWhereSort
    on QueryBuilder<UserSubscription, UserSubscription, QWhere> {
  QueryBuilder<UserSubscription, UserSubscription, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserSubscriptionQueryWhere
    on QueryBuilder<UserSubscription, UserSubscription, QWhereClause> {
  QueryBuilder<UserSubscription, UserSubscription, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<UserSubscription, UserSubscription, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterWhereClause> idBetween(
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

extension UserSubscriptionQueryFilter
    on QueryBuilder<UserSubscription, UserSubscription, QFilterCondition> {
  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      autoRenewEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoRenew',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      dailyChatCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyChatCount',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      dailyChatCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyChatCount',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      dailyChatCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyChatCount',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      dailyChatCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyChatCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      dailyScanCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyScanCount',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      dailyScanCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyScanCount',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      dailyScanCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyScanCount',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      dailyScanCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyScanCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      endDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      endDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      endDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      endDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      endDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      endDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      lastResetDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastResetDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      lastResetDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastResetDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      lastResetDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastResetDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      lastResetDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastResetDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      startDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      startDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      startDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      startDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      subscriptionTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subscriptionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      subscriptionTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subscriptionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      subscriptionTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subscriptionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      subscriptionTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subscriptionType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      subscriptionTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subscriptionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      subscriptionTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subscriptionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      subscriptionTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subscriptionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      subscriptionTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subscriptionType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      subscriptionTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subscriptionType',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      subscriptionTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subscriptionType',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      userIdEqualTo(
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

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      userIdGreaterThan(
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

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      userIdLessThan(
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

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      userIdBetween(
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

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      userIdStartsWith(
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

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      userIdEndsWith(
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

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension UserSubscriptionQueryObject
    on QueryBuilder<UserSubscription, UserSubscription, QFilterCondition> {}

extension UserSubscriptionQueryLinks
    on QueryBuilder<UserSubscription, UserSubscription, QFilterCondition> {}

extension UserSubscriptionQuerySortBy
    on QueryBuilder<UserSubscription, UserSubscription, QSortBy> {
  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByAutoRenew() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoRenew', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByAutoRenewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoRenew', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByDailyChatCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyChatCount', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByDailyChatCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyChatCount', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByDailyScanCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyScanCount', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByDailyScanCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyScanCount', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByLastResetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastResetDate', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByLastResetDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastResetDate', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortBySubscriptionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionType', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortBySubscriptionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionType', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension UserSubscriptionQuerySortThenBy
    on QueryBuilder<UserSubscription, UserSubscription, QSortThenBy> {
  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByAutoRenew() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoRenew', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByAutoRenewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoRenew', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByDailyChatCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyChatCount', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByDailyChatCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyChatCount', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByDailyScanCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyScanCount', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByDailyScanCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyScanCount', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByLastResetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastResetDate', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByLastResetDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastResetDate', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenBySubscriptionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionType', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenBySubscriptionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionType', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension UserSubscriptionQueryWhereDistinct
    on QueryBuilder<UserSubscription, UserSubscription, QDistinct> {
  QueryBuilder<UserSubscription, UserSubscription, QDistinct>
      distinctByAutoRenew() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoRenew');
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QDistinct>
      distinctByDailyChatCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyChatCount');
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QDistinct>
      distinctByDailyScanCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyScanCount');
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QDistinct>
      distinctByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDate');
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QDistinct>
      distinctByLastResetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastResetDate');
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QDistinct>
      distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QDistinct>
      distinctBySubscriptionType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subscriptionType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<UserSubscription, UserSubscription, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension UserSubscriptionQueryProperty
    on QueryBuilder<UserSubscription, UserSubscription, QQueryProperty> {
  QueryBuilder<UserSubscription, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserSubscription, bool, QQueryOperations> autoRenewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoRenew');
    });
  }

  QueryBuilder<UserSubscription, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<UserSubscription, int, QQueryOperations>
      dailyChatCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyChatCount');
    });
  }

  QueryBuilder<UserSubscription, int, QQueryOperations>
      dailyScanCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyScanCount');
    });
  }

  QueryBuilder<UserSubscription, DateTime?, QQueryOperations>
      endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDate');
    });
  }

  QueryBuilder<UserSubscription, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<UserSubscription, DateTime, QQueryOperations>
      lastResetDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastResetDate');
    });
  }

  QueryBuilder<UserSubscription, DateTime, QQueryOperations>
      startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }

  QueryBuilder<UserSubscription, String, QQueryOperations>
      subscriptionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subscriptionType');
    });
  }

  QueryBuilder<UserSubscription, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<UserSubscription, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
