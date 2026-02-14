// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPodcastEntityCollection on Isar {
  IsarCollection<PodcastEntity> get podcastEntitys => this.collection();
}

const PodcastEntitySchema = CollectionSchema(
  name: r'PodcastEntity',
  id: -3952567724682028863,
  properties: {
    r'author': PropertySchema(
      id: 0,
      name: r'author',
      type: IsarType.string,
    ),
    r'autoDownload': PropertySchema(
      id: 1,
      name: r'autoDownload',
      type: IsarType.bool,
    ),
    r'canonicalUrl': PropertySchema(
      id: 2,
      name: r'canonicalUrl',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 3,
      name: r'description',
      type: IsarType.string,
    ),
    r'etag': PropertySchema(
      id: 4,
      name: r'etag',
      type: IsarType.string,
    ),
    r'extraJson': PropertySchema(
      id: 5,
      name: r'extraJson',
      type: IsarType.string,
    ),
    r'groupName': PropertySchema(
      id: 6,
      name: r'groupName',
      type: IsarType.string,
    ),
    r'imageUrl': PropertySchema(
      id: 7,
      name: r'imageUrl',
      type: IsarType.string,
    ),
    r'isSubscribed': PropertySchema(
      id: 8,
      name: r'isSubscribed',
      type: IsarType.bool,
    ),
    r'lastFetchedAt': PropertySchema(
      id: 9,
      name: r'lastFetchedAt',
      type: IsarType.dateTime,
    ),
    r'lastModified': PropertySchema(
      id: 10,
      name: r'lastModified',
      type: IsarType.string,
    ),
    r'originalUrl': PropertySchema(
      id: 11,
      name: r'originalUrl',
      type: IsarType.string,
    ),
    r'sortOrder': PropertySchema(
      id: 12,
      name: r'sortOrder',
      type: IsarType.long,
    ),
    r'sourceType': PropertySchema(
      id: 13,
      name: r'sourceType',
      type: IsarType.byte,
      enumMap: _PodcastEntitysourceTypeEnumValueMap,
    ),
    r'title': PropertySchema(
      id: 14,
      name: r'title',
      type: IsarType.string,
    ),
    r'uid': PropertySchema(
      id: 15,
      name: r'uid',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 16,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _podcastEntityEstimateSize,
  serialize: _podcastEntitySerialize,
  deserialize: _podcastEntityDeserialize,
  deserializeProp: _podcastEntityDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'uid': IndexSchema(
      id: 8193695471701937315,
      name: r'uid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'canonicalUrl': IndexSchema(
      id: 1898383433214980253,
      name: r'canonicalUrl',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'canonicalUrl',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'isSubscribed_updatedAt': IndexSchema(
      id: -8275590563741995323,
      name: r'isSubscribed_updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isSubscribed',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'groupName_sortOrder': IndexSchema(
      id: -1032945877170896690,
      name: r'groupName_sortOrder',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'groupName',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'sortOrder',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _podcastEntityGetId,
  getLinks: _podcastEntityGetLinks,
  attach: _podcastEntityAttach,
  version: '3.1.0+1',
);

int _podcastEntityEstimateSize(
  PodcastEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.author;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.canonicalUrl.length * 3;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.etag;
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
  {
    final value = object.groupName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.imageUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastModified;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.originalUrl.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.uid.length * 3;
  return bytesCount;
}

void _podcastEntitySerialize(
  PodcastEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.author);
  writer.writeBool(offsets[1], object.autoDownload);
  writer.writeString(offsets[2], object.canonicalUrl);
  writer.writeString(offsets[3], object.description);
  writer.writeString(offsets[4], object.etag);
  writer.writeString(offsets[5], object.extraJson);
  writer.writeString(offsets[6], object.groupName);
  writer.writeString(offsets[7], object.imageUrl);
  writer.writeBool(offsets[8], object.isSubscribed);
  writer.writeDateTime(offsets[9], object.lastFetchedAt);
  writer.writeString(offsets[10], object.lastModified);
  writer.writeString(offsets[11], object.originalUrl);
  writer.writeLong(offsets[12], object.sortOrder);
  writer.writeByte(offsets[13], object.sourceType.index);
  writer.writeString(offsets[14], object.title);
  writer.writeString(offsets[15], object.uid);
  writer.writeDateTime(offsets[16], object.updatedAt);
}

PodcastEntity _podcastEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PodcastEntity();
  object.author = reader.readStringOrNull(offsets[0]);
  object.autoDownload = reader.readBool(offsets[1]);
  object.canonicalUrl = reader.readString(offsets[2]);
  object.description = reader.readStringOrNull(offsets[3]);
  object.etag = reader.readStringOrNull(offsets[4]);
  object.extraJson = reader.readStringOrNull(offsets[5]);
  object.groupName = reader.readStringOrNull(offsets[6]);
  object.imageUrl = reader.readStringOrNull(offsets[7]);
  object.isSubscribed = reader.readBool(offsets[8]);
  object.isarId = id;
  object.lastFetchedAt = reader.readDateTimeOrNull(offsets[9]);
  object.lastModified = reader.readStringOrNull(offsets[10]);
  object.originalUrl = reader.readString(offsets[11]);
  object.sortOrder = reader.readLongOrNull(offsets[12]);
  object.sourceType = _PodcastEntitysourceTypeValueEnumMap[
          reader.readByteOrNull(offsets[13])] ??
      SourceType.rss;
  object.title = reader.readString(offsets[14]);
  object.uid = reader.readString(offsets[15]);
  object.updatedAt = reader.readDateTime(offsets[16]);
  return object;
}

P _podcastEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (_PodcastEntitysourceTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SourceType.rss) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PodcastEntitysourceTypeEnumValueMap = {
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
const _PodcastEntitysourceTypeValueEnumMap = {
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

Id _podcastEntityGetId(PodcastEntity object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _podcastEntityGetLinks(PodcastEntity object) {
  return [];
}

void _podcastEntityAttach(
    IsarCollection<dynamic> col, Id id, PodcastEntity object) {
  object.isarId = id;
}

extension PodcastEntityByIndex on IsarCollection<PodcastEntity> {
  Future<PodcastEntity?> getByUid(String uid) {
    return getByIndex(r'uid', [uid]);
  }

  PodcastEntity? getByUidSync(String uid) {
    return getByIndexSync(r'uid', [uid]);
  }

  Future<bool> deleteByUid(String uid) {
    return deleteByIndex(r'uid', [uid]);
  }

  bool deleteByUidSync(String uid) {
    return deleteByIndexSync(r'uid', [uid]);
  }

  Future<List<PodcastEntity?>> getAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uid', values);
  }

  List<PodcastEntity?> getAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uid', values);
  }

  Future<int> deleteAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uid', values);
  }

  int deleteAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uid', values);
  }

  Future<Id> putByUid(PodcastEntity object) {
    return putByIndex(r'uid', object);
  }

  Id putByUidSync(PodcastEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'uid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUid(List<PodcastEntity> objects) {
    return putAllByIndex(r'uid', objects);
  }

  List<Id> putAllByUidSync(List<PodcastEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uid', objects, saveLinks: saveLinks);
  }

  Future<PodcastEntity?> getByCanonicalUrl(String canonicalUrl) {
    return getByIndex(r'canonicalUrl', [canonicalUrl]);
  }

  PodcastEntity? getByCanonicalUrlSync(String canonicalUrl) {
    return getByIndexSync(r'canonicalUrl', [canonicalUrl]);
  }

  Future<bool> deleteByCanonicalUrl(String canonicalUrl) {
    return deleteByIndex(r'canonicalUrl', [canonicalUrl]);
  }

  bool deleteByCanonicalUrlSync(String canonicalUrl) {
    return deleteByIndexSync(r'canonicalUrl', [canonicalUrl]);
  }

  Future<List<PodcastEntity?>> getAllByCanonicalUrl(
      List<String> canonicalUrlValues) {
    final values = canonicalUrlValues.map((e) => [e]).toList();
    return getAllByIndex(r'canonicalUrl', values);
  }

  List<PodcastEntity?> getAllByCanonicalUrlSync(
      List<String> canonicalUrlValues) {
    final values = canonicalUrlValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'canonicalUrl', values);
  }

  Future<int> deleteAllByCanonicalUrl(List<String> canonicalUrlValues) {
    final values = canonicalUrlValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'canonicalUrl', values);
  }

  int deleteAllByCanonicalUrlSync(List<String> canonicalUrlValues) {
    final values = canonicalUrlValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'canonicalUrl', values);
  }

  Future<Id> putByCanonicalUrl(PodcastEntity object) {
    return putByIndex(r'canonicalUrl', object);
  }

  Id putByCanonicalUrlSync(PodcastEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'canonicalUrl', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCanonicalUrl(List<PodcastEntity> objects) {
    return putAllByIndex(r'canonicalUrl', objects);
  }

  List<Id> putAllByCanonicalUrlSync(List<PodcastEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'canonicalUrl', objects, saveLinks: saveLinks);
  }
}

