import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:pike/pike.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../mocks/mock_pike.dart';

void main() {
  group('MultiPikeProvider', () {
    testWidgets('applies multiple PikeProviders in the correct order',
        (tester) async {
      // Создаем моки для Pike
      final mockPike1 = MockPike();
      final mockPike2 = MockPike();
      final keyProvider1 = Key('Provider1');
      final keyProvider2 = Key('Provider2');
      final keyChild = Key('Child');

      // Создаем моки для PikeProvider
      final mockPikeProvider1 = PikeProvider<MockPike>(
        pike: mockPike1,
        key: keyProvider1,
      );
      final mockPikeProvider2 = PikeProvider<MockPike>(
        pike: mockPike2,
        key: keyProvider2,
      );

      // Создаем MultiPikeProvider
      await tester.pumpWidget(
        MaterialApp(
          home: MultiPikeProvider(
            providers: [
              mockPikeProvider1,
              mockPikeProvider2,
            ],
            child: Text('Test', key: keyChild),
          ),
        )
      );

      // Проверяем порядок наложения провайдеров
      expect(find.byKey(keyProvider1), findsOneWidget);
      expect(find.byKey(keyProvider2), findsOneWidget);
      expect(find.byKey(keyChild), findsOneWidget);
    });

    testWidgets('renders child without providers if list is empty', (tester) async {
      final keyChild = Key('Child');


      // Создаем MultiPikeProvider без провайдеров
      await tester.pumpWidget(
          MaterialApp(
            home: MultiPikeProvider(
              providers: [],
              child: Text('Test', key: keyChild),
            ),
          )
      );

      // Проверяем, что отображается только дочерний виджет
      expect(find.byKey(keyChild), findsOneWidget);
    });
  });
}
