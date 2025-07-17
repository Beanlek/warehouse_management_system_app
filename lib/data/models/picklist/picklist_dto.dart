import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/core/network/interfaces/base_dto_model.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';

part 'picklist_dto.freezed.dart';
part 'picklist_dto.g.dart';

@freezed
class PicklistDto with _$PicklistDto implements BaseDtoModel<Picklist> {
  const PicklistDto._();

  const factory PicklistDto({
    required String id,
    required String status,
    @JsonKey(name: 'site_id') String? siteId,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'created_by') String? created_by,
    @JsonKey(name: 'sent_for_picking_by') String? sentForPickingBy,
    @JsonKey(name: 'sent_for_picking_at') String? sentForPickingAt,
    @JsonKey(name: 'started_packing_at') String? startedPackingAt,
    @JsonKey(name: 'done_packing_at') String? donePackingAt,
    @JsonKey(name: 'created_date') String? createdDate,
    String? updatedAt,
  }) = _PicklistDto;

  factory PicklistDto.fromJson(Map<String, Object?> json) =>
      _$PicklistDtoFromJson(json);

  @override
  Picklist map() => Picklist(
    id: id,
    status: status,
    siteId: siteId,
    createdAt: createdAt,
    createdBy: created_by,
    sentForPickingBy: sentForPickingBy,
    sentForPickingAt: sentForPickingAt,
    startedPackingAt: startedPackingAt,
    donePackingAt: donePackingAt,
    createdDate: createdDate,
    updatedAt: updatedAt,
  );
}