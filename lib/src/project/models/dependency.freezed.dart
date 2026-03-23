// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dependency.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Dependency {

 String get issueId; String get dependsOnId; String get type; DateTime get createdAt; String get createdBy; String get metadata;
/// Create a copy of Dependency
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DependencyCopyWith<Dependency> get copyWith => _$DependencyCopyWithImpl<Dependency>(this as Dependency, _$identity);

  /// Serializes this Dependency to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Dependency&&(identical(other.issueId, issueId) || other.issueId == issueId)&&(identical(other.dependsOnId, dependsOnId) || other.dependsOnId == dependsOnId)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,issueId,dependsOnId,type,createdAt,createdBy,metadata);

@override
String toString() {
  return 'Dependency(issueId: $issueId, dependsOnId: $dependsOnId, type: $type, createdAt: $createdAt, createdBy: $createdBy, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $DependencyCopyWith<$Res>  {
  factory $DependencyCopyWith(Dependency value, $Res Function(Dependency) _then) = _$DependencyCopyWithImpl;
@useResult
$Res call({
 String issueId, String dependsOnId, String type, DateTime createdAt, String createdBy, String metadata
});




}
/// @nodoc
class _$DependencyCopyWithImpl<$Res>
    implements $DependencyCopyWith<$Res> {
  _$DependencyCopyWithImpl(this._self, this._then);

  final Dependency _self;
  final $Res Function(Dependency) _then;

/// Create a copy of Dependency
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? issueId = null,Object? dependsOnId = null,Object? type = null,Object? createdAt = null,Object? createdBy = null,Object? metadata = null,}) {
  return _then(_self.copyWith(
issueId: null == issueId ? _self.issueId : issueId // ignore: cast_nullable_to_non_nullable
as String,dependsOnId: null == dependsOnId ? _self.dependsOnId : dependsOnId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}



/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Dependency implements Dependency {
  const _Dependency({required this.issueId, required this.dependsOnId, this.type = 'blocks', required this.createdAt, this.createdBy = '', this.metadata = '{}'});
  factory _Dependency.fromJson(Map<String, dynamic> json) => _$DependencyFromJson(json);

@override final  String issueId;
@override final  String dependsOnId;
@override@JsonKey() final  String type;
@override final  DateTime createdAt;
@override@JsonKey() final  String createdBy;
@override@JsonKey() final  String metadata;

/// Create a copy of Dependency
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DependencyCopyWith<_Dependency> get copyWith => __$DependencyCopyWithImpl<_Dependency>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DependencyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Dependency&&(identical(other.issueId, issueId) || other.issueId == issueId)&&(identical(other.dependsOnId, dependsOnId) || other.dependsOnId == dependsOnId)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,issueId,dependsOnId,type,createdAt,createdBy,metadata);

@override
String toString() {
  return 'Dependency(issueId: $issueId, dependsOnId: $dependsOnId, type: $type, createdAt: $createdAt, createdBy: $createdBy, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$DependencyCopyWith<$Res> implements $DependencyCopyWith<$Res> {
  factory _$DependencyCopyWith(_Dependency value, $Res Function(_Dependency) _then) = __$DependencyCopyWithImpl;
@override @useResult
$Res call({
 String issueId, String dependsOnId, String type, DateTime createdAt, String createdBy, String metadata
});




}
/// @nodoc
class __$DependencyCopyWithImpl<$Res>
    implements _$DependencyCopyWith<$Res> {
  __$DependencyCopyWithImpl(this._self, this._then);

  final _Dependency _self;
  final $Res Function(_Dependency) _then;

/// Create a copy of Dependency
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? issueId = null,Object? dependsOnId = null,Object? type = null,Object? createdAt = null,Object? createdBy = null,Object? metadata = null,}) {
  return _then(_Dependency(
issueId: null == issueId ? _self.issueId : issueId // ignore: cast_nullable_to_non_nullable
as String,dependsOnId: null == dependsOnId ? _self.dependsOnId : dependsOnId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
