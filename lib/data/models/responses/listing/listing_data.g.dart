// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListingData<T> _$ListingDataFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ListingData<T>(
      count: json['count'] as num?,
      rows: _$nullableGenericFromJson(json['rows'], fromJsonT),
    );

Map<String, dynamic> _$ListingDataToJson<T>(
  ListingData<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'count': instance.count,
      'rows': _$nullableGenericToJson(instance.rows, toJsonT),
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
