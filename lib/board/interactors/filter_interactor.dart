import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

part 'filter_interactor.freezed.dart';

@freezed
sealed class BoardFilter with _$BoardFilter {
  const factory BoardFilter({
    @Default({}) Set<String> labels,
    @Default({}) Set<int> priorities,
    @Default({}) Set<String> assignees,
  }) = _BoardFilter;
}

extension BoardFilterX on BoardFilter {
  bool get isActive =>
      labels.isNotEmpty || priorities.isNotEmpty || assignees.isNotEmpty;
}

class FilterInteractor extends StateNotifier<BoardFilter> {
  FilterInteractor() : super(const BoardFilter());

  void toggleLabel(String label) {
    final updated = Set<String>.from(state.labels);
    if (!updated.remove(label)) updated.add(label);
    state = state.copyWith(labels: updated);
  }

  void togglePriority(int priority) {
    final updated = Set<int>.from(state.priorities);
    if (!updated.remove(priority)) updated.add(priority);
    state = state.copyWith(priorities: updated);
  }

  void toggleAssignee(String assignee) {
    final updated = Set<String>.from(state.assignees);
    if (!updated.remove(assignee)) updated.add(assignee);
    state = state.copyWith(assignees: updated);
  }

  void clearAll() {
    state = const BoardFilter();
  }
}
