// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'picklist_pack_all_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PicklistPackAllResponseDto _$PicklistPackAllResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _PicklistPackAllResponseDto.fromJson(json);
}

/// @nodoc
mixin _$PicklistPackAllResponseDto {
  PicklistDto get picklist => throw _privateConstructorUsedError;

  /// Serializes this PicklistPackAllResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PicklistPackAllResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PicklistPackAllResponseDtoCopyWith<PicklistPackAllResponseDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PicklistPackAllResponseDtoCopyWith<$Res> {
  factory $PicklistPackAllResponseDtoCopyWith(PicklistPackAllResponseDto value,
          $Res Function(PicklistPackAllResponseDto) then) =
      _$PicklistPackAllResponseDtoCopyWithImpl<$Res,
          PicklistPackAllResponseDto>;
  @useResult
  $Res call({PicklistDto picklist});

  $PicklistDtoCopyWith<$Res> get picklist;
}

/// @nodoc
class _$PicklistPackAllResponseDtoCopyWithImpl<$Res,
        $Val extends PicklistPackAllResponseDto>
    implements $PicklistPackAllResponseDtoCopyWith<$Res> {
  _$PicklistPackAllResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PicklistPackAllResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? picklist = null,
  }) {
    return _then(_value.copyWith(
      picklist: null == picklist
          ? _value.picklist
          : picklist // ignore: cast_nullable_to_non_nullable
              as PicklistDto,
    ) as $Val);
  }

  /// Create a copy of PicklistPackAllResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PicklistDtoCopyWith<$Res> get picklist {
    return $PicklistDtoCopyWith<$Res>(_value.picklist, (value) {
      return _then(_value.copyWith(picklist: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PicklistPackAllResponseDtoImplCopyWith<$Res>
    implements $PicklistPackAllResponseDtoCopyWith<$Res> {
  factory _$$PicklistPackAllResponseDtoImplCopyWith(
          _$PicklistPackAllResponseDtoImpl value,
          $Res Function(_$PicklistPackAllResponseDtoImpl) then) =
      __$$PicklistPackAllResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PicklistDto picklist});

  @override
  $PicklistDtoCopyWith<$Res> get picklist;
}

/// @nodoc
class __$$PicklistPackAllResponseDtoImplCopyWithImpl<$Res>
    extends _$PicklistPackAllResponseDtoCopyWithImpl<$Res,
        _$PicklistPackAllResponseDtoImpl>
    implements _$$PicklistPackAllResponseDtoImplCopyWith<$Res> {
  __$$PicklistPackAllResponseDtoImplCopyWithImpl(
      _$PicklistPackAllResponseDtoImpl _value,
      $Res Function(_$PicklistPackAllResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PicklistPackAllResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? picklist = null,
  }) {
    return _then(_$PicklistPackAllResponseDtoImpl(
      picklist: null == picklist
          ? _value.picklist
          : picklist // ignore: cast_nullable_to_non_nullable
              as PicklistDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PicklistPackAllResponseDtoImpl extends _PicklistPackAllResponseDto {
  const _$PicklistPackAllResponseDtoImpl({required this.picklist}) : super._();

  factory _$PicklistPackAllResponseDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PicklistPackAllResponseDtoImplFromJson(json);

  @override
  final PicklistDto picklist;

  @override
  String toString() {
    return 'PicklistPackAllResponseDto(picklist: $picklist)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PicklistPackAllResponseDtoImpl &&
            (identical(other.picklist, picklist) ||
                other.picklist == picklist));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, picklist);

  /// Create a copy of PicklistPackAllResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PicklistPackAllResponseDtoImplCopyWith<_$PicklistPackAllResponseDtoImpl>
      get copyWith => __$$PicklistPackAllResponseDtoImplCopyWithImpl<
          _$PicklistPackAllResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PicklistPackAllResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _PicklistPackAllResponseDto extends PicklistPackAllResponseDto {
  const factory _PicklistPackAllResponseDto(
      {required final PicklistDto picklist}) = _$PicklistPackAllResponseDtoImpl;
  const _PicklistPackAllResponseDto._() : super._();

  factory _PicklistPackAllResponseDto.fromJson(Map<String, dynamic> json) =
      _$PicklistPackAllResponseDtoImpl.fromJson;

  @override
  PicklistDto get picklist;

  /// Create a copy of PicklistPackAllResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PicklistPackAllResponseDtoImplCopyWith<_$PicklistPackAllResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
