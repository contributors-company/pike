import 'package:pike/pike.dart';

final class MockPike extends Pike<Event, MockState> {
  MockPike() : super(InitialState()) {
    on<Event>(
      (event, emit) => switch (event) {
        FetchEvent() => _callback(event, emit),
        FetchWithExceptionEvent() => _callbackA(event, emit),
        ToInitialEvent() => _toInitialEvent(event, emit),
      },
    );
  }

  Future<void> _callback(FetchEvent event, Emit<MockState> emit) async {
    emit(LoadedState());
  }

  void _callbackA(FetchWithExceptionEvent event, Emit<MockState> emit) {
    emit(ExceptionState());
  }

  void _toInitialEvent(ToInitialEvent event, Emit<MockState> emit) {
    emit(InitialState());
  }
}

// Events

sealed class Event {}

class FetchEvent extends Event {}

class ToInitialEvent extends Event {}

class FetchWithExceptionEvent extends Event {}

// States

sealed class MockState {}

class InitialState extends MockState {
  @override
  String toString() => 'Initial State';
}

class LoadedState extends MockState {
  @override
  String toString() => 'Loaded State';
}

class ExceptionState extends MockState {
  @override
  String toString() => 'Exception State';
}
