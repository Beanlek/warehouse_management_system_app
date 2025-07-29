// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picklist_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PicklistWrapperImpl _$$PicklistWrapperImplFromJson(
        Map<String, dynamic> json) =>
    _$PicklistWrapperImpl(
      count: (json['count'] as num?)?.toInt(),
      rows: (json['rows'] as List<dynamic>)
          .map((e) => Picklist.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PicklistWrapperImplToJson(
        _$PicklistWrapperImpl instance) =>
    <String, dynamic>{
      'count': instance.count,
      'rows': instance.rows,
    };
