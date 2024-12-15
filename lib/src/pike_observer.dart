import 'package:pike/pike.dart';

/// Base class for observing the lifecycle and behavior of `PikeBase` instances.
///
/// The `PikeObserver` provides hooks for monitoring events, state changes,
/// and the creation or disposal of `PikeBase` objects.
/// This is particularly useful for debugging or adding
/// custom logging functionality to state management.

class PikeObserver {
  /// Called when a `PikeBase` instance is created.
  ///
  /// [P] - The type of the `PikeBase` instance.
  ///
  /// **Example Usage:**
  /// ```dart
  /// class MyObserver extends PikeObserver {
  ///   @override
  ///   void onCreate<P extends PikeBase<Object?>>(P pike) {
  ///     print('Pike created: $pike');
  ///   }
  /// }
  /// ```
  void onCreate<P extends PikeBase<Object?>>(P pike) {}

  /// Called when an event is dispatched to a `PikeBase` instance.
  ///
  /// [P] - The type of the `PikeBase` instance.
  /// [Event] - The type of the event dispatched.
  ///
  /// **Example Usage:**
  /// ```dart
  /// class MyObserver extends PikeObserver {
  ///   @override
  ///   void onEvent<P extends PikeBase<Object?>, Event>(
  ///     P pike,
  ///     Event event,
  ///   ) {
  ///     print('Event $event dispatched to $pike');
  ///   }
  /// }
  /// ```
  void onEvent<P extends PikeBase<Object?>, Event>(
    P pike,
    Event event,
  ) {}

  /// Called when a `PikeBase` instance is disposed.
  ///
  /// [P] - The type of the `PikeBase` instance.
  ///
  /// **Example Usage:**
  /// ```dart
  /// class MyObserver extends PikeObserver {
  ///   @override
  ///   void onDispose<P extends PikeBase<Object?>>(P pike) {
  ///     print('Pike disposed: $pike');
  ///   }
  /// }
  /// ```
  void onDispose<P extends PikeBase<Object?>>(P pike) {}

  /// Called when a state change occurs in a `PikeBase` instance.
  ///
  /// [Event] - The type of the event that triggered the state change.
  /// [State] - The type of the state being managed.
  /// [P] - The type of the `PikeBase` instance.
  ///
  /// **Example Usage:**
  /// ```dart
  /// class MyObserver extends PikeObserver {
  ///   @override
  ///   void onEmit<Event, State, P extends PikeBase<Object?>>(
  ///     P pike,
  ///     Change<Event, State> change,
  ///   ) {
  ///     print('State changed in $pike: '
  ///           'Event: ${change.event}, '
  ///           'From: ${change.currentState}, '
  ///           'To: ${change.nextState}');
  ///   }
  /// }
  /// ```
  void onEmit<Event, State, P extends PikeBase<Object?>>(
    P pike,
    Change<Event, State> change,
  ) {}
}
