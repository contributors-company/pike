import 'package:flutter_test/flutter_test.dart';

import '../mocks/mock_cart.dart';

void main() {
  group('Carp Test', () {
    test('adds one to input values', () {
      final carp = MockCarp();

      expect(carp.state, isA<InitialState>());

      carp.fetch();

      expect(carp.state, isA<LoadedState>());

      carp.fetchWithException();

      expect(carp.state, isA<ExceptionState>());

      carp.dispose();

      expect(carp.state, isA<ExceptionState>());
    });

    test('listener carp', () {
      final carp = MockCarp();

      void listen() {
        expect(carp.state, isA<MockState>());
      }

      carp
        ..fetch()
        ..fetchWithException()
        ..addListener(listen);
    });
  });
}
