
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/data/models/warehouse/warehouse_inventory_dto.dart';

part 'inventory_list_response_dto.freezed.dart';
part 'inventory_list_response_dto.g.dart';

@freezed
class InventoryListResponseDto with _$InventoryListResponseDto {
  const factory InventoryListResponseDto({
    required List<WarehouseInventoryDto> inventory,
  }) = _InventoryListResponseDto;

  factory InventoryListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$InventoryListResponseDtoFromJson(json);
}
