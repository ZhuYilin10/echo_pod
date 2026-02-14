// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_item_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetQueueItemEntityCollection on Isar {
  IsarCollection<QueueItemEntity> get queueItemEntitys => this.collection();
}

const QueueItemEntitySchema = CollectionSchema(
  name: r'QueueItemEntity',
  id: -6029484834376635152,
  properties: {
    r'addedAt': PropertySchema(
      id: 0,
      name: r'addedAt',
      type: IsarType.dateTime,
    ),
    r'episodeUid': PropertySchema(
      id: 1,
      name: r'episodeUid',
      type: IsarType.string,
    ),
    r'extraJson': PropertySchema(
      id: 2,
      name: r'extraJson',
      type: IsarType.string,
    ),
    r'orderIndex': PropertySchema(
      id: 3,
      name: r'orderIndex',
      type: IsarType.long,
    ),
    r'queueType': PropertySchema(
      id: 4,
      name: r'queueType',
      type: IsarType.byte,
      enumMap: _QueueItemEntityqueueTypeEnumValueMap,
    )
  },
  estimateSize: _queueItemEntityEstimateSize,
  serialize: _queueItemEntitySerialize,
  deserialize: _queueItemEntityDeserialize,
  deserializeProp: _queueItemEntityDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'queueType_orderIndex': IndexSchema(
      id: -5635760152533328089,
      name: r'queueType_orderIndex',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'queueType',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'orderIndex',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'episodeUid': IndexSchema(
      id: 6605848235218381551,
      name: r'episodeUid',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'episodeUid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _queueItemEntityGetId,
  getLinks: _queueItemEntityGetLinks,
  attach: _queueItemEntityAttach,
  version: '3.1.0+1',
);

int _queueItemEntityEstimateSize(
  QueueItemEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.episodeUid.length * 3;
  {
    final value = object.extraJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _queueItemEntitySerialize(
  QueueItemEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.addedAt);
  writer.writeString(offsets[1], object.episodeUid);
  writer.writeString(offsets[2], object.extraJson);
  writer.writeLong(offsets[3], object.orderIndex);
  writer.writeByte(offsets[4], object.queueType.index);
}

QueueItemEntity _queueItemEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = QueueItemEntity();
  object.addedAt = reader.readDateTime(offsets[0]);
  object.episodeUid = reader.readString(offsets[1]);
  object.extraJson = reader.readStringOrNull(offsets[2]);
  object.isarId = id;
  object.orderIndex = reader.readLong(offsets[3]);
  object.queueType = _QueueItemEntityqueueTypeValueEnumMap[
          reader.readByteOrNull(offsets[4])] ??
      QueueType.nowPlaying;
  return object;
}

P _queueItemEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (_QueueItemEntityqueueTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          QueueType.nowPlaying) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _QueueItemEntityqueueTypeEnumValueMap = {
  'nowPlaying': 0,
  'manual': 1,
  'auto': 2,
};
const _QueueItemEntityqueueTypeValueEnumMap = {
  0: QueueType.nowPlaying,
  1: QueueType.manual,
  2: QueueType.auto,
};

Id _queueItemEntityGetId(QueueItemEntity object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _queueItemEntityGetLinks(QueueItemEntity object) {
  return [];
}

void _queueItemEntityAttach(
    IsarCollection<dynamic> col, Id id, QueueItemEntity object) {
  object.isarId = id;
}

extension QueueItemEntityByIndex on IsarCollection<QueueItemEntity> {
  Future<QueueItemEntity?> getByQueueTypeOrderIndex(
      QueueType queueType, int orderIndex) {
    return getByIndex(r'queueType_orderIndex', [queueType, orderIndex]);
  }

  QueueItemEntity? getByQueueTypeOrderIndexSync(
      QueueType queueType, int orderIndex) {
    return getByIndexSync(r'queueType_orderIndex', [queueType, orderIndex]);
  }

  Future<bool> deleteByQueueTypeOrderIndex(
      QueueType queueType, int orderIndex) {
    return deleteByIndex(r'queueType_orderIndex', [queueType, orderIndex]);
  }

  bool deleteByQueueTypeOrderIndexSync(QueueType queueType, int orderIndex) {
    return deleteByIndexSync(r'queueType_orderIndex', [queueType, orderIndex]);
  }

  Future<List<QueueItemEntity?>> getAllByQueueTypeOrderIndex(
      List<QueueType> queueTypeValues, List<int> orderIndexValues) {
    final len = queueTypeValues.length;
    assert(orderIndexValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([queueTypeValues[i], orderIndexValues[i]]);
    }

    return getAllByIndex(r'queueType_orderIndex', values);
  }

  List<QueueItemEntity?> getAllByQueueTypeOrderIndexSync(
      List<QueueType> queueTypeValues, List<int> orderIndexValues) {
    final len = queueTypeValues.length;
    assert(orderIndexValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([queueTypeValues[i], orderIndexValues[i]]);
    }

    return getAllByIndexSync(r'queueType_orderIndex', values);
  }

  Future<int> deleteAllByQueueTypeOrderIndex(
      List<QueueType> queueTypeValues, List<int> orderIndexValues) {
    final len = queueTypeValues.length;
    assert(orderIndexValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([queueTypeValues[i], orderIndexValues[i]]);
    }

    return deleteAllByIndex(r'queueType_orderIndex', values);
  }

  int deleteAllByQueueTypeOrderIndexSync(
      List<QueueType> queueTypeValues, List<int> orderIndexValues) {
    final len = queueTypeValues.length;
    assert(orderIndexValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([queueTypeValues[i], orderIndexValues[i]]);
    }

    return deleteAllByIndexSync(r'queueType_orderIndex', values);
  }

  Future<Id> putByQueueTypeOrderIndex(QueueItemEntity object) {
    return putByIndex(r'queueType_orderIndex', object);
  }

  Id putByQueueTypeOrderIndexSync(QueueItemEntity object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'queueType_orderIndex', object,
        saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByQueueTypeOrderIndex(List<QueueItemEntity> objects) {
    return putAllByIndex(r'queueType_orderIndex', objects);
  }

  List<Id> putAllByQueueTypeOrderIndexSync(List<QueueItemEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'queueType_orderIndex', objects,
        saveLinks: saveLinks);
  }
}

extension QueueItemEntityQueryWhereSort
    on QueryBuilder<QueueItemEntity, QueueItemEntity, QWhere> {
  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhere>
      anyQueueTypeOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'queueType_orderIndex'),
      );
    });
  }
}

