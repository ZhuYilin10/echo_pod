// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_job_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSyncJobEntityCollection on Isar {
  IsarCollection<SyncJobEntity> get syncJobEntitys => this.collection();
}

const SyncJobEntitySchema = CollectionSchema(
  name: r'SyncJobEntity',
  id: -3928960571318731660,
  properties: {
    r'extraJson': PropertySchema(
      id: 0,
      name: r'extraJson',
      type: IsarType.string,
    ),
    r'finishedAt': PropertySchema(
      id: 1,
      name: r'finishedAt',
      type: IsarType.dateTime,
    ),
    r'lastError': PropertySchema(
      id: 2,
      name: r'lastError',
      type: IsarType.string,
    ),
    r'namespace': PropertySchema(
      id: 3,
      name: r'namespace',
      type: IsarType.string,
    ),
    r'startedAt': PropertySchema(
      id: 4,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 5,
      name: r'status',
      type: IsarType.byte,
      enumMap: _SyncJobEntitystatusEnumValueMap,
    )
  },
  estimateSize: _syncJobEntityEstimateSize,
  serialize: _syncJobEntitySerialize,
  deserialize: _syncJobEntityDeserialize,
  deserializeProp: _syncJobEntityDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'namespace': IndexSchema(
      id: 2334977328868235416,
      name: r'namespace',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'namespace',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _syncJobEntityGetId,
  getLinks: _syncJobEntityGetLinks,
  attach: _syncJobEntityAttach,
  version: '3.1.0+1',
);

int _syncJobEntityEstimateSize(
  SyncJobEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.extraJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastError;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.namespace.length * 3;
  return bytesCount;
}

void _syncJobEntitySerialize(
  SyncJobEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.extraJson);
  writer.writeDateTime(offsets[1], object.finishedAt);
  writer.writeString(offsets[2], object.lastError);
  writer.writeString(offsets[3], object.namespace);
  writer.writeDateTime(offsets[4], object.startedAt);
  writer.writeByte(offsets[5], object.status.index);
}

SyncJobEntity _syncJobEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SyncJobEntity();
  object.extraJson = reader.readStringOrNull(offsets[0]);
  object.finishedAt = reader.readDateTimeOrNull(offsets[1]);
  object.isarId = id;
  object.lastError = reader.readStringOrNull(offsets[2]);
  object.namespace = reader.readString(offsets[3]);
  object.startedAt = reader.readDateTimeOrNull(offsets[4]);
  object.status =
      _SyncJobEntitystatusValueEnumMap[reader.readByteOrNull(offsets[5])] ??
          SyncStatus.idle;
  return object;
}

P _syncJobEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (_SyncJobEntitystatusValueEnumMap[reader.readByteOrNull(offset)] ??
          SyncStatus.idle) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SyncJobEntitystatusEnumValueMap = {
  'idle': 0,
  'running': 1,
  'error': 2,
};
const _SyncJobEntitystatusValueEnumMap = {
  0: SyncStatus.idle,
  1: SyncStatus.running,
  2: SyncStatus.error,
};

Id _syncJobEntityGetId(SyncJobEntity object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _syncJobEntityGetLinks(SyncJobEntity object) {
  return [];
}

void _syncJobEntityAttach(
    IsarCollection<dynamic> col, Id id, SyncJobEntity object) {
  object.isarId = id;
}

extension SyncJobEntityByIndex on IsarCollection<SyncJobEntity> {
  Future<SyncJobEntity?> getByNamespace(String namespace) {
    return getByIndex(r'namespace', [namespace]);
  }

  SyncJobEntity? getByNamespaceSync(String namespace) {
    return getByIndexSync(r'namespace', [namespace]);
  }

  Future<bool> deleteByNamespace(String namespace) {
    return deleteByIndex(r'namespace', [namespace]);
  }

  bool deleteByNamespaceSync(String namespace) {
    return deleteByIndexSync(r'namespace', [namespace]);
  }

  Future<List<SyncJobEntity?>> getAllByNamespace(List<String> namespaceValues) {
    final values = namespaceValues.map((e) => [e]).toList();
    return getAllByIndex(r'namespace', values);
  }

  List<SyncJobEntity?> getAllByNamespaceSync(List<String> namespaceValues) {
    final values = namespaceValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'namespace', values);
  }

  Future<int> deleteAllByNamespace(List<String> namespaceValues) {
    final values = namespaceValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'namespace', values);
  }

  int deleteAllByNamespaceSync(List<String> namespaceValues) {
    final values = namespaceValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'namespace', values);
  }

  Future<Id> putByNamespace(SyncJobEntity object) {
    return putByIndex(r'namespace', object);
  }

  Id putByNamespaceSync(SyncJobEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'namespace', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByNamespace(List<SyncJobEntity> objects) {
    return putAllByIndex(r'namespace', objects);
  }

  List<Id> putAllByNamespaceSync(List<SyncJobEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'namespace', objects, saveLinks: saveLinks);
  }
}

