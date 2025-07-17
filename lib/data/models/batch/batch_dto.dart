import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/domain/entities/batch/batch.dart';

part 'batch_dto.freezed.dart';
part 'batch_dto.g.dart';

@freezed
class BatchDto with _$BatchDto {
  const BatchDto._();

  const factory BatchDto({
    @JsonKey(name: 'sku_id') String? skuId,
    @JsonKey(name: 'uom_id') String? uomId,
    required List<int> quantity,
  }) = _BatchDto;

  factory BatchDto.fromJson(Map<String, Object?> json) =>
      _$BatchDtoFromJson(json);

  Batch map() => Batch(
    skuId: skuId,
    uomId: uomId,
    quantity: quantity,
  );
}