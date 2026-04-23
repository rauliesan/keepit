// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStreakDataCollection on Isar {
  IsarCollection<StreakData> get streakDatas => this.collection();
}

const StreakDataSchema = CollectionSchema(
  name: r'StreakData',
  id: 2927366008274921717,
  properties: {
    r'currentStreak': PropertySchema(
      id: 0,
      name: r'currentStreak',
      type: IsarType.long,
    ),
    r'freezesAvailable': PropertySchema(
      id: 1,
      name: r'freezesAvailable',
      type: IsarType.long,
    ),
    r'lastLogDate': PropertySchema(
      id: 2,
      name: r'lastLogDate',
      type: IsarType.dateTime,
    ),
    r'longestStreak': PropertySchema(
      id: 3,
      name: r'longestStreak',
      type: IsarType.long,
    ),
    r'totalLogged': PropertySchema(
      id: 4,
      name: r'totalLogged',
      type: IsarType.long,
    )
  },
  estimateSize: _streakDataEstimateSize,
  serialize: _streakDataSerialize,
  deserialize: _streakDataDeserialize,
  deserializeProp: _streakDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _streakDataGetId,
  getLinks: _streakDataGetLinks,
  attach: _streakDataAttach,
  version: '3.1.0+1',
);

int _streakDataEstimateSize(
  StreakData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _streakDataSerialize(
  StreakData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.currentStreak);
  writer.writeLong(offsets[1], object.freezesAvailable);
  writer.writeDateTime(offsets[2], object.lastLogDate);
  writer.writeLong(offsets[3], object.longestStreak);
  writer.writeLong(offsets[4], object.totalLogged);
}

StreakData _streakDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StreakData();
  object.currentStreak = reader.readLong(offsets[0]);
  object.freezesAvailable = reader.readLong(offsets[1]);
  object.id = id;
  object.lastLogDate = reader.readDateTimeOrNull(offsets[2]);
  object.longestStreak = reader.readLong(offsets[3]);
  object.totalLogged = reader.readLong(offsets[4]);
  return object;
}

P _streakDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _streakDataGetId(StreakData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _streakDataGetLinks(StreakData object) {
  return [];
}

void _streakDataAttach(IsarCollection<dynamic> col, Id id, StreakData object) {
  object.id = id;
}

extension StreakDataQueryWhereSort
    on QueryBuilder<StreakData, StreakData, QWhere> {
  QueryBuilder<StreakData, StreakData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StreakDataQueryWhere
    on QueryBuilder<StreakData, StreakData, QWhereClause> {
  QueryBuilder<StreakData, StreakData, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<StreakData, StreakData, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterWhereClause> idBetween(
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

extension StreakDataQueryFilter
    on QueryBuilder<StreakData, StreakData, QFilterCondition> {
  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      currentStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      currentStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      currentStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      currentStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      freezesAvailableEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'freezesAvailable',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      freezesAvailableGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'freezesAvailable',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      freezesAvailableLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'freezesAvailable',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      freezesAvailableBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'freezesAvailable',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition> idBetween(
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

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      lastLogDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastLogDate',
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      lastLogDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastLogDate',
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      lastLogDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastLogDate',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      lastLogDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastLogDate',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      lastLogDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastLogDate',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      lastLogDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastLogDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      longestStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      longestStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      longestStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      longestStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longestStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      totalLoggedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalLogged',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      totalLoggedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalLogged',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      totalLoggedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalLogged',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterFilterCondition>
      totalLoggedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalLogged',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StreakDataQueryObject
    on QueryBuilder<StreakData, StreakData, QFilterCondition> {}

extension StreakDataQueryLinks
    on QueryBuilder<StreakData, StreakData, QFilterCondition> {}

extension StreakDataQuerySortBy
    on QueryBuilder<StreakData, StreakData, QSortBy> {
  QueryBuilder<StreakData, StreakData, QAfterSortBy> sortByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> sortByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> sortByFreezesAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'freezesAvailable', Sort.asc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy>
      sortByFreezesAvailableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'freezesAvailable', Sort.desc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> sortByLastLogDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLogDate', Sort.asc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> sortByLastLogDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLogDate', Sort.desc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> sortByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.asc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> sortByLongestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.desc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> sortByTotalLogged() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLogged', Sort.asc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> sortByTotalLoggedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLogged', Sort.desc);
    });
  }
}

extension StreakDataQuerySortThenBy
    on QueryBuilder<StreakData, StreakData, QSortThenBy> {
  QueryBuilder<StreakData, StreakData, QAfterSortBy> thenByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> thenByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> thenByFreezesAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'freezesAvailable', Sort.asc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy>
      thenByFreezesAvailableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'freezesAvailable', Sort.desc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> thenByLastLogDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLogDate', Sort.asc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> thenByLastLogDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLogDate', Sort.desc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> thenByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.asc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> thenByLongestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.desc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> thenByTotalLogged() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLogged', Sort.asc);
    });
  }

  QueryBuilder<StreakData, StreakData, QAfterSortBy> thenByTotalLoggedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLogged', Sort.desc);
    });
  }
}

extension StreakDataQueryWhereDistinct
    on QueryBuilder<StreakData, StreakData, QDistinct> {
  QueryBuilder<StreakData, StreakData, QDistinct> distinctByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStreak');
    });
  }

  QueryBuilder<StreakData, StreakData, QDistinct> distinctByFreezesAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'freezesAvailable');
    });
  }

  QueryBuilder<StreakData, StreakData, QDistinct> distinctByLastLogDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastLogDate');
    });
  }

  QueryBuilder<StreakData, StreakData, QDistinct> distinctByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longestStreak');
    });
  }

  QueryBuilder<StreakData, StreakData, QDistinct> distinctByTotalLogged() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalLogged');
    });
  }
}

extension StreakDataQueryProperty
    on QueryBuilder<StreakData, StreakData, QQueryProperty> {
  QueryBuilder<StreakData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StreakData, int, QQueryOperations> currentStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStreak');
    });
  }

  QueryBuilder<StreakData, int, QQueryOperations> freezesAvailableProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'freezesAvailable');
    });
  }

  QueryBuilder<StreakData, DateTime?, QQueryOperations> lastLogDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastLogDate');
    });
  }

  QueryBuilder<StreakData, int, QQueryOperations> longestStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longestStreak');
    });
  }

  QueryBuilder<StreakData, int, QQueryOperations> totalLoggedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalLogged');
    });
  }
}