extension SyncJobEntityQueryWhereSort
    on QueryBuilder<SyncJobEntity, SyncJobEntity, QWhere> {
  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SyncJobEntityQueryWhere
    on QueryBuilder<SyncJobEntity, SyncJobEntity, QWhereClause> {
  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterWhereClause>
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

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterWhereClause>
      namespaceEqualTo(String namespace) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'namespace',
        value: [namespace],
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterWhereClause>
      namespaceNotEqualTo(String namespace) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'namespace',
              lower: [],
              upper: [namespace],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'namespace',
              lower: [namespace],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'namespace',
              lower: [namespace],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'namespace',
              lower: [],
              upper: [namespace],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SyncJobEntityQueryFilter
    on QueryBuilder<SyncJobEntity, SyncJobEntity, QFilterCondition> {
  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      extraJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'extraJson',
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      extraJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'extraJson',
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
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

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
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

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
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

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
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

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
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

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
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

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      extraJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'extraJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      extraJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'extraJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      extraJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extraJson',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      extraJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'extraJson',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      finishedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'finishedAt',
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      finishedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'finishedAt',
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      finishedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finishedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      finishedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'finishedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      finishedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'finishedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      finishedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'finishedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
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

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
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

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
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

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      lastErrorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastError',
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      lastErrorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastError',
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      lastErrorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      lastErrorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      lastErrorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      lastErrorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastError',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      lastErrorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      lastErrorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      lastErrorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      lastErrorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastError',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      lastErrorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastError',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      lastErrorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastError',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      namespaceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'namespace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      namespaceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'namespace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      namespaceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'namespace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      namespaceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'namespace',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      namespaceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'namespace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      namespaceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'namespace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      namespaceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'namespace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      namespaceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'namespace',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      namespaceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'namespace',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      namespaceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'namespace',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      startedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startedAt',
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      startedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startedAt',
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      startedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      startedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      startedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      startedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      statusEqualTo(SyncStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      statusGreaterThan(
    SyncStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      statusLessThan(
    SyncStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterFilterCondition>
      statusBetween(
    SyncStatus lower,
    SyncStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SyncJobEntityQueryObject
    on QueryBuilder<SyncJobEntity, SyncJobEntity, QFilterCondition> {}

extension SyncJobEntityQueryLinks
    on QueryBuilder<SyncJobEntity, SyncJobEntity, QFilterCondition> {}

extension SyncJobEntityQuerySortBy
    on QueryBuilder<SyncJobEntity, SyncJobEntity, QSortBy> {
  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy> sortByExtraJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.asc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy>
      sortByExtraJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.desc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy> sortByFinishedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishedAt', Sort.asc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy>
      sortByFinishedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishedAt', Sort.desc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy> sortByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy>
      sortByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy> sortByNamespace() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'namespace', Sort.asc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy>
      sortByNamespaceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'namespace', Sort.desc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy> sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy>
      sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension SyncJobEntityQuerySortThenBy
    on QueryBuilder<SyncJobEntity, SyncJobEntity, QSortThenBy> {
  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy> thenByExtraJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.asc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy>
      thenByExtraJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraJson', Sort.desc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy> thenByFinishedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishedAt', Sort.asc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy>
      thenByFinishedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishedAt', Sort.desc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy> thenByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy>
      thenByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy> thenByNamespace() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'namespace', Sort.asc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy>
      thenByNamespaceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'namespace', Sort.desc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy> thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy>
      thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension SyncJobEntityQueryWhereDistinct
    on QueryBuilder<SyncJobEntity, SyncJobEntity, QDistinct> {
  QueryBuilder<SyncJobEntity, SyncJobEntity, QDistinct> distinctByExtraJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'extraJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QDistinct> distinctByFinishedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finishedAt');
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QDistinct> distinctByLastError(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastError', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QDistinct> distinctByNamespace(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'namespace', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QDistinct> distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<SyncJobEntity, SyncJobEntity, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }
}

extension SyncJobEntityQueryProperty
    on QueryBuilder<SyncJobEntity, SyncJobEntity, QQueryProperty> {
  QueryBuilder<SyncJobEntity, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<SyncJobEntity, String?, QQueryOperations> extraJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extraJson');
    });
  }

  QueryBuilder<SyncJobEntity, DateTime?, QQueryOperations>
      finishedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finishedAt');
    });
  }

  QueryBuilder<SyncJobEntity, String?, QQueryOperations> lastErrorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastError');
    });
  }

  QueryBuilder<SyncJobEntity, String, QQueryOperations> namespaceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'namespace');
    });
  }

  QueryBuilder<SyncJobEntity, DateTime?, QQueryOperations> startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<SyncJobEntity, SyncStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}
