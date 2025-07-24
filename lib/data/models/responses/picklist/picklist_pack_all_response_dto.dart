import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/core/network/interfaces/base_network_model.dart';
import 'package:warehouse/data/models/picklist/picklist_dto.dart';

part 'picklist_pack_all_response_dto.freezed.dart';
part 'picklist_pack_all_response_dto.g.dart';

@freezed
class PicklistPackAllResponseDto with _$PicklistPackAllResponseDto implements BaseNetworkModel<PicklistPackAllResponseDto>{
  const PicklistPackAllResponseDto._();
  
  const factory PicklistPackAllResponseDto({
    required PicklistDto picklist,
  }) = _PicklistPackAllResponseDto;

  factory PicklistPackAllResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PicklistPackAllResponseDtoFromJson(json);

  @override
  PicklistPackAllResponseDto fromJson(Map<String, dynamic> json) {
    return PicklistPackAllResponseDto.fromJson(json);
  }
}
