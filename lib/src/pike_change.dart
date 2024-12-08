class Change<Event, State> {
  final Event event;
  final State currentState;
  final State nextState;

  Change(
    this.event,
    this.currentState,
    this.nextState,
  );
}
