// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'site_list_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SiteListResponseDto _$SiteListResponseDtoFromJson(Map<String, dynamic> json) {
  return _SiteListResponseDto.fromJson(json);
}

/// @nodoc
mixin _$SiteListResponseDto {
  List<SiteDto> get sites => throw _privateConstructorUsedError;

  /// Serializes this SiteListResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SiteListResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SiteListResponseDtoCopyWith<SiteListResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SiteListResponseDtoCopyWith<$Res> {
  factory $SiteListResponseDtoCopyWith(
          SiteListResponseDto value, $Res Function(SiteListResponseDto) then) =
      _$SiteListResponseDtoCopyWithImpl<$Res, SiteListResponseDto>;
  @useResult
  $Res call({List<SiteDto> sites});
}

/// @nodoc
class _$SiteListResponseDtoCopyWithImpl<$Res, $Val extends SiteListResponseDto>
    implements $SiteListResponseDtoCopyWith<$Res> {
  _$SiteListResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SiteListResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sites = null,
  }) {
    return _then(_value.copyWith(
      sites: null == sites
          ? _value.sites
          : sites // ignore: cast_nullable_to_non_nullable
              as List<SiteDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SiteListResponseDtoImplCopyWith<$Res>
    implements $SiteListResponseDtoCopyWith<$Res> {
  factory _$$SiteListResponseDtoImplCopyWith(_$SiteListResponseDtoImpl value,
          $Res Function(_$SiteListResponseDtoImpl) then) =
      __$$SiteListResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SiteDto> sites});
}

/// @nodoc
class __$$SiteListResponseDtoImplCopyWithImpl<$Res>
    extends _$SiteListResponseDtoCopyWithImpl<$Res, _$SiteListResponseDtoImpl>
    implements _$$SiteListResponseDtoImplCopyWith<$Res> {
  __$$SiteListResponseDtoImplCopyWithImpl(_$SiteListResponseDtoImpl _value,
      $Res Function(_$SiteListResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SiteListResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sites = null,
  }) {
    return _then(_$SiteListResponseDtoImpl(
      sites: null == sites
          ? _value._sites
          : sites // ignore: cast_nullable_to_non_nullable
              as List<SiteDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SiteListResponseDtoImpl implements _SiteListResponseDto {
  const _$SiteListResponseDtoImpl({required final List<SiteDto> sites})
      : _sites = sites;

  factory _$SiteListResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SiteListResponseDtoImplFromJson(json);

  final List<SiteDto> _sites;
  @override
  List<SiteDto> get sites {
    if (_sites is EqualUnmodifiableListView) return _sites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sites);
  }

  @override
  String toString() {
    return 'SiteListResponseDto(sites: $sites)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SiteListResponseDtoImpl &&
            const DeepCollectionEquality().equals(other._sites, _sites));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_sites));

  /// Create a copy of SiteListResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SiteListResponseDtoImplCopyWith<_$SiteListResponseDtoImpl> get copyWith =>
      __$$SiteListResponseDtoImplCopyWithImpl<_$SiteListResponseDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SiteListResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _SiteListResponseDto implements SiteListResponseDto {
  const factory _SiteListResponseDto({required final List<SiteDto> sites}) =
      _$SiteListResponseDtoImpl;

  factory _SiteListResponseDto.fromJson(Map<String, dynamic> json) =
      _$SiteListResponseDtoImpl.fromJson;

  @override
  List<SiteDto> get sites;

  /// Create a copy of SiteListResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SiteListResponseDtoImplCopyWith<_$SiteListResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
