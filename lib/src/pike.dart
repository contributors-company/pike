import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

typedef EventHandler<Event, State> = FutureOr<void> Function(
  Event event,
  Emit<State> emit,
);

typedef Emit<S> = void Function(S state);

class Pike<Event, State> {
  Pike(State initialValue)
      : _stateNotifier = ValueNotifier(initialValue),
        _eventNotifier = ValueNotifier(null),
        _listeners = [] {
    _observer?.onCreate(this);
    _stateNotifier.addListener(_notifyListeners);
  }

  final List<VoidCallback> _listeners;
  final ValueNotifier<State> _stateNotifier;
  final ValueNotifier<Event?> _eventNotifier;
  static PikeObserver? _observer;

  static set observer(PikeObserver observer) => _observer = observer;

  State get state => _stateNotifier.value;

  Event get event => _eventNotifier.value!;

  void on<E extends Event>(EventHandler<E, State> callback) =>
      _eventNotifier.addListener(
        _listener(callback),
      );

  VoidCallback _listener<E extends Event>(EventHandler<E, State> callback) =>
      () {
        if (event case E event) callback(event, _emit(event));
      };

  void add(Event event) {
    _observer?.onEvent(this, event);
    _eventNotifier.value = event;
  }

  Emit<State> _emit(Event event) => (state) {
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

  void dispose() {
    _observer?.onDispose(this);
    _listeners.clear();
    _eventNotifier.dispose();
    _stateNotifier.dispose();
  }

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) listener();
  }

  void removeListener(VoidCallback listener) => _listeners.remove(listener);
}