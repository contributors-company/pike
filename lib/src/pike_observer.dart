import 'package:pike/pike.dart';

class PikeObserver {
  void onCreate<P extends Pike<Object?, Object?>>(P pike) {}

  void onEvent<P extends Pike<Object?, Object?>, Event>(
    P pike,
    Event event,
  ) {}

  void onDispose<P extends Pike<Object?, Object?>>(P pike) {}

  void onEmit<Event, State, P extends Pike<Object?, Object?>>(
    P pike,
    Change<Event, State> change,
  ) {}
}
