// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response_for_listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiResponseForListingImpl<T> _$$ApiResponseForListingImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$ApiResponseForListingImpl<T>(
      status: json['status'] as String?,
      error: json['error'] as String?,
      data: json['data'] == null
          ? null
          : ListingData<List<T>>.fromJson(json['data'] as Map<String, dynamic>,
              (value) => (value as List<dynamic>).map(fromJsonT).toList()),
    );

Map<String, dynamic> _$$ApiResponseForListingImplToJson<T>(
  _$ApiResponseForListingImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'status': instance.status,
      'error': instance.error,
      'data': instance.data,
    };
