import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

/// A function type that defines a builder widget, which takes a [BuildContext]
/// and a state of type [S] and returns a [Widget].
typedef PikeBuilderWidget<S> = Widget Function(BuildContext, S);

/// A function type that defines a condition to determine when the builder
/// should be triggered based on the old and new state.
typedef PikeBuilderWidgetWhen<S> = bool Function(S newState, S oldState);

/// A widget that listens to a [PikeBase] instance, and rebuilds the UI
/// using the provided [builder] function when the state changes.
///
/// The widget takes in an optional [pike] instance,
/// and a [builderWhen] function
/// to control when the builder should be triggered. If [pike] is not provided,
/// it is fetched from the nearest [PikeProvider] in the widget tree.
class PikeBuilder<P extends PikeBase<S>, S> extends StatefulWidget {
  /// Creates a [PikeBuilder] widget.
  ///
  /// The [builder] is required and will be called whenever the state changes.
  /// [pike] is optional, if not provided,
  /// it will be obtained from the [PikeProvider].
  /// [builderWhen] is an optional condition
  /// that allows customizing when the builder
  /// should be invoked, based on the old and new state.
  const PikeBuilder({
    required this.builder,
    super.key,
    this.pike,
    this.builderWhen,
  });

  /// The Pike instance that provides the state.
  /// If not provided, it will be fetched
  /// from the nearest [PikeProvider] in the widget tree.
  final P? pike;

  /// The builder function that is called to build
  /// the UI based on the current state.
  final PikeBuilderWidget<S> builder;

  /// An optional condition function that determines
  /// when the builder should be triggered.
  /// It compares the new and old state and returns a boolean value.
  final PikeBuilderWidgetWhen<S>? builderWhen;

  @override
  State<PikeBuilder<P, S>> createState() => _PikeBuilderState<P, S>();
}

/// The state for the [PikeBuilder] widget,
/// which listens for changes in the Pike instance and rebuilds
/// the UI when necessary.
class _PikeBuilderState<P extends PikeBase<S>, S>
    extends State<PikeBuilder<P, S>> {
  late P _pike;

  @override
  void initState() {
    super.initState();
    _pike = widget.pike ?? PikeProvider.of<P>(context);
  }

  @override
  void didUpdateWidget(PikeBuilder<P, S> oldWidget) {
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

  /// A listener that triggers a rebuild
  /// of the widget whenever the state changes.
  void _listener(BuildContext context, S state) => setState(() {});

  @override
  Widget build(BuildContext context) => PikeListener<P, S>(
        pike: _pike,
        listenerWhen: widget.builderWhen,
        listener: _listener,
        child: widget.builder(context, _pike.state),
      );
}
