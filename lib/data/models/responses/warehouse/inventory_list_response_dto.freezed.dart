// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_list_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InventoryListResponseDto _$InventoryListResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _InventoryListResponseDto.fromJson(json);
}

/// @nodoc
mixin _$InventoryListResponseDto {
  List<WarehouseInventoryDto> get inventory =>
      throw _privateConstructorUsedError;

  /// Serializes this InventoryListResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryListResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryListResponseDtoCopyWith<InventoryListResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryListResponseDtoCopyWith<$Res> {
  factory $InventoryListResponseDtoCopyWith(InventoryListResponseDto value,
          $Res Function(InventoryListResponseDto) then) =
      _$InventoryListResponseDtoCopyWithImpl<$Res, InventoryListResponseDto>;
  @useResult
  $Res call({List<WarehouseInventoryDto> inventory});
}

/// @nodoc
class _$InventoryListResponseDtoCopyWithImpl<$Res,
        $Val extends InventoryListResponseDto>
    implements $InventoryListResponseDtoCopyWith<$Res> {
  _$InventoryListResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryListResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inventory = null,
  }) {
    return _then(_value.copyWith(
      inventory: null == inventory
          ? _value.inventory
          : inventory // ignore: cast_nullable_to_non_nullable
              as List<WarehouseInventoryDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryListResponseDtoImplCopyWith<$Res>
    implements $InventoryListResponseDtoCopyWith<$Res> {
  factory _$$InventoryListResponseDtoImplCopyWith(
          _$InventoryListResponseDtoImpl value,
          $Res Function(_$InventoryListResponseDtoImpl) then) =
      __$$InventoryListResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<WarehouseInventoryDto> inventory});
}

/// @nodoc
class __$$InventoryListResponseDtoImplCopyWithImpl<$Res>
    extends _$InventoryListResponseDtoCopyWithImpl<$Res,
        _$InventoryListResponseDtoImpl>
    implements _$$InventoryListResponseDtoImplCopyWith<$Res> {
  __$$InventoryListResponseDtoImplCopyWithImpl(
      _$InventoryListResponseDtoImpl _value,
      $Res Function(_$InventoryListResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryListResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inventory = null,
  }) {
    return _then(_$InventoryListResponseDtoImpl(
      inventory: null == inventory
          ? _value._inventory
          : inventory // ignore: cast_nullable_to_non_nullable
              as List<WarehouseInventoryDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryListResponseDtoImpl implements _InventoryListResponseDto {
  const _$InventoryListResponseDtoImpl(
      {required final List<WarehouseInventoryDto> inventory})
      : _inventory = inventory;

  factory _$InventoryListResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryListResponseDtoImplFromJson(json);

  final List<WarehouseInventoryDto> _inventory;
  @override
  List<WarehouseInventoryDto> get inventory {
    if (_inventory is EqualUnmodifiableListView) return _inventory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inventory);
  }

  @override
  String toString() {
    return 'InventoryListResponseDto(inventory: $inventory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryListResponseDtoImpl &&
            const DeepCollectionEquality()
                .equals(other._inventory, _inventory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_inventory));

  /// Create a copy of InventoryListResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryListResponseDtoImplCopyWith<_$InventoryListResponseDtoImpl>
      get copyWith => __$$InventoryListResponseDtoImplCopyWithImpl<
          _$InventoryListResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryListResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _InventoryListResponseDto implements InventoryListResponseDto {
  const factory _InventoryListResponseDto(
          {required final List<WarehouseInventoryDto> inventory}) =
      _$InventoryListResponseDtoImpl;

  factory _InventoryListResponseDto.fromJson(Map<String, dynamic> json) =
      _$InventoryListResponseDtoImpl.fromJson;

  @override
  List<WarehouseInventoryDto> get inventory;

  /// Create a copy of InventoryListResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryListResponseDtoImplCopyWith<_$InventoryListResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
