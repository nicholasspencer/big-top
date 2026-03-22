// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'issue_detail_selector.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IssueDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'IssueDetailState()';
}


}

/// @nodoc
class $IssueDetailStateCopyWith<$Res>  {
$IssueDetailStateCopyWith(IssueDetailState _, $Res Function(IssueDetailState) __);
}



/// @nodoc


class IssueDetailEmpty implements IssueDetailState {
  const IssueDetailEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueDetailEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'IssueDetailState.empty()';
}


}




/// @nodoc


class IssueDetailLoading implements IssueDetailState {
  const IssueDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'IssueDetailState.loading()';
}


}




/// @nodoc


class IssueDetailLoaded implements IssueDetailState {
  const IssueDetailLoaded({required this.issue, required final  List<Comment> comments, required final  List<Label> labels, required final  List<Dependency> dependencies}): _comments = comments,_labels = labels,_dependencies = dependencies;
  

 final  Issue issue;
 final  List<Comment> _comments;
 List<Comment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

 final  List<Label> _labels;
 List<Label> get labels {
  if (_labels is EqualUnmodifiableListView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_labels);
}

 final  List<Dependency> _dependencies;
 List<Dependency> get dependencies {
  if (_dependencies is EqualUnmodifiableListView) return _dependencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dependencies);
}


/// Create a copy of IssueDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IssueDetailLoadedCopyWith<IssueDetailLoaded> get copyWith => _$IssueDetailLoadedCopyWithImpl<IssueDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueDetailLoaded&&(identical(other.issue, issue) || other.issue == issue)&&const DeepCollectionEquality().equals(other._comments, _comments)&&const DeepCollectionEquality().equals(other._labels, _labels)&&const DeepCollectionEquality().equals(other._dependencies, _dependencies));
}


@override
int get hashCode => Object.hash(runtimeType,issue,const DeepCollectionEquality().hash(_comments),const DeepCollectionEquality().hash(_labels),const DeepCollectionEquality().hash(_dependencies));

@override
String toString() {
  return 'IssueDetailState.loaded(issue: $issue, comments: $comments, labels: $labels, dependencies: $dependencies)';
}


}

/// @nodoc
abstract mixin class $IssueDetailLoadedCopyWith<$Res> implements $IssueDetailStateCopyWith<$Res> {
  factory $IssueDetailLoadedCopyWith(IssueDetailLoaded value, $Res Function(IssueDetailLoaded) _then) = _$IssueDetailLoadedCopyWithImpl;
@useResult
$Res call({
 Issue issue, List<Comment> comments, List<Label> labels, List<Dependency> dependencies
});


$IssueCopyWith<$Res> get issue;

}
/// @nodoc
class _$IssueDetailLoadedCopyWithImpl<$Res>
    implements $IssueDetailLoadedCopyWith<$Res> {
  _$IssueDetailLoadedCopyWithImpl(this._self, this._then);

  final IssueDetailLoaded _self;
  final $Res Function(IssueDetailLoaded) _then;

/// Create a copy of IssueDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? issue = null,Object? comments = null,Object? labels = null,Object? dependencies = null,}) {
  return _then(IssueDetailLoaded(
issue: null == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as Issue,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<Label>,dependencies: null == dependencies ? _self._dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<Dependency>,
  ));
}

/// Create a copy of IssueDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IssueCopyWith<$Res> get issue {
  
  return $IssueCopyWith<$Res>(_self.issue, (value) {
    return _then(_self.copyWith(issue: value));
  });
}
}

/// @nodoc


class IssueDetailNotFound implements IssueDetailState {
  const IssueDetailNotFound();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueDetailNotFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'IssueDetailState.notFound()';
}


}




/// @nodoc


class IssueDetailError implements IssueDetailState {
  const IssueDetailError({required this.message});
  

 final  String message;

/// Create a copy of IssueDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IssueDetailErrorCopyWith<IssueDetailError> get copyWith => _$IssueDetailErrorCopyWithImpl<IssueDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'IssueDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $IssueDetailErrorCopyWith<$Res> implements $IssueDetailStateCopyWith<$Res> {
  factory $IssueDetailErrorCopyWith(IssueDetailError value, $Res Function(IssueDetailError) _then) = _$IssueDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$IssueDetailErrorCopyWithImpl<$Res>
    implements $IssueDetailErrorCopyWith<$Res> {
  _$IssueDetailErrorCopyWithImpl(this._self, this._then);

  final IssueDetailError _self;
  final $Res Function(IssueDetailError) _then;

/// Create a copy of IssueDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(IssueDetailError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
