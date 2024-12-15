import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

/// Base class that manages state and provides mechanisms for
/// observing events, state changes, and lifecycle hooks.
///
/// [State] - The type of state managed by this class.
class PikeBase<State> {
  /// Creates an instance of [PikeBase] with the given [ValueNotifier].
  ///
  /// **Example Usage:**
  /// ```dart
  /// final pike = CustomPike();
  /// print(pike.state); // Outputs: Custom state
  /// ```
  PikeBase({
    required ValueNotifier<State> stateNotifier,
  }) : _stateNotifier = stateNotifier {
    onCreate(this); // Calls the onCreate hook when the instance is created.
  }

  /// Private [ValueNotifier] that holds the current state.
  final ValueNotifier<State> _stateNotifier;

  /// Static property for a global observer that will receive notifications
  /// about events, state changes, and lifecycle methods.
  static PikeObserver? _observer;

  /// Sets a global observer for all instances of [PikeBase].
  ///
  /// **Example:**
  /// ```dart
  /// PikeBase.observer = MyObserver();
  /// ```
  static set observer(PikeObserver? observer) => _observer = observer;

  /// Returns the current state of this instance.
  ///
  /// **Example:**
  /// ```dart
  /// final state = pike.state; // Access the current state
  /// print(state);
  /// ```
  State get state => _stateNotifier.value;

  /// Disposes of the internal [ValueNotifier] and calls the [onDispose] hook.
  ///
  /// **Example:**
  /// ```dart
  /// pike.dispose(); // Cleans up resources
  /// ```
  void dispose() {
    _stateNotifier.dispose();
    onDispose(this);
  }

  /// Hook to notify about an event occurring on this Pike instance.
  ///
  /// [pike] - The Pike instance where the event occurred.
  /// [event] - The event data.
  ///
  /// **Example:**
  /// ```dart
  /// pike.onEvent(pike, "ButtonClicked");
  /// ```
  void onEvent<P extends PikeBase<Object?>, Event>(P pike, Event event) {
    _observer?.onEvent(pike, event);
  }

  /// Hook called when the instance is disposed.
  ///
  /// **Example:**
  /// ```dart
  /// pike.dispose(); // Triggers the onDispose hook
  /// ```
  void onDispose<P extends PikeBase<Object?>>(P pike) {
    _observer?.onDispose(pike);
  }

  /// Hook called when the state is emitted (changed).
  ///
  /// [pike] - The Pike instance.
  /// [change] - The change object containing the previous and next state.
  ///
  /// **Example:**
  /// ```dart
  /// final change = Change<int>(previousState: 0, nextState: 1);
  /// pike.onEmit(pike, change);
  /// ```
  void onEmit<Event, P extends PikeBase<State>>(
    P pike,
    Change<Event, State> change,
  ) {
    _stateNotifier.value = change.nextState;
    _observer?.onEmit(pike, change);
  }

  /// Hook called when the instance is created.
  void onCreate<P extends PikeBase<Object?>>(P pike) {
    _observer?.onCreate(pike);
  }

  /// Adds a listener to the internal [ValueNotifier] to be notified
  /// when the state changes.
  ///
  /// **Example:**
  /// ```dart
  /// pike.addListener(() {
  ///   print("State changed: ${pike.state}");
  /// });
  /// ```
  void addListener(VoidCallback listener) {
    _stateNotifier.addListener(listener);
  }

  /// Removes a previously added listener from the internal [ValueNotifier].
  ///
  /// **Example:**
  /// ```dart
  /// pike.removeListener(myListener);
  /// ```
  void removeListener(VoidCallback listener) {
    _stateNotifier.removeListener(listener);
  }
}
