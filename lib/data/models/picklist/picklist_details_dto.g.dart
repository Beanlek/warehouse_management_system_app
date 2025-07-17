// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picklist_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PicklistDetailsDtoImpl _$$PicklistDetailsDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PicklistDetailsDtoImpl(
      picklist: Picklist.fromJson(json['picklist'] as Map<String, dynamic>),
      batch: (json['batch'] as List<dynamic>)
          .map((e) => Batch.fromJson(e as Map<String, dynamic>))
          .toList(),
      packing: (json['packing'] as List<dynamic>)
          .map((e) => Packing.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PicklistDetailsDtoImplToJson(
        _$PicklistDetailsDtoImpl instance) =>
    <String, dynamic>{
      'picklist': instance.picklist,
      'batch': instance.batch,
      'packing': instance.packing,
    };
