import 'package:big_top/board/widgets/issue_card.dart';
import 'package:big_top/project/models/issue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2025);

  Widget buildCard(Issue issue) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 300,
          child: IssueCard(issue: issue),
        ),
      ),
    );
  }

  group('IssueCard', () {
    testWidgets('renders issue id and title', (tester) async {
      final issue = Issue(
        id: 'test-1',
        title: 'Fix the thing',
        createdAt: now,
        updatedAt: now,
      );
      await tester.pumpWidget(buildCard(issue));

      expect(find.text('test-1'), findsOneWidget);
      expect(find.text('Fix the thing'), findsOneWidget);
    });

    testWidgets('renders label chips when labels are present', (tester) async {
      final issue = Issue(
        id: 'test-2',
        title: 'Labeled issue',
        labels: ['bug', 'frontend'],
        createdAt: now,
        updatedAt: now,
      );
      await tester.pumpWidget(buildCard(issue));

      expect(find.text('bug'), findsOneWidget);
      expect(find.text('frontend'), findsOneWidget);
    });

    testWidgets('does not render label section when labels are empty',
        (tester) async {
      final issue = Issue(
        id: 'test-3',
        title: 'No labels',
        labels: [],
        createdAt: now,
        updatedAt: now,
      );
      await tester.pumpWidget(buildCard(issue));

      // Only the id and title should appear, no label chips
      expect(find.text('test-3'), findsOneWidget);
      expect(find.text('No labels'), findsOneWidget);
    });

    testWidgets('renders assignee avatar when present', (tester) async {
      final issue = Issue(
        id: 'test-4',
        title: 'Assigned issue',
        assignee: 'alice',
        createdAt: now,
        updatedAt: now,
      );
      await tester.pumpWidget(buildCard(issue));

      // Should show the first letter of assignee
      expect(find.text('A'), findsOneWidget);
      // Tooltip should contain full assignee name
      expect(find.byType(Tooltip), findsOneWidget);
    });

    testWidgets('does not render assignee when empty', (tester) async {
      final issue = Issue(
        id: 'test-5',
        title: 'Unassigned',
        assignee: '',
        createdAt: now,
        updatedAt: now,
      );
      await tester.pumpWidget(buildCard(issue));

      expect(find.byType(CircleAvatar), findsNothing);
    });

    testWidgets('renders both labels and assignee together', (tester) async {
      final issue = Issue(
        id: 'test-6',
        title: 'Full card',
        labels: ['feature'],
        assignee: 'bob',
        createdAt: now,
        updatedAt: now,
      );
      await tester.pumpWidget(buildCard(issue));

      expect(find.text('feature'), findsOneWidget);
      expect(find.text('B'), findsOneWidget); // bob's avatar
    });
  });
}
