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
mixin _$IssueDetail {

 Issue get issue; List<Comment> get comments; List<Label> get labels; List<Dependency> get dependencies;
/// Create a copy of IssueDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IssueDetailCopyWith<IssueDetail> get copyWith => _$IssueDetailCopyWithImpl<IssueDetail>(this as IssueDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueDetail&&(identical(other.issue, issue) || other.issue == issue)&&const DeepCollectionEquality().equals(other.comments, comments)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.dependencies, dependencies));
}


@override
int get hashCode => Object.hash(runtimeType,issue,const DeepCollectionEquality().hash(comments),const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(dependencies));

@override
String toString() {
  return 'IssueDetail(issue: $issue, comments: $comments, labels: $labels, dependencies: $dependencies)';
}


}

/// @nodoc
abstract mixin class $IssueDetailCopyWith<$Res>  {
  factory $IssueDetailCopyWith(IssueDetail value, $Res Function(IssueDetail) _then) = _$IssueDetailCopyWithImpl;
@useResult
$Res call({
 Issue issue, List<Comment> comments, List<Label> labels, List<Dependency> dependencies
});


$IssueCopyWith<$Res> get issue;

}
/// @nodoc
class _$IssueDetailCopyWithImpl<$Res>
    implements $IssueDetailCopyWith<$Res> {
  _$IssueDetailCopyWithImpl(this._self, this._then);

  final IssueDetail _self;
  final $Res Function(IssueDetail) _then;

/// Create a copy of IssueDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? issue = null,Object? comments = null,Object? labels = null,Object? dependencies = null,}) {
  return _then(_self.copyWith(
issue: null == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as Issue,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<Label>,dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<Dependency>,
  ));
}
/// Create a copy of IssueDetail
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


class _IssueDetail implements IssueDetail {
  const _IssueDetail({required this.issue, final  List<Comment> comments = const [], final  List<Label> labels = const [], final  List<Dependency> dependencies = const []}): _comments = comments,_labels = labels,_dependencies = dependencies;
  

@override final  Issue issue;
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


/// Create a copy of IssueDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IssueDetailCopyWith<_IssueDetail> get copyWith => __$IssueDetailCopyWithImpl<_IssueDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IssueDetail&&(identical(other.issue, issue) || other.issue == issue)&&const DeepCollectionEquality().equals(other._comments, _comments)&&const DeepCollectionEquality().equals(other._labels, _labels)&&const DeepCollectionEquality().equals(other._dependencies, _dependencies));
}


@override
int get hashCode => Object.hash(runtimeType,issue,const DeepCollectionEquality().hash(_comments),const DeepCollectionEquality().hash(_labels),const DeepCollectionEquality().hash(_dependencies));

@override
String toString() {
  return 'IssueDetail(issue: $issue, comments: $comments, labels: $labels, dependencies: $dependencies)';
}


}

/// @nodoc
abstract mixin class _$IssueDetailCopyWith<$Res> implements $IssueDetailCopyWith<$Res> {
  factory _$IssueDetailCopyWith(_IssueDetail value, $Res Function(_IssueDetail) _then) = __$IssueDetailCopyWithImpl;
@override @useResult
$Res call({
 Issue issue, List<Comment> comments, List<Label> labels, List<Dependency> dependencies
});


@override $IssueCopyWith<$Res> get issue;

}
/// @nodoc
class __$IssueDetailCopyWithImpl<$Res>
    implements _$IssueDetailCopyWith<$Res> {
  __$IssueDetailCopyWithImpl(this._self, this._then);

  final _IssueDetail _self;
  final $Res Function(_IssueDetail) _then;

/// Create a copy of IssueDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? issue = null,Object? comments = null,Object? labels = null,Object? dependencies = null,}) {
  return _then(_IssueDetail(
issue: null == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as Issue,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<Label>,dependencies: null == dependencies ? _self._dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<Dependency>,
  ));
}

/// Create a copy of IssueDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IssueCopyWith<$Res> get issue {
  
  return $IssueCopyWith<$Res>(_self.issue, (value) {
    return _then(_self.copyWith(issue: value));
  });
}
}

// dart format on
