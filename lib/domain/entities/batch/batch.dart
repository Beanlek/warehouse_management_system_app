import 'package:freezed_annotation/freezed_annotation.dart';

part 'batch.freezed.dart';
part 'batch.g.dart';

@freezed
class Batch with _$Batch {
  const Batch._();

  const factory Batch({
    @JsonKey(name: 'sku_id') String? skuId,
    @JsonKey(name: 'uom_id') String? uomId,
    required List<int> quantity,
  }) = _Batch;

  factory Batch.fromJson(Map<String, dynamic> json) => _$BatchFromJson(json);

}