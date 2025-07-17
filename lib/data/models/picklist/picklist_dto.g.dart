// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picklist_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PicklistDtoImpl _$$PicklistDtoImplFromJson(Map<String, dynamic> json) =>
    _$PicklistDtoImpl(
      id: json['id'] as String,
      status: json['status'] as String,
      siteId: json['site_id'] as String?,
      createdAt: json['created_at'] as String?,
      created_by: json['created_by'] as String?,
    );

Map<String, dynamic> _$$PicklistDtoImplToJson(_$PicklistDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'site_id': instance.siteId,
      'created_at': instance.createdAt,
      'created_by': instance.created_by,
    };
