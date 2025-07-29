// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'picklist_wrapper.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PicklistWrapper _$PicklistWrapperFromJson(Map<String, dynamic> json) {
  return _PicklistWrapper.fromJson(json);
}

/// @nodoc
mixin _$PicklistWrapper {
  int? get count => throw _privateConstructorUsedError;
  List<Picklist> get rows => throw _privateConstructorUsedError;

  /// Serializes this PicklistWrapper to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PicklistWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PicklistWrapperCopyWith<PicklistWrapper> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PicklistWrapperCopyWith<$Res> {
  factory $PicklistWrapperCopyWith(
          PicklistWrapper value, $Res Function(PicklistWrapper) then) =
      _$PicklistWrapperCopyWithImpl<$Res, PicklistWrapper>;
  @useResult
  $Res call({int? count, List<Picklist> rows});
}

/// @nodoc
class _$PicklistWrapperCopyWithImpl<$Res, $Val extends PicklistWrapper>
    implements $PicklistWrapperCopyWith<$Res> {
  _$PicklistWrapperCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PicklistWrapper
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
              as List<Picklist>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PicklistWrapperImplCopyWith<$Res>
    implements $PicklistWrapperCopyWith<$Res> {
  factory _$$PicklistWrapperImplCopyWith(_$PicklistWrapperImpl value,
          $Res Function(_$PicklistWrapperImpl) then) =
      __$$PicklistWrapperImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? count, List<Picklist> rows});
}

/// @nodoc
class __$$PicklistWrapperImplCopyWithImpl<$Res>
    extends _$PicklistWrapperCopyWithImpl<$Res, _$PicklistWrapperImpl>
    implements _$$PicklistWrapperImplCopyWith<$Res> {
  __$$PicklistWrapperImplCopyWithImpl(
      _$PicklistWrapperImpl _value, $Res Function(_$PicklistWrapperImpl) _then)
      : super(_value, _then);

  /// Create a copy of PicklistWrapper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = freezed,
    Object? rows = null,
  }) {
    return _then(_$PicklistWrapperImpl(
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      rows: null == rows
          ? _value._rows
          : rows // ignore: cast_nullable_to_non_nullable
              as List<Picklist>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PicklistWrapperImpl extends _PicklistWrapper {
  const _$PicklistWrapperImpl({this.count, required final List<Picklist> rows})
      : _rows = rows,
        super._();

  factory _$PicklistWrapperImpl.fromJson(Map<String, dynamic> json) =>
      _$$PicklistWrapperImplFromJson(json);

  @override
  final int? count;
  final List<Picklist> _rows;
  @override
  List<Picklist> get rows {
    if (_rows is EqualUnmodifiableListView) return _rows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rows);
  }

  @override
  String toString() {
    return 'PicklistWrapper(count: $count, rows: $rows)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PicklistWrapperImpl &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality().equals(other._rows, _rows));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, count, const DeepCollectionEquality().hash(_rows));

  /// Create a copy of PicklistWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PicklistWrapperImplCopyWith<_$PicklistWrapperImpl> get copyWith =>
      __$$PicklistWrapperImplCopyWithImpl<_$PicklistWrapperImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PicklistWrapperImplToJson(
      this,
    );
  }
}

abstract class _PicklistWrapper extends PicklistWrapper {
  const factory _PicklistWrapper(
      {final int? count,
      required final List<Picklist> rows}) = _$PicklistWrapperImpl;
  const _PicklistWrapper._() : super._();

  factory _PicklistWrapper.fromJson(Map<String, dynamic> json) =
      _$PicklistWrapperImpl.fromJson;

  @override
  int? get count;
  @override
  List<Picklist> get rows;

  /// Create a copy of PicklistWrapper
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PicklistWrapperImplCopyWith<_$PicklistWrapperImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
