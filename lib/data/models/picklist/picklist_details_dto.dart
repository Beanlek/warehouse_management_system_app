import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/domain/entities/batch/batch.dart';
import 'package:warehouse/domain/entities/packing/packing.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';
import 'package:warehouse/domain/entities/picklist/picklist_details.dart';

part 'picklist_details_dto.freezed.dart';
part 'picklist_details_dto.g.dart';

@freezed
class PicklistDetailsDto with _$PicklistDetailsDto {
  const PicklistDetailsDto._();

  const factory PicklistDetailsDto({
    required Picklist picklist,
    required List<Batch> batch,
    required List<Packing> packing,
  }) = _PicklistDetailsDto;

  factory PicklistDetailsDto.fromJson(Map<String, Object?> json) =>
      _$PicklistDetailsDtoFromJson(json);

  PicklistDetails map() => PicklistDetails(
    picklist: picklist,
    batch: batch,
    packing: packing
  );
}