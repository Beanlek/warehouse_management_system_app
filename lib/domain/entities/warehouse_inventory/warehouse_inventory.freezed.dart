// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warehouse_inventory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WarehouseInventory {
  String? get brand => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'sub_category')
  String? get subCategory => throw _privateConstructorUsedError;
  @JsonKey(name: 'sku_id')
  String? get skuId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sku_name')
  String? get skuName => throw _privateConstructorUsedError;
  int? get sequence => throw _privateConstructorUsedError;
  @JsonKey(name: 'uom_id')
  String? get uomId => throw _privateConstructorUsedError;
  @JsonKey(name: 'short_code')
  String? get shortCode => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  List<int?>? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_sku_conversion')
  List<String?>? get availableSkuConversion =>
      throw _privateConstructorUsedError;

  /// Create a copy of WarehouseInventory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WarehouseInventoryCopyWith<WarehouseInventory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarehouseInventoryCopyWith<$Res> {
  factory $WarehouseInventoryCopyWith(
          WarehouseInventory value, $Res Function(WarehouseInventory) then) =
      _$WarehouseInventoryCopyWithImpl<$Res, WarehouseInventory>;
  @useResult
  $Res call(
      {String? brand,
      String? category,
      @JsonKey(name: 'sub_category') String? subCategory,
      @JsonKey(name: 'sku_id') String? skuId,
      @JsonKey(name: 'sku_name') String? skuName,
      int? sequence,
      @JsonKey(name: 'uom_id') String? uomId,
      @JsonKey(name: 'short_code') String? shortCode,
      String? name,
      List<int?>? quantity,
      @JsonKey(name: 'available_sku_conversion')
      List<String?>? availableSkuConversion});
}

