// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'picklist_send_for_picking_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PicklistSendForPickingResponseDto _$PicklistSendForPickingResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _PicklistSendForPickingResponseDto.fromJson(json);
}

/// @nodoc
mixin _$PicklistSendForPickingResponseDto {
  String get id => throw _privateConstructorUsedError;

  /// Serializes this PicklistSendForPickingResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PicklistSendForPickingResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PicklistSendForPickingResponseDtoCopyWith<PicklistSendForPickingResponseDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PicklistSendForPickingResponseDtoCopyWith<$Res> {
  factory $PicklistSendForPickingResponseDtoCopyWith(
          PicklistSendForPickingResponseDto value,
          $Res Function(PicklistSendForPickingResponseDto) then) =
      _$PicklistSendForPickingResponseDtoCopyWithImpl<$Res,
          PicklistSendForPickingResponseDto>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class _$PicklistSendForPickingResponseDtoCopyWithImpl<$Res,
        $Val extends PicklistSendForPickingResponseDto>
    implements $PicklistSendForPickingResponseDtoCopyWith<$Res> {
  _$PicklistSendForPickingResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PicklistSendForPickingResponseDto
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
abstract class _$$PicklistSendForPickingResponseDtoImplCopyWith<$Res>
    implements $PicklistSendForPickingResponseDtoCopyWith<$Res> {
  factory _$$PicklistSendForPickingResponseDtoImplCopyWith(
          _$PicklistSendForPickingResponseDtoImpl value,
          $Res Function(_$PicklistSendForPickingResponseDtoImpl) then) =
      __$$PicklistSendForPickingResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$PicklistSendForPickingResponseDtoImplCopyWithImpl<$Res>
    extends _$PicklistSendForPickingResponseDtoCopyWithImpl<$Res,
        _$PicklistSendForPickingResponseDtoImpl>
    implements _$$PicklistSendForPickingResponseDtoImplCopyWith<$Res> {
  __$$PicklistSendForPickingResponseDtoImplCopyWithImpl(
      _$PicklistSendForPickingResponseDtoImpl _value,
      $Res Function(_$PicklistSendForPickingResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PicklistSendForPickingResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_$PicklistSendForPickingResponseDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PicklistSendForPickingResponseDtoImpl
    extends _PicklistSendForPickingResponseDto {
  const _$PicklistSendForPickingResponseDtoImpl({required this.id}) : super._();

  factory _$PicklistSendForPickingResponseDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PicklistSendForPickingResponseDtoImplFromJson(json);

  @override
  final String id;

  @override
  String toString() {
    return 'PicklistSendForPickingResponseDto(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PicklistSendForPickingResponseDtoImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of PicklistSendForPickingResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PicklistSendForPickingResponseDtoImplCopyWith<
          _$PicklistSendForPickingResponseDtoImpl>
      get copyWith => __$$PicklistSendForPickingResponseDtoImplCopyWithImpl<
          _$PicklistSendForPickingResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PicklistSendForPickingResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _PicklistSendForPickingResponseDto
    extends PicklistSendForPickingResponseDto {
  const factory _PicklistSendForPickingResponseDto({required final String id}) =
      _$PicklistSendForPickingResponseDtoImpl;
  const _PicklistSendForPickingResponseDto._() : super._();

  factory _PicklistSendForPickingResponseDto.fromJson(
          Map<String, dynamic> json) =
      _$PicklistSendForPickingResponseDtoImpl.fromJson;

  @override
  String get id;

  /// Create a copy of PicklistSendForPickingResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PicklistSendForPickingResponseDtoImplCopyWith<
          _$PicklistSendForPickingResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
