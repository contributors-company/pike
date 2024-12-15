/// Represents a change in state triggered by an event.
///
/// [Event] - The type of event that caused the state change.
/// [State] - The type of state being managed.
///
/// This class encapsulates the event, the current state before the change,
/// and the next state after the change.
class Change<Event, State> {
  /// Creates an instance of [Change].
  ///
  /// [event] - The event that caused the state change (can be null).
  /// [currentState] - The state before the change.
  /// [nextState] - The state after the change.
  ///
  /// **Example Usage:**
  /// ```dart
  /// final change = Change<String, int>(
  ///   "Increment",
  ///   0,    // currentState
  ///   1,    // nextState
  /// );
  ///
  /// print("Event: ${change.event}"); // Outputs: Increment
  /// print("Current State: ${change.currentState}"); // Outputs: 0
  /// print("Next State: ${change.nextState}"); // Outputs: 1
  /// ```
  Change(
    this.event,
    this.currentState,
    this.nextState,
  );

  /// The event that caused the state change.
  /// Can be `null` if the change was triggered without a specific event.
  final Event? event;

  /// The state before the change occurred.
  final State currentState;

  /// The state after the change occurred.
  final State nextState;
}
