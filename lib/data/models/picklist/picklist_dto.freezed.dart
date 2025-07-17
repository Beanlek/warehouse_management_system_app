// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'picklist_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PicklistDto _$PicklistDtoFromJson(Map<String, dynamic> json) {
  return _PicklistDto.fromJson(json);
}

/// @nodoc
mixin _$PicklistDto {
  String get id => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_id')
  String? get siteId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String? get created_by => throw _privateConstructorUsedError;
  @JsonKey(name: 'sent_for_picking_by')
  String? get sentForPickingBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'sent_for_picking_at')
  String? get sentForPickingAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_packing_at')
  String? get startedPackingAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'done_packing_at')
  String? get donePackingAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_date')
  String? get createdDate => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PicklistDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PicklistDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PicklistDtoCopyWith<PicklistDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PicklistDtoCopyWith<$Res> {
  factory $PicklistDtoCopyWith(
          PicklistDto value, $Res Function(PicklistDto) then) =
      _$PicklistDtoCopyWithImpl<$Res, PicklistDto>;
  @useResult
  $Res call(
      {String id,
      String status,
      @JsonKey(name: 'site_id') String? siteId,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'created_by') String? created_by,
      @JsonKey(name: 'sent_for_picking_by') String? sentForPickingBy,
      @JsonKey(name: 'sent_for_picking_at') String? sentForPickingAt,
      @JsonKey(name: 'started_packing_at') String? startedPackingAt,
      @JsonKey(name: 'done_packing_at') String? donePackingAt,
      @JsonKey(name: 'created_date') String? createdDate,
      String? updatedAt});
}

/// @nodoc
class _$PicklistDtoCopyWithImpl<$Res, $Val extends PicklistDto>
    implements $PicklistDtoCopyWith<$Res> {
  _$PicklistDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PicklistDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? siteId = freezed,
    Object? createdAt = freezed,
    Object? created_by = freezed,
    Object? sentForPickingBy = freezed,
    Object? sentForPickingAt = freezed,
    Object? startedPackingAt = freezed,
    Object? donePackingAt = freezed,
    Object? createdDate = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      siteId: freezed == siteId
          ? _value.siteId
          : siteId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      created_by: freezed == created_by
          ? _value.created_by
          : created_by // ignore: cast_nullable_to_non_nullable
              as String?,
      sentForPickingBy: freezed == sentForPickingBy
          ? _value.sentForPickingBy
          : sentForPickingBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sentForPickingAt: freezed == sentForPickingAt
          ? _value.sentForPickingAt
          : sentForPickingAt // ignore: cast_nullable_to_non_nullable
              as String?,
      startedPackingAt: freezed == startedPackingAt
          ? _value.startedPackingAt
          : startedPackingAt // ignore: cast_nullable_to_non_nullable
              as String?,
      donePackingAt: freezed == donePackingAt
          ? _value.donePackingAt
          : donePackingAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdDate: freezed == createdDate
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PicklistDtoImplCopyWith<$Res>
    implements $PicklistDtoCopyWith<$Res> {
  factory _$$PicklistDtoImplCopyWith(
          _$PicklistDtoImpl value, $Res Function(_$PicklistDtoImpl) then) =
      __$$PicklistDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String status,
      @JsonKey(name: 'site_id') String? siteId,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'created_by') String? created_by,
      @JsonKey(name: 'sent_for_picking_by') String? sentForPickingBy,
      @JsonKey(name: 'sent_for_picking_at') String? sentForPickingAt,
      @JsonKey(name: 'started_packing_at') String? startedPackingAt,
      @JsonKey(name: 'done_packing_at') String? donePackingAt,
      @JsonKey(name: 'created_date') String? createdDate,
      String? updatedAt});
}

