// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_ref_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetExternalRefEntityCollection on Isar {
  IsarCollection<ExternalRefEntity> get externalRefEntitys => this.collection();
}

const ExternalRefEntitySchema = CollectionSchema(
  name: r'ExternalRefEntity',
  id: -8181448470308185775,
  properties: {
    r'externalId': PropertySchema(
      id: 0,
      name: r'externalId',
      type: IsarType.string,
    ),
    r'externalUrl': PropertySchema(
      id: 1,
      name: r'externalUrl',
      type: IsarType.string,
    ),
    r'extraJson': PropertySchema(
      id: 2,
      name: r'extraJson',
      type: IsarType.string,
    ),
    r'fetchedAt': PropertySchema(
      id: 3,
      name: r'fetchedAt',
      type: IsarType.dateTime,
    ),
    r'ownerType': PropertySchema(
      id: 4,
      name: r'ownerType',
      type: IsarType.byte,
      enumMap: _ExternalRefEntityownerTypeEnumValueMap,
    ),
    r'ownerUid': PropertySchema(
      id: 5,
      name: r'ownerUid',
      type: IsarType.string,
    ),
    r'priority': PropertySchema(
      id: 6,
      name: r'priority',
      type: IsarType.long,
    ),
    r'source': PropertySchema(
      id: 7,
      name: r'source',
      type: IsarType.byte,
      enumMap: _ExternalRefEntitysourceEnumValueMap,
    )
  },
  estimateSize: _externalRefEntityEstimateSize,
  serialize: _externalRefEntitySerialize,
  deserialize: _externalRefEntityDeserialize,
  deserializeProp: _externalRefEntityDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'ownerType_ownerUid': IndexSchema(
      id: 5296729294329083913,
      name: r'ownerType_ownerUid',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'ownerType',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'ownerUid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'source_externalId': IndexSchema(
      id: 7290424687692283137,
      name: r'source_externalId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'source',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'externalId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'fetchedAt': IndexSchema(
      id: -689920985439132966,
      name: r'fetchedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'fetchedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _externalRefEntityGetId,
  getLinks: _externalRefEntityGetLinks,
  attach: _externalRefEntityAttach,
  version: '3.1.0+1',
);

int _externalRefEntityEstimateSize(
  ExternalRefEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.externalId.length * 3;
  {
    final value = object.externalUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.extraJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.ownerUid.length * 3;
  return bytesCount;
}

void _externalRefEntitySerialize(
  ExternalRefEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.externalId);
  writer.writeString(offsets[1], object.externalUrl);
  writer.writeString(offsets[2], object.extraJson);
  writer.writeDateTime(offsets[3], object.fetchedAt);
  writer.writeByte(offsets[4], object.ownerType.index);
  writer.writeString(offsets[5], object.ownerUid);
  writer.writeLong(offsets[6], object.priority);
  writer.writeByte(offsets[7], object.source.index);
}

ExternalRefEntity _externalRefEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExternalRefEntity();
  object.externalId = reader.readString(offsets[0]);
  object.externalUrl = reader.readStringOrNull(offsets[1]);
  object.extraJson = reader.readStringOrNull(offsets[2]);
  object.fetchedAt = reader.readDateTime(offsets[3]);
  object.isarId = id;
  object.ownerType = _ExternalRefEntityownerTypeValueEnumMap[
          reader.readByteOrNull(offsets[4])] ??
      ExternalOwnerType.podcast;
  object.ownerUid = reader.readString(offsets[5]);
  object.priority = reader.readLong(offsets[6]);
  object.source =
      _ExternalRefEntitysourceValueEnumMap[reader.readByteOrNull(offsets[7])] ??
          SourceType.rss;
  return object;
}

P _externalRefEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (_ExternalRefEntityownerTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ExternalOwnerType.podcast) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (_ExternalRefEntitysourceValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SourceType.rss) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ExternalRefEntityownerTypeEnumValueMap = {
  'podcast': 0,
  'episode': 1,
  'media': 2,
};
const _ExternalRefEntityownerTypeValueEnumMap = {
  0: ExternalOwnerType.podcast,
  1: ExternalOwnerType.episode,
  2: ExternalOwnerType.media,
};
const _ExternalRefEntitysourceEnumValueMap = {
  'rss': 0,
  'bilibili': 1,
  'youtube': 2,
  'webHtml': 3,
  'freshRss': 4,
  'itunes': 5,
  'xyzrank': 6,
  'manual': 7,
  'cache': 8,
};
const _ExternalRefEntitysourceValueEnumMap = {
  0: SourceType.rss,
  1: SourceType.bilibili,
  2: SourceType.youtube,
  3: SourceType.webHtml,
  4: SourceType.freshRss,
  5: SourceType.itunes,
  6: SourceType.xyzrank,
  7: SourceType.manual,
  8: SourceType.cache,
};

Id _externalRefEntityGetId(ExternalRefEntity object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _externalRefEntityGetLinks(
    ExternalRefEntity object) {
  return [];
}

void _externalRefEntityAttach(
    IsarCollection<dynamic> col, Id id, ExternalRefEntity object) {
  object.isarId = id;
}

extension ExternalRefEntityByIndex on IsarCollection<ExternalRefEntity> {
  Future<ExternalRefEntity?> getBySourceExternalId(
      SourceType source, String externalId) {
    return getByIndex(r'source_externalId', [source, externalId]);
  }

  ExternalRefEntity? getBySourceExternalIdSync(
      SourceType source, String externalId) {
    return getByIndexSync(r'source_externalId', [source, externalId]);
  }

  Future<bool> deleteBySourceExternalId(SourceType source, String externalId) {
    return deleteByIndex(r'source_externalId', [source, externalId]);
  }

  bool deleteBySourceExternalIdSync(SourceType source, String externalId) {
    return deleteByIndexSync(r'source_externalId', [source, externalId]);
  }

  Future<List<ExternalRefEntity?>> getAllBySourceExternalId(
      List<SourceType> sourceValues, List<String> externalIdValues) {
    final len = sourceValues.length;
    assert(externalIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([sourceValues[i], externalIdValues[i]]);
    }

    return getAllByIndex(r'source_externalId', values);
  }

  List<ExternalRefEntity?> getAllBySourceExternalIdSync(
      List<SourceType> sourceValues, List<String> externalIdValues) {
    final len = sourceValues.length;
    assert(externalIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([sourceValues[i], externalIdValues[i]]);
    }

    return getAllByIndexSync(r'source_externalId', values);
  }

  Future<int> deleteAllBySourceExternalId(
      List<SourceType> sourceValues, List<String> externalIdValues) {
    final len = sourceValues.length;
    assert(externalIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([sourceValues[i], externalIdValues[i]]);
    }

    return deleteAllByIndex(r'source_externalId', values);
  }

  int deleteAllBySourceExternalIdSync(
      List<SourceType> sourceValues, List<String> externalIdValues) {
    final len = sourceValues.length;
    assert(externalIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([sourceValues[i], externalIdValues[i]]);
    }

    return deleteAllByIndexSync(r'source_externalId', values);
  }

  Future<Id> putBySourceExternalId(ExternalRefEntity object) {
    return putByIndex(r'source_externalId', object);
  }

  Id putBySourceExternalIdSync(ExternalRefEntity object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'source_externalId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySourceExternalId(List<ExternalRefEntity> objects) {
    return putAllByIndex(r'source_externalId', objects);
  }

  List<Id> putAllBySourceExternalIdSync(List<ExternalRefEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'source_externalId', objects,
        saveLinks: saveLinks);
  }
}

extension ExternalRefEntityQueryWhereSort
    on QueryBuilder<ExternalRefEntity, ExternalRefEntity, QWhere> {
  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhere>
      anyFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'fetchedAt'),
      );
    });
  }
}

