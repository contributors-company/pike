class Change<Event, State> {
  Change(
    this.event,
    this.currentState,
    this.nextState,
  );
  final Event? event;
  final State currentState;
  final State nextState;
}
