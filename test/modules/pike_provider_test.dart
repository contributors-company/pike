import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pike/pike.dart';

import '../mocks/mock_pike.dart';

void main() {
  group('PikeProvider', () {
    late MockPike mockPike;

    setUp(() {
      mockPike = MockPike();
    });

    testWidgets('maybeOf returns null if PikeProvider is not in context',
        (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final result = PikeProvider.maybeOf<MockPike>(context);
            expect(result, isNull);
            return const SizedBox.shrink();
          },
        ),
      );
    });

    testWidgets('maybeOf returns Pike if PikeProvider is in context',
        (tester) async {
      await tester.pumpWidget(
        PikeProvider<MockPike>(
          pike: mockPike,
          child: Builder(
            builder: (context) {
              final result = PikeProvider.maybeOf<MockPike>(context);
              expect(result, equals(mockPike));
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('of throws error if PikeProvider is not in context',
        (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(
              () => PikeProvider.of<MockPike>(context),
              throwsA(isA<Error>()),
            );
            return const SizedBox.shrink();
          },
        ),
      );
    });

    testWidgets('of returns Pike if PikeProvider is in context',
        (tester) async {
      await tester.pumpWidget(
        PikeProvider<MockPike>(
          pike: mockPike,
          child: Builder(
            builder: (context) {
              final result = PikeProvider.of<MockPike>(context);
              expect(result, equals(mockPike));
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('updateShouldNotify returns true if Pike instance changes',
        (tester) async {
      final newPike = MockPike();
      final widget = PikeProvider<MockPike>(
        pike: mockPike,
        child: const SizedBox.shrink(),
      );

      expect(
          widget.updateShouldNotify(
              PikeProvider(pike: newPike, child: widget.child)),
          isTrue);
    });

    testWidgets(
        'updateShouldNotify returns false if Pike instance does not change',
        (tester) async {
      final widget = PikeProvider<MockPike>(
        pike: mockPike,
        child: const SizedBox.shrink(),
      );

      expect(
          widget.updateShouldNotify(
              PikeProvider(pike: mockPike, child: widget.child)),
          isFalse);
    });
    testWidgets(
        'maybeOf calls dependOnInheritedWidgetOfExactType when listen is true',
        (tester) async {
      final pikeProvider = PikeProvider<MockPike>(
        pike: mockPike,
        child: Builder(
          builder: (context) {
            final result =
                PikeProvider.maybeOf<MockPike>(context, listen: true);
            expect(result, equals(mockPike));
            return const SizedBox.shrink();
          },
        ),
      );

      await tester.pumpWidget(pikeProvider);
    });
  });
}
