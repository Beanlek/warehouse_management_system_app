// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'batch_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BatchDto _$BatchDtoFromJson(Map<String, dynamic> json) {
  return _BatchDto.fromJson(json);
}

/// @nodoc
mixin _$BatchDto {
  @JsonKey(name: 'sku_id')
  String? get skuId => throw _privateConstructorUsedError;
  @JsonKey(name: 'uom_id')
  String? get uomId => throw _privateConstructorUsedError;
  List<int> get quantity => throw _privateConstructorUsedError;

  /// Serializes this BatchDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BatchDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BatchDtoCopyWith<BatchDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchDtoCopyWith<$Res> {
  factory $BatchDtoCopyWith(BatchDto value, $Res Function(BatchDto) then) =
      _$BatchDtoCopyWithImpl<$Res, BatchDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'sku_id') String? skuId,
      @JsonKey(name: 'uom_id') String? uomId,
      List<int> quantity});
}

/// @nodoc
class _$BatchDtoCopyWithImpl<$Res, $Val extends BatchDto>
    implements $BatchDtoCopyWith<$Res> {
  _$BatchDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BatchDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skuId = freezed,
    Object? uomId = freezed,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      skuId: freezed == skuId
          ? _value.skuId
          : skuId // ignore: cast_nullable_to_non_nullable
              as String?,
      uomId: freezed == uomId
          ? _value.uomId
          : uomId // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatchDtoImplCopyWith<$Res>
    implements $BatchDtoCopyWith<$Res> {
  factory _$$BatchDtoImplCopyWith(
          _$BatchDtoImpl value, $Res Function(_$BatchDtoImpl) then) =
      __$$BatchDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'sku_id') String? skuId,
      @JsonKey(name: 'uom_id') String? uomId,
      List<int> quantity});
}

/// @nodoc
class __$$BatchDtoImplCopyWithImpl<$Res>
    extends _$BatchDtoCopyWithImpl<$Res, _$BatchDtoImpl>
    implements _$$BatchDtoImplCopyWith<$Res> {
  __$$BatchDtoImplCopyWithImpl(
      _$BatchDtoImpl _value, $Res Function(_$BatchDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BatchDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skuId = freezed,
    Object? uomId = freezed,
    Object? quantity = null,
  }) {
    return _then(_$BatchDtoImpl(
      skuId: freezed == skuId
          ? _value.skuId
          : skuId // ignore: cast_nullable_to_non_nullable
              as String?,
      uomId: freezed == uomId
          ? _value.uomId
          : uomId // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value._quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BatchDtoImpl extends _BatchDto {
  const _$BatchDtoImpl(
      {@JsonKey(name: 'sku_id') this.skuId,
      @JsonKey(name: 'uom_id') this.uomId,
      required final List<int> quantity})
      : _quantity = quantity,
        super._();

  factory _$BatchDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BatchDtoImplFromJson(json);

  @override
  @JsonKey(name: 'sku_id')
  final String? skuId;
  @override
  @JsonKey(name: 'uom_id')
  final String? uomId;
  final List<int> _quantity;
  @override
  List<int> get quantity {
    if (_quantity is EqualUnmodifiableListView) return _quantity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_quantity);
  }

  @override
  String toString() {
    return 'BatchDto(skuId: $skuId, uomId: $uomId, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchDtoImpl &&
            (identical(other.skuId, skuId) || other.skuId == skuId) &&
            (identical(other.uomId, uomId) || other.uomId == uomId) &&
            const DeepCollectionEquality().equals(other._quantity, _quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, skuId, uomId,
      const DeepCollectionEquality().hash(_quantity));

  /// Create a copy of BatchDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchDtoImplCopyWith<_$BatchDtoImpl> get copyWith =>
      __$$BatchDtoImplCopyWithImpl<_$BatchDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BatchDtoImplToJson(
      this,
    );
  }
}

abstract class _BatchDto extends BatchDto {
  const factory _BatchDto(
      {@JsonKey(name: 'sku_id') final String? skuId,
      @JsonKey(name: 'uom_id') final String? uomId,
      required final List<int> quantity}) = _$BatchDtoImpl;
  const _BatchDto._() : super._();

  factory _BatchDto.fromJson(Map<String, dynamic> json) =
      _$BatchDtoImpl.fromJson;

  @override
  @JsonKey(name: 'sku_id')
  String? get skuId;
  @override
  @JsonKey(name: 'uom_id')
  String? get uomId;
  @override
  List<int> get quantity;

  /// Create a copy of BatchDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BatchDtoImplCopyWith<_$BatchDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
