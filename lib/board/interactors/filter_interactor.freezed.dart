// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_interactor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BoardFilter {

 Set<String> get labels; Set<int> get priorities; Set<String> get assignees;
/// Create a copy of BoardFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardFilterCopyWith<BoardFilter> get copyWith => _$BoardFilterCopyWithImpl<BoardFilter>(this as BoardFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardFilter&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.priorities, priorities)&&const DeepCollectionEquality().equals(other.assignees, assignees));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(priorities),const DeepCollectionEquality().hash(assignees));

@override
String toString() {
  return 'BoardFilter(labels: $labels, priorities: $priorities, assignees: $assignees)';
}


}

/// @nodoc
abstract mixin class $BoardFilterCopyWith<$Res>  {
  factory $BoardFilterCopyWith(BoardFilter value, $Res Function(BoardFilter) _then) = _$BoardFilterCopyWithImpl;
@useResult
$Res call({
 Set<String> labels, Set<int> priorities, Set<String> assignees
});




}
/// @nodoc
class _$BoardFilterCopyWithImpl<$Res>
    implements $BoardFilterCopyWith<$Res> {
  _$BoardFilterCopyWithImpl(this._self, this._then);

  final BoardFilter _self;
  final $Res Function(BoardFilter) _then;

/// Create a copy of BoardFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? labels = null,Object? priorities = null,Object? assignees = null,}) {
  return _then(_self.copyWith(
labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as Set<String>,priorities: null == priorities ? _self.priorities : priorities // ignore: cast_nullable_to_non_nullable
as Set<int>,assignees: null == assignees ? _self.assignees : assignees // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}



/// @nodoc


class _BoardFilter implements BoardFilter {
  const _BoardFilter({final  Set<String> labels = const {}, final  Set<int> priorities = const {}, final  Set<String> assignees = const {}}): _labels = labels,_priorities = priorities,_assignees = assignees;
  

 final  Set<String> _labels;
@override@JsonKey() Set<String> get labels {
  if (_labels is EqualUnmodifiableSetView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_labels);
}

 final  Set<int> _priorities;
@override@JsonKey() Set<int> get priorities {
  if (_priorities is EqualUnmodifiableSetView) return _priorities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_priorities);
}

 final  Set<String> _assignees;
@override@JsonKey() Set<String> get assignees {
  if (_assignees is EqualUnmodifiableSetView) return _assignees;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_assignees);
}


/// Create a copy of BoardFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardFilterCopyWith<_BoardFilter> get copyWith => __$BoardFilterCopyWithImpl<_BoardFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardFilter&&const DeepCollectionEquality().equals(other._labels, _labels)&&const DeepCollectionEquality().equals(other._priorities, _priorities)&&const DeepCollectionEquality().equals(other._assignees, _assignees));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_labels),const DeepCollectionEquality().hash(_priorities),const DeepCollectionEquality().hash(_assignees));

@override
String toString() {
  return 'BoardFilter(labels: $labels, priorities: $priorities, assignees: $assignees)';
}


}

/// @nodoc
abstract mixin class _$BoardFilterCopyWith<$Res> implements $BoardFilterCopyWith<$Res> {
  factory _$BoardFilterCopyWith(_BoardFilter value, $Res Function(_BoardFilter) _then) = __$BoardFilterCopyWithImpl;
@override @useResult
$Res call({
 Set<String> labels, Set<int> priorities, Set<String> assignees
});




}
/// @nodoc
class __$BoardFilterCopyWithImpl<$Res>
    implements _$BoardFilterCopyWith<$Res> {
  __$BoardFilterCopyWithImpl(this._self, this._then);

  final _BoardFilter _self;
  final $Res Function(_BoardFilter) _then;

/// Create a copy of BoardFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? labels = null,Object? priorities = null,Object? assignees = null,}) {
  return _then(_BoardFilter(
labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as Set<String>,priorities: null == priorities ? _self._priorities : priorities // ignore: cast_nullable_to_non_nullable
as Set<int>,assignees: null == assignees ? _self._assignees : assignees // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
