import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

part 'pike_state_notifier.dart';

part 'pike_event_notifier.dart';

typedef EventHandler<Event, State> = FutureOr<void> Function(
  Event event,
  Emit<State> emit,
);

typedef Emit<S> = void Function(S state);

class Pike<Event, State> implements ChangeNotifier {
  Pike(State initialValue)
      : _stateNotifier = _PikeStateNotifier(initialValue),
        _eventNotifier = _PikeEventNotifier(),
        _listeners = [] {
    _observer?.onCreate(this);
    _stateNotifier.addListener(notifyListeners);
  }

  final List<VoidCallback> _listeners;

  final _PikeStateNotifier<State> _stateNotifier;
  final _PikeEventNotifier<Event> _eventNotifier;

  static PikeObserver? _observer;

  State get state => _stateNotifier.value;

  Event get event => _eventNotifier.value!;

  void on<E extends Event>(EventHandler<E, State> callback) {
    _eventNotifier.addListener(
      _listener(callback),
    );
  }

  VoidCallback _listener<E extends Event>(EventHandler<E, State> callback) =>
      () {
        if (event case E event) callback(event, _emit(event));
      };

  void add(Event event) {
    _observer?.onEvent(this, event);
    _eventNotifier.value = event;
  }

  Emit<State> _emit(Event event) => (State state) {
        _observer?.onEmit(
          this,
          Change(
            event,
            _stateNotifier.value,
            state,
          ),
        );
        _stateNotifier.value = state;
      };



  @override
  void dispose() {
    _observer?.onDispose(this);
    _listeners.clear();
    _eventNotifier.dispose();
    _stateNotifier.dispose();
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  bool get hasListeners => _listeners.isNotEmpty;

  @override
  void notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
}
