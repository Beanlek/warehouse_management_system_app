import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/domain/entities/batch/batch.dart';

part 'packing.freezed.dart';
part 'packing.g.dart';

@freezed
class Packing with _$Packing {
  const Packing._();

  const factory Packing({
    @JsonKey(name: 'van_allot_id') String? vanAllotId,
    @JsonKey(name: 'van_id') String? vanId,
    required String status,
    @JsonKey(name: 'allot_details') required List<Batch> allotDetails,
  }) = _Packing;

  factory Packing.fromJson(Map<String, dynamic> json) => _$PackingFromJson(json);
  
}