import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_task_list/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(TaskApp());

    expect(find.text('To do this'), findsNothing);

    MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
    TaskPage taskPage = materialApp.home;
    taskPage.appBarTextController.text = 'To do this';

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('To do this'), findsOneWidget);
  });
}
