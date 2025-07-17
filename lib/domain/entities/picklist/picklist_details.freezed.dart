// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'picklist_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PicklistDetails {
  Picklist get picklist => throw _privateConstructorUsedError;
  List<Batch> get batch => throw _privateConstructorUsedError;
  List<Packing> get packing => throw _privateConstructorUsedError;

  /// Create a copy of PicklistDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PicklistDetailsCopyWith<PicklistDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PicklistDetailsCopyWith<$Res> {
  factory $PicklistDetailsCopyWith(
          PicklistDetails value, $Res Function(PicklistDetails) then) =
      _$PicklistDetailsCopyWithImpl<$Res, PicklistDetails>;
  @useResult
  $Res call({Picklist picklist, List<Batch> batch, List<Packing> packing});

  $PicklistCopyWith<$Res> get picklist;
}

/// @nodoc
class _$PicklistDetailsCopyWithImpl<$Res, $Val extends PicklistDetails>
    implements $PicklistDetailsCopyWith<$Res> {
  _$PicklistDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PicklistDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? picklist = null,
    Object? batch = null,
    Object? packing = null,
  }) {
    return _then(_value.copyWith(
      picklist: null == picklist
          ? _value.picklist
          : picklist // ignore: cast_nullable_to_non_nullable
              as Picklist,
      batch: null == batch
          ? _value.batch
          : batch // ignore: cast_nullable_to_non_nullable
              as List<Batch>,
      packing: null == packing
          ? _value.packing
          : packing // ignore: cast_nullable_to_non_nullable
              as List<Packing>,
    ) as $Val);
  }

  /// Create a copy of PicklistDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PicklistCopyWith<$Res> get picklist {
    return $PicklistCopyWith<$Res>(_value.picklist, (value) {
      return _then(_value.copyWith(picklist: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PicklistDetailsImplCopyWith<$Res>
    implements $PicklistDetailsCopyWith<$Res> {
  factory _$$PicklistDetailsImplCopyWith(_$PicklistDetailsImpl value,
          $Res Function(_$PicklistDetailsImpl) then) =
      __$$PicklistDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Picklist picklist, List<Batch> batch, List<Packing> packing});

  @override
  $PicklistCopyWith<$Res> get picklist;
}

/// @nodoc
class __$$PicklistDetailsImplCopyWithImpl<$Res>
    extends _$PicklistDetailsCopyWithImpl<$Res, _$PicklistDetailsImpl>
    implements _$$PicklistDetailsImplCopyWith<$Res> {
  __$$PicklistDetailsImplCopyWithImpl(
      _$PicklistDetailsImpl _value, $Res Function(_$PicklistDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PicklistDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? picklist = null,
    Object? batch = null,
    Object? packing = null,
  }) {
    return _then(_$PicklistDetailsImpl(
      picklist: null == picklist
          ? _value.picklist
          : picklist // ignore: cast_nullable_to_non_nullable
              as Picklist,
      batch: null == batch
          ? _value._batch
          : batch // ignore: cast_nullable_to_non_nullable
              as List<Batch>,
      packing: null == packing
          ? _value._packing
          : packing // ignore: cast_nullable_to_non_nullable
              as List<Packing>,
    ));
  }
}

/// @nodoc

class _$PicklistDetailsImpl extends _PicklistDetails {
  const _$PicklistDetailsImpl(
      {required this.picklist,
      required final List<Batch> batch,
      required final List<Packing> packing})
      : _batch = batch,
        _packing = packing,
        super._();

  @override
  final Picklist picklist;
  final List<Batch> _batch;
  @override
  List<Batch> get batch {
    if (_batch is EqualUnmodifiableListView) return _batch;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_batch);
  }

  final List<Packing> _packing;
  @override
  List<Packing> get packing {
    if (_packing is EqualUnmodifiableListView) return _packing;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_packing);
  }

  @override
  String toString() {
    return 'PicklistDetails(picklist: $picklist, batch: $batch, packing: $packing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PicklistDetailsImpl &&
            (identical(other.picklist, picklist) ||
                other.picklist == picklist) &&
            const DeepCollectionEquality().equals(other._batch, _batch) &&
            const DeepCollectionEquality().equals(other._packing, _packing));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      picklist,
      const DeepCollectionEquality().hash(_batch),
      const DeepCollectionEquality().hash(_packing));

  /// Create a copy of PicklistDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PicklistDetailsImplCopyWith<_$PicklistDetailsImpl> get copyWith =>
      __$$PicklistDetailsImplCopyWithImpl<_$PicklistDetailsImpl>(
          this, _$identity);
}

abstract class _PicklistDetails extends PicklistDetails {
  const factory _PicklistDetails(
      {required final Picklist picklist,
      required final List<Batch> batch,
      required final List<Packing> packing}) = _$PicklistDetailsImpl;
  const _PicklistDetails._() : super._();

  @override
  Picklist get picklist;
  @override
  List<Batch> get batch;
  @override
  List<Packing> get packing;

  /// Create a copy of PicklistDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PicklistDetailsImplCopyWith<_$PicklistDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
