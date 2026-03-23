// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'issue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Issue {

 String get id; String get title; String get description; String get status; int get priority; String get issueType; String get owner; DateTime get createdAt; String get createdBy; DateTime get updatedAt; List<String> get dependencies; int get dependencyCount; int get commentCount; List<String> get labels; String get assignee;
/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IssueCopyWith<Issue> get copyWith => _$IssueCopyWithImpl<Issue>(this as Issue, _$identity);

  /// Serializes this Issue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Issue&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.issueType, issueType) || other.issueType == issueType)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.dependencies, dependencies)&&(identical(other.dependencyCount, dependencyCount) || other.dependencyCount == dependencyCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&const DeepCollectionEquality().equals(other.labels, labels)&&(identical(other.assignee, assignee) || other.assignee == assignee));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,status,priority,issueType,owner,createdAt,createdBy,updatedAt,const DeepCollectionEquality().hash(dependencies),dependencyCount,commentCount,const DeepCollectionEquality().hash(labels),assignee);

@override
String toString() {
  return 'Issue(id: $id, title: $title, description: $description, status: $status, priority: $priority, issueType: $issueType, owner: $owner, createdAt: $createdAt, createdBy: $createdBy, updatedAt: $updatedAt, dependencies: $dependencies, dependencyCount: $dependencyCount, commentCount: $commentCount, labels: $labels, assignee: $assignee)';
}


}

/// @nodoc
abstract mixin class $IssueCopyWith<$Res>  {
  factory $IssueCopyWith(Issue value, $Res Function(Issue) _then) = _$IssueCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String status, int priority, String issueType, String owner, DateTime createdAt, String createdBy, DateTime updatedAt, List<String> dependencies, int dependencyCount, int commentCount, List<String> labels, String assignee
});




}
/// @nodoc
class _$IssueCopyWithImpl<$Res>
    implements $IssueCopyWith<$Res> {
  _$IssueCopyWithImpl(this._self, this._then);

  final Issue _self;
  final $Res Function(Issue) _then;

/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? status = null,Object? priority = null,Object? issueType = null,Object? owner = null,Object? createdAt = null,Object? createdBy = null,Object? updatedAt = null,Object? dependencies = null,Object? dependencyCount = null,Object? commentCount = null,Object? labels = null,Object? assignee = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,issueType: null == issueType ? _self.issueType : issueType // ignore: cast_nullable_to_non_nullable
as String,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<String>,dependencyCount: null == dependencyCount ? _self.dependencyCount : dependencyCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,assignee: null == assignee ? _self.assignee : assignee // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}



/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Issue implements Issue {
  const _Issue({required this.id, required this.title, this.description = '', this.status = 'open', this.priority = 2, this.issueType = 'task', this.owner = '', required this.createdAt, this.createdBy = '', required this.updatedAt, final  List<String> dependencies = const [], this.dependencyCount = 0, this.commentCount = 0, final  List<String> labels = const [], this.assignee = ''}): _dependencies = dependencies,_labels = labels;
  factory _Issue.fromJson(Map<String, dynamic> json) => _$IssueFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  String status;
@override@JsonKey() final  int priority;
@override@JsonKey() final  String issueType;
@override@JsonKey() final  String owner;
@override final  DateTime createdAt;
@override@JsonKey() final  String createdBy;
@override final  DateTime updatedAt;
 final  List<String> _dependencies;
@override@JsonKey() List<String> get dependencies {
  if (_dependencies is EqualUnmodifiableListView) return _dependencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dependencies);
}

@override@JsonKey() final  int dependencyCount;
@override@JsonKey() final  int commentCount;
 final  List<String> _labels;
@override@JsonKey() List<String> get labels {
  if (_labels is EqualUnmodifiableListView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_labels);
}

@override@JsonKey() final  String assignee;

/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IssueCopyWith<_Issue> get copyWith => __$IssueCopyWithImpl<_Issue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IssueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Issue&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.issueType, issueType) || other.issueType == issueType)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._dependencies, _dependencies)&&(identical(other.dependencyCount, dependencyCount) || other.dependencyCount == dependencyCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&const DeepCollectionEquality().equals(other._labels, _labels)&&(identical(other.assignee, assignee) || other.assignee == assignee));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,status,priority,issueType,owner,createdAt,createdBy,updatedAt,const DeepCollectionEquality().hash(_dependencies),dependencyCount,commentCount,const DeepCollectionEquality().hash(_labels),assignee);

@override
String toString() {
  return 'Issue(id: $id, title: $title, description: $description, status: $status, priority: $priority, issueType: $issueType, owner: $owner, createdAt: $createdAt, createdBy: $createdBy, updatedAt: $updatedAt, dependencies: $dependencies, dependencyCount: $dependencyCount, commentCount: $commentCount, labels: $labels, assignee: $assignee)';
}


}

/// @nodoc
abstract mixin class _$IssueCopyWith<$Res> implements $IssueCopyWith<$Res> {
  factory _$IssueCopyWith(_Issue value, $Res Function(_Issue) _then) = __$IssueCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String status, int priority, String issueType, String owner, DateTime createdAt, String createdBy, DateTime updatedAt, List<String> dependencies, int dependencyCount, int commentCount, List<String> labels, String assignee
});




}
/// @nodoc
class __$IssueCopyWithImpl<$Res>
    implements _$IssueCopyWith<$Res> {
  __$IssueCopyWithImpl(this._self, this._then);

  final _Issue _self;
  final $Res Function(_Issue) _then;

/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? status = null,Object? priority = null,Object? issueType = null,Object? owner = null,Object? createdAt = null,Object? createdBy = null,Object? updatedAt = null,Object? dependencies = null,Object? dependencyCount = null,Object? commentCount = null,Object? labels = null,Object? assignee = null,}) {
  return _then(_Issue(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,issueType: null == issueType ? _self.issueType : issueType // ignore: cast_nullable_to_non_nullable
as String,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,dependencies: null == dependencies ? _self._dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<String>,dependencyCount: null == dependencyCount ? _self.dependencyCount : dependencyCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,assignee: null == assignee ? _self.assignee : assignee // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
