// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PackingImpl _$$PackingImplFromJson(Map<String, dynamic> json) =>
    _$PackingImpl(
      vanAllotId: json['van_allot_id'] as String?,
      vanId: json['van_id'] as String?,
      status: json['status'] as String,
      allotDetails: (json['allot_details'] as List<dynamic>)
          .map((e) => Batch.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PackingImplToJson(_$PackingImpl instance) =>
    <String, dynamic>{
      'van_allot_id': instance.vanAllotId,
      'van_id': instance.vanId,
      'status': instance.status,
      'allot_details': instance.allotDetails,
    };
