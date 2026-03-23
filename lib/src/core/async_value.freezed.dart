// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'async_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AsyncValue<T> {

 T? get data; Object? get error; StackTrace? get stackTrace;
/// Create a copy of AsyncValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AsyncValueCopyWith<T, AsyncValue<T>> get copyWith => _$AsyncValueCopyWithImpl<T, AsyncValue<T>>(this as AsyncValue<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AsyncValue<T>&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'AsyncValue<$T>(data: $data, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $AsyncValueCopyWith<T,$Res>  {
  factory $AsyncValueCopyWith(AsyncValue<T> value, $Res Function(AsyncValue<T>) _then) = _$AsyncValueCopyWithImpl;
@useResult
$Res call({
 T? data, Object? error, StackTrace? stackTrace
});




}
/// @nodoc
class _$AsyncValueCopyWithImpl<T,$Res>
    implements $AsyncValueCopyWith<T, $Res> {
  _$AsyncValueCopyWithImpl(this._self, this._then);

  final AsyncValue<T> _self;
  final $Res Function(AsyncValue<T>) _then;

/// Create a copy of AsyncValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,error: freezed == error ? _self.error : error ,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}

}



/// @nodoc


class AsyncValueNone<T> extends AsyncValue<T> {
  const AsyncValueNone({this.data, this.error, this.stackTrace}): super._();
  

@override final  T? data;
@override final  Object? error;
@override final  StackTrace? stackTrace;

/// Create a copy of AsyncValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AsyncValueNoneCopyWith<T, AsyncValueNone<T>> get copyWith => _$AsyncValueNoneCopyWithImpl<T, AsyncValueNone<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AsyncValueNone<T>&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'AsyncValue<$T>.none(data: $data, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $AsyncValueNoneCopyWith<T,$Res> implements $AsyncValueCopyWith<T, $Res> {
  factory $AsyncValueNoneCopyWith(AsyncValueNone<T> value, $Res Function(AsyncValueNone<T>) _then) = _$AsyncValueNoneCopyWithImpl;
@override @useResult
$Res call({
 T? data, Object? error, StackTrace? stackTrace
});




}
/// @nodoc
class _$AsyncValueNoneCopyWithImpl<T,$Res>
    implements $AsyncValueNoneCopyWith<T, $Res> {
  _$AsyncValueNoneCopyWithImpl(this._self, this._then);

  final AsyncValueNone<T> _self;
  final $Res Function(AsyncValueNone<T>) _then;

/// Create a copy of AsyncValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(AsyncValueNone<T>(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,error: freezed == error ? _self.error : error ,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class AsyncValueWaiting<T> extends AsyncValue<T> {
  const AsyncValueWaiting({this.data, this.error, this.stackTrace}): super._();
  

@override final  T? data;
@override final  Object? error;
@override final  StackTrace? stackTrace;

/// Create a copy of AsyncValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AsyncValueWaitingCopyWith<T, AsyncValueWaiting<T>> get copyWith => _$AsyncValueWaitingCopyWithImpl<T, AsyncValueWaiting<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AsyncValueWaiting<T>&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'AsyncValue<$T>.waiting(data: $data, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $AsyncValueWaitingCopyWith<T,$Res> implements $AsyncValueCopyWith<T, $Res> {
  factory $AsyncValueWaitingCopyWith(AsyncValueWaiting<T> value, $Res Function(AsyncValueWaiting<T>) _then) = _$AsyncValueWaitingCopyWithImpl;
@override @useResult
$Res call({
 T? data, Object? error, StackTrace? stackTrace
});




}
/// @nodoc
class _$AsyncValueWaitingCopyWithImpl<T,$Res>
    implements $AsyncValueWaitingCopyWith<T, $Res> {
  _$AsyncValueWaitingCopyWithImpl(this._self, this._then);

  final AsyncValueWaiting<T> _self;
  final $Res Function(AsyncValueWaiting<T>) _then;

/// Create a copy of AsyncValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(AsyncValueWaiting<T>(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,error: freezed == error ? _self.error : error ,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class AsyncValueActive<T> extends AsyncValue<T> {
  const AsyncValueActive({this.data, this.error, this.stackTrace}): super._();
  

@override final  T? data;
@override final  Object? error;
@override final  StackTrace? stackTrace;

/// Create a copy of AsyncValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AsyncValueActiveCopyWith<T, AsyncValueActive<T>> get copyWith => _$AsyncValueActiveCopyWithImpl<T, AsyncValueActive<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AsyncValueActive<T>&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'AsyncValue<$T>.active(data: $data, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $AsyncValueActiveCopyWith<T,$Res> implements $AsyncValueCopyWith<T, $Res> {
  factory $AsyncValueActiveCopyWith(AsyncValueActive<T> value, $Res Function(AsyncValueActive<T>) _then) = _$AsyncValueActiveCopyWithImpl;
@override @useResult
$Res call({
 T? data, Object? error, StackTrace? stackTrace
});




}
/// @nodoc
class _$AsyncValueActiveCopyWithImpl<T,$Res>
    implements $AsyncValueActiveCopyWith<T, $Res> {
  _$AsyncValueActiveCopyWithImpl(this._self, this._then);

  final AsyncValueActive<T> _self;
  final $Res Function(AsyncValueActive<T>) _then;

/// Create a copy of AsyncValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(AsyncValueActive<T>(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,error: freezed == error ? _self.error : error ,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class AsyncValueDone<T> extends AsyncValue<T> {
  const AsyncValueDone({this.data, this.error, this.stackTrace}): super._();
  

@override final  T? data;
@override final  Object? error;
@override final  StackTrace? stackTrace;

/// Create a copy of AsyncValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AsyncValueDoneCopyWith<T, AsyncValueDone<T>> get copyWith => _$AsyncValueDoneCopyWithImpl<T, AsyncValueDone<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AsyncValueDone<T>&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'AsyncValue<$T>.done(data: $data, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $AsyncValueDoneCopyWith<T,$Res> implements $AsyncValueCopyWith<T, $Res> {
  factory $AsyncValueDoneCopyWith(AsyncValueDone<T> value, $Res Function(AsyncValueDone<T>) _then) = _$AsyncValueDoneCopyWithImpl;
@override @useResult
$Res call({
 T? data, Object? error, StackTrace? stackTrace
});




}
/// @nodoc
class _$AsyncValueDoneCopyWithImpl<T,$Res>
    implements $AsyncValueDoneCopyWith<T, $Res> {
  _$AsyncValueDoneCopyWithImpl(this._self, this._then);

  final AsyncValueDone<T> _self;
  final $Res Function(AsyncValueDone<T>) _then;

/// Create a copy of AsyncValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(AsyncValueDone<T>(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,error: freezed == error ? _self.error : error ,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
