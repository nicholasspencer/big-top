// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectData {

 List<Issue> get issues; List<Comment> get comments; List<Label> get labels; List<Dependency> get dependencies; List<Event> get events;
/// Create a copy of ProjectData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectDataCopyWith<ProjectData> get copyWith => _$ProjectDataCopyWithImpl<ProjectData>(this as ProjectData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectData&&const DeepCollectionEquality().equals(other.issues, issues)&&const DeepCollectionEquality().equals(other.comments, comments)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.dependencies, dependencies)&&const DeepCollectionEquality().equals(other.events, events));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(issues),const DeepCollectionEquality().hash(comments),const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(dependencies),const DeepCollectionEquality().hash(events));

@override
String toString() {
  return 'ProjectData(issues: $issues, comments: $comments, labels: $labels, dependencies: $dependencies, events: $events)';
}


}

/// @nodoc
abstract mixin class $ProjectDataCopyWith<$Res>  {
  factory $ProjectDataCopyWith(ProjectData value, $Res Function(ProjectData) _then) = _$ProjectDataCopyWithImpl;
@useResult
$Res call({
 List<Issue> issues, List<Comment> comments, List<Label> labels, List<Dependency> dependencies, List<Event> events
});




}
/// @nodoc
class _$ProjectDataCopyWithImpl<$Res>
    implements $ProjectDataCopyWith<$Res> {
  _$ProjectDataCopyWithImpl(this._self, this._then);

  final ProjectData _self;
  final $Res Function(ProjectData) _then;

/// Create a copy of ProjectData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? issues = null,Object? comments = null,Object? labels = null,Object? dependencies = null,Object? events = null,}) {
  return _then(_self.copyWith(
issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as List<Issue>,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<Label>,dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<Dependency>,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<Event>,
  ));
}

}



/// @nodoc


class _ProjectData implements ProjectData {
  const _ProjectData({final  List<Issue> issues = const [], final  List<Comment> comments = const [], final  List<Label> labels = const [], final  List<Dependency> dependencies = const [], final  List<Event> events = const []}): _issues = issues,_comments = comments,_labels = labels,_dependencies = dependencies,_events = events;
  

 final  List<Issue> _issues;
@override@JsonKey() List<Issue> get issues {
  if (_issues is EqualUnmodifiableListView) return _issues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_issues);
}

 final  List<Comment> _comments;
@override@JsonKey() List<Comment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

 final  List<Label> _labels;
@override@JsonKey() List<Label> get labels {
  if (_labels is EqualUnmodifiableListView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_labels);
}

 final  List<Dependency> _dependencies;
@override@JsonKey() List<Dependency> get dependencies {
  if (_dependencies is EqualUnmodifiableListView) return _dependencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dependencies);
}

 final  List<Event> _events;
@override@JsonKey() List<Event> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}


/// Create a copy of ProjectData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectDataCopyWith<_ProjectData> get copyWith => __$ProjectDataCopyWithImpl<_ProjectData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectData&&const DeepCollectionEquality().equals(other._issues, _issues)&&const DeepCollectionEquality().equals(other._comments, _comments)&&const DeepCollectionEquality().equals(other._labels, _labels)&&const DeepCollectionEquality().equals(other._dependencies, _dependencies)&&const DeepCollectionEquality().equals(other._events, _events));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_issues),const DeepCollectionEquality().hash(_comments),const DeepCollectionEquality().hash(_labels),const DeepCollectionEquality().hash(_dependencies),const DeepCollectionEquality().hash(_events));

@override
String toString() {
  return 'ProjectData(issues: $issues, comments: $comments, labels: $labels, dependencies: $dependencies, events: $events)';
}


}

/// @nodoc
abstract mixin class _$ProjectDataCopyWith<$Res> implements $ProjectDataCopyWith<$Res> {
  factory _$ProjectDataCopyWith(_ProjectData value, $Res Function(_ProjectData) _then) = __$ProjectDataCopyWithImpl;
@override @useResult
$Res call({
 List<Issue> issues, List<Comment> comments, List<Label> labels, List<Dependency> dependencies, List<Event> events
});




}
/// @nodoc
class __$ProjectDataCopyWithImpl<$Res>
    implements _$ProjectDataCopyWith<$Res> {
  __$ProjectDataCopyWithImpl(this._self, this._then);

  final _ProjectData _self;
  final $Res Function(_ProjectData) _then;

/// Create a copy of ProjectData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? issues = null,Object? comments = null,Object? labels = null,Object? dependencies = null,Object? events = null,}) {
  return _then(_ProjectData(
issues: null == issues ? _self._issues : issues // ignore: cast_nullable_to_non_nullable
as List<Issue>,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<Label>,dependencies: null == dependencies ? _self._dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<Dependency>,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<Event>,
  ));
}


}

// dart format on
