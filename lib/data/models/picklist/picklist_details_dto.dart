import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/core/network/interfaces/base_dto_model.dart';
import 'package:warehouse/data/models/batch/batch_dto.dart';
import 'package:warehouse/data/models/packing/packing_dto.dart';
import 'package:warehouse/data/models/picklist/picklist_dto.dart';
import 'package:warehouse/domain/entities/batch/batch.dart';
import 'package:warehouse/domain/entities/packing/packing.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';
import 'package:warehouse/domain/entities/picklist/picklist_details.dart';

part 'picklist_details_dto.freezed.dart';
part 'picklist_details_dto.g.dart';

@freezed
class PicklistDetailsDto with _$PicklistDetailsDto implements BaseDtoModel<PicklistDetails>{
  const PicklistDetailsDto._();

  const factory PicklistDetailsDto({
    required PicklistDto picklist,
    required List<BatchDto> batch,
    required List<PackingDto> packing,
  }) = _PicklistDetailsDto;

  factory PicklistDetailsDto.fromJson(Map<String, Object?> json) =>
      _$PicklistDetailsDtoFromJson(json);

  @override
  PicklistDetails map() {
    final picklistMapped = [picklist].map((e) => e.map()).whereType<Picklist>().toList()[0];
    final batchMapped = batch.map((e) => e.map()).whereType<Batch>().toList();
    final packingMapped = packing.map((e) => e.map()).whereType<Packing>().toList();
    
    return PicklistDetails(
      picklist: picklistMapped,
      batch: batchMapped,
      packing: packingMapped
    );
  }
}