import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/core/network/interfaces/base_dto_model.dart';
import 'package:warehouse/data/models/picklist/picklist_dto.dart';
import 'package:warehouse/domain/entities/picklist/picklist_wrapper.dart';

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
class PicklistWrapperDto with _$PicklistWrapperDto implements BaseDtoModel<PicklistWrapper>{
  const PicklistWrapperDto._();

  const factory PicklistWrapperDto({
    int? count,
    @JsonKey(name: 'rows') required List<PicklistDto> rows,
  }) = _PicklistWrapperDto;

  factory PicklistWrapperDto.fromJson(Map<String, dynamic> json) =>
      _$PicklistWrapperDtoFromJson(json);

  @override
  PicklistWrapper map() => PicklistWrapper(
    count: count,
    rows: rows.map((e) => e.map()).toList()
    ); 
}
