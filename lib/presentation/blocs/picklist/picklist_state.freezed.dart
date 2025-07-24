// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'picklist_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PicklistState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get deletePicklistSucceeded => throw _privateConstructorUsedError;
  bool get deletePicklistProgress => throw _privateConstructorUsedError;
  bool get setPicklistSendForPickingSucceeded =>
      throw _privateConstructorUsedError;
  bool get setPicklistSendForPickingProgress =>
      throw _privateConstructorUsedError;
  bool get setPicklistPackAllSucceeded => throw _privateConstructorUsedError;
  bool get setPicklistPackAllProgress => throw _privateConstructorUsedError;
  List<Picklist> get picklist => throw _privateConstructorUsedError;
  PicklistDetails get picklistDetails => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of PicklistState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PicklistStateCopyWith<PicklistState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PicklistStateCopyWith<$Res> {
  factory $PicklistStateCopyWith(
          PicklistState value, $Res Function(PicklistState) then) =
      _$PicklistStateCopyWithImpl<$Res, PicklistState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool deletePicklistSucceeded,
      bool deletePicklistProgress,
      bool setPicklistSendForPickingSucceeded,
      bool setPicklistSendForPickingProgress,
      bool setPicklistPackAllSucceeded,
      bool setPicklistPackAllProgress,
      List<Picklist> picklist,
      PicklistDetails picklistDetails,
      String? error});

  $PicklistDetailsCopyWith<$Res> get picklistDetails;
}

