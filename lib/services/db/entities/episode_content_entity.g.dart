// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_content_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEpisodeContentEntityCollection on Isar {
  IsarCollection<EpisodeContentEntity> get episodeContentEntitys =>
      this.collection();
}

const EpisodeContentEntitySchema = CollectionSchema(
  name: r'EpisodeContentEntity',
  id: -6075276073015750477,
  properties: {
    r'episodeUid': PropertySchema(
      id: 0,
      name: r'episodeUid',
      type: IsarType.string,
    ),
    r'shownotesHtml': PropertySchema(
      id: 1,
      name: r'shownotesHtml',
      type: IsarType.string,
    ),
    r'shownotesText': PropertySchema(
      id: 2,
      name: r'shownotesText',
      type: IsarType.string,
    ),
    r'transcriptText': PropertySchema(
      id: 3,
      name: r'transcriptText',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 4,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _episodeContentEntityEstimateSize,
  serialize: _episodeContentEntitySerialize,
  deserialize: _episodeContentEntityDeserialize,
  deserializeProp: _episodeContentEntityDeserializeProp,
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
  getId: _episodeContentEntityGetId,
  getLinks: _episodeContentEntityGetLinks,
  attach: _episodeContentEntityAttach,
  version: '3.1.0+1',
);

int _episodeContentEntityEstimateSize(
  EpisodeContentEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.episodeUid.length * 3;
  {
    final value = object.shownotesHtml;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.shownotesText;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.transcriptText;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _episodeContentEntitySerialize(
  EpisodeContentEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.episodeUid);
  writer.writeString(offsets[1], object.shownotesHtml);
  writer.writeString(offsets[2], object.shownotesText);
  writer.writeString(offsets[3], object.transcriptText);
  writer.writeDateTime(offsets[4], object.updatedAt);
}

EpisodeContentEntity _episodeContentEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EpisodeContentEntity();
  object.episodeUid = reader.readString(offsets[0]);
  object.isarId = id;
  object.shownotesHtml = reader.readStringOrNull(offsets[1]);
  object.shownotesText = reader.readStringOrNull(offsets[2]);
  object.transcriptText = reader.readStringOrNull(offsets[3]);
  object.updatedAt = reader.readDateTime(offsets[4]);
  return object;
}

P _episodeContentEntityDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _episodeContentEntityGetId(EpisodeContentEntity object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _episodeContentEntityGetLinks(
    EpisodeContentEntity object) {
  return [];
}

void _episodeContentEntityAttach(
    IsarCollection<dynamic> col, Id id, EpisodeContentEntity object) {
  object.isarId = id;
}

extension EpisodeContentEntityByIndex on IsarCollection<EpisodeContentEntity> {
  Future<EpisodeContentEntity?> getByEpisodeUid(String episodeUid) {
    return getByIndex(r'episodeUid', [episodeUid]);
  }

  EpisodeContentEntity? getByEpisodeUidSync(String episodeUid) {
    return getByIndexSync(r'episodeUid', [episodeUid]);
  }

  Future<bool> deleteByEpisodeUid(String episodeUid) {
    return deleteByIndex(r'episodeUid', [episodeUid]);
  }

  bool deleteByEpisodeUidSync(String episodeUid) {
    return deleteByIndexSync(r'episodeUid', [episodeUid]);
  }

  Future<List<EpisodeContentEntity?>> getAllByEpisodeUid(
      List<String> episodeUidValues) {
    final values = episodeUidValues.map((e) => [e]).toList();
    return getAllByIndex(r'episodeUid', values);
  }

  List<EpisodeContentEntity?> getAllByEpisodeUidSync(
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

  Future<Id> putByEpisodeUid(EpisodeContentEntity object) {
    return putByIndex(r'episodeUid', object);
  }

  Id putByEpisodeUidSync(EpisodeContentEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'episodeUid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEpisodeUid(List<EpisodeContentEntity> objects) {
    return putAllByIndex(r'episodeUid', objects);
  }

  List<Id> putAllByEpisodeUidSync(List<EpisodeContentEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'episodeUid', objects, saveLinks: saveLinks);
  }
}

extension EpisodeContentEntityQueryWhereSort
    on QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QWhere> {
  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterWhere>
      anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension EpisodeContentEntityQueryWhere
    on QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QWhereClause> {
  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterWhereClause>
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterWhereClause>
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterWhereClause>
      episodeUidEqualTo(String episodeUid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'episodeUid',
        value: [episodeUid],
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterWhereClause>
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterWhereClause>
      updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterWhereClause>
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterWhereClause>
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterWhereClause>
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterWhereClause>
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

extension EpisodeContentEntityQueryFilter on QueryBuilder<EpisodeContentEntity,
    EpisodeContentEntity, QFilterCondition> {
  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> episodeUidEqualTo(
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> episodeUidGreaterThan(
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> episodeUidLessThan(
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> episodeUidBetween(
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> episodeUidStartsWith(
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> episodeUidEndsWith(
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
          QAfterFilterCondition>
      episodeUidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'episodeUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
          QAfterFilterCondition>
      episodeUidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'episodeUid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> episodeUidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodeUid',
        value: '',
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> episodeUidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'episodeUid',
        value: '',
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesHtmlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'shownotesHtml',
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesHtmlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'shownotesHtml',
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesHtmlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shownotesHtml',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesHtmlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shownotesHtml',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesHtmlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shownotesHtml',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesHtmlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shownotesHtml',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesHtmlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shownotesHtml',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesHtmlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shownotesHtml',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
          QAfterFilterCondition>
      shownotesHtmlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shownotesHtml',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
          QAfterFilterCondition>
      shownotesHtmlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shownotesHtml',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesHtmlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shownotesHtml',
        value: '',
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesHtmlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shownotesHtml',
        value: '',
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'shownotesText',
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'shownotesText',
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesTextEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shownotesText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesTextGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shownotesText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesTextLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shownotesText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesTextBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shownotesText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shownotesText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shownotesText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
          QAfterFilterCondition>
      shownotesTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shownotesText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
          QAfterFilterCondition>
      shownotesTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shownotesText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shownotesText',
        value: '',
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> shownotesTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shownotesText',
        value: '',
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> transcriptTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'transcriptText',
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> transcriptTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'transcriptText',
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> transcriptTextEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transcriptText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> transcriptTextGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transcriptText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> transcriptTextLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transcriptText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> transcriptTextBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transcriptText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> transcriptTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'transcriptText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> transcriptTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'transcriptText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
          QAfterFilterCondition>
      transcriptTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'transcriptText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
          QAfterFilterCondition>
      transcriptTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'transcriptText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> transcriptTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transcriptText',
        value: '',
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> transcriptTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'transcriptText',
        value: '',
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
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

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity,
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

extension EpisodeContentEntityQueryObject on QueryBuilder<EpisodeContentEntity,
    EpisodeContentEntity, QFilterCondition> {}

extension EpisodeContentEntityQueryLinks on QueryBuilder<EpisodeContentEntity,
    EpisodeContentEntity, QFilterCondition> {}

extension EpisodeContentEntityQuerySortBy
    on QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QSortBy> {
  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      sortByEpisodeUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeUid', Sort.asc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      sortByEpisodeUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeUid', Sort.desc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      sortByShownotesHtml() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shownotesHtml', Sort.asc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      sortByShownotesHtmlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shownotesHtml', Sort.desc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      sortByShownotesText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shownotesText', Sort.asc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      sortByShownotesTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shownotesText', Sort.desc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      sortByTranscriptText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transcriptText', Sort.asc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      sortByTranscriptTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transcriptText', Sort.desc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension EpisodeContentEntityQuerySortThenBy
    on QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QSortThenBy> {
  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      thenByEpisodeUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeUid', Sort.asc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      thenByEpisodeUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeUid', Sort.desc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      thenByShownotesHtml() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shownotesHtml', Sort.asc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      thenByShownotesHtmlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shownotesHtml', Sort.desc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      thenByShownotesText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shownotesText', Sort.asc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      thenByShownotesTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shownotesText', Sort.desc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      thenByTranscriptText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transcriptText', Sort.asc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      thenByTranscriptTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transcriptText', Sort.desc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension EpisodeContentEntityQueryWhereDistinct
    on QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QDistinct> {
  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QDistinct>
      distinctByEpisodeUid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episodeUid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QDistinct>
      distinctByShownotesHtml({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shownotesHtml',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QDistinct>
      distinctByShownotesText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shownotesText',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QDistinct>
      distinctByTranscriptText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transcriptText',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EpisodeContentEntity, EpisodeContentEntity, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension EpisodeContentEntityQueryProperty on QueryBuilder<
    EpisodeContentEntity, EpisodeContentEntity, QQueryProperty> {
  QueryBuilder<EpisodeContentEntity, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<EpisodeContentEntity, String, QQueryOperations>
      episodeUidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodeUid');
    });
  }

  QueryBuilder<EpisodeContentEntity, String?, QQueryOperations>
      shownotesHtmlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shownotesHtml');
    });
  }

  QueryBuilder<EpisodeContentEntity, String?, QQueryOperations>
      shownotesTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shownotesText');
    });
  }

  QueryBuilder<EpisodeContentEntity, String?, QQueryOperations>
      transcriptTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transcriptText');
    });
  }

  QueryBuilder<EpisodeContentEntity, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
