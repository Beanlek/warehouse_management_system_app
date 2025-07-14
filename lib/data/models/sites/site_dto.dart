import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/domain/entities/sites/site.dart';

part 'site_dto.freezed.dart';
part 'site_dto.g.dart';

@freezed
class SiteDto with _$SiteDto {
  const SiteDto._();

  const factory SiteDto({
    required String id,
    required String name,
  }) = _SiteDto;

  factory SiteDto.fromJson(Map<String, Object?> json) =>
      _$SiteDtoFromJson(json);

  Site map() => Site(id: id, name: name);
}