// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_preference_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPodcastPreferenceEntityCollection on Isar {
  IsarCollection<PodcastPreferenceEntity> get podcastPreferenceEntitys =>
      this.collection();
}

const PodcastPreferenceEntitySchema = CollectionSchema(
  name: r'PodcastPreferenceEntity',
  id: -3182639943397976022,
  properties: {
    r'loudnessNormalize': PropertySchema(
      id: 0,
      name: r'loudnessNormalize',
      type: IsarType.bool,
    ),
    r'podcastUid': PropertySchema(
      id: 1,
      name: r'podcastUid',
      type: IsarType.string,
    ),
    r'skipSilenceOverride': PropertySchema(
      id: 2,
      name: r'skipSilenceOverride',
      type: IsarType.bool,
    ),
    r'speed': PropertySchema(
      id: 3,
      name: r'speed',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 4,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _podcastPreferenceEntityEstimateSize,
  serialize: _podcastPreferenceEntitySerialize,
  deserialize: _podcastPreferenceEntityDeserialize,
  deserializeProp: _podcastPreferenceEntityDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'podcastUid': IndexSchema(
      id: 5858516428501787428,
      name: r'podcastUid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'podcastUid',
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
  getId: _podcastPreferenceEntityGetId,
  getLinks: _podcastPreferenceEntityGetLinks,
  attach: _podcastPreferenceEntityAttach,
  version: '3.1.0+1',
);

int _podcastPreferenceEntityEstimateSize(
  PodcastPreferenceEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.podcastUid.length * 3;
  return bytesCount;
}

void _podcastPreferenceEntitySerialize(
  PodcastPreferenceEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.loudnessNormalize);
  writer.writeString(offsets[1], object.podcastUid);
  writer.writeBool(offsets[2], object.skipSilenceOverride);
  writer.writeDouble(offsets[3], object.speed);
  writer.writeDateTime(offsets[4], object.updatedAt);
}

PodcastPreferenceEntity _podcastPreferenceEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PodcastPreferenceEntity();
  object.isarId = id;
  object.loudnessNormalize = reader.readBoolOrNull(offsets[0]);
  object.podcastUid = reader.readString(offsets[1]);
  object.skipSilenceOverride = reader.readBoolOrNull(offsets[2]);
  object.speed = reader.readDoubleOrNull(offsets[3]);
  object.updatedAt = reader.readDateTime(offsets[4]);
  return object;
}

P _podcastPreferenceEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _podcastPreferenceEntityGetId(PodcastPreferenceEntity object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _podcastPreferenceEntityGetLinks(
    PodcastPreferenceEntity object) {
  return [];
}

void _podcastPreferenceEntityAttach(
    IsarCollection<dynamic> col, Id id, PodcastPreferenceEntity object) {
  object.isarId = id;
}

extension PodcastPreferenceEntityByIndex
    on IsarCollection<PodcastPreferenceEntity> {
  Future<PodcastPreferenceEntity?> getByPodcastUid(String podcastUid) {
    return getByIndex(r'podcastUid', [podcastUid]);
  }

  PodcastPreferenceEntity? getByPodcastUidSync(String podcastUid) {
    return getByIndexSync(r'podcastUid', [podcastUid]);
  }

  Future<bool> deleteByPodcastUid(String podcastUid) {
    return deleteByIndex(r'podcastUid', [podcastUid]);
  }

  bool deleteByPodcastUidSync(String podcastUid) {
    return deleteByIndexSync(r'podcastUid', [podcastUid]);
  }

  Future<List<PodcastPreferenceEntity?>> getAllByPodcastUid(
      List<String> podcastUidValues) {
    final values = podcastUidValues.map((e) => [e]).toList();
    return getAllByIndex(r'podcastUid', values);
  }

  List<PodcastPreferenceEntity?> getAllByPodcastUidSync(
      List<String> podcastUidValues) {
    final values = podcastUidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'podcastUid', values);
  }

  Future<int> deleteAllByPodcastUid(List<String> podcastUidValues) {
    final values = podcastUidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'podcastUid', values);
  }

  int deleteAllByPodcastUidSync(List<String> podcastUidValues) {
    final values = podcastUidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'podcastUid', values);
  }

  Future<Id> putByPodcastUid(PodcastPreferenceEntity object) {
    return putByIndex(r'podcastUid', object);
  }

  Id putByPodcastUidSync(PodcastPreferenceEntity object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'podcastUid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPodcastUid(List<PodcastPreferenceEntity> objects) {
    return putAllByIndex(r'podcastUid', objects);
  }

  List<Id> putAllByPodcastUidSync(List<PodcastPreferenceEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'podcastUid', objects, saveLinks: saveLinks);
  }
}

