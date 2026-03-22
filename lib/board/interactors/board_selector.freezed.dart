// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_selector.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BoardColumn {

 String get status; String get label; List<Issue> get issues;
/// Create a copy of BoardColumn
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardColumnCopyWith<BoardColumn> get copyWith => _$BoardColumnCopyWithImpl<BoardColumn>(this as BoardColumn, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardColumn&&(identical(other.status, status) || other.status == status)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.issues, issues));
}


@override
int get hashCode => Object.hash(runtimeType,status,label,const DeepCollectionEquality().hash(issues));

@override
String toString() {
  return 'BoardColumn(status: $status, label: $label, issues: $issues)';
}


}

/// @nodoc
abstract mixin class $BoardColumnCopyWith<$Res>  {
  factory $BoardColumnCopyWith(BoardColumn value, $Res Function(BoardColumn) _then) = _$BoardColumnCopyWithImpl;
@useResult
$Res call({
 String status, String label, List<Issue> issues
});




}
/// @nodoc
class _$BoardColumnCopyWithImpl<$Res>
    implements $BoardColumnCopyWith<$Res> {
  _$BoardColumnCopyWithImpl(this._self, this._then);

  final BoardColumn _self;
  final $Res Function(BoardColumn) _then;

/// Create a copy of BoardColumn
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? label = null,Object? issues = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as List<Issue>,
  ));
}

}



/// @nodoc


class _BoardColumn implements BoardColumn {
  const _BoardColumn({required this.status, required this.label, final  List<Issue> issues = const []}): _issues = issues;
  

@override final  String status;
@override final  String label;
 final  List<Issue> _issues;
@override@JsonKey() List<Issue> get issues {
  if (_issues is EqualUnmodifiableListView) return _issues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_issues);
}


/// Create a copy of BoardColumn
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardColumnCopyWith<_BoardColumn> get copyWith => __$BoardColumnCopyWithImpl<_BoardColumn>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardColumn&&(identical(other.status, status) || other.status == status)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other._issues, _issues));
}


@override
int get hashCode => Object.hash(runtimeType,status,label,const DeepCollectionEquality().hash(_issues));

@override
String toString() {
  return 'BoardColumn(status: $status, label: $label, issues: $issues)';
}


}

/// @nodoc
abstract mixin class _$BoardColumnCopyWith<$Res> implements $BoardColumnCopyWith<$Res> {
  factory _$BoardColumnCopyWith(_BoardColumn value, $Res Function(_BoardColumn) _then) = __$BoardColumnCopyWithImpl;
@override @useResult
$Res call({
 String status, String label, List<Issue> issues
});




}
/// @nodoc
class __$BoardColumnCopyWithImpl<$Res>
    implements _$BoardColumnCopyWith<$Res> {
  __$BoardColumnCopyWithImpl(this._self, this._then);

  final _BoardColumn _self;
  final $Res Function(_BoardColumn) _then;

/// Create a copy of BoardColumn
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? label = null,Object? issues = null,}) {
  return _then(_BoardColumn(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,issues: null == issues ? _self._issues : issues // ignore: cast_nullable_to_non_nullable
as List<Issue>,
  ));
}


}

/// @nodoc
mixin _$BoardSelectorState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardSelectorState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BoardSelectorState()';
}


}

/// @nodoc
class $BoardSelectorStateCopyWith<$Res>  {
$BoardSelectorStateCopyWith(BoardSelectorState _, $Res Function(BoardSelectorState) __);
}



/// @nodoc


class BoardSelectorEmpty implements BoardSelectorState {
  const BoardSelectorEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardSelectorEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BoardSelectorState.empty()';
}


}




/// @nodoc


class BoardSelectorLoading implements BoardSelectorState {
  const BoardSelectorLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardSelectorLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BoardSelectorState.loading()';
}


}




/// @nodoc


class BoardSelectorLoaded implements BoardSelectorState {
  const BoardSelectorLoaded({required final  List<BoardColumn> columns}): _columns = columns;
  

 final  List<BoardColumn> _columns;
 List<BoardColumn> get columns {
  if (_columns is EqualUnmodifiableListView) return _columns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_columns);
}


/// Create a copy of BoardSelectorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardSelectorLoadedCopyWith<BoardSelectorLoaded> get copyWith => _$BoardSelectorLoadedCopyWithImpl<BoardSelectorLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardSelectorLoaded&&const DeepCollectionEquality().equals(other._columns, _columns));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_columns));

@override
String toString() {
  return 'BoardSelectorState.loaded(columns: $columns)';
}


}

/// @nodoc
abstract mixin class $BoardSelectorLoadedCopyWith<$Res> implements $BoardSelectorStateCopyWith<$Res> {
  factory $BoardSelectorLoadedCopyWith(BoardSelectorLoaded value, $Res Function(BoardSelectorLoaded) _then) = _$BoardSelectorLoadedCopyWithImpl;
@useResult
$Res call({
 List<BoardColumn> columns
});




}
/// @nodoc
class _$BoardSelectorLoadedCopyWithImpl<$Res>
    implements $BoardSelectorLoadedCopyWith<$Res> {
  _$BoardSelectorLoadedCopyWithImpl(this._self, this._then);

  final BoardSelectorLoaded _self;
  final $Res Function(BoardSelectorLoaded) _then;

/// Create a copy of BoardSelectorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? columns = null,}) {
  return _then(BoardSelectorLoaded(
columns: null == columns ? _self._columns : columns // ignore: cast_nullable_to_non_nullable
as List<BoardColumn>,
  ));
}


}

/// @nodoc


class BoardSelectorError implements BoardSelectorState {
  const BoardSelectorError({required this.message});
  

 final  String message;

/// Create a copy of BoardSelectorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardSelectorErrorCopyWith<BoardSelectorError> get copyWith => _$BoardSelectorErrorCopyWithImpl<BoardSelectorError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardSelectorError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'BoardSelectorState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $BoardSelectorErrorCopyWith<$Res> implements $BoardSelectorStateCopyWith<$Res> {
  factory $BoardSelectorErrorCopyWith(BoardSelectorError value, $Res Function(BoardSelectorError) _then) = _$BoardSelectorErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$BoardSelectorErrorCopyWithImpl<$Res>
    implements $BoardSelectorErrorCopyWith<$Res> {
  _$BoardSelectorErrorCopyWithImpl(this._self, this._then);

  final BoardSelectorError _self;
  final $Res Function(BoardSelectorError) _then;

/// Create a copy of BoardSelectorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(BoardSelectorError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
