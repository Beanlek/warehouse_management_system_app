// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'picklist_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PicklistEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? status) setup,
    required TResult Function(String id) selectPickList,
    required TResult Function(List<Picklist> picklist) loadPickList,
    required TResult Function(List<Picklist> picklist) searchPicklist,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? status)? setup,
    TResult? Function(String id)? selectPickList,
    TResult? Function(List<Picklist> picklist)? loadPickList,
    TResult? Function(List<Picklist> picklist)? searchPicklist,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? status)? setup,
    TResult Function(String id)? selectPickList,
    TResult Function(List<Picklist> picklist)? loadPickList,
    TResult Function(List<Picklist> picklist)? searchPicklist,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Setup value) setup,
    required TResult Function(SelectPickList value) selectPickList,
    required TResult Function(loadPickList value) loadPickList,
    required TResult Function(searchPicklist value) searchPicklist,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Setup value)? setup,
    TResult? Function(SelectPickList value)? selectPickList,
    TResult? Function(loadPickList value)? loadPickList,
    TResult? Function(searchPicklist value)? searchPicklist,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Setup value)? setup,
    TResult Function(SelectPickList value)? selectPickList,
    TResult Function(loadPickList value)? loadPickList,
    TResult Function(searchPicklist value)? searchPicklist,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PicklistEventCopyWith<$Res> {
  factory $PicklistEventCopyWith(
          PicklistEvent value, $Res Function(PicklistEvent) then) =
      _$PicklistEventCopyWithImpl<$Res, PicklistEvent>;
}

/// @nodoc
class _$PicklistEventCopyWithImpl<$Res, $Val extends PicklistEvent>
    implements $PicklistEventCopyWith<$Res> {
  _$PicklistEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PicklistEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SetupImplCopyWith<$Res> {
  factory _$$SetupImplCopyWith(
          _$SetupImpl value, $Res Function(_$SetupImpl) then) =
      __$$SetupImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? status});
}

/// @nodoc
class __$$SetupImplCopyWithImpl<$Res>
    extends _$PicklistEventCopyWithImpl<$Res, _$SetupImpl>
    implements _$$SetupImplCopyWith<$Res> {
  __$$SetupImplCopyWithImpl(
      _$SetupImpl _value, $Res Function(_$SetupImpl) _then)
      : super(_value, _then);

  /// Create a copy of PicklistEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
  }) {
    return _then(_$SetupImpl(
      freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SetupImpl implements Setup {
  const _$SetupImpl(this.status);

  @override
  final String? status;

  @override
  String toString() {
    return 'PicklistEvent.setup(status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetupImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status);

  /// Create a copy of PicklistEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetupImplCopyWith<_$SetupImpl> get copyWith =>
      __$$SetupImplCopyWithImpl<_$SetupImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? status) setup,
    required TResult Function(String id) selectPickList,
    required TResult Function(List<Picklist> picklist) loadPickList,
    required TResult Function(List<Picklist> picklist) searchPicklist,
  }) {
    return setup(status);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? status)? setup,
    TResult? Function(String id)? selectPickList,
    TResult? Function(List<Picklist> picklist)? loadPickList,
    TResult? Function(List<Picklist> picklist)? searchPicklist,
  }) {
    return setup?.call(status);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? status)? setup,
    TResult Function(String id)? selectPickList,
    TResult Function(List<Picklist> picklist)? loadPickList,
    TResult Function(List<Picklist> picklist)? searchPicklist,
    required TResult orElse(),
  }) {
    if (setup != null) {
      return setup(status);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Setup value) setup,
    required TResult Function(SelectPickList value) selectPickList,
    required TResult Function(loadPickList value) loadPickList,
    required TResult Function(searchPicklist value) searchPicklist,
  }) {
    return setup(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Setup value)? setup,
    TResult? Function(SelectPickList value)? selectPickList,
    TResult? Function(loadPickList value)? loadPickList,
    TResult? Function(searchPicklist value)? searchPicklist,
  }) {
    return setup?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Setup value)? setup,
    TResult Function(SelectPickList value)? selectPickList,
    TResult Function(loadPickList value)? loadPickList,
    TResult Function(searchPicklist value)? searchPicklist,
    required TResult orElse(),
  }) {
    if (setup != null) {
      return setup(this);
    }
    return orElse();
  }
}

abstract class Setup implements PicklistEvent {
  const factory Setup(final String? status) = _$SetupImpl;

  String? get status;

