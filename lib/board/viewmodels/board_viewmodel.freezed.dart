// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BoardState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BoardState()';
}


}

/// @nodoc
class $BoardStateCopyWith<$Res>  {
$BoardStateCopyWith(BoardState _, $Res Function(BoardState) __);
}



/// @nodoc


class BoardStateLoading implements BoardState {
  const BoardStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BoardState.loading()';
}


}




/// @nodoc


class BoardStateLoaded implements BoardState {
  const BoardStateLoaded({required final  List<BoardColumn> columns, this.username, this.avatarUrl}): _columns = columns;
  

 final  List<BoardColumn> _columns;
 List<BoardColumn> get columns {
  if (_columns is EqualUnmodifiableListView) return _columns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_columns);
}

 final  String? username;
 final  String? avatarUrl;

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardStateLoadedCopyWith<BoardStateLoaded> get copyWith => _$BoardStateLoadedCopyWithImpl<BoardStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardStateLoaded&&const DeepCollectionEquality().equals(other._columns, _columns)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_columns),username,avatarUrl);

@override
String toString() {
  return 'BoardState.loaded(columns: $columns, username: $username, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $BoardStateLoadedCopyWith<$Res> implements $BoardStateCopyWith<$Res> {
  factory $BoardStateLoadedCopyWith(BoardStateLoaded value, $Res Function(BoardStateLoaded) _then) = _$BoardStateLoadedCopyWithImpl;
@useResult
$Res call({
 List<BoardColumn> columns, String? username, String? avatarUrl
});




}
/// @nodoc
class _$BoardStateLoadedCopyWithImpl<$Res>
    implements $BoardStateLoadedCopyWith<$Res> {
  _$BoardStateLoadedCopyWithImpl(this._self, this._then);

  final BoardStateLoaded _self;
  final $Res Function(BoardStateLoaded) _then;

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? columns = null,Object? username = freezed,Object? avatarUrl = freezed,}) {
  return _then(BoardStateLoaded(
columns: null == columns ? _self._columns : columns // ignore: cast_nullable_to_non_nullable
as List<BoardColumn>,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class BoardStateEmpty implements BoardState {
  const BoardStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BoardState.empty()';
}


}




/// @nodoc


class BoardStateError implements BoardState {
  const BoardStateError({required this.message});
  

 final  String message;

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardStateErrorCopyWith<BoardStateError> get copyWith => _$BoardStateErrorCopyWithImpl<BoardStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'BoardState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $BoardStateErrorCopyWith<$Res> implements $BoardStateCopyWith<$Res> {
  factory $BoardStateErrorCopyWith(BoardStateError value, $Res Function(BoardStateError) _then) = _$BoardStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$BoardStateErrorCopyWithImpl<$Res>
    implements $BoardStateErrorCopyWith<$Res> {
  _$BoardStateErrorCopyWithImpl(this._self, this._then);

  final BoardStateError _self;
  final $Res Function(BoardStateError) _then;

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(BoardStateError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
