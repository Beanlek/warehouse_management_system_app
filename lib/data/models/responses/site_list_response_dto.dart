
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/data/models/sites/site_dto.dart';

part 'site_list_response_dto.freezed.dart';
part 'site_list_response_dto.g.dart';

@freezed
class SiteListResponseDto with _$SiteListResponseDto {
  const factory SiteListResponseDto({
    required List<SiteDto> sites,
  }) = _SiteListResponseDto;

  factory SiteListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SiteListResponseDtoFromJson(json);
}
