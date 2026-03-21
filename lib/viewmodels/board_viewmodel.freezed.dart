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

 bool get isLoading; String? get error;
/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardStateCopyWith<BoardState> get copyWith => _$BoardStateCopyWithImpl<BoardState>(this as BoardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,error);

@override
String toString() {
  return 'BoardState(isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class $BoardStateCopyWith<$Res>  {
  factory $BoardStateCopyWith(BoardState value, $Res Function(BoardState) _then) = _$BoardStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String? error
});




}
/// @nodoc
class _$BoardStateCopyWithImpl<$Res>
    implements $BoardStateCopyWith<$Res> {
  _$BoardStateCopyWithImpl(this._self, this._then);

  final BoardState _self;
  final $Res Function(BoardState) _then;

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}



/// @nodoc


class _BoardState implements BoardState {
  const _BoardState({this.isLoading = false, this.error});
  

@override@JsonKey() final  bool isLoading;
@override final  String? error;

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardStateCopyWith<_BoardState> get copyWith => __$BoardStateCopyWithImpl<_BoardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,error);

@override
String toString() {
  return 'BoardState(isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$BoardStateCopyWith<$Res> implements $BoardStateCopyWith<$Res> {
  factory _$BoardStateCopyWith(_BoardState value, $Res Function(_BoardState) _then) = __$BoardStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String? error
});




}
/// @nodoc
class __$BoardStateCopyWithImpl<$Res>
    implements _$BoardStateCopyWith<$Res> {
  __$BoardStateCopyWithImpl(this._self, this._then);

  final _BoardState _self;
  final $Res Function(_BoardState) _then;

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? error = freezed,}) {
  return _then(_BoardState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