  /// Create a copy of PicklistEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetupImplCopyWith<_$SetupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SelectPickListImplCopyWith<$Res> {
  factory _$$SelectPickListImplCopyWith(_$SelectPickListImpl value,
          $Res Function(_$SelectPickListImpl) then) =
      __$$SelectPickListImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$SelectPickListImplCopyWithImpl<$Res>
    extends _$PicklistEventCopyWithImpl<$Res, _$SelectPickListImpl>
    implements _$$SelectPickListImplCopyWith<$Res> {
  __$$SelectPickListImplCopyWithImpl(
      _$SelectPickListImpl _value, $Res Function(_$SelectPickListImpl) _then)
      : super(_value, _then);

  /// Create a copy of PicklistEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_$SelectPickListImpl(
      null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SelectPickListImpl implements SelectPickList {
  const _$SelectPickListImpl(this.id);

  @override
  final String id;

  @override
  String toString() {
    return 'PicklistEvent.selectPickList(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectPickListImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of PicklistEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectPickListImplCopyWith<_$SelectPickListImpl> get copyWith =>
      __$$SelectPickListImplCopyWithImpl<_$SelectPickListImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? status) setup,
    required TResult Function(String id) selectPickList,
    required TResult Function(List<Picklist> picklist) loadPickList,
    required TResult Function(List<Picklist> picklist) searchPicklist,
  }) {
    return selectPickList(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? status)? setup,
    TResult? Function(String id)? selectPickList,
    TResult? Function(List<Picklist> picklist)? loadPickList,
    TResult? Function(List<Picklist> picklist)? searchPicklist,
  }) {
    return selectPickList?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? status)? setup,
    TResult Function(String id)? selectPickList,
    TResult Function(List<Picklist> picklist)? loadPickList,
    TResult Function(List<Picklist> picklist)? searchPicklist,
    required TResult orElse(),
  }) {
    if (selectPickList != null) {
      return selectPickList(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Setup value) setup,
    required TResult Function(SelectPickList value) selectPickList,
    required TResult Function(loadPickList value) loadPickList,
    required TResult Function(searchPicklist value) searchPicklist,
  }) {
    return selectPickList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Setup value)? setup,
    TResult? Function(SelectPickList value)? selectPickList,
    TResult? Function(loadPickList value)? loadPickList,
    TResult? Function(searchPicklist value)? searchPicklist,
  }) {
    return selectPickList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Setup value)? setup,
    TResult Function(SelectPickList value)? selectPickList,
    TResult Function(loadPickList value)? loadPickList,
    TResult Function(searchPicklist value)? searchPicklist,
    required TResult orElse(),
  }) {
    if (selectPickList != null) {
      return selectPickList(this);
    }
    return orElse();
  }
}

abstract class SelectPickList implements PicklistEvent {
  const factory SelectPickList(final String id) = _$SelectPickListImpl;

  String get id;

  /// Create a copy of PicklistEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectPickListImplCopyWith<_$SelectPickListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$loadPickListImplCopyWith<$Res> {
  factory _$$loadPickListImplCopyWith(
          _$loadPickListImpl value, $Res Function(_$loadPickListImpl) then) =
      __$$loadPickListImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Picklist> picklist});
}

/// @nodoc
class __$$loadPickListImplCopyWithImpl<$Res>
    extends _$PicklistEventCopyWithImpl<$Res, _$loadPickListImpl>
    implements _$$loadPickListImplCopyWith<$Res> {
  __$$loadPickListImplCopyWithImpl(
      _$loadPickListImpl _value, $Res Function(_$loadPickListImpl) _then)
      : super(_value, _then);

  /// Create a copy of PicklistEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? picklist = null,
  }) {
    return _then(_$loadPickListImpl(
      null == picklist
          ? _value._picklist
          : picklist // ignore: cast_nullable_to_non_nullable
              as List<Picklist>,
    ));
  }
}

/// @nodoc

class _$loadPickListImpl implements loadPickList {
  const _$loadPickListImpl(final List<Picklist> picklist)
      : _picklist = picklist;

  final List<Picklist> _picklist;
  @override
  List<Picklist> get picklist {
    if (_picklist is EqualUnmodifiableListView) return _picklist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_picklist);
  }

  @override
  String toString() {
    return 'PicklistEvent.loadPickList(picklist: $picklist)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$loadPickListImpl &&
            const DeepCollectionEquality().equals(other._picklist, _picklist));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_picklist));

  /// Create a copy of PicklistEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$loadPickListImplCopyWith<_$loadPickListImpl> get copyWith =>
      __$$loadPickListImplCopyWithImpl<_$loadPickListImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? status) setup,
    required TResult Function(String id) selectPickList,
    required TResult Function(List<Picklist> picklist) loadPickList,
    required TResult Function(List<Picklist> picklist) searchPicklist,
  }) {
    return loadPickList(picklist);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? status)? setup,
    TResult? Function(String id)? selectPickList,
    TResult? Function(List<Picklist> picklist)? loadPickList,
    TResult? Function(List<Picklist> picklist)? searchPicklist,
  }) {
    return loadPickList?.call(picklist);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? status)? setup,
    TResult Function(String id)? selectPickList,
    TResult Function(List<Picklist> picklist)? loadPickList,
    TResult Function(List<Picklist> picklist)? searchPicklist,
    required TResult orElse(),
  }) {
    if (loadPickList != null) {
      return loadPickList(picklist);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Setup value) setup,
    required TResult Function(SelectPickList value) selectPickList,
    required TResult Function(loadPickList value) loadPickList,
    required TResult Function(searchPicklist value) searchPicklist,
  }) {
    return loadPickList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Setup value)? setup,
    TResult? Function(SelectPickList value)? selectPickList,
    TResult? Function(loadPickList value)? loadPickList,
    TResult? Function(searchPicklist value)? searchPicklist,
  }) {
    return loadPickList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Setup value)? setup,
    TResult Function(SelectPickList value)? selectPickList,
    TResult Function(loadPickList value)? loadPickList,
    TResult Function(searchPicklist value)? searchPicklist,
    required TResult orElse(),
  }) {
    if (loadPickList != null) {
      return loadPickList(this);
    }
    return orElse();
  }
}

