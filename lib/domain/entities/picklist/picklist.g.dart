// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picklist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PicklistImpl _$$PicklistImplFromJson(Map<String, dynamic> json) =>
    _$PicklistImpl(
      id: json['id'] as String,
      status: json['status'] as String,
      siteId: json['site_id'] as String?,
      createdAt: json['created_at'] as String?,
      createdBy: json['created_by'] as String?,
      sentForPickingBy: json['sent_for_picking_by'] as String?,
      sentForPickingAt: json['sent_for_picking_at'] as String?,
      startedPackingAt: json['started_packing_at'] as String?,
      donePackingAt: json['done_packing_at'] as String?,
      createdDate: json['created_date'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$PicklistImplToJson(_$PicklistImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'site_id': instance.siteId,
      'created_at': instance.createdAt,
      'created_by': instance.createdBy,
      'sent_for_picking_by': instance.sentForPickingBy,
      'sent_for_picking_at': instance.sentForPickingAt,
      'started_packing_at': instance.startedPackingAt,
      'done_packing_at': instance.donePackingAt,
      'created_date': instance.createdDate,
      'updatedAt': instance.updatedAt,
    };
