import 'package:pike/pike.dart';

class MockCarp extends Carp<State> {
  MockCarp() : super(InitialState());

  void fetch() {
    emit(LoadedState());
  }

  void fetchWithException() {
    emit(ExceptionState());
  }
}

sealed class State {}

class InitialState extends State {}

class LoadedState extends State {}

class ExceptionState extends State {}
