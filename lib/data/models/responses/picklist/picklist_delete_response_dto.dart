import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/core/network/interfaces/base_network_model.dart';

part 'picklist_delete_response_dto.freezed.dart';
part 'picklist_delete_response_dto.g.dart';

@freezed
class PicklistDeleteResponseDto with _$PicklistDeleteResponseDto implements BaseNetworkModel<PicklistDeleteResponseDto>{
  const PicklistDeleteResponseDto._();
  
  const factory PicklistDeleteResponseDto({
    required String id,
  }) = _PicklistDeleteResponseDto;

  factory PicklistDeleteResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PicklistDeleteResponseDtoFromJson(json);

  @override
  PicklistDeleteResponseDto fromJson(Map<String, dynamic> json) {
    return PicklistDeleteResponseDto.fromJson(json);
  }
}
