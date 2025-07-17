// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'picklist_details_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PicklistDetailsResponseDto _$PicklistDetailsResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _PicklistDetailsResponseDto.fromJson(json);
}

/// @nodoc
mixin _$PicklistDetailsResponseDto {
  Picklist get picklist => throw _privateConstructorUsedError;
  List<Batch> get batch => throw _privateConstructorUsedError;
  List<Packing> get packing => throw _privateConstructorUsedError;

  /// Serializes this PicklistDetailsResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PicklistDetailsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PicklistDetailsResponseDtoCopyWith<PicklistDetailsResponseDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PicklistDetailsResponseDtoCopyWith<$Res> {
  factory $PicklistDetailsResponseDtoCopyWith(PicklistDetailsResponseDto value,
          $Res Function(PicklistDetailsResponseDto) then) =
      _$PicklistDetailsResponseDtoCopyWithImpl<$Res,
          PicklistDetailsResponseDto>;
  @useResult
  $Res call({Picklist picklist, List<Batch> batch, List<Packing> packing});

  $PicklistCopyWith<$Res> get picklist;
}

/// @nodoc
class _$PicklistDetailsResponseDtoCopyWithImpl<$Res,
        $Val extends PicklistDetailsResponseDto>
    implements $PicklistDetailsResponseDtoCopyWith<$Res> {
  _$PicklistDetailsResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PicklistDetailsResponseDto
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
              as Picklist,
      batch: null == batch
          ? _value.batch
          : batch // ignore: cast_nullable_to_non_nullable
              as List<Batch>,
      packing: null == packing
          ? _value.packing
          : packing // ignore: cast_nullable_to_non_nullable
              as List<Packing>,
    ) as $Val);
  }

  /// Create a copy of PicklistDetailsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PicklistCopyWith<$Res> get picklist {
    return $PicklistCopyWith<$Res>(_value.picklist, (value) {
      return _then(_value.copyWith(picklist: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PicklistDetailsResponseDtoImplCopyWith<$Res>
    implements $PicklistDetailsResponseDtoCopyWith<$Res> {
  factory _$$PicklistDetailsResponseDtoImplCopyWith(
          _$PicklistDetailsResponseDtoImpl value,
          $Res Function(_$PicklistDetailsResponseDtoImpl) then) =
      __$$PicklistDetailsResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Picklist picklist, List<Batch> batch, List<Packing> packing});

  @override
  $PicklistCopyWith<$Res> get picklist;
}

/// @nodoc
class __$$PicklistDetailsResponseDtoImplCopyWithImpl<$Res>
    extends _$PicklistDetailsResponseDtoCopyWithImpl<$Res,
        _$PicklistDetailsResponseDtoImpl>
    implements _$$PicklistDetailsResponseDtoImplCopyWith<$Res> {
  __$$PicklistDetailsResponseDtoImplCopyWithImpl(
      _$PicklistDetailsResponseDtoImpl _value,
      $Res Function(_$PicklistDetailsResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PicklistDetailsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? picklist = null,
    Object? batch = null,
    Object? packing = null,
  }) {
    return _then(_$PicklistDetailsResponseDtoImpl(
      picklist: null == picklist
          ? _value.picklist
          : picklist // ignore: cast_nullable_to_non_nullable
              as Picklist,
      batch: null == batch
          ? _value._batch
          : batch // ignore: cast_nullable_to_non_nullable
              as List<Batch>,
      packing: null == packing
          ? _value._packing
          : packing // ignore: cast_nullable_to_non_nullable
              as List<Packing>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PicklistDetailsResponseDtoImpl implements _PicklistDetailsResponseDto {
  const _$PicklistDetailsResponseDtoImpl(
      {required this.picklist,
      required final List<Batch> batch,
      required final List<Packing> packing})
      : _batch = batch,
        _packing = packing;

  factory _$PicklistDetailsResponseDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PicklistDetailsResponseDtoImplFromJson(json);

  @override
  final Picklist picklist;
  final List<Batch> _batch;
  @override
  List<Batch> get batch {
    if (_batch is EqualUnmodifiableListView) return _batch;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_batch);
  }

  final List<Packing> _packing;
  @override
  List<Packing> get packing {
    if (_packing is EqualUnmodifiableListView) return _packing;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_packing);
  }

  @override
  String toString() {
    return 'PicklistDetailsResponseDto(picklist: $picklist, batch: $batch, packing: $packing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PicklistDetailsResponseDtoImpl &&
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

  /// Create a copy of PicklistDetailsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PicklistDetailsResponseDtoImplCopyWith<_$PicklistDetailsResponseDtoImpl>
      get copyWith => __$$PicklistDetailsResponseDtoImplCopyWithImpl<
          _$PicklistDetailsResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PicklistDetailsResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _PicklistDetailsResponseDto
    implements PicklistDetailsResponseDto {
  const factory _PicklistDetailsResponseDto(
      {required final Picklist picklist,
      required final List<Batch> batch,
      required final List<Packing> packing}) = _$PicklistDetailsResponseDtoImpl;

  factory _PicklistDetailsResponseDto.fromJson(Map<String, dynamic> json) =
      _$PicklistDetailsResponseDtoImpl.fromJson;

  @override
  Picklist get picklist;
  @override
  List<Batch> get batch;
  @override
  List<Packing> get packing;

  /// Create a copy of PicklistDetailsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PicklistDetailsResponseDtoImplCopyWith<_$PicklistDetailsResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PicklistDetailsWrapperDto _$PicklistDetailsWrapperDtoFromJson(
    Map<String, dynamic> json) {
  return _PicklistDetailsWrapperDto.fromJson(json);
}

/// @nodoc
mixin _$PicklistDetailsWrapperDto {
  Picklist get picklist => throw _privateConstructorUsedError;
  List<Batch> get batch => throw _privateConstructorUsedError;
  List<Packing> get packing => throw _privateConstructorUsedError;

  /// Serializes this PicklistDetailsWrapperDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PicklistDetailsWrapperDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PicklistDetailsWrapperDtoCopyWith<PicklistDetailsWrapperDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PicklistDetailsWrapperDtoCopyWith<$Res> {
  factory $PicklistDetailsWrapperDtoCopyWith(PicklistDetailsWrapperDto value,
          $Res Function(PicklistDetailsWrapperDto) then) =
      _$PicklistDetailsWrapperDtoCopyWithImpl<$Res, PicklistDetailsWrapperDto>;
  @useResult
  $Res call({Picklist picklist, List<Batch> batch, List<Packing> packing});

  $PicklistCopyWith<$Res> get picklist;
}

/// @nodoc
class _$PicklistDetailsWrapperDtoCopyWithImpl<$Res,
        $Val extends PicklistDetailsWrapperDto>
    implements $PicklistDetailsWrapperDtoCopyWith<$Res> {
  _$PicklistDetailsWrapperDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PicklistDetailsWrapperDto
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
              as Picklist,
      batch: null == batch
          ? _value.batch
          : batch // ignore: cast_nullable_to_non_nullable
              as List<Batch>,
      packing: null == packing
          ? _value.packing
          : packing // ignore: cast_nullable_to_non_nullable
              as List<Packing>,
    ) as $Val);
  }

  /// Create a copy of PicklistDetailsWrapperDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PicklistCopyWith<$Res> get picklist {
    return $PicklistCopyWith<$Res>(_value.picklist, (value) {
      return _then(_value.copyWith(picklist: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PicklistDetailsWrapperDtoImplCopyWith<$Res>
    implements $PicklistDetailsWrapperDtoCopyWith<$Res> {
  factory _$$PicklistDetailsWrapperDtoImplCopyWith(
          _$PicklistDetailsWrapperDtoImpl value,
          $Res Function(_$PicklistDetailsWrapperDtoImpl) then) =
      __$$PicklistDetailsWrapperDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Picklist picklist, List<Batch> batch, List<Packing> packing});

  @override
  $PicklistCopyWith<$Res> get picklist;
}

/// @nodoc
class __$$PicklistDetailsWrapperDtoImplCopyWithImpl<$Res>
    extends _$PicklistDetailsWrapperDtoCopyWithImpl<$Res,
        _$PicklistDetailsWrapperDtoImpl>
    implements _$$PicklistDetailsWrapperDtoImplCopyWith<$Res> {
  __$$PicklistDetailsWrapperDtoImplCopyWithImpl(
      _$PicklistDetailsWrapperDtoImpl _value,
      $Res Function(_$PicklistDetailsWrapperDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PicklistDetailsWrapperDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? picklist = null,
    Object? batch = null,
    Object? packing = null,
  }) {
    return _then(_$PicklistDetailsWrapperDtoImpl(
      picklist: null == picklist
          ? _value.picklist
          : picklist // ignore: cast_nullable_to_non_nullable
              as Picklist,
      batch: null == batch
          ? _value._batch
          : batch // ignore: cast_nullable_to_non_nullable
              as List<Batch>,
      packing: null == packing
          ? _value._packing
          : packing // ignore: cast_nullable_to_non_nullable
              as List<Packing>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PicklistDetailsWrapperDtoImpl implements _PicklistDetailsWrapperDto {
  const _$PicklistDetailsWrapperDtoImpl(
      {required this.picklist,
      required final List<Batch> batch,
      required final List<Packing> packing})
      : _batch = batch,
        _packing = packing;

  factory _$PicklistDetailsWrapperDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PicklistDetailsWrapperDtoImplFromJson(json);

  @override
  final Picklist picklist;
  final List<Batch> _batch;
  @override
  List<Batch> get batch {
    if (_batch is EqualUnmodifiableListView) return _batch;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_batch);
  }

  final List<Packing> _packing;
  @override
  List<Packing> get packing {
    if (_packing is EqualUnmodifiableListView) return _packing;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_packing);
  }

  @override
  String toString() {
    return 'PicklistDetailsWrapperDto(picklist: $picklist, batch: $batch, packing: $packing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PicklistDetailsWrapperDtoImpl &&
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

  /// Create a copy of PicklistDetailsWrapperDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PicklistDetailsWrapperDtoImplCopyWith<_$PicklistDetailsWrapperDtoImpl>
      get copyWith => __$$PicklistDetailsWrapperDtoImplCopyWithImpl<
          _$PicklistDetailsWrapperDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PicklistDetailsWrapperDtoImplToJson(
      this,
    );
  }
}

abstract class _PicklistDetailsWrapperDto implements PicklistDetailsWrapperDto {
  const factory _PicklistDetailsWrapperDto(
      {required final Picklist picklist,
      required final List<Batch> batch,
      required final List<Packing> packing}) = _$PicklistDetailsWrapperDtoImpl;

  factory _PicklistDetailsWrapperDto.fromJson(Map<String, dynamic> json) =
      _$PicklistDetailsWrapperDtoImpl.fromJson;

  @override
  Picklist get picklist;
  @override
  List<Batch> get batch;
  @override
  List<Packing> get packing;

  /// Create a copy of PicklistDetailsWrapperDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PicklistDetailsWrapperDtoImplCopyWith<_$PicklistDetailsWrapperDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
