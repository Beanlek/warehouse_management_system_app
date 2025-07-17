// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'picklist_details_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PicklistDetailsDto _$PicklistDetailsDtoFromJson(Map<String, dynamic> json) {
  return _PicklistDetailsDto.fromJson(json);
}

/// @nodoc
mixin _$PicklistDetailsDto {
  PicklistDto get picklist => throw _privateConstructorUsedError;
  List<BatchDto> get batch => throw _privateConstructorUsedError;
  List<PackingDto> get packing => throw _privateConstructorUsedError;

  /// Serializes this PicklistDetailsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PicklistDetailsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PicklistDetailsDtoCopyWith<PicklistDetailsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PicklistDetailsDtoCopyWith<$Res> {
  factory $PicklistDetailsDtoCopyWith(
          PicklistDetailsDto value, $Res Function(PicklistDetailsDto) then) =
      _$PicklistDetailsDtoCopyWithImpl<$Res, PicklistDetailsDto>;
  @useResult
  $Res call(
      {PicklistDto picklist, List<BatchDto> batch, List<PackingDto> packing});

  $PicklistDtoCopyWith<$Res> get picklist;
}

/// @nodoc
class _$PicklistDetailsDtoCopyWithImpl<$Res, $Val extends PicklistDetailsDto>
    implements $PicklistDetailsDtoCopyWith<$Res> {
  _$PicklistDetailsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PicklistDetailsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? picklist = null,
    Object? batch = null,
    Object? packing = null,
  }) {
    return _then(_value.copyWith(
      picklist: null == picklist
          ? _value.picklist
          : picklist // ignore: cast_nullable_to_non_nullable
              as PicklistDto,
      batch: null == batch
          ? _value.batch
          : batch // ignore: cast_nullable_to_non_nullable
              as List<BatchDto>,
      packing: null == packing
          ? _value.packing
          : packing // ignore: cast_nullable_to_non_nullable
              as List<PackingDto>,
    ) as $Val);
  }

  /// Create a copy of PicklistDetailsDto
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
abstract class _$$PicklistDetailsDtoImplCopyWith<$Res>
    implements $PicklistDetailsDtoCopyWith<$Res> {
  factory _$$PicklistDetailsDtoImplCopyWith(_$PicklistDetailsDtoImpl value,
          $Res Function(_$PicklistDetailsDtoImpl) then) =
      __$$PicklistDetailsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PicklistDto picklist, List<BatchDto> batch, List<PackingDto> packing});

  @override
  $PicklistDtoCopyWith<$Res> get picklist;
}

/// @nodoc
class __$$PicklistDetailsDtoImplCopyWithImpl<$Res>
    extends _$PicklistDetailsDtoCopyWithImpl<$Res, _$PicklistDetailsDtoImpl>
    implements _$$PicklistDetailsDtoImplCopyWith<$Res> {
  __$$PicklistDetailsDtoImplCopyWithImpl(_$PicklistDetailsDtoImpl _value,
      $Res Function(_$PicklistDetailsDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PicklistDetailsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? picklist = null,
    Object? batch = null,
    Object? packing = null,
  }) {
    return _then(_$PicklistDetailsDtoImpl(
      picklist: null == picklist
          ? _value.picklist
          : picklist // ignore: cast_nullable_to_non_nullable
              as PicklistDto,
      batch: null == batch
          ? _value._batch
          : batch // ignore: cast_nullable_to_non_nullable
              as List<BatchDto>,
      packing: null == packing
          ? _value._packing
          : packing // ignore: cast_nullable_to_non_nullable
              as List<PackingDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PicklistDetailsDtoImpl extends _PicklistDetailsDto {
  const _$PicklistDetailsDtoImpl(
      {required this.picklist,
      required final List<BatchDto> batch,
      required final List<PackingDto> packing})
      : _batch = batch,
        _packing = packing,
        super._();

  factory _$PicklistDetailsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PicklistDetailsDtoImplFromJson(json);

  @override
  final PicklistDto picklist;
  final List<BatchDto> _batch;
  @override
  List<BatchDto> get batch {
    if (_batch is EqualUnmodifiableListView) return _batch;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_batch);
  }

  final List<PackingDto> _packing;
  @override
  List<PackingDto> get packing {
    if (_packing is EqualUnmodifiableListView) return _packing;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_packing);
  }

  @override
  String toString() {
    return 'PicklistDetailsDto(picklist: $picklist, batch: $batch, packing: $packing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PicklistDetailsDtoImpl &&
            (identical(other.picklist, picklist) ||
                other.picklist == picklist) &&
            const DeepCollectionEquality().equals(other._batch, _batch) &&
            const DeepCollectionEquality().equals(other._packing, _packing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      picklist,
      const DeepCollectionEquality().hash(_batch),
      const DeepCollectionEquality().hash(_packing));

  /// Create a copy of PicklistDetailsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PicklistDetailsDtoImplCopyWith<_$PicklistDetailsDtoImpl> get copyWith =>
      __$$PicklistDetailsDtoImplCopyWithImpl<_$PicklistDetailsDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PicklistDetailsDtoImplToJson(
      this,
    );
  }
}

abstract class _PicklistDetailsDto extends PicklistDetailsDto {
  const factory _PicklistDetailsDto(
      {required final PicklistDto picklist,
      required final List<BatchDto> batch,
      required final List<PackingDto> packing}) = _$PicklistDetailsDtoImpl;
  const _PicklistDetailsDto._() : super._();

  factory _PicklistDetailsDto.fromJson(Map<String, dynamic> json) =
      _$PicklistDetailsDtoImpl.fromJson;

  @override
  PicklistDto get picklist;
  @override
  List<BatchDto> get batch;
  @override
  List<PackingDto> get packing;

  /// Create a copy of PicklistDetailsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PicklistDetailsDtoImplCopyWith<_$PicklistDetailsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
