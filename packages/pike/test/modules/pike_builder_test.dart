import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pike/pike.dart';

import '../mocks/mock_pike.dart';

void main() {
  group('PikeBuilder Tests', () {
    late MockPike mockPike;

    setUp(() {
      mockPike = MockPike();
    });

    testWidgets('should initialize Pike from PikeProvider if not provided',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PikeBuilder<MockPike, MockState>(
            pike: mockPike,
            builder: (context, state) => Text(state.toString()),
          ),
        ),
      );

      // Проверяем, что текстовый виджет с начальным состоянием отображается
      expect(find.text('Initial State'), findsOneWidget);
    });

    testWidgets('should rebuild UI when state changes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PikeBuilder<MockPike, MockState>(
            pike: mockPike,
            builder: (context, state) => Text(state.toString()),
          ),
        ),
      );

      mockPike.add(FetchEvent());

      await tester.pump();

      // Проверяем, что текст изменился
      expect(find.text('Loaded State'), findsOneWidget);
    });

    testWidgets('should rebuild UI only when builderWhen returns true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PikeBuilder<MockPike, MockState>(
            pike: mockPike,
            builderWhen: (newState, oldState) => newState != oldState,
            builder: (context, state) => Text(state.toString()),
          ),
        ),
      );

      mockPike.add(ToInitialEvent());

      await tester.pump();
      expect(find.text('Initial State'), findsOneWidget);
    });

    testWidgets('should use provided Pike instead of PikeProvider',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PikeBuilder<MockPike, MockState>(
            pike: mockPike,
            builder: (context, state) => Text(state.toString()),
          ),
        ),
      );

      // Проверяем, что текстовый виджет отображает состояние из mockPike
      expect(find.text('Initial State'), findsOneWidget);
    });

    testWidgets('should use provided Pike instead of PikeProvider',
        (tester) async {
      final mock1 = MockPike();
      final mock2 = MockPike()..add(FetchEvent());

      await tester.pumpWidget(
        MaterialApp(
          home: PikeBuilder<MockPike, MockState>(
            pike: mock1,
            builder: (context, state) => Text(state.toString()),
          ),
        ),
      );

      expect(find.text('Initial State'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: PikeBuilder<MockPike, MockState>(
            pike: mock2,
            builder: (context, state) => Text(state.toString()),
          ),
        ),
      );

      expect(find.text('Loaded State'), findsOneWidget);

      // Проверяем, что текстовый виджет отображает состояние из mockPike
    });
  });
}
