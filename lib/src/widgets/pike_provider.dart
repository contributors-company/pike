import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

/// A custom [InheritedWidget] that provides access to a [Pike] instance
/// of type [T] to the widget tree.
///
/// Example usage:
/// ```dart
/// PikeProvider<MyPike>(
///   pike: myPikeInstance,
///   child: MyWidget(),
/// );
/// ```
class PikeProvider<T extends PikeBase<Object?>> extends InheritedWidget {
  /// Constructor for [PikeProvider]
  /// that requires a [child] widget and a [pike] instance.
  ///
  /// Example:
  /// ```dart
  /// const PikeProvider(
  ///   pike: myPikeInstance,
  ///   child: MyWidget(),
  /// );
  /// ```
  const PikeProvider({
    required super.child,
    required this.pike,
    super.key,
  });

  /// pike is [T] instance Pike
  final T pike;

  /// A helper method to retrieve the [Pike] instance of type [T]
  /// from the nearest [PikeProvider] widget.
  ///
  /// [context] - The build context.
  /// [listen] - Whether to subscribe to updates to the [Pike] instance.
  /// Returns the [Pike] instance if found, or null if it doesn't exist.
  ///
  /// Example usage:
  /// ```dart
  /// final myPike = PikeProvider.maybeOf<MyPike>(context);
  /// ```
  static T? maybeOf<T extends PikeBase<Object?>>(
    BuildContext context, {
    bool listen =
        false, // If true, the widget will rebuild when [Pike] changes.
  }) =>
      listen
          ? context.dependOnInheritedWidgetOfExactType<PikeProvider<T>>()?.pike
          : context.getInheritedWidgetOfExactType<PikeProvider<T>>()?.pike;

  /// A helper method to retrieve the [Pike] instance of type [T]
  /// from the nearest [PikeProvider] widget.
  ///
  /// [context] - The build context.
  /// [listen] - Whether to subscribe to updates to the [Pike] instance.
  /// This method will throw an error if no [Pike] instance is found.
  ///
  /// Example usage:
  /// ```dart
  /// final myPike = PikeProvider.of<MyPike>(context);
  /// ```
  static T of<T extends PikeBase<Object?>>(
    BuildContext context, {
    bool listen = false,
  }) =>
      maybeOf<T>(context, listen: false)!;

  /// This method checks whether the widget should notify its dependents.
  /// It returns `true` if the current [pike] is different from the old one.
  ///
  /// Example usage:
  /// ```dart
  /// final shouldNotify = provider.updateShouldNotify(oldProvider);
  /// ```
  @override
  bool updateShouldNotify(covariant PikeProvider oldWidget) =>
      pike != oldWidget.pike;

  /// Override the default [createElement] method
  /// to return a custom element for this widget.
  @override
  InheritedElement createElement() => _PikeElement(this);
}

/// A custom [InheritedElement] that manages
/// the lifecycle of the [Pike] instance.
/// This element will call [pike.dispose()] when it is unmounted.
class _PikeElement<T extends PikeBase<Object?>> extends InheritedElement {
  /// Constructor for [_PikeElement], passing the [widget] to the superclass.
  _PikeElement(super.widget);

  /// Get the widget associated with this element, cast to [PikeProvider<T>].
  @override
  PikeProvider get widget => super.widget as PikeProvider<T>;

  /// Override the [unmount] method to dispose
  /// of the [Pike] instance when it is unmounted.
  ///
  /// Example:
  /// ```dart
  /// element.unmount();
  /// // This will dispose of the Pike instance.
  /// ```
  @override
  void unmount() {
    widget.pike.dispose();
    super.unmount();
  }
}
