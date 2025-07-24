// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'picklist_delete_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PicklistDeleteResponseDto _$PicklistDeleteResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _PicklistDeleteResponseDto.fromJson(json);
}

/// @nodoc
mixin _$PicklistDeleteResponseDto {
  String get id => throw _privateConstructorUsedError;

  /// Serializes this PicklistDeleteResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PicklistDeleteResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PicklistDeleteResponseDtoCopyWith<PicklistDeleteResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PicklistDeleteResponseDtoCopyWith<$Res> {
  factory $PicklistDeleteResponseDtoCopyWith(PicklistDeleteResponseDto value,
          $Res Function(PicklistDeleteResponseDto) then) =
      _$PicklistDeleteResponseDtoCopyWithImpl<$Res, PicklistDeleteResponseDto>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class _$PicklistDeleteResponseDtoCopyWithImpl<$Res,
        $Val extends PicklistDeleteResponseDto>
    implements $PicklistDeleteResponseDtoCopyWith<$Res> {
  _$PicklistDeleteResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PicklistDeleteResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PicklistDeleteResponseDtoImplCopyWith<$Res>
    implements $PicklistDeleteResponseDtoCopyWith<$Res> {
  factory _$$PicklistDeleteResponseDtoImplCopyWith(
          _$PicklistDeleteResponseDtoImpl value,
          $Res Function(_$PicklistDeleteResponseDtoImpl) then) =
      __$$PicklistDeleteResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$PicklistDeleteResponseDtoImplCopyWithImpl<$Res>
    extends _$PicklistDeleteResponseDtoCopyWithImpl<$Res,
        _$PicklistDeleteResponseDtoImpl>
    implements _$$PicklistDeleteResponseDtoImplCopyWith<$Res> {
  __$$PicklistDeleteResponseDtoImplCopyWithImpl(
      _$PicklistDeleteResponseDtoImpl _value,
      $Res Function(_$PicklistDeleteResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PicklistDeleteResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_$PicklistDeleteResponseDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PicklistDeleteResponseDtoImpl extends _PicklistDeleteResponseDto {
  const _$PicklistDeleteResponseDtoImpl({required this.id}) : super._();

  factory _$PicklistDeleteResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PicklistDeleteResponseDtoImplFromJson(json);

  @override
  final String id;

  @override
  String toString() {
    return 'PicklistDeleteResponseDto(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PicklistDeleteResponseDtoImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of PicklistDeleteResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PicklistDeleteResponseDtoImplCopyWith<_$PicklistDeleteResponseDtoImpl>
      get copyWith => __$$PicklistDeleteResponseDtoImplCopyWithImpl<
          _$PicklistDeleteResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PicklistDeleteResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _PicklistDeleteResponseDto extends PicklistDeleteResponseDto {
  const factory _PicklistDeleteResponseDto({required final String id}) =
      _$PicklistDeleteResponseDtoImpl;
  const _PicklistDeleteResponseDto._() : super._();

  factory _PicklistDeleteResponseDto.fromJson(Map<String, dynamic> json) =
      _$PicklistDeleteResponseDtoImpl.fromJson;

  @override
  String get id;

  /// Create a copy of PicklistDeleteResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PicklistDeleteResponseDtoImplCopyWith<_$PicklistDeleteResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
