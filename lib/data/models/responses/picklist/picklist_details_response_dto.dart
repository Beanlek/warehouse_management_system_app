import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/data/models/batch/batch_dto.dart';
import 'package:warehouse/data/models/packing/packing_dto.dart';
import 'package:warehouse/data/models/picklist/picklist_dto.dart';
import 'package:warehouse/domain/entities/picklist/picklist_details.dart';

part 'picklist_details_response_dto.freezed.dart';
part 'picklist_details_response_dto.g.dart';

@freezed
class PicklistDetailsResponseDto with _$PicklistDetailsResponseDto {
  const factory PicklistDetailsResponseDto({
    required PicklistDto picklist,
    required List<BatchDto> batch,
    required List<PackingDto> packing,
  }) = _PicklistDetailsResponseDto;

  factory PicklistDetailsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PicklistDetailsResponseDtoFromJson(json);

  // factory PicklistDetailsResponseDto.map() => PicklistDetails(
  //   picklist: picklist.map(),
  //   batch: batch.map((b) => b.map()).toList(),
  //   packing: packing.map((p) => p.map()).toList(),
  // );
}

@freezed
class PicklistDetailsWrapperDto with _$PicklistDetailsWrapperDto {
  const factory PicklistDetailsWrapperDto({
    required PicklistDto picklist,
    required List<BatchDto> batch,
    required List<PackingDto> packing,
  }) = _PicklistDetailsWrapperDto;

  factory PicklistDetailsWrapperDto.fromJson(Map<String, dynamic> json) =>
      _$PicklistDetailsWrapperDtoFromJson(json);
}
