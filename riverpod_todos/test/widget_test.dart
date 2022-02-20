// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:riverpod_todos/main.dart';

void main() {
  final addTodoInput = find.byKey(addTodoKey);
  final activeFilterButton = find.byKey(activeFilterKey);
  final firstItem = find.byKey(const Key('todo-0'));
  final firstCheckbox = find.descendant(
    of: firstItem,
    matching: find.byType(Checkbox),
  );
  final secondItem = find.byKey(const Key('todo-1'));
  final secondCheckbox = find.descendant(
    of: secondItem,
    matching: find.byType(Checkbox),
  );
  final thirdItem = find.byKey(const Key('todo-2'));
  final thirdCheckbox = find.descendant(
    of: thirdItem,
    matching: find.byType(Checkbox),
  );
  testWidgets(
    'Render the default todos',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      expect(
        find.descendant(of: firstItem, matching: find.text('hi')),
        findsOneWidget,
      );
      expect(
        tester.widget(firstCheckbox),
        isA<Checkbox>().having((s) => s.value, 'value', false),
      );
      expect(
        find.descendant(of: secondItem, matching: find.text('hello')),
        findsOneWidget,
      );
      expect(
        tester.widget(secondCheckbox),
        isA<Checkbox>().having((s) => s.value, 'value', false),
      );
      expect(
        find.descendant(of: thirdItem, matching: find.text('bonjour')),
        findsOneWidget,
      );
      expect(
        tester.widget(thirdCheckbox),
        isA<Checkbox>().having((s) => s.value, 'value', false),
      );

      await expectLater(
        find.byType(MyApp),
        matchesGoldenFile('initial_state.png'),
      );
    },
    skip: !Platform.isMacOS,
  );

  testWidgets('Clicking on checkbox toggles the todo', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(
      tester.widget(firstCheckbox),
      isA<Checkbox>().having((s) => s.value, 'value', false),
    );

    expect(find.text('2 items left'), findsOneWidget);
    expect(find.text('3 items left'), findsNothing);

    await tester.tap(firstCheckbox);
    await tester.pump();

    expect(
      tester.widget(firstCheckbox),
      isA<Checkbox>().having((s) => s.value, 'value', true),
    );
    expect(find.text('2 items left'), findsOneWidget);
    expect(find.text('3 items left'), findsNothing);
  });
}
