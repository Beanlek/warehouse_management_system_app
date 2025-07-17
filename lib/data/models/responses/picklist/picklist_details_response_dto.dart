import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/data/models/picklist/picklist_details_dto.dart';
import 'package:warehouse/domain/entities/batch/batch.dart';
import 'package:warehouse/domain/entities/packing/packing.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';

part 'picklist_details_response_dto.freezed.dart';
part 'picklist_details_response_dto.g.dart';

@freezed
class PicklistDetailsResponseDto with _$PicklistDetailsResponseDto {
  const factory PicklistDetailsResponseDto({
    required Picklist picklist,
    required List<Batch> batch,
    required List<Packing> packing,
  }) = _PicklistDetailsResponseDto;

  factory PicklistDetailsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PicklistDetailsResponseDtoFromJson(json);
}

@freezed
class PicklistDetailsWrapperDto with _$PicklistDetailsWrapperDto {
  const factory PicklistDetailsWrapperDto({
    required Picklist picklist,
    required List<Batch> batch,
    required List<Packing> packing,
  }) = _PicklistDetailsWrapperDto;

  factory PicklistDetailsWrapperDto.fromJson(Map<String, dynamic> json) =>
      _$PicklistDetailsWrapperDtoFromJson(json);
}
