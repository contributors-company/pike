import 'package:pike/pike.dart';

class MockCarp extends Carp<MockState> {
  MockCarp() : super(InitialState());

  void fetch() {
    emit(LoadedState());
  }

  void fetchWithException() {
    emit(ExceptionState());
  }
}

sealed class MockState {}

class InitialState extends MockState {}

class LoadedState extends MockState {}

class ExceptionState extends MockState {}
