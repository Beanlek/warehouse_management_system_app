// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_list_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SiteListResponseDtoImpl _$$SiteListResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$SiteListResponseDtoImpl(
      sites: (json['sites'] as List<dynamic>)
          .map((e) => SiteDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SiteListResponseDtoImplToJson(
        _$SiteListResponseDtoImpl instance) =>
    <String, dynamic>{
      'sites': instance.sites,
    };
