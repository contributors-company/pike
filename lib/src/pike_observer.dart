import '../pike.dart';

interface class PikeObserver {
  void onCreate<P extends Pike>(P pike) {}

  void onEvent<P extends Pike, Event>(P pike, Event event) {}

  void onDispose<P extends Pike>(P pike) {}

  void onEmit<Event, State, P extends Pike<Event, State>>(P pike, Change<Event, State> change) {}
}