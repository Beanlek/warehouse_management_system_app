// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warehouse_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WarehouseState {
  bool get isLoading => throw _privateConstructorUsedError;
  String? get siteId => throw _privateConstructorUsedError;
  List<Site> get siteList => throw _privateConstructorUsedError;
  String? get selectedBrand => throw _privateConstructorUsedError;
  List<String> get brands => throw _privateConstructorUsedError;
  String get active => throw _privateConstructorUsedError;
  List<WarehouseInventory> get warehouseInventoryList =>
      throw _privateConstructorUsedError;
  Map<String, List<WarehouseInventory>> get brandInventoryMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of WarehouseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WarehouseStateCopyWith<WarehouseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarehouseStateCopyWith<$Res> {
  factory $WarehouseStateCopyWith(
          WarehouseState value, $Res Function(WarehouseState) then) =
      _$WarehouseStateCopyWithImpl<$Res, WarehouseState>;
  @useResult
  $Res call(
      {bool isLoading,
      String? siteId,
      List<Site> siteList,
      String? selectedBrand,
      List<String> brands,
      String active,
      List<WarehouseInventory> warehouseInventoryList,
      Map<String, List<WarehouseInventory>> brandInventoryMap});
}

/// @nodoc
class _$WarehouseStateCopyWithImpl<$Res, $Val extends WarehouseState>
    implements $WarehouseStateCopyWith<$Res> {
  _$WarehouseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WarehouseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? siteId = freezed,
    Object? siteList = null,
    Object? selectedBrand = freezed,
    Object? brands = null,
    Object? active = null,
    Object? warehouseInventoryList = null,
    Object? brandInventoryMap = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      siteId: freezed == siteId
          ? _value.siteId
          : siteId // ignore: cast_nullable_to_non_nullable
              as String?,
      siteList: null == siteList
          ? _value.siteList
          : siteList // ignore: cast_nullable_to_non_nullable
              as List<Site>,
      selectedBrand: freezed == selectedBrand
          ? _value.selectedBrand
          : selectedBrand // ignore: cast_nullable_to_non_nullable
              as String?,
      brands: null == brands
          ? _value.brands
          : brands // ignore: cast_nullable_to_non_nullable
              as List<String>,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as String,
      warehouseInventoryList: null == warehouseInventoryList
          ? _value.warehouseInventoryList
          : warehouseInventoryList // ignore: cast_nullable_to_non_nullable
              as List<WarehouseInventory>,
      brandInventoryMap: null == brandInventoryMap
          ? _value.brandInventoryMap
          : brandInventoryMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<WarehouseInventory>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WarehouseStateImplCopyWith<$Res>
    implements $WarehouseStateCopyWith<$Res> {
  factory _$$WarehouseStateImplCopyWith(_$WarehouseStateImpl value,
          $Res Function(_$WarehouseStateImpl) then) =
      __$$WarehouseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      String? siteId,
      List<Site> siteList,
      String? selectedBrand,
      List<String> brands,
      String active,
      List<WarehouseInventory> warehouseInventoryList,
      Map<String, List<WarehouseInventory>> brandInventoryMap});
}

/// @nodoc
class __$$WarehouseStateImplCopyWithImpl<$Res>
    extends _$WarehouseStateCopyWithImpl<$Res, _$WarehouseStateImpl>
    implements _$$WarehouseStateImplCopyWith<$Res> {
  __$$WarehouseStateImplCopyWithImpl(
      _$WarehouseStateImpl _value, $Res Function(_$WarehouseStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WarehouseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? siteId = freezed,
    Object? siteList = null,
    Object? selectedBrand = freezed,
    Object? brands = null,
    Object? active = null,
    Object? warehouseInventoryList = null,
    Object? brandInventoryMap = null,
  }) {
    return _then(_$WarehouseStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      siteId: freezed == siteId
          ? _value.siteId
          : siteId // ignore: cast_nullable_to_non_nullable
              as String?,
      siteList: null == siteList
          ? _value._siteList
          : siteList // ignore: cast_nullable_to_non_nullable
              as List<Site>,
      selectedBrand: freezed == selectedBrand
          ? _value.selectedBrand
          : selectedBrand // ignore: cast_nullable_to_non_nullable
              as String?,
      brands: null == brands
          ? _value._brands
          : brands // ignore: cast_nullable_to_non_nullable
              as List<String>,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as String,
      warehouseInventoryList: null == warehouseInventoryList
          ? _value._warehouseInventoryList
          : warehouseInventoryList // ignore: cast_nullable_to_non_nullable
              as List<WarehouseInventory>,
      brandInventoryMap: null == brandInventoryMap
          ? _value._brandInventoryMap
          : brandInventoryMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<WarehouseInventory>>,
    ));
  }
}

