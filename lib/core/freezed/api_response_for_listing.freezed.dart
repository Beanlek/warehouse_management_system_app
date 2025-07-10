// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_response_for_listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiResponseForListing<T> _$ApiResponseForListingFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _ApiResponseForListing<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$ApiResponseForListing<T> {
  String? get status => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  ListingData<List<T>>? get data => throw _privateConstructorUsedError;

  /// Serializes this ApiResponseForListing to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;

  /// Create a copy of ApiResponseForListing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiResponseForListingCopyWith<T, ApiResponseForListing<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiResponseForListingCopyWith<T, $Res> {
  factory $ApiResponseForListingCopyWith(ApiResponseForListing<T> value,
          $Res Function(ApiResponseForListing<T>) then) =
      _$ApiResponseForListingCopyWithImpl<T, $Res, ApiResponseForListing<T>>;
  @useResult
  $Res call({String? status, String? error, ListingData<List<T>>? data});

  $ListingDataCopyWith<List<T>, $Res>? get data;
}

/// @nodoc
class _$ApiResponseForListingCopyWithImpl<T, $Res,
        $Val extends ApiResponseForListing<T>>
    implements $ApiResponseForListingCopyWith<T, $Res> {
  _$ApiResponseForListingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiResponseForListing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? error = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ListingData<List<T>>?,
    ) as $Val);
  }

  /// Create a copy of ApiResponseForListing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ListingDataCopyWith<List<T>, $Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $ListingDataCopyWith<List<T>, $Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApiResponseForListingImplCopyWith<T, $Res>
    implements $ApiResponseForListingCopyWith<T, $Res> {
  factory _$$ApiResponseForListingImplCopyWith(
          _$ApiResponseForListingImpl<T> value,
          $Res Function(_$ApiResponseForListingImpl<T>) then) =
      __$$ApiResponseForListingImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({String? status, String? error, ListingData<List<T>>? data});

  @override
  $ListingDataCopyWith<List<T>, $Res>? get data;
}

/// @nodoc
class __$$ApiResponseForListingImplCopyWithImpl<T, $Res>
    extends _$ApiResponseForListingCopyWithImpl<T, $Res,
        _$ApiResponseForListingImpl<T>>
    implements _$$ApiResponseForListingImplCopyWith<T, $Res> {
  __$$ApiResponseForListingImplCopyWithImpl(
      _$ApiResponseForListingImpl<T> _value,
      $Res Function(_$ApiResponseForListingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ApiResponseForListing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? error = freezed,
    Object? data = freezed,
  }) {
    return _then(_$ApiResponseForListingImpl<T>(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ListingData<List<T>>?,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$ApiResponseForListingImpl<T> implements _ApiResponseForListing<T> {
  const _$ApiResponseForListingImpl(
      {required this.status, required this.error, required this.data});

  factory _$ApiResponseForListingImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$ApiResponseForListingImplFromJson(json, fromJsonT);

  @override
  final String? status;
  @override
  final String? error;
  @override
  final ListingData<List<T>>? data;

  @override
  String toString() {
    return 'ApiResponseForListing<$T>(status: $status, error: $error, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiResponseForListingImpl<T> &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, error, data);

  /// Create a copy of ApiResponseForListing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiResponseForListingImplCopyWith<T, _$ApiResponseForListingImpl<T>>
      get copyWith => __$$ApiResponseForListingImplCopyWithImpl<T,
          _$ApiResponseForListingImpl<T>>(this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$ApiResponseForListingImplToJson<T>(this, toJsonT);
  }
}

abstract class _ApiResponseForListing<T> implements ApiResponseForListing<T> {
  const factory _ApiResponseForListing(
          {required final String? status,
          required final String? error,
          required final ListingData<List<T>>? data}) =
      _$ApiResponseForListingImpl<T>;

  factory _ApiResponseForListing.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$ApiResponseForListingImpl<T>.fromJson;

  @override
  String? get status;
  @override
  String? get error;
  @override
  ListingData<List<T>>? get data;

  /// Create a copy of ApiResponseForListing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiResponseForListingImplCopyWith<T, _$ApiResponseForListingImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}
