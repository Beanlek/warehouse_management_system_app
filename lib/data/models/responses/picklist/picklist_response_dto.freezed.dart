// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'picklist_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PicklistResponseDto _$PicklistResponseDtoFromJson(Map<String, dynamic> json) {
  return _PicklistResponseDto.fromJson(json);
}

/// @nodoc
mixin _$PicklistResponseDto {
  String get status => throw _privateConstructorUsedError;
  PicklistWrapperDto get picklists => throw _privateConstructorUsedError;

  /// Serializes this PicklistResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PicklistResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PicklistResponseDtoCopyWith<PicklistResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PicklistResponseDtoCopyWith<$Res> {
  factory $PicklistResponseDtoCopyWith(
          PicklistResponseDto value, $Res Function(PicklistResponseDto) then) =
      _$PicklistResponseDtoCopyWithImpl<$Res, PicklistResponseDto>;
  @useResult
  $Res call({String status, PicklistWrapperDto picklists});

  $PicklistWrapperDtoCopyWith<$Res> get picklists;
}

/// @nodoc
class _$PicklistResponseDtoCopyWithImpl<$Res, $Val extends PicklistResponseDto>
    implements $PicklistResponseDtoCopyWith<$Res> {
  _$PicklistResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PicklistResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? picklists = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      picklists: null == picklists
          ? _value.picklists
          : picklists // ignore: cast_nullable_to_non_nullable
              as PicklistWrapperDto,
    ) as $Val);
  }

  /// Create a copy of PicklistResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PicklistWrapperDtoCopyWith<$Res> get picklists {
    return $PicklistWrapperDtoCopyWith<$Res>(_value.picklists, (value) {
      return _then(_value.copyWith(picklists: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PicklistResponseDtoImplCopyWith<$Res>
    implements $PicklistResponseDtoCopyWith<$Res> {
  factory _$$PicklistResponseDtoImplCopyWith(_$PicklistResponseDtoImpl value,
          $Res Function(_$PicklistResponseDtoImpl) then) =
      __$$PicklistResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, PicklistWrapperDto picklists});

  @override
  $PicklistWrapperDtoCopyWith<$Res> get picklists;
}

/// @nodoc
class __$$PicklistResponseDtoImplCopyWithImpl<$Res>
    extends _$PicklistResponseDtoCopyWithImpl<$Res, _$PicklistResponseDtoImpl>
    implements _$$PicklistResponseDtoImplCopyWith<$Res> {
  __$$PicklistResponseDtoImplCopyWithImpl(_$PicklistResponseDtoImpl _value,
      $Res Function(_$PicklistResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PicklistResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? picklists = null,
  }) {
    return _then(_$PicklistResponseDtoImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      picklists: null == picklists
          ? _value.picklists
          : picklists // ignore: cast_nullable_to_non_nullable
              as PicklistWrapperDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PicklistResponseDtoImpl implements _PicklistResponseDto {
  const _$PicklistResponseDtoImpl(
      {required this.status, required this.picklists});

  factory _$PicklistResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PicklistResponseDtoImplFromJson(json);

  @override
  final String status;
  @override
  final PicklistWrapperDto picklists;

  @override
  String toString() {
    return 'PicklistResponseDto(status: $status, picklists: $picklists)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PicklistResponseDtoImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.picklists, picklists) ||
                other.picklists == picklists));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, picklists);

  /// Create a copy of PicklistResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PicklistResponseDtoImplCopyWith<_$PicklistResponseDtoImpl> get copyWith =>
      __$$PicklistResponseDtoImplCopyWithImpl<_$PicklistResponseDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PicklistResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _PicklistResponseDto implements PicklistResponseDto {
  const factory _PicklistResponseDto(
      {required final String status,
      required final PicklistWrapperDto picklists}) = _$PicklistResponseDtoImpl;

  factory _PicklistResponseDto.fromJson(Map<String, dynamic> json) =
      _$PicklistResponseDtoImpl.fromJson;

  @override
  String get status;
  @override
  PicklistWrapperDto get picklists;

  /// Create a copy of PicklistResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PicklistResponseDtoImplCopyWith<_$PicklistResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PicklistWrapperDto _$PicklistWrapperDtoFromJson(Map<String, dynamic> json) {
  return _PicklistWrapperDto.fromJson(json);
}

/// @nodoc
mixin _$PicklistWrapperDto {
  int? get count => throw _privateConstructorUsedError;
  @JsonKey(name: 'rows')
  List<PicklistDto> get rows => throw _privateConstructorUsedError;

  /// Serializes this PicklistWrapperDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PicklistWrapperDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PicklistWrapperDtoCopyWith<PicklistWrapperDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PicklistWrapperDtoCopyWith<$Res> {
  factory $PicklistWrapperDtoCopyWith(
          PicklistWrapperDto value, $Res Function(PicklistWrapperDto) then) =
      _$PicklistWrapperDtoCopyWithImpl<$Res, PicklistWrapperDto>;
  @useResult
  $Res call({int? count, @JsonKey(name: 'rows') List<PicklistDto> rows});
}

/// @nodoc
class _$PicklistWrapperDtoCopyWithImpl<$Res, $Val extends PicklistWrapperDto>
    implements $PicklistWrapperDtoCopyWith<$Res> {
  _$PicklistWrapperDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PicklistWrapperDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = freezed,
    Object? rows = null,
  }) {
    return _then(_value.copyWith(
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      rows: null == rows
          ? _value.rows
          : rows // ignore: cast_nullable_to_non_nullable
              as List<PicklistDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PicklistWrapperDtoImplCopyWith<$Res>
    implements $PicklistWrapperDtoCopyWith<$Res> {
  factory _$$PicklistWrapperDtoImplCopyWith(_$PicklistWrapperDtoImpl value,
          $Res Function(_$PicklistWrapperDtoImpl) then) =
      __$$PicklistWrapperDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? count, @JsonKey(name: 'rows') List<PicklistDto> rows});
}

/// @nodoc
class __$$PicklistWrapperDtoImplCopyWithImpl<$Res>
    extends _$PicklistWrapperDtoCopyWithImpl<$Res, _$PicklistWrapperDtoImpl>
    implements _$$PicklistWrapperDtoImplCopyWith<$Res> {
  __$$PicklistWrapperDtoImplCopyWithImpl(_$PicklistWrapperDtoImpl _value,
      $Res Function(_$PicklistWrapperDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PicklistWrapperDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = freezed,
    Object? rows = null,
  }) {
    return _then(_$PicklistWrapperDtoImpl(
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      rows: null == rows
          ? _value._rows
          : rows // ignore: cast_nullable_to_non_nullable
              as List<PicklistDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PicklistWrapperDtoImpl implements _PicklistWrapperDto {
  const _$PicklistWrapperDtoImpl(
      {this.count,
      @JsonKey(name: 'rows') required final List<PicklistDto> rows})
      : _rows = rows;

  factory _$PicklistWrapperDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PicklistWrapperDtoImplFromJson(json);

  @override
  final int? count;
  final List<PicklistDto> _rows;
  @override
  @JsonKey(name: 'rows')
  List<PicklistDto> get rows {
    if (_rows is EqualUnmodifiableListView) return _rows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rows);
  }

  @override
  String toString() {
    return 'PicklistWrapperDto(count: $count, rows: $rows)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PicklistWrapperDtoImpl &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality().equals(other._rows, _rows));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, count, const DeepCollectionEquality().hash(_rows));

  /// Create a copy of PicklistWrapperDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PicklistWrapperDtoImplCopyWith<_$PicklistWrapperDtoImpl> get copyWith =>
      __$$PicklistWrapperDtoImplCopyWithImpl<_$PicklistWrapperDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PicklistWrapperDtoImplToJson(
      this,
    );
  }
}

abstract class _PicklistWrapperDto implements PicklistWrapperDto {
  const factory _PicklistWrapperDto(
          {final int? count,
          @JsonKey(name: 'rows') required final List<PicklistDto> rows}) =
      _$PicklistWrapperDtoImpl;

  factory _PicklistWrapperDto.fromJson(Map<String, dynamic> json) =
      _$PicklistWrapperDtoImpl.fromJson;

  @override
  int? get count;
  @override
  @JsonKey(name: 'rows')
  List<PicklistDto> get rows;

  /// Create a copy of PicklistWrapperDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PicklistWrapperDtoImplCopyWith<_$PicklistWrapperDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
