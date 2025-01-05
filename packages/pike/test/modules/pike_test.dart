import 'package:flutter_test/flutter_test.dart';
import '../mocks/mock_pike.dart';

void main() {
  group('Pike test', () {
    test('adds one to input values', () {
      final pike = MockPike();

      expect(pike.state, isA<InitialState>());

      pike.add(FetchEvent());

      expect(pike.state, isA<LoadedState>());

      pike.add(FetchWithExceptionEvent());

      expect(pike.state, isA<ExceptionState>());

      pike.dispose();

      expect(pike.state, isA<ExceptionState>());
    });

    test('listener pike', () {
      final pike = MockPike();

      void listen() {
        expect(pike.state, isA<MockState>());
      }

      pike
        ..addListener(listen)
        ..add(FetchEvent())
        ..add(FetchWithExceptionEvent())
        ..removeListener(listen);
    });
  });
}
