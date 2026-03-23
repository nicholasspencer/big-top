// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_interactor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectSelection {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSelection);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProjectSelection()';
}


}

/// @nodoc
class $ProjectSelectionCopyWith<$Res>  {
$ProjectSelectionCopyWith(ProjectSelection _, $Res Function(ProjectSelection) __);
}



/// @nodoc


class ProjectSelectionNone implements ProjectSelection {
  const ProjectSelectionNone();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSelectionNone);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProjectSelection.none()';
}


}




/// @nodoc


class ProjectSelectionSelected implements ProjectSelection {
  const ProjectSelectionSelected({required this.owner, required this.repo, required this.project});
  

 final  String owner;
 final  String repo;
 final  String project;

/// Create a copy of ProjectSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSelectionSelectedCopyWith<ProjectSelectionSelected> get copyWith => _$ProjectSelectionSelectedCopyWithImpl<ProjectSelectionSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSelectionSelected&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.repo, repo) || other.repo == repo)&&(identical(other.project, project) || other.project == project));
}


@override
int get hashCode => Object.hash(runtimeType,owner,repo,project);

@override
String toString() {
  return 'ProjectSelection.selected(owner: $owner, repo: $repo, project: $project)';
}


}

/// @nodoc
abstract mixin class $ProjectSelectionSelectedCopyWith<$Res> implements $ProjectSelectionCopyWith<$Res> {
  factory $ProjectSelectionSelectedCopyWith(ProjectSelectionSelected value, $Res Function(ProjectSelectionSelected) _then) = _$ProjectSelectionSelectedCopyWithImpl;
@useResult
$Res call({
 String owner, String repo, String project
});




}
/// @nodoc
class _$ProjectSelectionSelectedCopyWithImpl<$Res>
    implements $ProjectSelectionSelectedCopyWith<$Res> {
  _$ProjectSelectionSelectedCopyWithImpl(this._self, this._then);

  final ProjectSelectionSelected _self;
  final $Res Function(ProjectSelectionSelected) _then;

/// Create a copy of ProjectSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? owner = null,Object? repo = null,Object? project = null,}) {
  return _then(ProjectSelectionSelected(
owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,repo: null == repo ? _self.repo : repo // ignore: cast_nullable_to_non_nullable
as String,project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ProjectInteractorState {

 ProjectSelection get selection; AsyncValue<ProjectData> get data;
/// Create a copy of ProjectInteractorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectInteractorStateCopyWith<ProjectInteractorState> get copyWith => _$ProjectInteractorStateCopyWithImpl<ProjectInteractorState>(this as ProjectInteractorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectInteractorState&&(identical(other.selection, selection) || other.selection == selection)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,selection,data);

@override
String toString() {
  return 'ProjectInteractorState(selection: $selection, data: $data)';
}


}

/// @nodoc
abstract mixin class $ProjectInteractorStateCopyWith<$Res>  {
  factory $ProjectInteractorStateCopyWith(ProjectInteractorState value, $Res Function(ProjectInteractorState) _then) = _$ProjectInteractorStateCopyWithImpl;
@useResult
$Res call({
 ProjectSelection selection, AsyncValue<ProjectData> data
});


$ProjectSelectionCopyWith<$Res> get selection;$AsyncValueCopyWith<ProjectData, $Res> get data;

}
/// @nodoc
class _$ProjectInteractorStateCopyWithImpl<$Res>
    implements $ProjectInteractorStateCopyWith<$Res> {
  _$ProjectInteractorStateCopyWithImpl(this._self, this._then);

  final ProjectInteractorState _self;
  final $Res Function(ProjectInteractorState) _then;

/// Create a copy of ProjectInteractorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selection = null,Object? data = null,}) {
  return _then(_self.copyWith(
selection: null == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as ProjectSelection,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AsyncValue<ProjectData>,
  ));
}
/// Create a copy of ProjectInteractorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSelectionCopyWith<$Res> get selection {
  
  return $ProjectSelectionCopyWith<$Res>(_self.selection, (value) {
    return _then(_self.copyWith(selection: value));
  });
}/// Create a copy of ProjectInteractorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AsyncValueCopyWith<ProjectData, $Res> get data {
  
  return $AsyncValueCopyWith<ProjectData, $Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}



/// @nodoc


class _ProjectInteractorState implements ProjectInteractorState {
  const _ProjectInteractorState({this.selection = const ProjectSelection.none(), this.data = const AsyncValue<ProjectData>.none()});
  

@override@JsonKey() final  ProjectSelection selection;
@override@JsonKey() final  AsyncValue<ProjectData> data;

/// Create a copy of ProjectInteractorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectInteractorStateCopyWith<_ProjectInteractorState> get copyWith => __$ProjectInteractorStateCopyWithImpl<_ProjectInteractorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectInteractorState&&(identical(other.selection, selection) || other.selection == selection)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,selection,data);

@override
String toString() {
  return 'ProjectInteractorState(selection: $selection, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ProjectInteractorStateCopyWith<$Res> implements $ProjectInteractorStateCopyWith<$Res> {
  factory _$ProjectInteractorStateCopyWith(_ProjectInteractorState value, $Res Function(_ProjectInteractorState) _then) = __$ProjectInteractorStateCopyWithImpl;
@override @useResult
$Res call({
 ProjectSelection selection, AsyncValue<ProjectData> data
});


@override $ProjectSelectionCopyWith<$Res> get selection;@override $AsyncValueCopyWith<ProjectData, $Res> get data;

}
/// @nodoc
class __$ProjectInteractorStateCopyWithImpl<$Res>
    implements _$ProjectInteractorStateCopyWith<$Res> {
  __$ProjectInteractorStateCopyWithImpl(this._self, this._then);

  final _ProjectInteractorState _self;
  final $Res Function(_ProjectInteractorState) _then;

/// Create a copy of ProjectInteractorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selection = null,Object? data = null,}) {
  return _then(_ProjectInteractorState(
selection: null == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as ProjectSelection,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AsyncValue<ProjectData>,
  ));
}

/// Create a copy of ProjectInteractorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSelectionCopyWith<$Res> get selection {
  
  return $ProjectSelectionCopyWith<$Res>(_self.selection, (value) {
    return _then(_self.copyWith(selection: value));
  });
}/// Create a copy of ProjectInteractorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AsyncValueCopyWith<ProjectData, $Res> get data {
  
  return $AsyncValueCopyWith<ProjectData, $Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
