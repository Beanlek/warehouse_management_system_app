// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picklist_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PicklistResponseDtoImpl _$$PicklistResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PicklistResponseDtoImpl(
      status: json['status'] as String,
      picklists: PicklistWrapperDto.fromJson(
          json['picklists'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PicklistResponseDtoImplToJson(
        _$PicklistResponseDtoImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'picklists': instance.picklists,
    };

_$PicklistWrapperDtoImpl _$$PicklistWrapperDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PicklistWrapperDtoImpl(
      count: (json['count'] as num?)?.toInt(),
      rows: (json['rows'] as List<dynamic>)
          .map((e) => PicklistDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PicklistWrapperDtoImplToJson(
        _$PicklistWrapperDtoImpl instance) =>
    <String, dynamic>{
      'count': instance.count,
      'rows': instance.rows,
    };
