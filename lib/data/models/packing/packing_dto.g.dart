// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packing_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PackingDtoImpl _$$PackingDtoImplFromJson(Map<String, dynamic> json) =>
    _$PackingDtoImpl(
      vanAllotId: json['van_allot_id'] as String?,
      vanId: json['van_id'] as String?,
      status: json['status'] as String,
      allotDetails: (json['allot_details'] as List<dynamic>)
          .map((e) => Batch.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PackingDtoImplToJson(_$PackingDtoImpl instance) =>
    <String, dynamic>{
      'van_allot_id': instance.vanAllotId,
      'van_id': instance.vanId,
      'status': instance.status,
      'allot_details': instance.allotDetails,
    };