/// @nodoc
class __$$PicklistDtoImplCopyWithImpl<$Res>
    extends _$PicklistDtoCopyWithImpl<$Res, _$PicklistDtoImpl>
    implements _$$PicklistDtoImplCopyWith<$Res> {
  __$$PicklistDtoImplCopyWithImpl(
      _$PicklistDtoImpl _value, $Res Function(_$PicklistDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PicklistDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? siteId = freezed,
    Object? createdAt = freezed,
    Object? created_by = freezed,
    Object? sentForPickingBy = freezed,
    Object? sentForPickingAt = freezed,
    Object? startedPackingAt = freezed,
    Object? donePackingAt = freezed,
    Object? createdDate = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PicklistDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      siteId: freezed == siteId
          ? _value.siteId
          : siteId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      created_by: freezed == created_by
          ? _value.created_by
          : created_by // ignore: cast_nullable_to_non_nullable
              as String?,
      sentForPickingBy: freezed == sentForPickingBy
          ? _value.sentForPickingBy
          : sentForPickingBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sentForPickingAt: freezed == sentForPickingAt
          ? _value.sentForPickingAt
          : sentForPickingAt // ignore: cast_nullable_to_non_nullable
              as String?,
      startedPackingAt: freezed == startedPackingAt
          ? _value.startedPackingAt
          : startedPackingAt // ignore: cast_nullable_to_non_nullable
              as String?,
      donePackingAt: freezed == donePackingAt
          ? _value.donePackingAt
          : donePackingAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdDate: freezed == createdDate
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PicklistDtoImpl extends _PicklistDto {
  const _$PicklistDtoImpl(
      {required this.id,
      required this.status,
      @JsonKey(name: 'site_id') this.siteId,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'created_by') this.created_by,
      @JsonKey(name: 'sent_for_picking_by') this.sentForPickingBy,
      @JsonKey(name: 'sent_for_picking_at') this.sentForPickingAt,
      @JsonKey(name: 'started_packing_at') this.startedPackingAt,
      @JsonKey(name: 'done_packing_at') this.donePackingAt,
      @JsonKey(name: 'created_date') this.createdDate,
      this.updatedAt})
      : super._();

  factory _$PicklistDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PicklistDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String status;
  @override
  @JsonKey(name: 'site_id')
  final String? siteId;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'created_by')
  final String? created_by;
  @override
  @JsonKey(name: 'sent_for_picking_by')
  final String? sentForPickingBy;
  @override
  @JsonKey(name: 'sent_for_picking_at')
  final String? sentForPickingAt;
  @override
  @JsonKey(name: 'started_packing_at')
  final String? startedPackingAt;
  @override
  @JsonKey(name: 'done_packing_at')
  final String? donePackingAt;
  @override
  @JsonKey(name: 'created_date')
  final String? createdDate;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'PicklistDto(id: $id, status: $status, siteId: $siteId, createdAt: $createdAt, created_by: $created_by, sentForPickingBy: $sentForPickingBy, sentForPickingAt: $sentForPickingAt, startedPackingAt: $startedPackingAt, donePackingAt: $donePackingAt, createdDate: $createdDate, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PicklistDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.siteId, siteId) || other.siteId == siteId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.created_by, created_by) ||
                other.created_by == created_by) &&
            (identical(other.sentForPickingBy, sentForPickingBy) ||
                other.sentForPickingBy == sentForPickingBy) &&
            (identical(other.sentForPickingAt, sentForPickingAt) ||
                other.sentForPickingAt == sentForPickingAt) &&
            (identical(other.startedPackingAt, startedPackingAt) ||
                other.startedPackingAt == startedPackingAt) &&
            (identical(other.donePackingAt, donePackingAt) ||
                other.donePackingAt == donePackingAt) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      status,
      siteId,
      createdAt,
      created_by,
      sentForPickingBy,
      sentForPickingAt,
      startedPackingAt,
      donePackingAt,
      createdDate,
      updatedAt);

  /// Create a copy of PicklistDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PicklistDtoImplCopyWith<_$PicklistDtoImpl> get copyWith =>
      __$$PicklistDtoImplCopyWithImpl<_$PicklistDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PicklistDtoImplToJson(
      this,
    );
  }
}

abstract class _PicklistDto extends PicklistDto {
  const factory _PicklistDto(
      {required final String id,
      required final String status,
      @JsonKey(name: 'site_id') final String? siteId,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'created_by') final String? created_by,
      @JsonKey(name: 'sent_for_picking_by') final String? sentForPickingBy,
      @JsonKey(name: 'sent_for_picking_at') final String? sentForPickingAt,
      @JsonKey(name: 'started_packing_at') final String? startedPackingAt,
      @JsonKey(name: 'done_packing_at') final String? donePackingAt,
      @JsonKey(name: 'created_date') final String? createdDate,
      final String? updatedAt}) = _$PicklistDtoImpl;
  const _PicklistDto._() : super._();

  factory _PicklistDto.fromJson(Map<String, dynamic> json) =
      _$PicklistDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get status;
  @override
  @JsonKey(name: 'site_id')
  String? get siteId;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'created_by')
  String? get created_by;
  @override
  @JsonKey(name: 'sent_for_picking_by')
  String? get sentForPickingBy;
  @override
  @JsonKey(name: 'sent_for_picking_at')
  String? get sentForPickingAt;
  @override
  @JsonKey(name: 'started_packing_at')
  String? get startedPackingAt;
  @override
  @JsonKey(name: 'done_packing_at')
  String? get donePackingAt;
  @override
  @JsonKey(name: 'created_date')
  String? get createdDate;
  @override
  String? get updatedAt;

  /// Create a copy of PicklistDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PicklistDtoImplCopyWith<_$PicklistDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