extension PodcastEntityQueryWhereSort
    on QueryBuilder<PodcastEntity, PodcastEntity, QWhere> {
  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhere>
      anyIsSubscribedUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isSubscribed_updatedAt'),
      );
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension PodcastEntityQueryWhere
    on QueryBuilder<PodcastEntity, PodcastEntity, QWhereClause> {
  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
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

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause> uidEqualTo(
      String uid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uid',
        value: [uid],
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause> uidNotEqualTo(
      String uid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [],
              upper: [uid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [uid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [uid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [],
              upper: [uid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      canonicalUrlEqualTo(String canonicalUrl) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'canonicalUrl',
        value: [canonicalUrl],
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      canonicalUrlNotEqualTo(String canonicalUrl) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'canonicalUrl',
              lower: [],
              upper: [canonicalUrl],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'canonicalUrl',
              lower: [canonicalUrl],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'canonicalUrl',
              lower: [canonicalUrl],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'canonicalUrl',
              lower: [],
              upper: [canonicalUrl],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      isSubscribedEqualToAnyUpdatedAt(bool isSubscribed) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isSubscribed_updatedAt',
        value: [isSubscribed],
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      isSubscribedNotEqualToAnyUpdatedAt(bool isSubscribed) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSubscribed_updatedAt',
              lower: [],
              upper: [isSubscribed],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSubscribed_updatedAt',
              lower: [isSubscribed],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSubscribed_updatedAt',
              lower: [isSubscribed],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSubscribed_updatedAt',
              lower: [],
              upper: [isSubscribed],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      isSubscribedUpdatedAtEqualTo(bool isSubscribed, DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isSubscribed_updatedAt',
        value: [isSubscribed, updatedAt],
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      isSubscribedEqualToUpdatedAtNotEqualTo(
          bool isSubscribed, DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSubscribed_updatedAt',
              lower: [isSubscribed],
              upper: [isSubscribed, updatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSubscribed_updatedAt',
              lower: [isSubscribed, updatedAt],
              includeLower: false,
              upper: [isSubscribed],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSubscribed_updatedAt',
              lower: [isSubscribed, updatedAt],
              includeLower: false,
              upper: [isSubscribed],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSubscribed_updatedAt',
              lower: [isSubscribed],
              upper: [isSubscribed, updatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      isSubscribedEqualToUpdatedAtGreaterThan(
    bool isSubscribed,
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'isSubscribed_updatedAt',
        lower: [isSubscribed, updatedAt],
        includeLower: include,
        upper: [isSubscribed],
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      isSubscribedEqualToUpdatedAtLessThan(
    bool isSubscribed,
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'isSubscribed_updatedAt',
        lower: [isSubscribed],
        upper: [isSubscribed, updatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      isSubscribedEqualToUpdatedAtBetween(
    bool isSubscribed,
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'isSubscribed_updatedAt',
        lower: [isSubscribed, lowerUpdatedAt],
        includeLower: includeLower,
        upper: [isSubscribed, upperUpdatedAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      groupNameIsNullAnySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'groupName_sortOrder',
        value: [null],
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      groupNameIsNotNullAnySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'groupName_sortOrder',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      groupNameEqualToAnySortOrder(String? groupName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'groupName_sortOrder',
        value: [groupName],
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      groupNameNotEqualToAnySortOrder(String? groupName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupName_sortOrder',
              lower: [],
              upper: [groupName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupName_sortOrder',
              lower: [groupName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupName_sortOrder',
              lower: [groupName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupName_sortOrder',
              lower: [],
              upper: [groupName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      groupNameEqualToSortOrderIsNull(String? groupName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'groupName_sortOrder',
        value: [groupName, null],
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      groupNameEqualToSortOrderIsNotNull(String? groupName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'groupName_sortOrder',
        lower: [groupName, null],
        includeLower: false,
        upper: [
          groupName,
        ],
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      groupNameSortOrderEqualTo(String? groupName, int? sortOrder) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'groupName_sortOrder',
        value: [groupName, sortOrder],
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      groupNameEqualToSortOrderNotEqualTo(String? groupName, int? sortOrder) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupName_sortOrder',
              lower: [groupName],
              upper: [groupName, sortOrder],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupName_sortOrder',
              lower: [groupName, sortOrder],
              includeLower: false,
              upper: [groupName],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupName_sortOrder',
              lower: [groupName, sortOrder],
              includeLower: false,
              upper: [groupName],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupName_sortOrder',
              lower: [groupName],
              upper: [groupName, sortOrder],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      groupNameEqualToSortOrderGreaterThan(
    String? groupName,
    int? sortOrder, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'groupName_sortOrder',
        lower: [groupName, sortOrder],
        includeLower: include,
        upper: [groupName],
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      groupNameEqualToSortOrderLessThan(
    String? groupName,
    int? sortOrder, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'groupName_sortOrder',
        lower: [groupName],
        upper: [groupName, sortOrder],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      groupNameEqualToSortOrderBetween(
    String? groupName,
    int? lowerSortOrder,
    int? upperSortOrder, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'groupName_sortOrder',
        lower: [groupName, lowerSortOrder],
        includeLower: includeLower,
        upper: [groupName, upperSortOrder],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      updatedAtNotEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      updatedAtGreaterThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [updatedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      updatedAtLessThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [],
        upper: [updatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterWhereClause>
      updatedAtBetween(
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [lowerUpdatedAt],
        includeLower: includeLower,
        upper: [upperUpdatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PodcastEntityQueryFilter
    on QueryBuilder<PodcastEntity, PodcastEntity, QFilterCondition> {
  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      authorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'author',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      authorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'author',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      authorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      authorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      authorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      authorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'author',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      authorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      authorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      authorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      authorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'author',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      authorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      authorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      autoDownloadEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoDownload',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      canonicalUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canonicalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      canonicalUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'canonicalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      canonicalUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'canonicalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      canonicalUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'canonicalUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      canonicalUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'canonicalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      canonicalUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'canonicalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      canonicalUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'canonicalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      canonicalUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'canonicalUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      canonicalUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canonicalUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      canonicalUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'canonicalUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      etagIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'etag',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      etagIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'etag',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition> etagEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      etagGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'etag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      etagLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'etag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition> etagBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'etag',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      etagStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'etag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      etagEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'etag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      etagContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'etag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition> etagMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'etag',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      etagIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etag',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      etagIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'etag',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      extraJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'extraJson',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      extraJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'extraJson',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
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

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
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

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
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

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
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

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
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

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
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

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      extraJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'extraJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      extraJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'extraJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      extraJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extraJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      extraJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'extraJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      groupNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'groupName',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      groupNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'groupName',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      groupNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      groupNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      groupNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      groupNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      groupNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      groupNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      groupNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      groupNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      groupNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupName',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      groupNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupName',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      imageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imageUrl',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      imageUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imageUrl',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      imageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      imageUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      imageUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      imageUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      imageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      imageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      imageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      imageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      imageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      imageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      isSubscribedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSubscribed',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
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

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
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

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
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

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastFetchedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastFetchedAt',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastFetchedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastFetchedAt',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastFetchedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastFetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastFetchedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastFetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastFetchedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastFetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastFetchedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastFetchedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastModifiedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastModified',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastModifiedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastModified',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastModifiedEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastModified',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastModifiedGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastModified',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastModifiedLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastModified',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastModifiedBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastModified',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastModifiedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastModified',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastModifiedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastModified',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastModifiedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastModified',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastModifiedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastModified',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastModifiedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastModified',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      lastModifiedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastModified',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      originalUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      originalUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      originalUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      originalUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      originalUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      originalUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      originalUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      originalUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      originalUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      originalUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      sortOrderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sortOrder',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      sortOrderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sortOrder',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      sortOrderEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      sortOrderGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      sortOrderLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      sortOrderBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sortOrder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      sourceTypeEqualTo(SourceType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceType',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      sourceTypeGreaterThan(
    SourceType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceType',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      sourceTypeLessThan(
    SourceType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceType',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      sourceTypeBetween(
    SourceType lower,
    SourceType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition> uidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      uidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition> uidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition> uidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      uidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition> uidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition> uidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition> uidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
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

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
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

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterFilterCondition>
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
}

extension PodcastEntityQueryObject
    on QueryBuilder<PodcastEntity, PodcastEntity, QFilterCondition> {}

extension PodcastEntityQueryLinks
    on QueryBuilder<PodcastEntity, PodcastEntity, QFilterCondition> {}

extension PodcastEntityQuerySortBy
    on QueryBuilder<PodcastEntity, PodcastEntity, QSortBy> {
  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> sortByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> sortByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortByAutoDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoDownload', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortByAutoDownloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoDownload', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortByCanonicalUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canonicalUrl', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortByCanonicalUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canonicalUrl', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> sortByEtag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etag', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> sortByEtagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etag', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> sortByExtraJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortByExtraJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> sortByGroupName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupName', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortByGroupNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupName', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> sortByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortByIsSubscribed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSubscribed', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortByIsSubscribedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSubscribed', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortByLastFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetchedAt', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortByLastFetchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetchedAt', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortByLastModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortByLastModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> sortByOriginalUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalUrl', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortByOriginalUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalUrl', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> sortBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> sortBySourceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceType', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortBySourceTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceType', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PodcastEntityQuerySortThenBy
    on QueryBuilder<PodcastEntity, PodcastEntity, QSortThenBy> {
  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenByAutoDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoDownload', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenByAutoDownloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoDownload', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenByCanonicalUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canonicalUrl', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenByCanonicalUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canonicalUrl', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenByEtag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etag', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenByEtagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etag', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenByExtraJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenByExtraJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenByGroupName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupName', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenByGroupNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupName', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenByIsSubscribed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSubscribed', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenByIsSubscribedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSubscribed', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenByLastFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetchedAt', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenByLastFetchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetchedAt', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenByLastModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenByLastModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenByOriginalUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalUrl', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenByOriginalUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalUrl', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenBySourceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceType', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenBySourceTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceType', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PodcastEntityQueryWhereDistinct
    on QueryBuilder<PodcastEntity, PodcastEntity, QDistinct> {
  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct> distinctByAuthor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'author', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct>
      distinctByAutoDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoDownload');
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct> distinctByCanonicalUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'canonicalUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct> distinctByEtag(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'etag', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct> distinctByExtraJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'extraJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct> distinctByGroupName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct> distinctByImageUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct>
      distinctByIsSubscribed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSubscribed');
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct>
      distinctByLastFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastFetchedAt');
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct> distinctByLastModified(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastModified', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct> distinctByOriginalUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct> distinctBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sortOrder');
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct> distinctBySourceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceType');
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct> distinctByUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PodcastEntity, PodcastEntity, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension PodcastEntityQueryProperty
    on QueryBuilder<PodcastEntity, PodcastEntity, QQueryProperty> {
  QueryBuilder<PodcastEntity, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<PodcastEntity, String?, QQueryOperations> authorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'author');
    });
  }

  QueryBuilder<PodcastEntity, bool, QQueryOperations> autoDownloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoDownload');
    });
  }

  QueryBuilder<PodcastEntity, String, QQueryOperations> canonicalUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'canonicalUrl');
    });
  }

  QueryBuilder<PodcastEntity, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<PodcastEntity, String?, QQueryOperations> etagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'etag');
    });
  }

  QueryBuilder<PodcastEntity, String?, QQueryOperations> extraJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extraJson');
    });
  }

  QueryBuilder<PodcastEntity, String?, QQueryOperations> groupNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupName');
    });
  }

  QueryBuilder<PodcastEntity, String?, QQueryOperations> imageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageUrl');
    });
  }

  QueryBuilder<PodcastEntity, bool, QQueryOperations> isSubscribedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSubscribed');
    });
  }

  QueryBuilder<PodcastEntity, DateTime?, QQueryOperations>
      lastFetchedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastFetchedAt');
    });
  }

  QueryBuilder<PodcastEntity, String?, QQueryOperations>
      lastModifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastModified');
    });
  }

  QueryBuilder<PodcastEntity, String, QQueryOperations> originalUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalUrl');
    });
  }

  QueryBuilder<PodcastEntity, int?, QQueryOperations> sortOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortOrder');
    });
  }

  QueryBuilder<PodcastEntity, SourceType, QQueryOperations>
      sourceTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceType');
    });
  }

  QueryBuilder<PodcastEntity, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<PodcastEntity, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }

  QueryBuilder<PodcastEntity, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
