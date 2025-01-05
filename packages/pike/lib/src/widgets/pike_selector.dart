import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

/// A function that selects a value of type `V`
/// from a Pike instance of type `P`.
typedef PikeSelectorWidget<P extends PikeBase<Object?>, V> = V Function(P pike);

/// A function that builds a widget based on the selected value of type `V`.
typedef PikeSelectorBuilder<P extends PikeBase<Object?>, V> = Widget Function(
    BuildContext context, V value);

/// A widget that listens to a Pike instance
/// and rebuilds based on a selected value.
///
/// The [PikeSelector] widget is used to listen to a specific Pike instance and
/// rebuild the UI based on a selected value from the Pike instance.
///
/// Example:
/// ```dart
/// PikeSelector<Pike<MyState>, String>(
///   pike: myPikeInstance, // The Pike instance to listen to.
///   selector: (pike) => pike.state.someValue,
///   builder: (context, value) {
///     return Text('Selected value: $value');
///     // The widget to rebuild based on the selected value.
///   },
/// );
/// ```
class PikeSelector<P extends PikeBase<Object?>, V> extends StatefulWidget {
  /// Creates a [PikeSelector] widget.
  ///
  /// [pike] - The Pike instance to listen to.
  /// If null, it will be fetched from the context.
  /// [selector] - The function to select a value from the Pike instance.
  /// [builder] - The function to build the widget based on the selected value.
  const PikeSelector({
    required this.selector,
    required this.builder,
    Key? key,
    this.pike,
  }) : super(key: key);

  /// The Pike instance to listen to.
  /// If null, the instance will be fetched from the context.
  final P? pike;

  /// The function to select a value from the Pike instance.
  final PikeSelectorWidget<P, V> selector;

  /// The function to build the widget based on the selected value.
  final PikeSelectorBuilder<P, V> builder;

  @override
  State<PikeSelector<P, V>> createState() => _PikeSelectorState<P, V>();
}

/// The state for the [PikeSelector] widget.
class _PikeSelectorState<P extends PikeBase<Object?>, V>
    extends State<PikeSelector<P, V>> {
  late P _pike;

  @override
  void initState() {
    super.initState();
    _pike = widget.pike ?? PikeProvider.of<P>(context);
  }

  @override
  void didUpdateWidget(PikeSelector<P, V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldPike = oldWidget.pike ?? PikeProvider.of<P>(context);
    final currentPike = widget.pike ?? oldPike;

    if (_pike != currentPike) {
      _pike = currentPike;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final pike = widget.pike ?? PikeProvider.of<P>(context);

    if (_pike != pike) {
      _pike = pike;
    }
  }

  @override
  Widget build(BuildContext context) => PikeBuilder<P, Object?>(
        pike: _pike,
        builder: (context, _) =>
            widget.builder(context, widget.selector(_pike)),
      );
}
