import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

/// A widget that allows combining multiple [PikeProvider]s
/// into a single widget tree.
///
/// This is useful when you need to provide access to multiple [Pike] instances
/// within the same subtree.
/// Instead of nesting [PikeProvider]s manually, you can use [MultiPikeProvider]
/// to simplify the widget structure.
///
/// Example usage:
/// ```dart
/// MultiPikeProvider(
///   providers: [
///     PikeProvider<MyPike1>(pike: myPike1),
///     PikeProvider<MyPike2>(pike: myPike2),
///   ],
///   child: MyWidget(),
/// );
/// ```
class MultiPikeProvider extends StatelessWidget {
  /// Creates a [MultiPikeProvider] widget.
  ///
  /// - [providers] is a list of [PikeProvider] instances
  ///   to be applied to the widget tree.
  /// - [child] is the widget that will be wrapped by all
  ///   the provided [PikeProvider]s.
  ///
  /// Example:
  /// ```dart
  /// MultiPikeProvider(
  ///   providers: [
  ///     PikeProvider<MyPike1>(pike: myPike1),
  ///     PikeProvider<MyPike2>(pike: myPike2),
  ///   ],
  ///   child: MyWidget(),
  /// );
  /// ```
  const MultiPikeProvider({
    required this.providers,
    required this.child,
    super.key,
  });

  /// A list of [PikeProvider] instances that will wrap the [child] widget.
  ///
  /// Each [PikeProvider] provides access to a different [Pike] instance
  /// for the subtree. The [providers] are applied in the order they are
  /// listed, with the first provider wrapping the second, and so on.
  final List<PikeProvider<Object?>> providers;

  /// The child widget that will be wrapped by the provided [PikeProvider]s.
  ///
  /// This is the root widget for the subtree that requires access
  /// to the provided [Pike] instances.
  final Widget child;

  /// Builds the widget tree by applying all the [providers] to the [child].
  ///
  /// Each [PikeProvider] wraps the widget returned by the previous provider,
  /// forming a nested widget tree. This is done using the [fold] function.
  ///
  /// [context] is the build context for the widget.
  ///
  /// Example:
  /// ```dart
  /// MultiPikeProvider(
  ///   providers: [
  ///     PikeProvider<MyPike1>(pike: myPike1),
  ///     PikeProvider<MyPike2>(pike: myPike2),
  ///   ],
  ///   child: MyWidget(),
  /// );
  /// ```
  @override
  Widget build(BuildContext context) => providers.fold(
        child,
        (widget, provider) => provider.buildWithChild(widget),
      );
}
