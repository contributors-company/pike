import 'package:flutter_test/flutter_test.dart';
import 'package:pike/pike.dart';
import '../mocks/mock_pike.dart';
import '../mocks/mock_pike_observer.dart';

void main() {
  group('PikeObserver', () {
    group('Only test PikeObserver', () {
      late MockPike pike;
      late MockObserver observer;
      setUp(() {
        // Инициализируем mock-объект и назначаем его как observer
        observer = MockObserver();
        PikeBase.observer = observer;
        pike = MockPike();
      });

      tearDown(() {
        PikeBase.observer = null;
      });

      test('Pike Create', () {
        observer.onCreate(pike);
      });

      test('Pike Event', () {
        observer.onEvent(pike, FetchEvent());
      });

      test(
        'Pike Emit',
        () {
          observer.onEmit(
              pike, Change(FetchEvent(), InitialState(), LoadedState()));
        },
      );

      test('Pike Dispose', () {
        observer.onDispose(pike);
      });
    });

    group('Only test PikeObserver', () {
      late MockPike pike;
      late MockitoObserver observer;
      setUp(() {
        // Инициализируем mock-объект и назначаем его как observer
        observer = MockitoObserver();
        PikeBase.observer = observer;
      });

      tearDown(() {
        PikeBase.observer = null;
      });

      test('Create Pike', () {
        pike = MockPike();
      });

      setUp(() {
        pike = MockPike();
      });

      tearDown(() {
        PikeBase.observer = null;
      });

      test('Send Event Pike', () async {
        pike.add(FetchEvent());
        expect(pike.state, isA<LoadedState>());
      });

      test('Dispose Pike', () async {
        pike.dispose();
      });
    });

    PikeBase.observer = null;
  });
}
