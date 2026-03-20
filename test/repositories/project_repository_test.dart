import 'package:big_top/repositories/project_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProjectRepository', () {
    late ProjectRepository repo;

    setUp(() {
      repo = ProjectRepository();
    });

    tearDown(() {
      repo.dispose();
    });

    test('initial state has no selection', () {
      expect(repo.state.isSelected, isFalse);
      expect(repo.state.owner, isNull);
      expect(repo.state.repo, isNull);
      expect(repo.state.project, isNull);
    });

    test('selectProject emits new state', () {
      repo.selectProject(owner: 'octocat', repo: 'hello-world', project: 'p1');

      expect(repo.state.isSelected, isTrue);
      expect(repo.state.owner, 'octocat');
      expect(repo.state.repo, 'hello-world');
      expect(repo.state.project, 'p1');
      expect(repo.state.fullName, 'octocat/hello-world');
    });

    test('clear resets to initial state', () {
      repo.selectProject(owner: 'octocat', repo: 'hello-world');
      repo.clear();

      expect(repo.state.isSelected, isFalse);
      expect(repo.state.owner, isNull);
      expect(repo.state.repo, isNull);
    });

    test('selectProject without project parameter', () {
      repo.selectProject(owner: 'octocat', repo: 'hello-world');

      expect(repo.state.isSelected, isTrue);
      expect(repo.state.project, isNull);
    });
  });
}