extension ExternalRefEntityQueryWhere
    on QueryBuilder<ExternalRefEntity, ExternalRefEntity, QWhereClause> {
  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
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

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
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

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      ownerTypeEqualToAnyOwnerUid(ExternalOwnerType ownerType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ownerType_ownerUid',
        value: [ownerType],
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      ownerTypeNotEqualToAnyOwnerUid(ExternalOwnerType ownerType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ownerType_ownerUid',
              lower: [],
              upper: [ownerType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ownerType_ownerUid',
              lower: [ownerType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ownerType_ownerUid',
              lower: [ownerType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ownerType_ownerUid',
              lower: [],
              upper: [ownerType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      ownerTypeGreaterThanAnyOwnerUid(
    ExternalOwnerType ownerType, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ownerType_ownerUid',
        lower: [ownerType],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      ownerTypeLessThanAnyOwnerUid(
    ExternalOwnerType ownerType, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ownerType_ownerUid',
        lower: [],
        upper: [ownerType],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      ownerTypeBetweenAnyOwnerUid(
    ExternalOwnerType lowerOwnerType,
    ExternalOwnerType upperOwnerType, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ownerType_ownerUid',
        lower: [lowerOwnerType],
        includeLower: includeLower,
        upper: [upperOwnerType],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      ownerTypeOwnerUidEqualTo(ExternalOwnerType ownerType, String ownerUid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ownerType_ownerUid',
        value: [ownerType, ownerUid],
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      ownerTypeEqualToOwnerUidNotEqualTo(
          ExternalOwnerType ownerType, String ownerUid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ownerType_ownerUid',
              lower: [ownerType],
              upper: [ownerType, ownerUid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ownerType_ownerUid',
              lower: [ownerType, ownerUid],
              includeLower: false,
              upper: [ownerType],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ownerType_ownerUid',
              lower: [ownerType, ownerUid],
              includeLower: false,
              upper: [ownerType],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ownerType_ownerUid',
              lower: [ownerType],
              upper: [ownerType, ownerUid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      sourceEqualToAnyExternalId(SourceType source) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'source_externalId',
        value: [source],
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      sourceNotEqualToAnyExternalId(SourceType source) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source_externalId',
              lower: [],
              upper: [source],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source_externalId',
              lower: [source],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source_externalId',
              lower: [source],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source_externalId',
              lower: [],
              upper: [source],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      sourceGreaterThanAnyExternalId(
    SourceType source, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'source_externalId',
        lower: [source],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      sourceLessThanAnyExternalId(
    SourceType source, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'source_externalId',
        lower: [],
        upper: [source],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      sourceBetweenAnyExternalId(
    SourceType lowerSource,
    SourceType upperSource, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'source_externalId',
        lower: [lowerSource],
        includeLower: includeLower,
        upper: [upperSource],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      sourceExternalIdEqualTo(SourceType source, String externalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'source_externalId',
        value: [source, externalId],
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      sourceEqualToExternalIdNotEqualTo(SourceType source, String externalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source_externalId',
              lower: [source],
              upper: [source, externalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source_externalId',
              lower: [source, externalId],
              includeLower: false,
              upper: [source],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source_externalId',
              lower: [source, externalId],
              includeLower: false,
              upper: [source],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source_externalId',
              lower: [source],
              upper: [source, externalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      fetchedAtEqualTo(DateTime fetchedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'fetchedAt',
        value: [fetchedAt],
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      fetchedAtNotEqualTo(DateTime fetchedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fetchedAt',
              lower: [],
              upper: [fetchedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fetchedAt',
              lower: [fetchedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fetchedAt',
              lower: [fetchedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fetchedAt',
              lower: [],
              upper: [fetchedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      fetchedAtGreaterThan(
    DateTime fetchedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'fetchedAt',
        lower: [fetchedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      fetchedAtLessThan(
    DateTime fetchedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'fetchedAt',
        lower: [],
        upper: [fetchedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterWhereClause>
      fetchedAtBetween(
    DateTime lowerFetchedAt,
    DateTime upperFetchedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'fetchedAt',
        lower: [lowerFetchedAt],
        includeLower: includeLower,
        upper: [upperFetchedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ExternalRefEntityQueryFilter
    on QueryBuilder<ExternalRefEntity, ExternalRefEntity, QFilterCondition> {
  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'externalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'externalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'externalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'externalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'externalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'externalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'externalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'externalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'externalUrl',
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'externalUrl',
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'externalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'externalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'externalUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'externalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'externalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'externalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'externalUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      externalUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'externalUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      extraJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'extraJson',
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      extraJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'extraJson',
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
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

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
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

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
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

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
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

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
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

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
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

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      extraJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'extraJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      extraJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'extraJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      extraJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extraJson',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      extraJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'extraJson',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      fetchedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      fetchedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      fetchedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      fetchedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fetchedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
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

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
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

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
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

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      ownerTypeEqualTo(ExternalOwnerType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerType',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      ownerTypeGreaterThan(
    ExternalOwnerType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerType',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      ownerTypeLessThan(
    ExternalOwnerType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerType',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      ownerTypeBetween(
    ExternalOwnerType lower,
    ExternalOwnerType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      ownerUidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      ownerUidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      ownerUidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      ownerUidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerUid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      ownerUidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ownerUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      ownerUidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ownerUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      ownerUidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ownerUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      ownerUidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ownerUid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      ownerUidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerUid',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      ownerUidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ownerUid',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      priorityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      priorityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      priorityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      priorityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      sourceEqualTo(SourceType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      sourceGreaterThan(
    SourceType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      sourceLessThan(
    SourceType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterFilterCondition>
      sourceBetween(
    SourceType lower,
    SourceType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ExternalRefEntityQueryObject
    on QueryBuilder<ExternalRefEntity, ExternalRefEntity, QFilterCondition> {}

extension ExternalRefEntityQueryLinks
    on QueryBuilder<ExternalRefEntity, ExternalRefEntity, QFilterCondition> {}

extension ExternalRefEntityQuerySortBy
    on QueryBuilder<ExternalRefEntity, ExternalRefEntity, QSortBy> {
  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      sortByExternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalId', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      sortByExternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalId', Sort.desc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      sortByExternalUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalUrl', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      sortByExternalUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalUrl', Sort.desc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      sortByExtraJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      sortByExtraJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.desc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      sortByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      sortByFetchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.desc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      sortByOwnerType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerType', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      sortByOwnerTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerType', Sort.desc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      sortByOwnerUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUid', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      sortByOwnerUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUid', Sort.desc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }
}

extension ExternalRefEntityQuerySortThenBy
    on QueryBuilder<ExternalRefEntity, ExternalRefEntity, QSortThenBy> {
  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenByExternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalId', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenByExternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalId', Sort.desc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenByExternalUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalUrl', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenByExternalUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalUrl', Sort.desc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenByExtraJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenByExtraJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.desc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenByFetchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.desc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenByOwnerType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerType', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenByOwnerTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerType', Sort.desc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenByOwnerUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUid', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenByOwnerUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUid', Sort.desc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QAfterSortBy>
      thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }
}

extension ExternalRefEntityQueryWhereDistinct
    on QueryBuilder<ExternalRefEntity, ExternalRefEntity, QDistinct> {
  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QDistinct>
      distinctByExternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'externalId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QDistinct>
      distinctByExternalUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'externalUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QDistinct>
      distinctByExtraJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'extraJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QDistinct>
      distinctByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fetchedAt');
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QDistinct>
      distinctByOwnerType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerType');
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QDistinct>
      distinctByOwnerUid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerUid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QDistinct>
      distinctByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority');
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalRefEntity, QDistinct>
      distinctBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source');
    });
  }
}

extension ExternalRefEntityQueryProperty
    on QueryBuilder<ExternalRefEntity, ExternalRefEntity, QQueryProperty> {
  QueryBuilder<ExternalRefEntity, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<ExternalRefEntity, String, QQueryOperations>
      externalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'externalId');
    });
  }

  QueryBuilder<ExternalRefEntity, String?, QQueryOperations>
      externalUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'externalUrl');
    });
  }

  QueryBuilder<ExternalRefEntity, String?, QQueryOperations>
      extraJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extraJson');
    });
  }

  QueryBuilder<ExternalRefEntity, DateTime, QQueryOperations>
      fetchedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fetchedAt');
    });
  }

  QueryBuilder<ExternalRefEntity, ExternalOwnerType, QQueryOperations>
      ownerTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerType');
    });
  }

  QueryBuilder<ExternalRefEntity, String, QQueryOperations> ownerUidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerUid');
    });
  }

  QueryBuilder<ExternalRefEntity, int, QQueryOperations> priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }

  QueryBuilder<ExternalRefEntity, SourceType, QQueryOperations>
      sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }
}
