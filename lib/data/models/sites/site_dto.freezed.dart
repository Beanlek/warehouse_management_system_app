// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'site_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SiteDto _$SiteDtoFromJson(Map<String, dynamic> json) {
  return _SiteDto.fromJson(json);
}

/// @nodoc
mixin _$SiteDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this SiteDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SiteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SiteDtoCopyWith<SiteDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SiteDtoCopyWith<$Res> {
  factory $SiteDtoCopyWith(SiteDto value, $Res Function(SiteDto) then) =
      _$SiteDtoCopyWithImpl<$Res, SiteDto>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$SiteDtoCopyWithImpl<$Res, $Val extends SiteDto>
    implements $SiteDtoCopyWith<$Res> {
  _$SiteDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SiteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SiteDtoImplCopyWith<$Res> implements $SiteDtoCopyWith<$Res> {
  factory _$$SiteDtoImplCopyWith(
          _$SiteDtoImpl value, $Res Function(_$SiteDtoImpl) then) =
      __$$SiteDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$SiteDtoImplCopyWithImpl<$Res>
    extends _$SiteDtoCopyWithImpl<$Res, _$SiteDtoImpl>
    implements _$$SiteDtoImplCopyWith<$Res> {
  __$$SiteDtoImplCopyWithImpl(
      _$SiteDtoImpl _value, $Res Function(_$SiteDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SiteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$SiteDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SiteDtoImpl extends _SiteDto {
  const _$SiteDtoImpl({required this.id, required this.name}) : super._();

  factory _$SiteDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SiteDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'SiteDto(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SiteDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of SiteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SiteDtoImplCopyWith<_$SiteDtoImpl> get copyWith =>
      __$$SiteDtoImplCopyWithImpl<_$SiteDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SiteDtoImplToJson(
      this,
    );
  }
}

abstract class _SiteDto extends SiteDto {
  const factory _SiteDto(
      {required final String id, required final String name}) = _$SiteDtoImpl;
  const _SiteDto._() : super._();

  factory _SiteDto.fromJson(Map<String, dynamic> json) = _$SiteDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of SiteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SiteDtoImplCopyWith<_$SiteDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
