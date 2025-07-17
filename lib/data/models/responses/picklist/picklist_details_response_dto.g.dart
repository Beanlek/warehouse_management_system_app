// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picklist_details_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PicklistDetailsResponseDtoImpl _$$PicklistDetailsResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PicklistDetailsResponseDtoImpl(
      picklist: Picklist.fromJson(json['picklist'] as Map<String, dynamic>),
      batch: (json['batch'] as List<dynamic>)
          .map((e) => Batch.fromJson(e as Map<String, dynamic>))
          .toList(),
      packing: (json['packing'] as List<dynamic>)
          .map((e) => Packing.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PicklistDetailsResponseDtoImplToJson(
        _$PicklistDetailsResponseDtoImpl instance) =>
    <String, dynamic>{
      'picklist': instance.picklist,
      'batch': instance.batch,
      'packing': instance.packing,
    };

_$PicklistDetailsWrapperDtoImpl _$$PicklistDetailsWrapperDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PicklistDetailsWrapperDtoImpl(
      picklist: Picklist.fromJson(json['picklist'] as Map<String, dynamic>),
      batch: (json['batch'] as List<dynamic>)
          .map((e) => Batch.fromJson(e as Map<String, dynamic>))
          .toList(),
      packing: (json['packing'] as List<dynamic>)
          .map((e) => Packing.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PicklistDetailsWrapperDtoImplToJson(
        _$PicklistDetailsWrapperDtoImpl instance) =>
    <String, dynamic>{
      'picklist': instance.picklist,
      'batch': instance.batch,
      'packing': instance.packing,
    };
