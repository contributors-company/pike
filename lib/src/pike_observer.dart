import 'package:pike/pike.dart';

class PikeObserver {
  void onCreate<P extends PikeBase<Object?>>(P pike) {}

  void onEvent<P extends PikeBase<Object?>, Event>(
    P pike,
    Event event,
  ) {}

  void onDispose<P extends PikeBase<Object?>>(P pike) {}

  void onEmit<Event, State, P extends PikeBase<Object?>>(
    P pike,
    Change<Event, State> change,
  ) {}
}
