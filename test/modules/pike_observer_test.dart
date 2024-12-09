import 'package:flutter_test/flutter_test.dart';
import 'package:pike/pike.dart';

import '../mocks/mock_pike.dart';
import '../mocks/mock_pike_observer.dart';

void main() {
  group('PikeObserver', () {
    final pike = MockPike();
    final observer = MockPikeObserver();
    Pike.observer = observer;

    test('Pike Create', () {
      observer.onCreate(pike);
    });

    test('Pike Event', () {
      observer.onEvent(pike, FetchEvent());
    });

    test('Pike Emit', () {
      observer.onEmit(
          pike, Change(FetchEvent(), InitialState(), LoadedState()));
    });

    test('Pike Dispose', () {
      observer.onDispose(pike);
    });
  });
}
