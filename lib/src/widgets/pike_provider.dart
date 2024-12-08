import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

class PikeProvider<T extends Pike> extends InheritedWidget {
  const PikeProvider({super.key, required super.child, required this.pike});

  final T pike;

  static T? maybeOf<T extends Pike>(
    BuildContext context, {
    bool listen = false,
  }) =>
      listen
          ? context.dependOnInheritedWidgetOfExactType<PikeProvider<T>>()?.pike
          : context.getInheritedWidgetOfExactType<PikeProvider<T>>()?.pike;

  static T of<T extends Pike>(
    BuildContext context, {
    bool listen = false,
  }) =>
      maybeOf<T>(context, listen: false)!;

  @override
  bool updateShouldNotify(covariant PikeProvider oldWidget) {
    return pike != oldWidget.pike;
  }
}
