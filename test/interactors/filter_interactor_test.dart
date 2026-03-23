import 'package:big_top/board/interactors/filter_interactor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FilterInteractor', () {
    late FilterInteractor interactor;

    setUp(() {
      interactor = FilterInteractor();
    });

    tearDown(() {
      interactor.dispose();
    });

    test('initial state has empty filters and isActive is false', () {
      expect(interactor.state.labels, isEmpty);
      expect(interactor.state.priorities, isEmpty);
      expect(interactor.state.assignees, isEmpty);
      expect(interactor.state.isActive, isFalse);
    });

    group('toggleLabel', () {
      test('adds label when not present', () {
        interactor.toggleLabel('bug');
        expect(interactor.state.labels, {'bug'});
        expect(interactor.state.isActive, isTrue);
      });

      test('removes label when already present', () {
        interactor.toggleLabel('bug');
        interactor.toggleLabel('bug');
        expect(interactor.state.labels, isEmpty);
        expect(interactor.state.isActive, isFalse);
      });

      test('supports multiple labels', () {
        interactor.toggleLabel('bug');
        interactor.toggleLabel('feature');
        expect(interactor.state.labels, {'bug', 'feature'});
      });
    });

    group('togglePriority', () {
      test('adds priority when not present', () {
        interactor.togglePriority(1);
        expect(interactor.state.priorities, {1});
        expect(interactor.state.isActive, isTrue);
      });

      test('removes priority when already present', () {
        interactor.togglePriority(1);
        interactor.togglePriority(1);
        expect(interactor.state.priorities, isEmpty);
      });

      test('supports multiple priorities', () {
        interactor.togglePriority(0);
        interactor.togglePriority(2);
        expect(interactor.state.priorities, {0, 2});
      });
    });

    group('toggleAssignee', () {
      test('adds assignee when not present', () {
        interactor.toggleAssignee('alice');
        expect(interactor.state.assignees, {'alice'});
        expect(interactor.state.isActive, isTrue);
      });

      test('removes assignee when already present', () {
        interactor.toggleAssignee('alice');
        interactor.toggleAssignee('alice');
        expect(interactor.state.assignees, isEmpty);
      });
    });

    group('clearAll', () {
      test('resets all filters', () {
        interactor.toggleLabel('bug');
        interactor.togglePriority(1);
        interactor.toggleAssignee('alice');
        expect(interactor.state.isActive, isTrue);

        interactor.clearAll();
        expect(interactor.state.labels, isEmpty);
        expect(interactor.state.priorities, isEmpty);
        expect(interactor.state.assignees, isEmpty);
        expect(interactor.state.isActive, isFalse);
      });
    });

    group('isActive', () {
      test('is true when only labels set', () {
        interactor.toggleLabel('bug');
        expect(interactor.state.isActive, isTrue);
      });

      test('is true when only priorities set', () {
        interactor.togglePriority(0);
        expect(interactor.state.isActive, isTrue);
      });

      test('is true when only assignees set', () {
        interactor.toggleAssignee('bob');
        expect(interactor.state.isActive, isTrue);
      });
    });
  });
}
