import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

abstract class Carp<State> extends PikeBase<State> {
  Carp(State initialValue) : super(stateNotifier: ValueNotifier(initialValue));

  void emit(State state) {
    onEmit(
      this,
      Change(
        null,
        super.state,
        state,
      ),
    );
  }
}