/// @nodoc
class _$PicklistStateCopyWithImpl<$Res, $Val extends PicklistState>
    implements $PicklistStateCopyWith<$Res> {
  _$PicklistStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PicklistState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? deletePicklistSucceeded = null,
    Object? deletePicklistProgress = null,
    Object? setPicklistSendForPickingSucceeded = null,
    Object? setPicklistSendForPickingProgress = null,
    Object? setPicklistPackAllSucceeded = null,
    Object? setPicklistPackAllProgress = null,
    Object? picklist = null,
    Object? picklistDetails = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      deletePicklistSucceeded: null == deletePicklistSucceeded
          ? _value.deletePicklistSucceeded
          : deletePicklistSucceeded // ignore: cast_nullable_to_non_nullable
              as bool,
      deletePicklistProgress: null == deletePicklistProgress
          ? _value.deletePicklistProgress
          : deletePicklistProgress // ignore: cast_nullable_to_non_nullable
              as bool,
      setPicklistSendForPickingSucceeded: null ==
              setPicklistSendForPickingSucceeded
          ? _value.setPicklistSendForPickingSucceeded
          : setPicklistSendForPickingSucceeded // ignore: cast_nullable_to_non_nullable
              as bool,
      setPicklistSendForPickingProgress: null ==
              setPicklistSendForPickingProgress
          ? _value.setPicklistSendForPickingProgress
          : setPicklistSendForPickingProgress // ignore: cast_nullable_to_non_nullable
              as bool,
      setPicklistPackAllSucceeded: null == setPicklistPackAllSucceeded
          ? _value.setPicklistPackAllSucceeded
          : setPicklistPackAllSucceeded // ignore: cast_nullable_to_non_nullable
              as bool,
      setPicklistPackAllProgress: null == setPicklistPackAllProgress
          ? _value.setPicklistPackAllProgress
          : setPicklistPackAllProgress // ignore: cast_nullable_to_non_nullable
              as bool,
      picklist: null == picklist
          ? _value.picklist
          : picklist // ignore: cast_nullable_to_non_nullable
              as List<Picklist>,
      picklistDetails: null == picklistDetails
          ? _value.picklistDetails
          : picklistDetails // ignore: cast_nullable_to_non_nullable
              as PicklistDetails,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of PicklistState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PicklistDetailsCopyWith<$Res> get picklistDetails {
    return $PicklistDetailsCopyWith<$Res>(_value.picklistDetails, (value) {
      return _then(_value.copyWith(picklistDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PicklistStateImplCopyWith<$Res>
    implements $PicklistStateCopyWith<$Res> {
  factory _$$PicklistStateImplCopyWith(
          _$PicklistStateImpl value, $Res Function(_$PicklistStateImpl) then) =
      __$$PicklistStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool deletePicklistSucceeded,
      bool deletePicklistProgress,
      bool setPicklistSendForPickingSucceeded,
      bool setPicklistSendForPickingProgress,
      bool setPicklistPackAllSucceeded,
      bool setPicklistPackAllProgress,
      List<Picklist> picklist,
      PicklistDetails picklistDetails,
      String? error});

  @override
  $PicklistDetailsCopyWith<$Res> get picklistDetails;
}

/// @nodoc
class __$$PicklistStateImplCopyWithImpl<$Res>
    extends _$PicklistStateCopyWithImpl<$Res, _$PicklistStateImpl>
    implements _$$PicklistStateImplCopyWith<$Res> {
  __$$PicklistStateImplCopyWithImpl(
      _$PicklistStateImpl _value, $Res Function(_$PicklistStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PicklistState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? deletePicklistSucceeded = null,
    Object? deletePicklistProgress = null,
    Object? setPicklistSendForPickingSucceeded = null,
    Object? setPicklistSendForPickingProgress = null,
    Object? setPicklistPackAllSucceeded = null,
    Object? setPicklistPackAllProgress = null,
    Object? picklist = null,
    Object? picklistDetails = null,
    Object? error = freezed,
  }) {
    return _then(_$PicklistStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      deletePicklistSucceeded: null == deletePicklistSucceeded
          ? _value.deletePicklistSucceeded
          : deletePicklistSucceeded // ignore: cast_nullable_to_non_nullable
              as bool,
      deletePicklistProgress: null == deletePicklistProgress
          ? _value.deletePicklistProgress
          : deletePicklistProgress // ignore: cast_nullable_to_non_nullable
              as bool,
      setPicklistSendForPickingSucceeded: null ==
              setPicklistSendForPickingSucceeded
          ? _value.setPicklistSendForPickingSucceeded
          : setPicklistSendForPickingSucceeded // ignore: cast_nullable_to_non_nullable
              as bool,
      setPicklistSendForPickingProgress: null ==
              setPicklistSendForPickingProgress
          ? _value.setPicklistSendForPickingProgress
          : setPicklistSendForPickingProgress // ignore: cast_nullable_to_non_nullable
              as bool,
      setPicklistPackAllSucceeded: null == setPicklistPackAllSucceeded
          ? _value.setPicklistPackAllSucceeded
          : setPicklistPackAllSucceeded // ignore: cast_nullable_to_non_nullable
              as bool,
      setPicklistPackAllProgress: null == setPicklistPackAllProgress
          ? _value.setPicklistPackAllProgress
          : setPicklistPackAllProgress // ignore: cast_nullable_to_non_nullable
              as bool,
      picklist: null == picklist
          ? _value._picklist
          : picklist // ignore: cast_nullable_to_non_nullable
              as List<Picklist>,
      picklistDetails: null == picklistDetails
          ? _value.picklistDetails
          : picklistDetails // ignore: cast_nullable_to_non_nullable
              as PicklistDetails,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PicklistStateImpl extends _PicklistState {
  const _$PicklistStateImpl(
      {this.isLoading = false,
      this.deletePicklistSucceeded = false,
      this.deletePicklistProgress = false,
      this.setPicklistSendForPickingSucceeded = false,
      this.setPicklistSendForPickingProgress = false,
      this.setPicklistPackAllSucceeded = false,
      this.setPicklistPackAllProgress = false,
      final List<Picklist> picklist = const [],
      this.picklistDetails = PicklistDetails.empty,
      this.error = null})
      : _picklist = picklist,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool deletePicklistSucceeded;
  @override
  @JsonKey()
  final bool deletePicklistProgress;
  @override
  @JsonKey()
  final bool setPicklistSendForPickingSucceeded;
  @override
  @JsonKey()
  final bool setPicklistSendForPickingProgress;
  @override
  @JsonKey()
  final bool setPicklistPackAllSucceeded;
  @override
  @JsonKey()
  final bool setPicklistPackAllProgress;
  final List<Picklist> _picklist;
  @override
  @JsonKey()
  List<Picklist> get picklist {
    if (_picklist is EqualUnmodifiableListView) return _picklist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_picklist);
  }

  @override
  @JsonKey()
  final PicklistDetails picklistDetails;
  @override
  @JsonKey()
  final String? error;

  @override
  String toString() {
    return 'PicklistState(isLoading: $isLoading, deletePicklistSucceeded: $deletePicklistSucceeded, deletePicklistProgress: $deletePicklistProgress, setPicklistSendForPickingSucceeded: $setPicklistSendForPickingSucceeded, setPicklistSendForPickingProgress: $setPicklistSendForPickingProgress, setPicklistPackAllSucceeded: $setPicklistPackAllSucceeded, setPicklistPackAllProgress: $setPicklistPackAllProgress, picklist: $picklist, picklistDetails: $picklistDetails, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PicklistStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(
                    other.deletePicklistSucceeded, deletePicklistSucceeded) ||
                other.deletePicklistSucceeded == deletePicklistSucceeded) &&
            (identical(other.deletePicklistProgress, deletePicklistProgress) ||
                other.deletePicklistProgress == deletePicklistProgress) &&
            (identical(other.setPicklistSendForPickingSucceeded,
                    setPicklistSendForPickingSucceeded) ||
                other.setPicklistSendForPickingSucceeded ==
                    setPicklistSendForPickingSucceeded) &&
            (identical(other.setPicklistSendForPickingProgress,
                    setPicklistSendForPickingProgress) ||
                other.setPicklistSendForPickingProgress ==
                    setPicklistSendForPickingProgress) &&
            (identical(other.setPicklistPackAllSucceeded,
                    setPicklistPackAllSucceeded) ||
                other.setPicklistPackAllSucceeded ==
                    setPicklistPackAllSucceeded) &&
            (identical(other.setPicklistPackAllProgress,
                    setPicklistPackAllProgress) ||
                other.setPicklistPackAllProgress ==
                    setPicklistPackAllProgress) &&
            const DeepCollectionEquality().equals(other._picklist, _picklist) &&
            (identical(other.picklistDetails, picklistDetails) ||
                other.picklistDetails == picklistDetails) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      deletePicklistSucceeded,
      deletePicklistProgress,
      setPicklistSendForPickingSucceeded,
      setPicklistSendForPickingProgress,
      setPicklistPackAllSucceeded,
      setPicklistPackAllProgress,
      const DeepCollectionEquality().hash(_picklist),
      picklistDetails,
      error);

  /// Create a copy of PicklistState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PicklistStateImplCopyWith<_$PicklistStateImpl> get copyWith =>
      __$$PicklistStateImplCopyWithImpl<_$PicklistStateImpl>(this, _$identity);
}

abstract class _PicklistState extends PicklistState {
  const factory _PicklistState(
      {final bool isLoading,
      final bool deletePicklistSucceeded,
      final bool deletePicklistProgress,
      final bool setPicklistSendForPickingSucceeded,
      final bool setPicklistSendForPickingProgress,
      final bool setPicklistPackAllSucceeded,
      final bool setPicklistPackAllProgress,
      final List<Picklist> picklist,
      final PicklistDetails picklistDetails,
      final String? error}) = _$PicklistStateImpl;
  const _PicklistState._() : super._();

  @override
  bool get isLoading;
  @override
  bool get deletePicklistSucceeded;
  @override
  bool get deletePicklistProgress;
  @override
  bool get setPicklistSendForPickingSucceeded;
  @override
  bool get setPicklistSendForPickingProgress;
  @override
  bool get setPicklistPackAllSucceeded;
  @override
  bool get setPicklistPackAllProgress;
  @override
  List<Picklist> get picklist;
  @override
  PicklistDetails get picklistDetails;
  @override
  String? get error;

  /// Create a copy of PicklistState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PicklistStateImplCopyWith<_$PicklistStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
