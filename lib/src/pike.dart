import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

typedef EventHandler<Event, State> = FutureOr<void> Function(
  Event event,
  Emit<State> emit,
);

typedef Emit<S> = void Function(S state);

abstract class Pike<Event, State> extends PikeBase<State> {
  Pike(State initialValue)
      : _eventNotifier = ValueNotifier(null),
        super(stateNotifier: ValueNotifier(initialValue));

  final ValueNotifier<Event?> _eventNotifier;

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
    onEvent(this, event);
    _eventNotifier.value = event;
  }

  Emit<State> _emit(Event event) => (state) {
        onEmit(
          this,
          Change(
            event,
            super.state,
            state,
          ),
        );
      };

  @override
  void dispose() {
    _eventNotifier.dispose();
    super.dispose();
  }
}