/// @nodoc

class _$WarehouseStateImpl extends _WarehouseState {
  const _$WarehouseStateImpl(
      {this.isLoading = false,
      this.siteId = null,
      final List<Site> siteList = const [],
      this.selectedBrand = null,
      final List<String> brands = const [],
      this.active = '',
      final List<WarehouseInventory> warehouseInventoryList = const [],
      final Map<String, List<WarehouseInventory>> brandInventoryMap = const {}})
      : _siteList = siteList,
        _brands = brands,
        _warehouseInventoryList = warehouseInventoryList,
        _brandInventoryMap = brandInventoryMap,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String? siteId;
  final List<Site> _siteList;
  @override
  @JsonKey()
  List<Site> get siteList {
    if (_siteList is EqualUnmodifiableListView) return _siteList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_siteList);
  }

  @override
  @JsonKey()
  final String? selectedBrand;
  final List<String> _brands;
  @override
  @JsonKey()
  List<String> get brands {
    if (_brands is EqualUnmodifiableListView) return _brands;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_brands);
  }

  @override
  @JsonKey()
  final String active;
  final List<WarehouseInventory> _warehouseInventoryList;
  @override
  @JsonKey()
  List<WarehouseInventory> get warehouseInventoryList {
    if (_warehouseInventoryList is EqualUnmodifiableListView)
      return _warehouseInventoryList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warehouseInventoryList);
  }

  final Map<String, List<WarehouseInventory>> _brandInventoryMap;
  @override
  @JsonKey()
  Map<String, List<WarehouseInventory>> get brandInventoryMap {
    if (_brandInventoryMap is EqualUnmodifiableMapView)
      return _brandInventoryMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_brandInventoryMap);
  }

  @override
  String toString() {
    return 'WarehouseState(isLoading: $isLoading, siteId: $siteId, siteList: $siteList, selectedBrand: $selectedBrand, brands: $brands, active: $active, warehouseInventoryList: $warehouseInventoryList, brandInventoryMap: $brandInventoryMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WarehouseStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.siteId, siteId) || other.siteId == siteId) &&
            const DeepCollectionEquality().equals(other._siteList, _siteList) &&
            (identical(other.selectedBrand, selectedBrand) ||
                other.selectedBrand == selectedBrand) &&
            const DeepCollectionEquality().equals(other._brands, _brands) &&
            (identical(other.active, active) || other.active == active) &&
            const DeepCollectionEquality().equals(
                other._warehouseInventoryList, _warehouseInventoryList) &&
            const DeepCollectionEquality()
                .equals(other._brandInventoryMap, _brandInventoryMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      siteId,
      const DeepCollectionEquality().hash(_siteList),
      selectedBrand,
      const DeepCollectionEquality().hash(_brands),
      active,
      const DeepCollectionEquality().hash(_warehouseInventoryList),
      const DeepCollectionEquality().hash(_brandInventoryMap));

  /// Create a copy of WarehouseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WarehouseStateImplCopyWith<_$WarehouseStateImpl> get copyWith =>
      __$$WarehouseStateImplCopyWithImpl<_$WarehouseStateImpl>(
          this, _$identity);
}

abstract class _WarehouseState extends WarehouseState {
  const factory _WarehouseState(
          {final bool isLoading,
          final String? siteId,
          final List<Site> siteList,
          final String? selectedBrand,
          final List<String> brands,
          final String active,
          final List<WarehouseInventory> warehouseInventoryList,
          final Map<String, List<WarehouseInventory>> brandInventoryMap}) =
      _$WarehouseStateImpl;
  const _WarehouseState._() : super._();

  @override
  bool get isLoading;
  @override
  String? get siteId;
  @override
  List<Site> get siteList;
  @override
  String? get selectedBrand;
  @override
  List<String> get brands;
  @override
  String get active;
  @override
  List<WarehouseInventory> get warehouseInventoryList;
  @override
  Map<String, List<WarehouseInventory>> get brandInventoryMap;

  /// Create a copy of WarehouseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WarehouseStateImplCopyWith<_$WarehouseStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
