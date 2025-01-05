import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

/// Type alias for the event handler function.
/// This function takes an [Event] and an [Emit] function to update the [State].
typedef EventHandler<Event, State> = FutureOr<void> Function(
  Event event,
  Emit<State> emit,
);

/// Type alias for emitting new state of type [State].
typedef Emit<S> = void Function(S state);

/// Abstract class Pike that manages state and event handling.
///
/// [Event] - The type of event that triggers state changes.
/// [State] - The type of state that is managed and updated.
abstract class Pike<Event, State> extends PikeBase<State> {
  /// Constructor to initialize the Pike instance with an initial state value.
  ///
  /// [initialValue] - The initial state to set.
  Pike(State initialValue)
      : _eventNotifier = ValueNotifier(null),
        super(stateNotifier: ValueNotifier(initialValue));

  final ValueNotifier<Event?> _eventNotifier;

  /// Gets the current event stored in the `_eventNotifier`.
  ///
  /// This property accesses the value of the private `_eventNotifier`,
  /// which holds the current event.
  /// The `!` operator is used to assert that the eventis non-null,
  /// assuming that the event will always be set before it's accessed.
  ///
  /// Example:
  /// ```dart
  /// pike.event; // Returns the current event of type `Event`.
  /// ```
  Event get event => _eventNotifier.value!;

  /// Registers an event handler for a specific event type [E].
  ///
  /// [E] - The type of event to listen for.
  /// [callback] - The function to call when the event of type [E] occurs.
  void on<E extends Event>(EventHandler<E, State> callback) =>
      _eventNotifier.addListener(
        _listener(callback),
      );

  /// Creates a listener that triggers the provided callback if
  /// the event matches the specified type [E].
  ///
  /// [callback] - The function that will be called when the event is detected.
  VoidCallback _listener<E extends Event>(EventHandler<E, State> callback) =>
      () {
        // If the event matches the type [E], call the provided callback.
        if (event case E event) callback(event, _emit(event));
      };

  /// Adds an event to the Pike and triggers the event handlers for that event.
  ///
  /// [event] - The event to be added and processed.
  void add(Event event) {
    onEvent(this, event);
    _eventNotifier.value = event;
  }

  /// Creates a function to emit new states when an event is processed.
  ///
  /// [event] - The event that triggered the state change.
  Emit<State> _emit(Event event) => (state) {
        onEmit(
          this,
          Change(
            event, // The event that caused the state change.
            super.state, // The current state before the change.
            state, // The new state after the change.
          ),
        );
      };

  /// Disposes of the resources, including the event notifier.
  @override
  void dispose() {
    _eventNotifier.dispose();
    super.dispose();
  }
}
