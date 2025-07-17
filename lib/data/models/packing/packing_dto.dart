import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/domain/entities/packing/packing.dart';
import 'package:warehouse/domain/entities/batch/batch.dart';

part 'packing_dto.freezed.dart';
part 'packing_dto.g.dart';

@freezed
class PackingDto with _$PackingDto {
  const PackingDto._();

  const factory PackingDto({
    @JsonKey(name: 'van_allot_id') String? vanAllotId,
    @JsonKey(name: 'van_id') String? vanId,
    required String status,
    @JsonKey(name: 'allot_details') required List<Batch> allotDetails,
  }) = _PackingDto;

  factory PackingDto.fromJson(Map<String, Object?> json) =>
      _$PackingDtoFromJson(json);

  Packing map() => Packing(
    vanAllotId: vanAllotId,
    vanId: vanId,
    status: status,
    allotDetails: allotDetails,
  );
}