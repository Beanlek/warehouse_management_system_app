// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'packing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Packing _$PackingFromJson(Map<String, dynamic> json) {
  return _Packing.fromJson(json);
}

/// @nodoc
mixin _$Packing {
  @JsonKey(name: 'van_allot_id')
  String? get vanAllotId => throw _privateConstructorUsedError;
  @JsonKey(name: 'van_id')
  String? get vanId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'allot_details')
  List<Batch> get allotDetails => throw _privateConstructorUsedError;

  /// Serializes this Packing to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Packing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PackingCopyWith<Packing> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackingCopyWith<$Res> {
  factory $PackingCopyWith(Packing value, $Res Function(Packing) then) =
      _$PackingCopyWithImpl<$Res, Packing>;
  @useResult
  $Res call(
      {@JsonKey(name: 'van_allot_id') String? vanAllotId,
      @JsonKey(name: 'van_id') String? vanId,
      String status,
      @JsonKey(name: 'allot_details') List<Batch> allotDetails});
}

/// @nodoc
class _$PackingCopyWithImpl<$Res, $Val extends Packing>
    implements $PackingCopyWith<$Res> {
  _$PackingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Packing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vanAllotId = freezed,
    Object? vanId = freezed,
    Object? status = null,
    Object? allotDetails = null,
  }) {
    return _then(_value.copyWith(
      vanAllotId: freezed == vanAllotId
          ? _value.vanAllotId
          : vanAllotId // ignore: cast_nullable_to_non_nullable
              as String?,
      vanId: freezed == vanId
          ? _value.vanId
          : vanId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      allotDetails: null == allotDetails
          ? _value.allotDetails
          : allotDetails // ignore: cast_nullable_to_non_nullable
              as List<Batch>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PackingImplCopyWith<$Res> implements $PackingCopyWith<$Res> {
  factory _$$PackingImplCopyWith(
          _$PackingImpl value, $Res Function(_$PackingImpl) then) =
      __$$PackingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'van_allot_id') String? vanAllotId,
      @JsonKey(name: 'van_id') String? vanId,
      String status,
      @JsonKey(name: 'allot_details') List<Batch> allotDetails});
}

/// @nodoc
class __$$PackingImplCopyWithImpl<$Res>
    extends _$PackingCopyWithImpl<$Res, _$PackingImpl>
    implements _$$PackingImplCopyWith<$Res> {
  __$$PackingImplCopyWithImpl(
      _$PackingImpl _value, $Res Function(_$PackingImpl) _then)
      : super(_value, _then);

  /// Create a copy of Packing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vanAllotId = freezed,
    Object? vanId = freezed,
    Object? status = null,
    Object? allotDetails = null,
  }) {
    return _then(_$PackingImpl(
      vanAllotId: freezed == vanAllotId
          ? _value.vanAllotId
          : vanAllotId // ignore: cast_nullable_to_non_nullable
              as String?,
      vanId: freezed == vanId
          ? _value.vanId
          : vanId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      allotDetails: null == allotDetails
          ? _value._allotDetails
          : allotDetails // ignore: cast_nullable_to_non_nullable
              as List<Batch>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PackingImpl extends _Packing {
  const _$PackingImpl(
      {@JsonKey(name: 'van_allot_id') this.vanAllotId,
      @JsonKey(name: 'van_id') this.vanId,
      required this.status,
      @JsonKey(name: 'allot_details') required final List<Batch> allotDetails})
      : _allotDetails = allotDetails,
        super._();

  factory _$PackingImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackingImplFromJson(json);

  @override
  @JsonKey(name: 'van_allot_id')
  final String? vanAllotId;
  @override
  @JsonKey(name: 'van_id')
  final String? vanId;
  @override
  final String status;
  final List<Batch> _allotDetails;
  @override
  @JsonKey(name: 'allot_details')
  List<Batch> get allotDetails {
    if (_allotDetails is EqualUnmodifiableListView) return _allotDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allotDetails);
  }

  @override
  String toString() {
    return 'Packing(vanAllotId: $vanAllotId, vanId: $vanId, status: $status, allotDetails: $allotDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackingImpl &&
            (identical(other.vanAllotId, vanAllotId) ||
                other.vanAllotId == vanAllotId) &&
            (identical(other.vanId, vanId) || other.vanId == vanId) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._allotDetails, _allotDetails));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, vanAllotId, vanId, status,
      const DeepCollectionEquality().hash(_allotDetails));

  /// Create a copy of Packing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PackingImplCopyWith<_$PackingImpl> get copyWith =>
      __$$PackingImplCopyWithImpl<_$PackingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PackingImplToJson(
      this,
    );
  }
}

abstract class _Packing extends Packing {
  const factory _Packing(
      {@JsonKey(name: 'van_allot_id') final String? vanAllotId,
      @JsonKey(name: 'van_id') final String? vanId,
      required final String status,
      @JsonKey(name: 'allot_details')
      required final List<Batch> allotDetails}) = _$PackingImpl;
  const _Packing._() : super._();

  factory _Packing.fromJson(Map<String, dynamic> json) = _$PackingImpl.fromJson;

  @override
  @JsonKey(name: 'van_allot_id')
  String? get vanAllotId;
  @override
  @JsonKey(name: 'van_id')
  String? get vanId;
  @override
  String get status;
  @override
  @JsonKey(name: 'allot_details')
  List<Batch> get allotDetails;

  /// Create a copy of Packing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PackingImplCopyWith<_$PackingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
