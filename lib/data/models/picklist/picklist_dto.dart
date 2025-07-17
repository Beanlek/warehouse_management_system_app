import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';

part 'picklist_dto.freezed.dart';
part 'picklist_dto.g.dart';

@freezed
class PicklistDto with _$PicklistDto {
  const PicklistDto._();

  const factory PicklistDto({
    required String id,
    required String status,
    @JsonKey(name: 'site_id') String? siteId,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'created_by') String? created_by,
  }) = _PicklistDto;

  factory PicklistDto.fromJson(Map<String, Object?> json) =>
      _$PicklistDtoFromJson(json);

  Picklist map() => Picklist(
    id: id,
    status: status,
    siteId: siteId,
    createdAt: createdAt,
    createdBy: created_by,
  );
}