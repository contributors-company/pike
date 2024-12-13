import 'package:pike/pike.dart';

final class MockPike extends Pike<Event, State> {
  MockPike() : super(InitialState()) {
    on<Event>(
      (event, emit) => switch (event) {
        FetchEvent() => _callback(event, emit),
        FetchWithExceptionEvent() => _callbackA(event, emit),
      },
    );
  }

  Future<void> _callback(FetchEvent event, Emit<State> emit) async {
    emit(LoadedState());
  }

  void _callbackA(FetchWithExceptionEvent event, Emit<State> emit) {
    emit(ExceptionState());
  }
}

// Events

sealed class Event {}

class FetchEvent extends Event {}

class FetchWithExceptionEvent extends Event {}

// States

sealed class State {}

class InitialState extends State {}

class LoadedState extends State {}

class ExceptionState extends State {}
