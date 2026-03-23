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
mixin _$BoardData {

 List<BoardColumn> get columns; BoardFilter get activeFilter; String? get username; String? get avatarUrl;
/// Create a copy of BoardData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardDataCopyWith<BoardData> get copyWith => _$BoardDataCopyWithImpl<BoardData>(this as BoardData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardData&&const DeepCollectionEquality().equals(other.columns, columns)&&(identical(other.activeFilter, activeFilter) || other.activeFilter == activeFilter)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(columns),activeFilter,username,avatarUrl);

@override
String toString() {
  return 'BoardData(columns: $columns, activeFilter: $activeFilter, username: $username, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $BoardDataCopyWith<$Res>  {
  factory $BoardDataCopyWith(BoardData value, $Res Function(BoardData) _then) = _$BoardDataCopyWithImpl;
@useResult
$Res call({
 List<BoardColumn> columns, BoardFilter activeFilter, String? username, String? avatarUrl
});


$BoardFilterCopyWith<$Res> get activeFilter;

}
/// @nodoc
class _$BoardDataCopyWithImpl<$Res>
    implements $BoardDataCopyWith<$Res> {
  _$BoardDataCopyWithImpl(this._self, this._then);

  final BoardData _self;
  final $Res Function(BoardData) _then;

/// Create a copy of BoardData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? columns = null,Object? activeFilter = null,Object? username = freezed,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
columns: null == columns ? _self.columns : columns // ignore: cast_nullable_to_non_nullable
as List<BoardColumn>,activeFilter: null == activeFilter ? _self.activeFilter : activeFilter // ignore: cast_nullable_to_non_nullable
as BoardFilter,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of BoardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardFilterCopyWith<$Res> get activeFilter {
  
  return $BoardFilterCopyWith<$Res>(_self.activeFilter, (value) {
    return _then(_self.copyWith(activeFilter: value));
  });
}
}



/// @nodoc


class _BoardData implements BoardData {
  const _BoardData({required final  List<BoardColumn> columns, required this.activeFilter, this.username, this.avatarUrl}): _columns = columns;
  

 final  List<BoardColumn> _columns;
@override List<BoardColumn> get columns {
  if (_columns is EqualUnmodifiableListView) return _columns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_columns);
}

@override final  BoardFilter activeFilter;
@override final  String? username;
@override final  String? avatarUrl;

/// Create a copy of BoardData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardDataCopyWith<_BoardData> get copyWith => __$BoardDataCopyWithImpl<_BoardData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardData&&const DeepCollectionEquality().equals(other._columns, _columns)&&(identical(other.activeFilter, activeFilter) || other.activeFilter == activeFilter)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_columns),activeFilter,username,avatarUrl);

@override
String toString() {
  return 'BoardData(columns: $columns, activeFilter: $activeFilter, username: $username, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$BoardDataCopyWith<$Res> implements $BoardDataCopyWith<$Res> {
  factory _$BoardDataCopyWith(_BoardData value, $Res Function(_BoardData) _then) = __$BoardDataCopyWithImpl;
@override @useResult
$Res call({
 List<BoardColumn> columns, BoardFilter activeFilter, String? username, String? avatarUrl
});


@override $BoardFilterCopyWith<$Res> get activeFilter;

}
/// @nodoc
class __$BoardDataCopyWithImpl<$Res>
    implements _$BoardDataCopyWith<$Res> {
  __$BoardDataCopyWithImpl(this._self, this._then);

  final _BoardData _self;
  final $Res Function(_BoardData) _then;

/// Create a copy of BoardData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? columns = null,Object? activeFilter = null,Object? username = freezed,Object? avatarUrl = freezed,}) {
  return _then(_BoardData(
columns: null == columns ? _self._columns : columns // ignore: cast_nullable_to_non_nullable
as List<BoardColumn>,activeFilter: null == activeFilter ? _self.activeFilter : activeFilter // ignore: cast_nullable_to_non_nullable
as BoardFilter,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of BoardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardFilterCopyWith<$Res> get activeFilter {
  
  return $BoardFilterCopyWith<$Res>(_self.activeFilter, (value) {
    return _then(_self.copyWith(activeFilter: value));
  });
}
}

// dart format on
