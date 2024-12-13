import 'package:flutter/cupertino.dart';
import 'package:pike/pike.dart';

class PikeBase<State> {
  PikeBase({
    required ValueNotifier<State> stateNotifier,
  }) : _stateNotifier = stateNotifier {
    onCreate(this);
  }

  final ValueNotifier<State> _stateNotifier;

  static PikeObserver? _observer;

  static set observer(PikeObserver? observer) => _observer = observer;

  State get state => _stateNotifier.value;

  void dispose() {
    _stateNotifier.dispose();
    onDispose(this);
  }

  void onEvent<P extends PikeBase<Object?>, Event>(P pike, Event event) {
    _observer?.onEvent(pike, event);
  }

  void onDispose<P extends PikeBase<Object?>>(P pike) {
    _observer?.onCreate(pike);
  }

  void onEmit<Event, P extends PikeBase<State>>(
    P pike,
    Change<Event, State> change,
  ) {
    _stateNotifier.value = change.nextState;
    _observer?.onEmit(pike, change);
  }

  void onCreate<P extends PikeBase<Object?>>(P pike) {
    _observer?.onCreate(pike);
  }

  void addListener(VoidCallback listener) {
    _stateNotifier.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    _stateNotifier.removeListener(listener);
  }
}
