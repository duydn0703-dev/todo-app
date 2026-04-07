// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo_app/app.dart';
import 'package:todo_app/core/di/injection.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await configureDependencies();
  });

  testWidgets('Add and complete todo via screens', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());

    expect(find.text('No todos yet. Tap + to add one.'), findsOneWidget);

    await tester.tap(find.byTooltip('Add todo'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'Buy milk');
    await tester.enterText(find.byType(TextFormField).at(1), 'At supermarket');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Buy milk'), findsOneWidget);
    expect(find.text('Priority: Medium'), findsOneWidget);

    await tester.tap(find.text('Buy milk'));
    await tester.pumpAndSettle();

    expect(find.textContaining('At supermarket'), findsOneWidget);
    expect(find.text('Status: Pending'), findsOneWidget);

    await tester.tap(find.text('Mark as done'));
    await tester.pumpAndSettle();

    expect(find.text('Status: Done'), findsOneWidget);
  });
}
