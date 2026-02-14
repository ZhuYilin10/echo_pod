// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_asset_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMediaAssetEntityCollection on Isar {
  IsarCollection<MediaAssetEntity> get mediaAssetEntitys => this.collection();
}

const MediaAssetEntitySchema = CollectionSchema(
  name: r'MediaAssetEntity',
  id: 1591897496847404355,
  properties: {
    r'bitrate': PropertySchema(
      id: 0,
      name: r'bitrate',
      type: IsarType.long,
    ),
    r'episodeUid': PropertySchema(
      id: 1,
      name: r'episodeUid',
      type: IsarType.string,
    ),
    r'expiresAt': PropertySchema(
      id: 2,
      name: r'expiresAt',
      type: IsarType.dateTime,
    ),
    r'headersJson': PropertySchema(
      id: 3,
      name: r'headersJson',
      type: IsarType.string,
    ),
    r'isPreferred': PropertySchema(
      id: 4,
      name: r'isPreferred',
      type: IsarType.bool,
    ),
    r'localPath': PropertySchema(
      id: 5,
      name: r'localPath',
      type: IsarType.string,
    ),
    r'mediaType': PropertySchema(
      id: 6,
      name: r'mediaType',
      type: IsarType.byte,
      enumMap: _MediaAssetEntitymediaTypeEnumValueMap,
    ),
    r'mimeType': PropertySchema(
      id: 7,
      name: r'mimeType',
      type: IsarType.string,
    ),
    r'resolvedBy': PropertySchema(
      id: 8,
      name: r'resolvedBy',
      type: IsarType.byte,
      enumMap: _MediaAssetEntityresolvedByEnumValueMap,
    ),
    r'sizeBytes': PropertySchema(
      id: 9,
      name: r'sizeBytes',
      type: IsarType.long,
    ),
    r'uid': PropertySchema(
      id: 10,
      name: r'uid',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'urlNormalized': PropertySchema(
      id: 12,
      name: r'urlNormalized',
      type: IsarType.string,
    ),
    r'urlOriginal': PropertySchema(
      id: 13,
      name: r'urlOriginal',
      type: IsarType.string,
    )
  },
  estimateSize: _mediaAssetEntityEstimateSize,
  serialize: _mediaAssetEntitySerialize,
  deserialize: _mediaAssetEntityDeserialize,
  deserializeProp: _mediaAssetEntityDeserializeProp,
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
    r'episodeUid_isPreferred': IndexSchema(
      id: -1564644032959450834,
      name: r'episodeUid_isPreferred',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'episodeUid',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'isPreferred',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'urlNormalized': IndexSchema(
      id: 6095782860025611388,
      name: r'urlNormalized',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'urlNormalized',
          type: IndexType.hash,
          caseSensitive: true,
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
  getId: _mediaAssetEntityGetId,
  getLinks: _mediaAssetEntityGetLinks,
  attach: _mediaAssetEntityAttach,
  version: '3.1.0+1',
);

int _mediaAssetEntityEstimateSize(
  MediaAssetEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.episodeUid.length * 3;
  {
    final value = object.headersJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.localPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.mimeType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.uid.length * 3;
  bytesCount += 3 + object.urlNormalized.length * 3;
  bytesCount += 3 + object.urlOriginal.length * 3;
  return bytesCount;
}

void _mediaAssetEntitySerialize(
  MediaAssetEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bitrate);
  writer.writeString(offsets[1], object.episodeUid);
  writer.writeDateTime(offsets[2], object.expiresAt);
  writer.writeString(offsets[3], object.headersJson);
  writer.writeBool(offsets[4], object.isPreferred);
  writer.writeString(offsets[5], object.localPath);
  writer.writeByte(offsets[6], object.mediaType.index);
  writer.writeString(offsets[7], object.mimeType);
  writer.writeByte(offsets[8], object.resolvedBy.index);
  writer.writeLong(offsets[9], object.sizeBytes);
  writer.writeString(offsets[10], object.uid);
  writer.writeDateTime(offsets[11], object.updatedAt);
  writer.writeString(offsets[12], object.urlNormalized);
  writer.writeString(offsets[13], object.urlOriginal);
}

MediaAssetEntity _mediaAssetEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MediaAssetEntity();
  object.bitrate = reader.readLongOrNull(offsets[0]);
  object.episodeUid = reader.readString(offsets[1]);
  object.expiresAt = reader.readDateTimeOrNull(offsets[2]);
  object.headersJson = reader.readStringOrNull(offsets[3]);
  object.isPreferred = reader.readBool(offsets[4]);
  object.isarId = id;
  object.localPath = reader.readStringOrNull(offsets[5]);
  object.mediaType = _MediaAssetEntitymediaTypeValueEnumMap[
          reader.readByteOrNull(offsets[6])] ??
      MediaType.audio;
  object.mimeType = reader.readStringOrNull(offsets[7]);
  object.resolvedBy = _MediaAssetEntityresolvedByValueEnumMap[
          reader.readByteOrNull(offsets[8])] ??
      ResolverType.rss;
  object.sizeBytes = reader.readLongOrNull(offsets[9]);
  object.uid = reader.readString(offsets[10]);
  object.updatedAt = reader.readDateTime(offsets[11]);
  object.urlNormalized = reader.readString(offsets[12]);
  object.urlOriginal = reader.readString(offsets[13]);
  return object;
}

P _mediaAssetEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (_MediaAssetEntitymediaTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          MediaType.audio) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (_MediaAssetEntityresolvedByValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ResolverType.rss) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MediaAssetEntitymediaTypeEnumValueMap = {
  'audio': 0,
  'video': 1,
};
const _MediaAssetEntitymediaTypeValueEnumMap = {
  0: MediaType.audio,
  1: MediaType.video,
};
const _MediaAssetEntityresolvedByEnumValueMap = {
  'rss': 0,
  'bilibiliApi': 1,
  'parser': 2,
  'rssHub': 3,
  'web': 4,
  'unknown': 5,
};
const _MediaAssetEntityresolvedByValueEnumMap = {
  0: ResolverType.rss,
  1: ResolverType.bilibiliApi,
  2: ResolverType.parser,
  3: ResolverType.rssHub,
  4: ResolverType.web,
  5: ResolverType.unknown,
};

Id _mediaAssetEntityGetId(MediaAssetEntity object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _mediaAssetEntityGetLinks(MediaAssetEntity object) {
  return [];
}

void _mediaAssetEntityAttach(
    IsarCollection<dynamic> col, Id id, MediaAssetEntity object) {
  object.isarId = id;
}

extension MediaAssetEntityByIndex on IsarCollection<MediaAssetEntity> {
  Future<MediaAssetEntity?> getByUid(String uid) {
    return getByIndex(r'uid', [uid]);
  }

  MediaAssetEntity? getByUidSync(String uid) {
    return getByIndexSync(r'uid', [uid]);
  }

  Future<bool> deleteByUid(String uid) {
    return deleteByIndex(r'uid', [uid]);
  }

  bool deleteByUidSync(String uid) {
    return deleteByIndexSync(r'uid', [uid]);
  }

  Future<List<MediaAssetEntity?>> getAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uid', values);
  }

  List<MediaAssetEntity?> getAllByUidSync(List<String> uidValues) {
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

  Future<Id> putByUid(MediaAssetEntity object) {
    return putByIndex(r'uid', object);
  }

  Id putByUidSync(MediaAssetEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'uid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUid(List<MediaAssetEntity> objects) {
    return putAllByIndex(r'uid', objects);
  }

  List<Id> putAllByUidSync(List<MediaAssetEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uid', objects, saveLinks: saveLinks);
  }
}

extension MediaAssetEntityQueryWhereSort
    on QueryBuilder<MediaAssetEntity, MediaAssetEntity, QWhere> {
  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension MediaAssetEntityQueryWhere
    on QueryBuilder<MediaAssetEntity, MediaAssetEntity, QWhereClause> {
  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
      uidEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uid',
        value: [uid],
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
      uidNotEqualTo(String uid) {
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
      episodeUidEqualToAnyIsPreferred(String episodeUid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'episodeUid_isPreferred',
        value: [episodeUid],
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
      episodeUidNotEqualToAnyIsPreferred(String episodeUid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'episodeUid_isPreferred',
              lower: [],
              upper: [episodeUid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'episodeUid_isPreferred',
              lower: [episodeUid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'episodeUid_isPreferred',
              lower: [episodeUid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'episodeUid_isPreferred',
              lower: [],
              upper: [episodeUid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
      episodeUidIsPreferredEqualTo(String episodeUid, bool isPreferred) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'episodeUid_isPreferred',
        value: [episodeUid, isPreferred],
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
      episodeUidEqualToIsPreferredNotEqualTo(
          String episodeUid, bool isPreferred) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'episodeUid_isPreferred',
              lower: [episodeUid],
              upper: [episodeUid, isPreferred],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'episodeUid_isPreferred',
              lower: [episodeUid, isPreferred],
              includeLower: false,
              upper: [episodeUid],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'episodeUid_isPreferred',
              lower: [episodeUid, isPreferred],
              includeLower: false,
              upper: [episodeUid],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'episodeUid_isPreferred',
              lower: [episodeUid],
              upper: [episodeUid, isPreferred],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
      urlNormalizedEqualTo(String urlNormalized) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'urlNormalized',
        value: [urlNormalized],
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
      urlNormalizedNotEqualTo(String urlNormalized) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'urlNormalized',
              lower: [],
              upper: [urlNormalized],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'urlNormalized',
              lower: [urlNormalized],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'urlNormalized',
              lower: [urlNormalized],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'urlNormalized',
              lower: [],
              upper: [urlNormalized],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
      updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterWhereClause>
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

extension MediaAssetEntityQueryFilter
    on QueryBuilder<MediaAssetEntity, MediaAssetEntity, QFilterCondition> {
  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      bitrateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bitrate',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      bitrateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bitrate',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      bitrateEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bitrate',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      bitrateGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bitrate',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      bitrateLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bitrate',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      bitrateBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bitrate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      episodeUidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'episodeUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      episodeUidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'episodeUid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      episodeUidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodeUid',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      episodeUidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'episodeUid',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      expiresAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expiresAt',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      expiresAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expiresAt',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      expiresAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      expiresAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      expiresAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      expiresAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiresAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      headersJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'headersJson',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      headersJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'headersJson',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      headersJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'headersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      headersJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'headersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      headersJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'headersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      headersJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'headersJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      headersJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'headersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      headersJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'headersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      headersJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'headersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      headersJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'headersJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      headersJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'headersJson',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      headersJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'headersJson',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      isPreferredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPreferred',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      localPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'localPath',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      localPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'localPath',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      localPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      localPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      localPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      localPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      localPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      localPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      localPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      localPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'localPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      localPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localPath',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      localPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'localPath',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      mediaTypeEqualTo(MediaType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaType',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      mediaTypeGreaterThan(
    MediaType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mediaType',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      mediaTypeLessThan(
    MediaType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mediaType',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      mediaTypeBetween(
    MediaType lower,
    MediaType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mediaType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      mimeTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mimeType',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      mimeTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mimeType',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      mimeTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      mimeTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      mimeTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      mimeTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mimeType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      mimeTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      mimeTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      mimeTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      mimeTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mimeType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      mimeTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mimeType',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      mimeTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mimeType',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      resolvedByEqualTo(ResolverType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resolvedBy',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      resolvedByGreaterThan(
    ResolverType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resolvedBy',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      resolvedByLessThan(
    ResolverType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resolvedBy',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      resolvedByBetween(
    ResolverType lower,
    ResolverType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resolvedBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      sizeBytesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sizeBytes',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      sizeBytesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sizeBytes',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      sizeBytesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      sizeBytesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      sizeBytesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      sizeBytesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sizeBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      uidEqualTo(
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      uidLessThan(
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      uidBetween(
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      uidEndsWith(
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      uidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      uidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
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

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlNormalizedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'urlNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlNormalizedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'urlNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlNormalizedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'urlNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlNormalizedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'urlNormalized',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlNormalizedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'urlNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlNormalizedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'urlNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlNormalizedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'urlNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlNormalizedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'urlNormalized',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlNormalizedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'urlNormalized',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlNormalizedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'urlNormalized',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlOriginalEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'urlOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlOriginalGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'urlOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlOriginalLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'urlOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlOriginalBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'urlOriginal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlOriginalStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'urlOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlOriginalEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'urlOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlOriginalContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'urlOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlOriginalMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'urlOriginal',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlOriginalIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'urlOriginal',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterFilterCondition>
      urlOriginalIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'urlOriginal',
        value: '',
      ));
    });
  }
}

extension MediaAssetEntityQueryObject
    on QueryBuilder<MediaAssetEntity, MediaAssetEntity, QFilterCondition> {}

extension MediaAssetEntityQueryLinks
    on QueryBuilder<MediaAssetEntity, MediaAssetEntity, QFilterCondition> {}

extension MediaAssetEntityQuerySortBy
    on QueryBuilder<MediaAssetEntity, MediaAssetEntity, QSortBy> {
  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByBitrate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bitrate', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByBitrateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bitrate', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByEpisodeUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeUid', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByEpisodeUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeUid', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByHeadersJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headersJson', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByHeadersJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headersJson', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByIsPreferred() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPreferred', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByIsPreferredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPreferred', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPath', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPath', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByMimeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByMimeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByResolvedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedBy', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByResolvedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedBy', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortBySizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByUrlNormalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'urlNormalized', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByUrlNormalizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'urlNormalized', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByUrlOriginal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'urlOriginal', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      sortByUrlOriginalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'urlOriginal', Sort.desc);
    });
  }
}

extension MediaAssetEntityQuerySortThenBy
    on QueryBuilder<MediaAssetEntity, MediaAssetEntity, QSortThenBy> {
  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByBitrate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bitrate', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByBitrateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bitrate', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByEpisodeUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeUid', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByEpisodeUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeUid', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByHeadersJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headersJson', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByHeadersJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headersJson', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByIsPreferred() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPreferred', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByIsPreferredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPreferred', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPath', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPath', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByMimeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByMimeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByResolvedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedBy', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByResolvedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedBy', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenBySizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByUrlNormalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'urlNormalized', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByUrlNormalizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'urlNormalized', Sort.desc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByUrlOriginal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'urlOriginal', Sort.asc);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QAfterSortBy>
      thenByUrlOriginalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'urlOriginal', Sort.desc);
    });
  }
}

extension MediaAssetEntityQueryWhereDistinct
    on QueryBuilder<MediaAssetEntity, MediaAssetEntity, QDistinct> {
  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QDistinct>
      distinctByBitrate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bitrate');
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QDistinct>
      distinctByEpisodeUid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episodeUid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QDistinct>
      distinctByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiresAt');
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QDistinct>
      distinctByHeadersJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'headersJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QDistinct>
      distinctByIsPreferred() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPreferred');
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QDistinct>
      distinctByLocalPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QDistinct>
      distinctByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaType');
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QDistinct>
      distinctByMimeType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mimeType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QDistinct>
      distinctByResolvedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resolvedBy');
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QDistinct>
      distinctBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sizeBytes');
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QDistinct> distinctByUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QDistinct>
      distinctByUrlNormalized({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'urlNormalized',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MediaAssetEntity, MediaAssetEntity, QDistinct>
      distinctByUrlOriginal({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'urlOriginal', caseSensitive: caseSensitive);
    });
  }
}

extension MediaAssetEntityQueryProperty
    on QueryBuilder<MediaAssetEntity, MediaAssetEntity, QQueryProperty> {
  QueryBuilder<MediaAssetEntity, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<MediaAssetEntity, int?, QQueryOperations> bitrateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bitrate');
    });
  }

  QueryBuilder<MediaAssetEntity, String, QQueryOperations>
      episodeUidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodeUid');
    });
  }

  QueryBuilder<MediaAssetEntity, DateTime?, QQueryOperations>
      expiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiresAt');
    });
  }

  QueryBuilder<MediaAssetEntity, String?, QQueryOperations>
      headersJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'headersJson');
    });
  }

  QueryBuilder<MediaAssetEntity, bool, QQueryOperations> isPreferredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPreferred');
    });
  }

  QueryBuilder<MediaAssetEntity, String?, QQueryOperations>
      localPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localPath');
    });
  }

  QueryBuilder<MediaAssetEntity, MediaType, QQueryOperations>
      mediaTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaType');
    });
  }

  QueryBuilder<MediaAssetEntity, String?, QQueryOperations> mimeTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mimeType');
    });
  }

  QueryBuilder<MediaAssetEntity, ResolverType, QQueryOperations>
      resolvedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resolvedBy');
    });
  }

  QueryBuilder<MediaAssetEntity, int?, QQueryOperations> sizeBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sizeBytes');
    });
  }

  QueryBuilder<MediaAssetEntity, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }

  QueryBuilder<MediaAssetEntity, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<MediaAssetEntity, String, QQueryOperations>
      urlNormalizedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'urlNormalized');
    });
  }

  QueryBuilder<MediaAssetEntity, String, QQueryOperations>
      urlOriginalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'urlOriginal');
    });
  }
}
