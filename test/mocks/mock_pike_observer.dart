import 'package:flutter_test/flutter_test.dart';
import 'package:pike/pike.dart';

import 'mock_pike.dart';

class MockPikeObserver extends PikeObserver {
  @override
  void onCreate<P extends PikeBase<Object?>>(P pike) {
    expect(pike, isA<MockPike>());
    super.onCreate(pike);
  }

  @override
  void onDispose<P extends PikeBase<Object?>>(P pike) {
    expect(pike, isA<MockPike>());
    super.onDispose(pike);
  }

  @override
  void onEmit<Event, State, P extends PikeBase<Object?>>(
      P pike, Change<Event, State> change) {
    expect(pike, isA<MockPike>());
    super.onEmit(pike, change);
  }

  @override
  void onEvent<P extends PikeBase<Object?>, Event>(P pike, Event event) {
    expect(pike, isA<MockPike>());
    super.onEvent(pike, event);
  }
}
