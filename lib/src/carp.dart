import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

/// Abstract class Carp that extends PikeBase and manages state updates.
///
/// This class is a simplified version of Pike, where you can emit
/// state changes directly without handling any events.
/// It is useful when state changes happen based on internal logic
/// or other factors without requiring event-based triggers.
///
/// [State] - The type of state that is managed and updated.
abstract class Carp<State> extends PikeBase<State> {
  /// Constructor to initialize the Carp instance with an initial state value.
  ///
  /// [initialValue] - The initial state to set when creating the Carp instance.
  Carp(State initialValue) : super(stateNotifier: ValueNotifier(initialValue));

  /// Emits a new state directly.
  ///
  /// This method is used to emit a new state, triggering the `onEmit` method
  /// to handle the state transition and notifying listeners of the change.
  ///
  /// [state] - The new state to emit.
  void emit(State state) {
    onEmit(
      this,
      Change(
        null, // No event in this case, as this is a direct state emission.
        super.state, // The current state before the change.
        state, // The new state after the change.
      ),
    );
  }
}
