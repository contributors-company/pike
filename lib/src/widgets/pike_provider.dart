import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

class PikeProvider<T extends Pike<Object?, Object?>> extends InheritedWidget {
  const PikeProvider({
    required super.child,
    required this.pike,
    super.key,
  });

  final T pike;

  static T? maybeOf<T extends Pike<Object?, Object?>>(
    BuildContext context, {
    bool listen = false,
  }) =>
      listen
          ? context.dependOnInheritedWidgetOfExactType<PikeProvider<T>>()?.pike
          : context.getInheritedWidgetOfExactType<PikeProvider<T>>()?.pike;

  static T of<T extends Pike<Object?, Object?>>(
    BuildContext context, {
    bool listen = false,
  }) =>
      maybeOf<T>(context, listen: false)!;

  @override
  bool updateShouldNotify(covariant PikeProvider oldWidget) =>
      pike != oldWidget.pike;
}
