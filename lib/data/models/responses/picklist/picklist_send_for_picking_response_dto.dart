import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/core/network/interfaces/base_network_model.dart';

part 'picklist_send_for_picking_response_dto.freezed.dart';
part 'picklist_send_for_picking_response_dto.g.dart';

@freezed
class PicklistSendForPickingResponseDto with _$PicklistSendForPickingResponseDto implements BaseNetworkModel<PicklistSendForPickingResponseDto>{
  const PicklistSendForPickingResponseDto._();
  
  const factory PicklistSendForPickingResponseDto({
    required String id,
  }) = _PicklistSendForPickingResponseDto;

  factory PicklistSendForPickingResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PicklistSendForPickingResponseDtoFromJson(json);

  @override
  PicklistSendForPickingResponseDto fromJson(Map<String, dynamic> json) {
    return PicklistSendForPickingResponseDto.fromJson(json);
  }
}
