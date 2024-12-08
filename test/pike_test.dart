import 'package:flutter_test/flutter_test.dart';

import 'package:pike/pike.dart';

void main() {
  test('adds one to input values', () {
    final pike = APike();

    expect(pike.state, isA<InitialState>());

    pike.add(FetchEvent());

    expect(pike.state, isA<LoadedState>());

    pike.add(FetchWithExceptionEvent());

    expect(pike.state, isA<ExceptionState>());

    pike.dispose();

    expect(pike.state, isA<ExceptionState>());


  });
}

final class APike extends Pike<Event, State> {
  APike() : super(InitialState()) {
    on<FetchEvent>(_callback);
    on<FetchWithExceptionEvent>(_callbackA);

  }

  Future<void> _callback(FetchEvent event, Emit<State> emit) async {
    emit(LoadedState());
  }

  void _callbackA(FetchWithExceptionEvent event, Emit<State> emit) {
    emit(ExceptionState());
  }
}

sealed class State {}

class InitialState extends State {}

class LoadedState extends State {}

class ExceptionState extends State {}

sealed class Event {}

class FetchEvent extends Event {}

class FetchWithExceptionEvent extends Event {}