extension PodcastPreferenceEntityQueryWhereSort
    on QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QWhere> {
  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterWhere>
      anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension PodcastPreferenceEntityQueryWhere on QueryBuilder<
    PodcastPreferenceEntity, PodcastPreferenceEntity, QWhereClause> {
  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterWhereClause> podcastUidEqualTo(String podcastUid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'podcastUid',
        value: [podcastUid],
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterWhereClause> podcastUidNotEqualTo(String podcastUid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'podcastUid',
              lower: [],
              upper: [podcastUid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'podcastUid',
              lower: [podcastUid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'podcastUid',
              lower: [podcastUid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'podcastUid',
              lower: [],
              upper: [podcastUid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterWhereClause> updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterWhereClause> updatedAtNotEqualTo(DateTime updatedAt) {
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

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterWhereClause> updatedAtGreaterThan(
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

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterWhereClause> updatedAtLessThan(
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

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterWhereClause> updatedAtBetween(
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

extension PodcastPreferenceEntityQueryFilter on QueryBuilder<
    PodcastPreferenceEntity, PodcastPreferenceEntity, QFilterCondition> {
  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> loudnessNormalizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'loudnessNormalize',
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> loudnessNormalizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'loudnessNormalize',
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> loudnessNormalizeEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loudnessNormalize',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> podcastUidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'podcastUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> podcastUidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'podcastUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> podcastUidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'podcastUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> podcastUidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'podcastUid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> podcastUidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'podcastUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> podcastUidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'podcastUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
          QAfterFilterCondition>
      podcastUidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'podcastUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
          QAfterFilterCondition>
      podcastUidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'podcastUid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> podcastUidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'podcastUid',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> podcastUidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'podcastUid',
        value: '',
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> skipSilenceOverrideIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'skipSilenceOverride',
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> skipSilenceOverrideIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'skipSilenceOverride',
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> skipSilenceOverrideEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skipSilenceOverride',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> speedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'speed',
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> speedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'speed',
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> speedEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'speed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> speedGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'speed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> speedLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'speed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> speedBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'speed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity,
      QAfterFilterCondition> updatedAtBetween(
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

extension PodcastPreferenceEntityQueryObject on QueryBuilder<
    PodcastPreferenceEntity, PodcastPreferenceEntity, QFilterCondition> {}

extension PodcastPreferenceEntityQueryLinks on QueryBuilder<
    PodcastPreferenceEntity, PodcastPreferenceEntity, QFilterCondition> {}

extension PodcastPreferenceEntityQuerySortBy
    on QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QSortBy> {
  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      sortByLoudnessNormalize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loudnessNormalize', Sort.asc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      sortByLoudnessNormalizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loudnessNormalize', Sort.desc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      sortByPodcastUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'podcastUid', Sort.asc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      sortByPodcastUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'podcastUid', Sort.desc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      sortBySkipSilenceOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skipSilenceOverride', Sort.asc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      sortBySkipSilenceOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skipSilenceOverride', Sort.desc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      sortBySpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.asc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      sortBySpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.desc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PodcastPreferenceEntityQuerySortThenBy on QueryBuilder<
    PodcastPreferenceEntity, PodcastPreferenceEntity, QSortThenBy> {
  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      thenByLoudnessNormalize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loudnessNormalize', Sort.asc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      thenByLoudnessNormalizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loudnessNormalize', Sort.desc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      thenByPodcastUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'podcastUid', Sort.asc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      thenByPodcastUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'podcastUid', Sort.desc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      thenBySkipSilenceOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skipSilenceOverride', Sort.asc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      thenBySkipSilenceOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skipSilenceOverride', Sort.desc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      thenBySpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.asc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      thenBySpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.desc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PodcastPreferenceEntityQueryWhereDistinct on QueryBuilder<
    PodcastPreferenceEntity, PodcastPreferenceEntity, QDistinct> {
  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QDistinct>
      distinctByLoudnessNormalize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loudnessNormalize');
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QDistinct>
      distinctByPodcastUid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'podcastUid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QDistinct>
      distinctBySkipSilenceOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'skipSilenceOverride');
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QDistinct>
      distinctBySpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'speed');
    });
  }

  QueryBuilder<PodcastPreferenceEntity, PodcastPreferenceEntity, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension PodcastPreferenceEntityQueryProperty on QueryBuilder<
    PodcastPreferenceEntity, PodcastPreferenceEntity, QQueryProperty> {
  QueryBuilder<PodcastPreferenceEntity, int, QQueryOperations>
      isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<PodcastPreferenceEntity, bool?, QQueryOperations>
      loudnessNormalizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loudnessNormalize');
    });
  }

  QueryBuilder<PodcastPreferenceEntity, String, QQueryOperations>
      podcastUidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'podcastUid');
    });
  }

  QueryBuilder<PodcastPreferenceEntity, bool?, QQueryOperations>
      skipSilenceOverrideProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'skipSilenceOverride');
    });
  }

  QueryBuilder<PodcastPreferenceEntity, double?, QQueryOperations>
      speedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'speed');
    });
  }

  QueryBuilder<PodcastPreferenceEntity, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
