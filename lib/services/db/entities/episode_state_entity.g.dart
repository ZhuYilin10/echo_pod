// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_state_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEpisodeStateEntityCollection on Isar {
  IsarCollection<EpisodeStateEntity> get episodeStateEntitys =>
      this.collection();
}

const EpisodeStateEntitySchema = CollectionSchema(
  name: r'EpisodeStateEntity',
  id: -54902451201467207,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'downloadProgress': PropertySchema(
      id: 1,
      name: r'downloadProgress',
      type: IsarType.double,
    ),
    r'downloadStatus': PropertySchema(
      id: 2,
      name: r'downloadStatus',
      type: IsarType.byte,
      enumMap: _EpisodeStateEntitydownloadStatusEnumValueMap,
    ),
    r'downloadedBytes': PropertySchema(
      id: 3,
      name: r'downloadedBytes',
      type: IsarType.long,
    ),
    r'episodeUid': PropertySchema(
      id: 4,
      name: r'episodeUid',
      type: IsarType.string,
    ),
    r'extraJson': PropertySchema(
      id: 5,
      name: r'extraJson',
      type: IsarType.string,
    ),
    r'favoriteAt': PropertySchema(
      id: 6,
      name: r'favoriteAt',
      type: IsarType.dateTime,
    ),
    r'lastPlayedAt': PropertySchema(
      id: 7,
      name: r'lastPlayedAt',
      type: IsarType.dateTime,
    ),
    r'localFilePath': PropertySchema(
      id: 8,
      name: r'localFilePath',
      type: IsarType.string,
    ),
    r'playCount': PropertySchema(
      id: 9,
      name: r'playCount',
      type: IsarType.long,
    ),
    r'progressMs': PropertySchema(
      id: 10,
      name: r'progressMs',
      type: IsarType.long,
    ),
    r'statusFlags': PropertySchema(
      id: 11,
      name: r'statusFlags',
      type: IsarType.long,
    ),
    r'totalBytes': PropertySchema(
      id: 12,
      name: r'totalBytes',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 13,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _episodeStateEntityEstimateSize,
  serialize: _episodeStateEntitySerialize,
  deserialize: _episodeStateEntityDeserialize,
  deserializeProp: _episodeStateEntityDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'episodeUid': IndexSchema(
      id: 6605848235218381551,
      name: r'episodeUid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'episodeUid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'lastPlayedAt': IndexSchema(
      id: 1709968845012040220,
      name: r'lastPlayedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lastPlayedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'downloadStatus_updatedAt': IndexSchema(
      id: -4724741029716126257,
      name: r'downloadStatus_updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'downloadStatus',
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
    r'favoriteAt': IndexSchema(
      id: -2622901397991365521,
      name: r'favoriteAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'favoriteAt',
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
  getId: _episodeStateEntityGetId,
  getLinks: _episodeStateEntityGetLinks,
  attach: _episodeStateEntityAttach,
  version: '3.1.0+1',
);

int _episodeStateEntityEstimateSize(
  EpisodeStateEntity object,
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
  {
    final value = object.localFilePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _episodeStateEntitySerialize(
  EpisodeStateEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeDouble(offsets[1], object.downloadProgress);
  writer.writeByte(offsets[2], object.downloadStatus.index);
  writer.writeLong(offsets[3], object.downloadedBytes);
  writer.writeString(offsets[4], object.episodeUid);
  writer.writeString(offsets[5], object.extraJson);
  writer.writeDateTime(offsets[6], object.favoriteAt);
  writer.writeDateTime(offsets[7], object.lastPlayedAt);
  writer.writeString(offsets[8], object.localFilePath);
  writer.writeLong(offsets[9], object.playCount);
  writer.writeLong(offsets[10], object.progressMs);
  writer.writeLong(offsets[11], object.statusFlags);
  writer.writeLong(offsets[12], object.totalBytes);
  writer.writeDateTime(offsets[13], object.updatedAt);
}

EpisodeStateEntity _episodeStateEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EpisodeStateEntity();
  object.completedAt = reader.readDateTimeOrNull(offsets[0]);
  object.downloadProgress = reader.readDouble(offsets[1]);
  object.downloadStatus = _EpisodeStateEntitydownloadStatusValueEnumMap[
          reader.readByteOrNull(offsets[2])] ??
      DownloadStatus.none;
  object.downloadedBytes = reader.readLong(offsets[3]);
  object.episodeUid = reader.readString(offsets[4]);
  object.extraJson = reader.readStringOrNull(offsets[5]);
  object.favoriteAt = reader.readDateTimeOrNull(offsets[6]);
  object.isarId = id;
  object.lastPlayedAt = reader.readDateTimeOrNull(offsets[7]);
  object.localFilePath = reader.readStringOrNull(offsets[8]);
  object.playCount = reader.readLong(offsets[9]);
  object.progressMs = reader.readLong(offsets[10]);
  object.statusFlags = reader.readLong(offsets[11]);
  object.totalBytes = reader.readLongOrNull(offsets[12]);
  object.updatedAt = reader.readDateTime(offsets[13]);
  return object;
}

P _episodeStateEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (_EpisodeStateEntitydownloadStatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          DownloadStatus.none) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _EpisodeStateEntitydownloadStatusEnumValueMap = {
  'none': 0,
  'queued': 1,
  'downloading': 2,
  'completed': 3,
  'failed': 4,
};
const _EpisodeStateEntitydownloadStatusValueEnumMap = {
  0: DownloadStatus.none,
  1: DownloadStatus.queued,
  2: DownloadStatus.downloading,
  3: DownloadStatus.completed,
  4: DownloadStatus.failed,
};

Id _episodeStateEntityGetId(EpisodeStateEntity object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _episodeStateEntityGetLinks(
    EpisodeStateEntity object) {
  return [];
}

void _episodeStateEntityAttach(
    IsarCollection<dynamic> col, Id id, EpisodeStateEntity object) {
  object.isarId = id;
}

extension EpisodeStateEntityByIndex on IsarCollection<EpisodeStateEntity> {
  Future<EpisodeStateEntity?> getByEpisodeUid(String episodeUid) {
    return getByIndex(r'episodeUid', [episodeUid]);
  }

  EpisodeStateEntity? getByEpisodeUidSync(String episodeUid) {
    return getByIndexSync(r'episodeUid', [episodeUid]);
  }

  Future<bool> deleteByEpisodeUid(String episodeUid) {
    return deleteByIndex(r'episodeUid', [episodeUid]);
  }

  bool deleteByEpisodeUidSync(String episodeUid) {
    return deleteByIndexSync(r'episodeUid', [episodeUid]);
  }

  Future<List<EpisodeStateEntity?>> getAllByEpisodeUid(
      List<String> episodeUidValues) {
    final values = episodeUidValues.map((e) => [e]).toList();
    return getAllByIndex(r'episodeUid', values);
  }

  List<EpisodeStateEntity?> getAllByEpisodeUidSync(
      List<String> episodeUidValues) {
    final values = episodeUidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'episodeUid', values);
  }

  Future<int> deleteAllByEpisodeUid(List<String> episodeUidValues) {
    final values = episodeUidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'episodeUid', values);
  }

  int deleteAllByEpisodeUidSync(List<String> episodeUidValues) {
    final values = episodeUidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'episodeUid', values);
  }

  Future<Id> putByEpisodeUid(EpisodeStateEntity object) {
    return putByIndex(r'episodeUid', object);
  }

  Id putByEpisodeUidSync(EpisodeStateEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'episodeUid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEpisodeUid(List<EpisodeStateEntity> objects) {
    return putAllByIndex(r'episodeUid', objects);
  }

  List<Id> putAllByEpisodeUidSync(List<EpisodeStateEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'episodeUid', objects, saveLinks: saveLinks);
  }
}

extension EpisodeStateEntityQueryWhereSort
    on QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QWhere> {
  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhere>
      anyLastPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lastPlayedAt'),
      );
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhere>
      anyDownloadStatusUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'downloadStatus_updatedAt'),
      );
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhere>
      anyFavoriteAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'favoriteAt'),
      );
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhere>
      anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension EpisodeStateEntityQueryWhere
    on QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QWhereClause> {
  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      episodeUidEqualTo(String episodeUid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'episodeUid',
        value: [episodeUid],
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      lastPlayedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastPlayedAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      lastPlayedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastPlayedAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      lastPlayedAtEqualTo(DateTime? lastPlayedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastPlayedAt',
        value: [lastPlayedAt],
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      lastPlayedAtNotEqualTo(DateTime? lastPlayedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastPlayedAt',
              lower: [],
              upper: [lastPlayedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastPlayedAt',
              lower: [lastPlayedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastPlayedAt',
              lower: [lastPlayedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastPlayedAt',
              lower: [],
              upper: [lastPlayedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      lastPlayedAtGreaterThan(
    DateTime? lastPlayedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastPlayedAt',
        lower: [lastPlayedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      lastPlayedAtLessThan(
    DateTime? lastPlayedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastPlayedAt',
        lower: [],
        upper: [lastPlayedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      lastPlayedAtBetween(
    DateTime? lowerLastPlayedAt,
    DateTime? upperLastPlayedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastPlayedAt',
        lower: [lowerLastPlayedAt],
        includeLower: includeLower,
        upper: [upperLastPlayedAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      downloadStatusEqualToAnyUpdatedAt(DownloadStatus downloadStatus) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'downloadStatus_updatedAt',
        value: [downloadStatus],
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      downloadStatusNotEqualToAnyUpdatedAt(DownloadStatus downloadStatus) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'downloadStatus_updatedAt',
              lower: [],
              upper: [downloadStatus],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'downloadStatus_updatedAt',
              lower: [downloadStatus],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'downloadStatus_updatedAt',
              lower: [downloadStatus],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'downloadStatus_updatedAt',
              lower: [],
              upper: [downloadStatus],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      downloadStatusGreaterThanAnyUpdatedAt(
    DownloadStatus downloadStatus, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'downloadStatus_updatedAt',
        lower: [downloadStatus],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      downloadStatusLessThanAnyUpdatedAt(
    DownloadStatus downloadStatus, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'downloadStatus_updatedAt',
        lower: [],
        upper: [downloadStatus],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      downloadStatusBetweenAnyUpdatedAt(
    DownloadStatus lowerDownloadStatus,
    DownloadStatus upperDownloadStatus, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'downloadStatus_updatedAt',
        lower: [lowerDownloadStatus],
        includeLower: includeLower,
        upper: [upperDownloadStatus],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      downloadStatusUpdatedAtEqualTo(
          DownloadStatus downloadStatus, DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'downloadStatus_updatedAt',
        value: [downloadStatus, updatedAt],
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      downloadStatusEqualToUpdatedAtNotEqualTo(
          DownloadStatus downloadStatus, DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'downloadStatus_updatedAt',
              lower: [downloadStatus],
              upper: [downloadStatus, updatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'downloadStatus_updatedAt',
              lower: [downloadStatus, updatedAt],
              includeLower: false,
              upper: [downloadStatus],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'downloadStatus_updatedAt',
              lower: [downloadStatus, updatedAt],
              includeLower: false,
              upper: [downloadStatus],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'downloadStatus_updatedAt',
              lower: [downloadStatus],
              upper: [downloadStatus, updatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      downloadStatusEqualToUpdatedAtGreaterThan(
    DownloadStatus downloadStatus,
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'downloadStatus_updatedAt',
        lower: [downloadStatus, updatedAt],
        includeLower: include,
        upper: [downloadStatus],
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      downloadStatusEqualToUpdatedAtLessThan(
    DownloadStatus downloadStatus,
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'downloadStatus_updatedAt',
        lower: [downloadStatus],
        upper: [downloadStatus, updatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      downloadStatusEqualToUpdatedAtBetween(
    DownloadStatus downloadStatus,
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'downloadStatus_updatedAt',
        lower: [downloadStatus, lowerUpdatedAt],
        includeLower: includeLower,
        upper: [downloadStatus, upperUpdatedAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      favoriteAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'favoriteAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      favoriteAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'favoriteAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      favoriteAtEqualTo(DateTime? favoriteAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'favoriteAt',
        value: [favoriteAt],
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      favoriteAtNotEqualTo(DateTime? favoriteAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favoriteAt',
              lower: [],
              upper: [favoriteAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favoriteAt',
              lower: [favoriteAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favoriteAt',
              lower: [favoriteAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favoriteAt',
              lower: [],
              upper: [favoriteAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      favoriteAtGreaterThan(
    DateTime? favoriteAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'favoriteAt',
        lower: [favoriteAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      favoriteAtLessThan(
    DateTime? favoriteAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'favoriteAt',
        lower: [],
        upper: [favoriteAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      favoriteAtBetween(
    DateTime? lowerFavoriteAt,
    DateTime? upperFavoriteAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'favoriteAt',
        lower: [lowerFavoriteAt],
        includeLower: includeLower,
        upper: [upperFavoriteAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
      updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterWhereClause>
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

extension EpisodeStateEntityQueryFilter
    on QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QFilterCondition> {
  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      downloadProgressEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadProgress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      downloadProgressGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadProgress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      downloadProgressLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadProgress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      downloadProgressBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadProgress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      downloadStatusEqualTo(DownloadStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      downloadStatusGreaterThan(
    DownloadStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      downloadStatusLessThan(
    DownloadStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      downloadStatusBetween(
    DownloadStatus lower,
    DownloadStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      downloadedBytesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadedBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      downloadedBytesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadedBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      downloadedBytesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadedBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      downloadedBytesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadedBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      episodeUidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'episodeUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      episodeUidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'episodeUid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      episodeUidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodeUid',
        value: '',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      episodeUidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'episodeUid',
        value: '',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      extraJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'extraJson',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      extraJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'extraJson',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      extraJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'extraJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      extraJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'extraJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      extraJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extraJson',
        value: '',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      extraJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'extraJson',
        value: '',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      favoriteAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'favoriteAt',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      favoriteAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'favoriteAt',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      favoriteAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favoriteAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      favoriteAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'favoriteAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      favoriteAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'favoriteAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      favoriteAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'favoriteAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      lastPlayedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastPlayedAt',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      lastPlayedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastPlayedAt',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      lastPlayedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastPlayedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      lastPlayedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastPlayedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      lastPlayedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastPlayedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      lastPlayedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastPlayedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      localFilePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'localFilePath',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      localFilePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'localFilePath',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      localFilePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      localFilePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      localFilePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      localFilePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localFilePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      localFilePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'localFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      localFilePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'localFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      localFilePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'localFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      localFilePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'localFilePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      localFilePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localFilePath',
        value: '',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      localFilePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'localFilePath',
        value: '',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      playCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playCount',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      playCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playCount',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      playCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playCount',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      playCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      progressMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progressMs',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      progressMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'progressMs',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      progressMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'progressMs',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      progressMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'progressMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      statusFlagsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusFlags',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      statusFlagsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statusFlags',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      statusFlagsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statusFlags',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      statusFlagsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statusFlags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      totalBytesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalBytes',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      totalBytesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalBytes',
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      totalBytesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      totalBytesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      totalBytesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      totalBytesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterFilterCondition>
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

extension EpisodeStateEntityQueryObject
    on QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QFilterCondition> {}

extension EpisodeStateEntityQueryLinks
    on QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QFilterCondition> {}

extension EpisodeStateEntityQuerySortBy
    on QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QSortBy> {
  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByDownloadProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadProgress', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByDownloadProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadProgress', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByDownloadStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadStatus', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByDownloadStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadStatus', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByDownloadedBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedBytes', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByDownloadedBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedBytes', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByEpisodeUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeUid', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByEpisodeUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeUid', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByExtraJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByExtraJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByFavoriteAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteAt', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByFavoriteAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteAt', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByLastPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayedAt', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByLastPlayedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayedAt', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByLocalFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localFilePath', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByLocalFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localFilePath', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByPlayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByProgressMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressMs', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByProgressMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressMs', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByStatusFlags() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusFlags', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByStatusFlagsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusFlags', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByTotalBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByTotalBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension EpisodeStateEntityQuerySortThenBy
    on QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QSortThenBy> {
  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByDownloadProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadProgress', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByDownloadProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadProgress', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByDownloadStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadStatus', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByDownloadStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadStatus', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByDownloadedBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedBytes', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByDownloadedBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedBytes', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByEpisodeUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeUid', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByEpisodeUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeUid', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByExtraJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByExtraJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByFavoriteAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteAt', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByFavoriteAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteAt', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByLastPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayedAt', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByLastPlayedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayedAt', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByLocalFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localFilePath', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByLocalFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localFilePath', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByPlayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByProgressMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressMs', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByProgressMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressMs', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByStatusFlags() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusFlags', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByStatusFlagsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusFlags', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByTotalBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByTotalBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.desc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension EpisodeStateEntityQueryWhereDistinct
    on QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QDistinct> {
  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QDistinct>
      distinctByDownloadProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadProgress');
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QDistinct>
      distinctByDownloadStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadStatus');
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QDistinct>
      distinctByDownloadedBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadedBytes');
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QDistinct>
      distinctByEpisodeUid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episodeUid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QDistinct>
      distinctByExtraJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'extraJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QDistinct>
      distinctByFavoriteAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'favoriteAt');
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QDistinct>
      distinctByLastPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastPlayedAt');
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QDistinct>
      distinctByLocalFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localFilePath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QDistinct>
      distinctByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playCount');
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QDistinct>
      distinctByProgressMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progressMs');
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QDistinct>
      distinctByStatusFlags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusFlags');
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QDistinct>
      distinctByTotalBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalBytes');
    });
  }

  QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension EpisodeStateEntityQueryProperty
    on QueryBuilder<EpisodeStateEntity, EpisodeStateEntity, QQueryProperty> {
  QueryBuilder<EpisodeStateEntity, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<EpisodeStateEntity, DateTime?, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<EpisodeStateEntity, double, QQueryOperations>
      downloadProgressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadProgress');
    });
  }

  QueryBuilder<EpisodeStateEntity, DownloadStatus, QQueryOperations>
      downloadStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadStatus');
    });
  }

  QueryBuilder<EpisodeStateEntity, int, QQueryOperations>
      downloadedBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadedBytes');
    });
  }

  QueryBuilder<EpisodeStateEntity, String, QQueryOperations>
      episodeUidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodeUid');
    });
  }

  QueryBuilder<EpisodeStateEntity, String?, QQueryOperations>
      extraJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extraJson');
    });
  }

  QueryBuilder<EpisodeStateEntity, DateTime?, QQueryOperations>
      favoriteAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'favoriteAt');
    });
  }

  QueryBuilder<EpisodeStateEntity, DateTime?, QQueryOperations>
      lastPlayedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPlayedAt');
    });
  }

  QueryBuilder<EpisodeStateEntity, String?, QQueryOperations>
      localFilePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localFilePath');
    });
  }

  QueryBuilder<EpisodeStateEntity, int, QQueryOperations> playCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playCount');
    });
  }

  QueryBuilder<EpisodeStateEntity, int, QQueryOperations> progressMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progressMs');
    });
  }

  QueryBuilder<EpisodeStateEntity, int, QQueryOperations>
      statusFlagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusFlags');
    });
  }

  QueryBuilder<EpisodeStateEntity, int?, QQueryOperations>
      totalBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalBytes');
    });
  }

  QueryBuilder<EpisodeStateEntity, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
