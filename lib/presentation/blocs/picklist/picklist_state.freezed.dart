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
  List<Picklist> get picklist => throw _privateConstructorUsedError;
  PicklistDetails get picklistDetails => throw _privateConstructorUsedError;

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
      List<Picklist> picklist,
      PicklistDetails picklistDetails});

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
    Object? picklist = null,
    Object? picklistDetails = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      picklist: null == picklist
          ? _value.picklist
          : picklist // ignore: cast_nullable_to_non_nullable
              as List<Picklist>,
      picklistDetails: null == picklistDetails
          ? _value.picklistDetails
          : picklistDetails // ignore: cast_nullable_to_non_nullable
              as PicklistDetails,
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
      List<Picklist> picklist,
      PicklistDetails picklistDetails});

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
    Object? picklist = null,
    Object? picklistDetails = null,
  }) {
    return _then(_$PicklistStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      picklist: null == picklist
          ? _value._picklist
          : picklist // ignore: cast_nullable_to_non_nullable
              as List<Picklist>,
      picklistDetails: null == picklistDetails
          ? _value.picklistDetails
          : picklistDetails // ignore: cast_nullable_to_non_nullable
              as PicklistDetails,
    ));
  }
}

/// @nodoc

class _$PicklistStateImpl extends _PicklistState {
  const _$PicklistStateImpl(
      {this.isLoading = false,
      final List<Picklist> picklist = const [],
      this.picklistDetails = PicklistDetails.empty})
      : _picklist = picklist,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
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
  String toString() {
    return 'PicklistState(isLoading: $isLoading, picklist: $picklist, picklistDetails: $picklistDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PicklistStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._picklist, _picklist) &&
            (identical(other.picklistDetails, picklistDetails) ||
                other.picklistDetails == picklistDetails));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading,
      const DeepCollectionEquality().hash(_picklist), picklistDetails);

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
      final List<Picklist> picklist,
      final PicklistDetails picklistDetails}) = _$PicklistStateImpl;
  const _PicklistState._() : super._();

  @override
  bool get isLoading;
  @override
  List<Picklist> get picklist;
  @override
  PicklistDetails get picklistDetails;

  /// Create a copy of PicklistState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PicklistStateImplCopyWith<_$PicklistStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