/// @nodoc
class _$WarehouseInventoryCopyWithImpl<$Res, $Val extends WarehouseInventory>
    implements $WarehouseInventoryCopyWith<$Res> {
  _$WarehouseInventoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WarehouseInventory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brand = freezed,
    Object? category = freezed,
    Object? subCategory = freezed,
    Object? skuId = freezed,
    Object? skuName = freezed,
    Object? sequence = freezed,
    Object? uomId = freezed,
    Object? shortCode = freezed,
    Object? name = freezed,
    Object? quantity = freezed,
    Object? availableSkuConversion = freezed,
  }) {
    return _then(_value.copyWith(
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      subCategory: freezed == subCategory
          ? _value.subCategory
          : subCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      skuId: freezed == skuId
          ? _value.skuId
          : skuId // ignore: cast_nullable_to_non_nullable
              as String?,
      skuName: freezed == skuName
          ? _value.skuName
          : skuName // ignore: cast_nullable_to_non_nullable
              as String?,
      sequence: freezed == sequence
          ? _value.sequence
          : sequence // ignore: cast_nullable_to_non_nullable
              as int?,
      uomId: freezed == uomId
          ? _value.uomId
          : uomId // ignore: cast_nullable_to_non_nullable
              as String?,
      shortCode: freezed == shortCode
          ? _value.shortCode
          : shortCode // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as List<int?>?,
      availableSkuConversion: freezed == availableSkuConversion
          ? _value.availableSkuConversion
          : availableSkuConversion // ignore: cast_nullable_to_non_nullable
              as List<String?>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WarehouseInventoryImplCopyWith<$Res>
    implements $WarehouseInventoryCopyWith<$Res> {
  factory _$$WarehouseInventoryImplCopyWith(_$WarehouseInventoryImpl value,
          $Res Function(_$WarehouseInventoryImpl) then) =
      __$$WarehouseInventoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? brand,
      String? category,
      @JsonKey(name: 'sub_category') String? subCategory,
      @JsonKey(name: 'sku_id') String? skuId,
      @JsonKey(name: 'sku_name') String? skuName,
      int? sequence,
      @JsonKey(name: 'uom_id') String? uomId,
      @JsonKey(name: 'short_code') String? shortCode,
      String? name,
      List<int?>? quantity,
      @JsonKey(name: 'available_sku_conversion')
      List<String?>? availableSkuConversion});
}

/// @nodoc
class __$$WarehouseInventoryImplCopyWithImpl<$Res>
    extends _$WarehouseInventoryCopyWithImpl<$Res, _$WarehouseInventoryImpl>
    implements _$$WarehouseInventoryImplCopyWith<$Res> {
  __$$WarehouseInventoryImplCopyWithImpl(_$WarehouseInventoryImpl _value,
      $Res Function(_$WarehouseInventoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of WarehouseInventory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brand = freezed,
    Object? category = freezed,
    Object? subCategory = freezed,
    Object? skuId = freezed,
    Object? skuName = freezed,
    Object? sequence = freezed,
    Object? uomId = freezed,
    Object? shortCode = freezed,
    Object? name = freezed,
    Object? quantity = freezed,
    Object? availableSkuConversion = freezed,
  }) {
    return _then(_$WarehouseInventoryImpl(
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      subCategory: freezed == subCategory
          ? _value.subCategory
          : subCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      skuId: freezed == skuId
          ? _value.skuId
          : skuId // ignore: cast_nullable_to_non_nullable
              as String?,
      skuName: freezed == skuName
          ? _value.skuName
          : skuName // ignore: cast_nullable_to_non_nullable
              as String?,
      sequence: freezed == sequence
          ? _value.sequence
          : sequence // ignore: cast_nullable_to_non_nullable
              as int?,
      uomId: freezed == uomId
          ? _value.uomId
          : uomId // ignore: cast_nullable_to_non_nullable
              as String?,
      shortCode: freezed == shortCode
          ? _value.shortCode
          : shortCode // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value._quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as List<int?>?,
      availableSkuConversion: freezed == availableSkuConversion
          ? _value._availableSkuConversion
          : availableSkuConversion // ignore: cast_nullable_to_non_nullable
              as List<String?>?,
    ));
  }
}

/// @nodoc

class _$WarehouseInventoryImpl extends _WarehouseInventory {
  const _$WarehouseInventoryImpl(
      {this.brand,
      this.category,
      @JsonKey(name: 'sub_category') this.subCategory,
      @JsonKey(name: 'sku_id') this.skuId,
      @JsonKey(name: 'sku_name') this.skuName,
      this.sequence,
      @JsonKey(name: 'uom_id') this.uomId,
      @JsonKey(name: 'short_code') this.shortCode,
      this.name,
      final List<int?>? quantity,
      @JsonKey(name: 'available_sku_conversion')
      final List<String?>? availableSkuConversion})
      : _quantity = quantity,
        _availableSkuConversion = availableSkuConversion,
        super._();

  @override
  final String? brand;
  @override
  final String? category;
  @override
  @JsonKey(name: 'sub_category')
  final String? subCategory;
  @override
  @JsonKey(name: 'sku_id')
  final String? skuId;
  @override
  @JsonKey(name: 'sku_name')
  final String? skuName;
  @override
  final int? sequence;
  @override
  @JsonKey(name: 'uom_id')
  final String? uomId;
  @override
  @JsonKey(name: 'short_code')
  final String? shortCode;
  @override
  final String? name;
  final List<int?>? _quantity;
  @override
  List<int?>? get quantity {
    final value = _quantity;
    if (value == null) return null;
    if (_quantity is EqualUnmodifiableListView) return _quantity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String?>? _availableSkuConversion;
  @override
  @JsonKey(name: 'available_sku_conversion')
  List<String?>? get availableSkuConversion {
    final value = _availableSkuConversion;
    if (value == null) return null;
    if (_availableSkuConversion is EqualUnmodifiableListView)
      return _availableSkuConversion;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'WarehouseInventory(brand: $brand, category: $category, subCategory: $subCategory, skuId: $skuId, skuName: $skuName, sequence: $sequence, uomId: $uomId, shortCode: $shortCode, name: $name, quantity: $quantity, availableSkuConversion: $availableSkuConversion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WarehouseInventoryImpl &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.subCategory, subCategory) ||
                other.subCategory == subCategory) &&
            (identical(other.skuId, skuId) || other.skuId == skuId) &&
            (identical(other.skuName, skuName) || other.skuName == skuName) &&
            (identical(other.sequence, sequence) ||
                other.sequence == sequence) &&
            (identical(other.uomId, uomId) || other.uomId == uomId) &&
            (identical(other.shortCode, shortCode) ||
                other.shortCode == shortCode) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._quantity, _quantity) &&
            const DeepCollectionEquality().equals(
                other._availableSkuConversion, _availableSkuConversion));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      brand,
      category,
      subCategory,
      skuId,
      skuName,
      sequence,
      uomId,
      shortCode,
      name,
      const DeepCollectionEquality().hash(_quantity),
      const DeepCollectionEquality().hash(_availableSkuConversion));

  /// Create a copy of WarehouseInventory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WarehouseInventoryImplCopyWith<_$WarehouseInventoryImpl> get copyWith =>
      __$$WarehouseInventoryImplCopyWithImpl<_$WarehouseInventoryImpl>(
          this, _$identity);
}

abstract class _WarehouseInventory extends WarehouseInventory {
  const factory _WarehouseInventory(
      {final String? brand,
      final String? category,
      @JsonKey(name: 'sub_category') final String? subCategory,
      @JsonKey(name: 'sku_id') final String? skuId,
      @JsonKey(name: 'sku_name') final String? skuName,
      final int? sequence,
      @JsonKey(name: 'uom_id') final String? uomId,
      @JsonKey(name: 'short_code') final String? shortCode,
      final String? name,
      final List<int?>? quantity,
      @JsonKey(name: 'available_sku_conversion')
      final List<String?>? availableSkuConversion}) = _$WarehouseInventoryImpl;
  const _WarehouseInventory._() : super._();

  @override
  String? get brand;
  @override
  String? get category;
  @override
  @JsonKey(name: 'sub_category')
  String? get subCategory;
  @override
  @JsonKey(name: 'sku_id')
  String? get skuId;
  @override
  @JsonKey(name: 'sku_name')
  String? get skuName;
  @override
  int? get sequence;
  @override
  @JsonKey(name: 'uom_id')
  String? get uomId;
  @override
  @JsonKey(name: 'short_code')
  String? get shortCode;
  @override
  String? get name;
  @override
  List<int?>? get quantity;
  @override
  @JsonKey(name: 'available_sku_conversion')
  List<String?>? get availableSkuConversion;

  /// Create a copy of WarehouseInventory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WarehouseInventoryImplCopyWith<_$WarehouseInventoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
