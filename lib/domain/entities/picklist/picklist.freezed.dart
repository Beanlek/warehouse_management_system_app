// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'picklist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Picklist _$PicklistFromJson(Map<String, dynamic> json) {
  return _Picklist.fromJson(json);
}

/// @nodoc
mixin _$Picklist {
  String get id => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_id')
  String? get siteId => throw _privateConstructorUsedError; //association
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;
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

  /// Serializes this Picklist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Picklist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PicklistCopyWith<Picklist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PicklistCopyWith<$Res> {
  factory $PicklistCopyWith(Picklist value, $Res Function(Picklist) then) =
      _$PicklistCopyWithImpl<$Res, Picklist>;
  @useResult
  $Res call(
      {String id,
      String status,
      @JsonKey(name: 'site_id') String? siteId,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'sent_for_picking_by') String? sentForPickingBy,
      @JsonKey(name: 'sent_for_picking_at') String? sentForPickingAt,
      @JsonKey(name: 'started_packing_at') String? startedPackingAt,
      @JsonKey(name: 'done_packing_at') String? donePackingAt,
      @JsonKey(name: 'created_date') String? createdDate,
      String? updatedAt});
}

/// @nodoc
class _$PicklistCopyWithImpl<$Res, $Val extends Picklist>
    implements $PicklistCopyWith<$Res> {
  _$PicklistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Picklist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? siteId = freezed,
    Object? createdAt = freezed,
    Object? createdBy = freezed,
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
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PicklistImplCopyWith<$Res>
    implements $PicklistCopyWith<$Res> {
  factory _$$PicklistImplCopyWith(
          _$PicklistImpl value, $Res Function(_$PicklistImpl) then) =
      __$$PicklistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String status,
      @JsonKey(name: 'site_id') String? siteId,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'sent_for_picking_by') String? sentForPickingBy,
      @JsonKey(name: 'sent_for_picking_at') String? sentForPickingAt,
      @JsonKey(name: 'started_packing_at') String? startedPackingAt,
      @JsonKey(name: 'done_packing_at') String? donePackingAt,
      @JsonKey(name: 'created_date') String? createdDate,
      String? updatedAt});
}

/// @nodoc
class __$$PicklistImplCopyWithImpl<$Res>
    extends _$PicklistCopyWithImpl<$Res, _$PicklistImpl>
    implements _$$PicklistImplCopyWith<$Res> {
  __$$PicklistImplCopyWithImpl(
      _$PicklistImpl _value, $Res Function(_$PicklistImpl) _then)
      : super(_value, _then);

  /// Create a copy of Picklist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? siteId = freezed,
    Object? createdAt = freezed,
    Object? createdBy = freezed,
    Object? sentForPickingBy = freezed,
    Object? sentForPickingAt = freezed,
    Object? startedPackingAt = freezed,
    Object? donePackingAt = freezed,
    Object? createdDate = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PicklistImpl(
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
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
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
class _$PicklistImpl extends _Picklist {
  const _$PicklistImpl(
      {required this.id,
      required this.status,
      @JsonKey(name: 'site_id') this.siteId,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'sent_for_picking_by') this.sentForPickingBy,
      @JsonKey(name: 'sent_for_picking_at') this.sentForPickingAt,
      @JsonKey(name: 'started_packing_at') this.startedPackingAt,
      @JsonKey(name: 'done_packing_at') this.donePackingAt,
      @JsonKey(name: 'created_date') this.createdDate,
      this.updatedAt})
      : super._();

  factory _$PicklistImpl.fromJson(Map<String, dynamic> json) =>
      _$$PicklistImplFromJson(json);

  @override
  final String id;
  @override
  final String status;
  @override
  @JsonKey(name: 'site_id')
  final String? siteId;
//association
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'created_by')
  final String? createdBy;
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
    return 'Picklist(id: $id, status: $status, siteId: $siteId, createdAt: $createdAt, createdBy: $createdBy, sentForPickingBy: $sentForPickingBy, sentForPickingAt: $sentForPickingAt, startedPackingAt: $startedPackingAt, donePackingAt: $donePackingAt, createdDate: $createdDate, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PicklistImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.siteId, siteId) || other.siteId == siteId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
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
      createdBy,
      sentForPickingBy,
      sentForPickingAt,
      startedPackingAt,
      donePackingAt,
      createdDate,
      updatedAt);

  /// Create a copy of Picklist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PicklistImplCopyWith<_$PicklistImpl> get copyWith =>
      __$$PicklistImplCopyWithImpl<_$PicklistImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PicklistImplToJson(
      this,
    );
  }
}

abstract class _Picklist extends Picklist {
  const factory _Picklist(
      {required final String id,
      required final String status,
      @JsonKey(name: 'site_id') final String? siteId,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'created_by') final String? createdBy,
      @JsonKey(name: 'sent_for_picking_by') final String? sentForPickingBy,
      @JsonKey(name: 'sent_for_picking_at') final String? sentForPickingAt,
      @JsonKey(name: 'started_packing_at') final String? startedPackingAt,
      @JsonKey(name: 'done_packing_at') final String? donePackingAt,
      @JsonKey(name: 'created_date') final String? createdDate,
      final String? updatedAt}) = _$PicklistImpl;
  const _Picklist._() : super._();

  factory _Picklist.fromJson(Map<String, dynamic> json) =
      _$PicklistImpl.fromJson;

  @override
  String get id;
  @override
  String get status;
  @override
  @JsonKey(name: 'site_id')
  String? get siteId; //association
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'created_by')
  String? get createdBy;
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

  /// Create a copy of Picklist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PicklistImplCopyWith<_$PicklistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
