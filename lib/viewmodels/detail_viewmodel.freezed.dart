// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DetailState {

 Issue? get issue; List<Comment> get comments; List<Label> get labels; List<Dependency> get dependencies;
/// Create a copy of DetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailStateCopyWith<DetailState> get copyWith => _$DetailStateCopyWithImpl<DetailState>(this as DetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailState&&(identical(other.issue, issue) || other.issue == issue)&&const DeepCollectionEquality().equals(other.comments, comments)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.dependencies, dependencies));
}


@override
int get hashCode => Object.hash(runtimeType,issue,const DeepCollectionEquality().hash(comments),const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(dependencies));

@override
String toString() {
  return 'DetailState(issue: $issue, comments: $comments, labels: $labels, dependencies: $dependencies)';
}


}

/// @nodoc
abstract mixin class $DetailStateCopyWith<$Res>  {
  factory $DetailStateCopyWith(DetailState value, $Res Function(DetailState) _then) = _$DetailStateCopyWithImpl;
@useResult
$Res call({
 Issue? issue, List<Comment> comments, List<Label> labels, List<Dependency> dependencies
});


$IssueCopyWith<$Res>? get issue;

}
/// @nodoc
class _$DetailStateCopyWithImpl<$Res>
    implements $DetailStateCopyWith<$Res> {
  _$DetailStateCopyWithImpl(this._self, this._then);

  final DetailState _self;
  final $Res Function(DetailState) _then;

/// Create a copy of DetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? issue = freezed,Object? comments = null,Object? labels = null,Object? dependencies = null,}) {
  return _then(_self.copyWith(
issue: freezed == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as Issue?,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<Label>,dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<Dependency>,
  ));
}
/// Create a copy of DetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IssueCopyWith<$Res>? get issue {
    if (_self.issue == null) {
    return null;
  }

  return $IssueCopyWith<$Res>(_self.issue!, (value) {
    return _then(_self.copyWith(issue: value));
  });
}
}



/// @nodoc


class _DetailState implements DetailState {
  const _DetailState({this.issue, final  List<Comment> comments = const [], final  List<Label> labels = const [], final  List<Dependency> dependencies = const []}): _comments = comments,_labels = labels,_dependencies = dependencies;
  

@override final  Issue? issue;
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


/// Create a copy of DetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailStateCopyWith<_DetailState> get copyWith => __$DetailStateCopyWithImpl<_DetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetailState&&(identical(other.issue, issue) || other.issue == issue)&&const DeepCollectionEquality().equals(other._comments, _comments)&&const DeepCollectionEquality().equals(other._labels, _labels)&&const DeepCollectionEquality().equals(other._dependencies, _dependencies));
}


@override
int get hashCode => Object.hash(runtimeType,issue,const DeepCollectionEquality().hash(_comments),const DeepCollectionEquality().hash(_labels),const DeepCollectionEquality().hash(_dependencies));

@override
String toString() {
  return 'DetailState(issue: $issue, comments: $comments, labels: $labels, dependencies: $dependencies)';
}


}

/// @nodoc
abstract mixin class _$DetailStateCopyWith<$Res> implements $DetailStateCopyWith<$Res> {
  factory _$DetailStateCopyWith(_DetailState value, $Res Function(_DetailState) _then) = __$DetailStateCopyWithImpl;
@override @useResult
$Res call({
 Issue? issue, List<Comment> comments, List<Label> labels, List<Dependency> dependencies
});


@override $IssueCopyWith<$Res>? get issue;

}
/// @nodoc
class __$DetailStateCopyWithImpl<$Res>
    implements _$DetailStateCopyWith<$Res> {
  __$DetailStateCopyWithImpl(this._self, this._then);

  final _DetailState _self;
  final $Res Function(_DetailState) _then;

/// Create a copy of DetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? issue = freezed,Object? comments = null,Object? labels = null,Object? dependencies = null,}) {
  return _then(_DetailState(
issue: freezed == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as Issue?,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<Label>,dependencies: null == dependencies ? _self._dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<Dependency>,
  ));
}

/// Create a copy of DetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IssueCopyWith<$Res>? get issue {
    if (_self.issue == null) {
    return null;
  }

  return $IssueCopyWith<$Res>(_self.issue!, (value) {
    return _then(_self.copyWith(issue: value));
  });
}
}

// dart format on
