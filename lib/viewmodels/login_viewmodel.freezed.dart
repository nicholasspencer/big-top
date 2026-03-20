// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginState {

 bool get isPolling; DeviceCodeResponse? get deviceCode; String? get error;
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateCopyWith<LoginState> get copyWith => _$LoginStateCopyWithImpl<LoginState>(this as LoginState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState&&(identical(other.isPolling, isPolling) || other.isPolling == isPolling)&&(identical(other.deviceCode, deviceCode) || other.deviceCode == deviceCode)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isPolling,deviceCode,error);

@override
String toString() {
  return 'LoginState(isPolling: $isPolling, deviceCode: $deviceCode, error: $error)';
}


}

/// @nodoc
abstract mixin class $LoginStateCopyWith<$Res>  {
  factory $LoginStateCopyWith(LoginState value, $Res Function(LoginState) _then) = _$LoginStateCopyWithImpl;
@useResult
$Res call({
 bool isPolling, DeviceCodeResponse? deviceCode, String? error
});




}
/// @nodoc
class _$LoginStateCopyWithImpl<$Res>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState _self;
  final $Res Function(LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPolling = null,Object? deviceCode = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
isPolling: null == isPolling ? _self.isPolling : isPolling // ignore: cast_nullable_to_non_nullable
as bool,deviceCode: freezed == deviceCode ? _self.deviceCode : deviceCode // ignore: cast_nullable_to_non_nullable
as DeviceCodeResponse?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}



/// @nodoc


class _LoginState implements LoginState {
  const _LoginState({this.isPolling = false, this.deviceCode, this.error});
  

@override@JsonKey() final  bool isPolling;
@override final  DeviceCodeResponse? deviceCode;
@override final  String? error;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateCopyWith<_LoginState> get copyWith => __$LoginStateCopyWithImpl<_LoginState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginState&&(identical(other.isPolling, isPolling) || other.isPolling == isPolling)&&(identical(other.deviceCode, deviceCode) || other.deviceCode == deviceCode)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isPolling,deviceCode,error);

@override
String toString() {
  return 'LoginState(isPolling: $isPolling, deviceCode: $deviceCode, error: $error)';
}


}

/// @nodoc
abstract mixin class _$LoginStateCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory _$LoginStateCopyWith(_LoginState value, $Res Function(_LoginState) _then) = __$LoginStateCopyWithImpl;
@override @useResult
$Res call({
 bool isPolling, DeviceCodeResponse? deviceCode, String? error
});




}
/// @nodoc
class __$LoginStateCopyWithImpl<$Res>
    implements _$LoginStateCopyWith<$Res> {
  __$LoginStateCopyWithImpl(this._self, this._then);

  final _LoginState _self;
  final $Res Function(_LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPolling = null,Object? deviceCode = freezed,Object? error = freezed,}) {
  return _then(_LoginState(
isPolling: null == isPolling ? _self.isPolling : isPolling // ignore: cast_nullable_to_non_nullable
as bool,deviceCode: freezed == deviceCode ? _self.deviceCode : deviceCode // ignore: cast_nullable_to_non_nullable
as DeviceCodeResponse?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