extension QueueItemEntityQueryWhere
    on QueryBuilder<QueueItemEntity, QueueItemEntity, QWhereClause> {
  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      queueTypeEqualToAnyOrderIndex(QueueType queueType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'queueType_orderIndex',
        value: [queueType],
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      queueTypeNotEqualToAnyOrderIndex(QueueType queueType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'queueType_orderIndex',
              lower: [],
              upper: [queueType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'queueType_orderIndex',
              lower: [queueType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'queueType_orderIndex',
              lower: [queueType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'queueType_orderIndex',
              lower: [],
              upper: [queueType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      queueTypeGreaterThanAnyOrderIndex(
    QueueType queueType, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'queueType_orderIndex',
        lower: [queueType],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      queueTypeLessThanAnyOrderIndex(
    QueueType queueType, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'queueType_orderIndex',
        lower: [],
        upper: [queueType],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      queueTypeBetweenAnyOrderIndex(
    QueueType lowerQueueType,
    QueueType upperQueueType, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'queueType_orderIndex',
        lower: [lowerQueueType],
        includeLower: includeLower,
        upper: [upperQueueType],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      queueTypeOrderIndexEqualTo(QueueType queueType, int orderIndex) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'queueType_orderIndex',
        value: [queueType, orderIndex],
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      queueTypeEqualToOrderIndexNotEqualTo(
          QueueType queueType, int orderIndex) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'queueType_orderIndex',
              lower: [queueType],
              upper: [queueType, orderIndex],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'queueType_orderIndex',
              lower: [queueType, orderIndex],
              includeLower: false,
              upper: [queueType],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'queueType_orderIndex',
              lower: [queueType, orderIndex],
              includeLower: false,
              upper: [queueType],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'queueType_orderIndex',
              lower: [queueType],
              upper: [queueType, orderIndex],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      queueTypeEqualToOrderIndexGreaterThan(
    QueueType queueType,
    int orderIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'queueType_orderIndex',
        lower: [queueType, orderIndex],
        includeLower: include,
        upper: [queueType],
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      queueTypeEqualToOrderIndexLessThan(
    QueueType queueType,
    int orderIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'queueType_orderIndex',
        lower: [queueType],
        upper: [queueType, orderIndex],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      queueTypeEqualToOrderIndexBetween(
    QueueType queueType,
    int lowerOrderIndex,
    int upperOrderIndex, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'queueType_orderIndex',
        lower: [queueType, lowerOrderIndex],
        includeLower: includeLower,
        upper: [queueType, upperOrderIndex],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      episodeUidEqualTo(String episodeUid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'episodeUid',
        value: [episodeUid],
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterWhereClause>
      episodeUidNotEqualTo(String episodeUid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'episodeUid',
              lower: [],
              upper: [episodeUid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'episodeUid',
              lower: [episodeUid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'episodeUid',
              lower: [episodeUid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'episodeUid',
              lower: [],
              upper: [episodeUid],
              includeUpper: false,
            ));
      }
    });
  }
}

extension QueueItemEntityQueryFilter
    on QueryBuilder<QueueItemEntity, QueueItemEntity, QFilterCondition> {
  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      addedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      addedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'addedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      addedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'addedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      addedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'addedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      episodeUidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodeUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      episodeUidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'episodeUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      episodeUidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'episodeUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      episodeUidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'episodeUid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      episodeUidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'episodeUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      episodeUidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'episodeUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      episodeUidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'episodeUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      episodeUidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'episodeUid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      episodeUidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodeUid',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      episodeUidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'episodeUid',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      extraJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'extraJson',
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      extraJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'extraJson',
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      extraJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extraJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      extraJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'extraJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      extraJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'extraJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      extraJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'extraJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      extraJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'extraJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      extraJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'extraJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      extraJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'extraJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      extraJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'extraJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      extraJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extraJson',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      extraJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'extraJson',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      orderIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      orderIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      orderIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      orderIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      queueTypeEqualTo(QueueType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'queueType',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      queueTypeGreaterThan(
    QueueType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'queueType',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      queueTypeLessThan(
    QueueType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'queueType',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterFilterCondition>
      queueTypeBetween(
    QueueType lower,
    QueueType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'queueType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension QueueItemEntityQueryObject
    on QueryBuilder<QueueItemEntity, QueueItemEntity, QFilterCondition> {}

extension QueueItemEntityQueryLinks
    on QueryBuilder<QueueItemEntity, QueueItemEntity, QFilterCondition> {}

extension QueueItemEntityQuerySortBy
    on QueryBuilder<QueueItemEntity, QueueItemEntity, QSortBy> {
  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy> sortByAddedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAt', Sort.asc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      sortByAddedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAt', Sort.desc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      sortByEpisodeUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeUid', Sort.asc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      sortByEpisodeUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeUid', Sort.desc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      sortByExtraJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.asc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      sortByExtraJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.desc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      sortByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.asc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      sortByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.desc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      sortByQueueType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queueType', Sort.asc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      sortByQueueTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queueType', Sort.desc);
    });
  }
}

extension QueueItemEntityQuerySortThenBy
    on QueryBuilder<QueueItemEntity, QueueItemEntity, QSortThenBy> {
  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy> thenByAddedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAt', Sort.asc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      thenByAddedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAt', Sort.desc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      thenByEpisodeUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeUid', Sort.asc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      thenByEpisodeUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeUid', Sort.desc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      thenByExtraJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.asc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      thenByExtraJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.desc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      thenByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.asc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      thenByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.desc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      thenByQueueType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queueType', Sort.asc);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QAfterSortBy>
      thenByQueueTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queueType', Sort.desc);
    });
  }
}

extension QueueItemEntityQueryWhereDistinct
    on QueryBuilder<QueueItemEntity, QueueItemEntity, QDistinct> {
  QueryBuilder<QueueItemEntity, QueueItemEntity, QDistinct>
      distinctByAddedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'addedAt');
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QDistinct>
      distinctByEpisodeUid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episodeUid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QDistinct> distinctByExtraJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'extraJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QDistinct>
      distinctByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderIndex');
    });
  }

  QueryBuilder<QueueItemEntity, QueueItemEntity, QDistinct>
      distinctByQueueType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'queueType');
    });
  }
}

extension QueueItemEntityQueryProperty
    on QueryBuilder<QueueItemEntity, QueueItemEntity, QQueryProperty> {
  QueryBuilder<QueueItemEntity, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<QueueItemEntity, DateTime, QQueryOperations> addedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'addedAt');
    });
  }

  QueryBuilder<QueueItemEntity, String, QQueryOperations> episodeUidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodeUid');
    });
  }

  QueryBuilder<QueueItemEntity, String?, QQueryOperations> extraJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extraJson');
    });
  }

  QueryBuilder<QueueItemEntity, int, QQueryOperations> orderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderIndex');
    });
  }

  QueryBuilder<QueueItemEntity, QueueType, QQueryOperations>
      queueTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'queueType');
    });
  }
}
