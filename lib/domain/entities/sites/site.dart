import 'package:freezed_annotation/freezed_annotation.dart';

part 'site.freezed.dart';

@freezed
class Site with _$Site {
  const Site._();

  const factory Site({
    required String id,
    required String name,
  }) = _Site;
}