abstract class loadPickList implements PicklistEvent {
  const factory loadPickList(final List<Picklist> picklist) =
      _$loadPickListImpl;

  List<Picklist> get picklist;

  /// Create a copy of PicklistEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$loadPickListImplCopyWith<_$loadPickListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$searchPicklistImplCopyWith<$Res> {
  factory _$$searchPicklistImplCopyWith(_$searchPicklistImpl value,
          $Res Function(_$searchPicklistImpl) then) =
      __$$searchPicklistImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Picklist> picklist});
}

/// @nodoc
class __$$searchPicklistImplCopyWithImpl<$Res>
    extends _$PicklistEventCopyWithImpl<$Res, _$searchPicklistImpl>
    implements _$$searchPicklistImplCopyWith<$Res> {
  __$$searchPicklistImplCopyWithImpl(
      _$searchPicklistImpl _value, $Res Function(_$searchPicklistImpl) _then)
      : super(_value, _then);

  /// Create a copy of PicklistEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? picklist = null,
  }) {
    return _then(_$searchPicklistImpl(
      null == picklist
          ? _value._picklist
          : picklist // ignore: cast_nullable_to_non_nullable
              as List<Picklist>,
    ));
  }
}

/// @nodoc

class _$searchPicklistImpl implements searchPicklist {
  const _$searchPicklistImpl(final List<Picklist> picklist)
      : _picklist = picklist;

  final List<Picklist> _picklist;
  @override
  List<Picklist> get picklist {
    if (_picklist is EqualUnmodifiableListView) return _picklist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_picklist);
  }

  @override
  String toString() {
    return 'PicklistEvent.searchPicklist(picklist: $picklist)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$searchPicklistImpl &&
            const DeepCollectionEquality().equals(other._picklist, _picklist));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_picklist));

  /// Create a copy of PicklistEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$searchPicklistImplCopyWith<_$searchPicklistImpl> get copyWith =>
      __$$searchPicklistImplCopyWithImpl<_$searchPicklistImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? status) setup,
    required TResult Function(String id) selectPickList,
    required TResult Function(List<Picklist> picklist) loadPickList,
    required TResult Function(List<Picklist> picklist) searchPicklist,
  }) {
    return searchPicklist(picklist);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? status)? setup,
    TResult? Function(String id)? selectPickList,
    TResult? Function(List<Picklist> picklist)? loadPickList,
    TResult? Function(List<Picklist> picklist)? searchPicklist,
  }) {
    return searchPicklist?.call(picklist);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? status)? setup,
    TResult Function(String id)? selectPickList,
    TResult Function(List<Picklist> picklist)? loadPickList,
    TResult Function(List<Picklist> picklist)? searchPicklist,
    required TResult orElse(),
  }) {
    if (searchPicklist != null) {
      return searchPicklist(picklist);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Setup value) setup,
    required TResult Function(SelectPickList value) selectPickList,
    required TResult Function(loadPickList value) loadPickList,
    required TResult Function(searchPicklist value) searchPicklist,
  }) {
    return searchPicklist(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Setup value)? setup,
    TResult? Function(SelectPickList value)? selectPickList,
    TResult? Function(loadPickList value)? loadPickList,
    TResult? Function(searchPicklist value)? searchPicklist,
  }) {
    return searchPicklist?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Setup value)? setup,
    TResult Function(SelectPickList value)? selectPickList,
    TResult Function(loadPickList value)? loadPickList,
    TResult Function(searchPicklist value)? searchPicklist,
    required TResult orElse(),
  }) {
    if (searchPicklist != null) {
      return searchPicklist(this);
    }
    return orElse();
  }
}

abstract class searchPicklist implements PicklistEvent {
  const factory searchPicklist(final List<Picklist> picklist) =
      _$searchPicklistImpl;

  List<Picklist> get picklist;

  /// Create a copy of PicklistEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$searchPicklistImplCopyWith<_$searchPicklistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
