import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/data/models/picklist/picklist_dto.dart';

part 'picklist_response_dto.freezed.dart';
part 'picklist_response_dto.g.dart';

@freezed
class PicklistResponseDto with _$PicklistResponseDto {
  const factory PicklistResponseDto({
    required String status,
    required PicklistWrapperDto picklists,
  }) = _PicklistResponseDto;

  factory PicklistResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PicklistResponseDtoFromJson(json);
}

@freezed
class PicklistWrapperDto with _$PicklistWrapperDto {
  const factory PicklistWrapperDto({
    int? count,
    @JsonKey(name: 'rows') required List<PicklistDto> rows,
  }) = _PicklistWrapperDto;

  factory PicklistWrapperDto.fromJson(Map<String, dynamic> json) =>
      _$PicklistWrapperDtoFromJson(json);
}
