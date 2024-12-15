import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

/// A widget that listens to a Pike instance and
/// rebuilds based on state changes.
/// It provides a builder function to update the UI and a
/// listener to react to state changes.
///
/// The [PikeConsumer] widget is used when you want to listen to a specific
/// Pike instance and rebuild the UI based on state changes.
/// The `builder` rebuilds the UI and the `listener`
/// is called whenever the state changes.
/// You can also use [builderWhen] and [listenerWhen]
/// to control the conditions for rebuilding and triggering the listener.
///
/// Example:
/// ```dart
/// PikeConsumer<Pike<MyState>, MyState>(
///   pike: myPikeInstance, // The Pike instance to listen to.
///   builder: (context, state) {
///     return Text('State: $state');
///     // The widget to rebuild based on state changes.
///   },
///   listener: (context, state) {
///     print('State updated: $state');
///     // The listener called when the state changes.
///   },
/// );
/// ```
class PikeConsumer<P extends PikeBase<S>, S> extends StatefulWidget {
  /// Constructor for PikeConsumer widget.
  ///
  /// [builder] - The function to rebuild the widget based on the state.
  /// [listener] - The callback function that will be triggered on state change.
  /// [pike] - The Pike instance to listen to.
  /// If null, it will be fetched from the context.
  /// [builderWhen] - Optional condition to control
  /// when the builder should be triggered.
  /// [listenerWhen] - Optional condition to control
  /// when the listener should be called.
  const PikeConsumer({
    required this.builder,
    required this.listener,
    super.key,
    this.pike,
    this.builderWhen,
    this.listenerWhen,
  });

  /// The Pike instance to listen to.
  /// If null, the instance will be fetched from the context.
  ///
  /// Example:
  /// ```dart
  /// PikeConsumer<Pike<MyState>, MyState>(
  ///   pike: myPikeInstance,
  /// );
  /// ```
  final P? pike;

  /// The builder function that rebuilds the UI based on the current state.
  /// Example:
  /// ```dart
  /// PikeConsumer<Pike<MyState>, MyState>(
  ///   builder: (context, state) {
  ///     return Text('Current state: $state');
  ///   },
  /// );
  /// ```
  final PikeBuilderWidget<S> builder;

  /// The listener function that is triggered whenever the state changes.
  /// Example:
  /// ```dart
  /// PikeConsumer<Pike<MyState>, MyState>(
  ///   listener: (context, state) {
  ///     print('State changed: $state');
  ///   },
  /// );
  /// ```
  final PikeWidgetListener<S> listener;

  /// A condition function to control when the builder should be triggered.
  /// Example:
  /// ```dart
  /// PikeConsumer<Pike<MyState>, MyState>(
  ///   builderWhen: (previous, current) {
  ///     return previous != current;
  ///     // Only rebuild when the state changes.
  ///   },
  /// );
  /// ```
  final PikeBuilderWidgetWhen<S>? builderWhen;

  /// A condition function to control when the listener should be triggered.
  /// Example:
  /// ```dart
  /// PikeConsumer<Pike<MyState>, MyState>(
  ///   listenerWhen: (previous, current) {
  ///     return previous != current;
  ///     // Only trigger listener when state changes.
  ///   },
  /// );
  /// ```
  final PikeWidgetListenerWhen<S>? listenerWhen;

  @override
  State<PikeConsumer<P, S>> createState() => _PikeConsumerState<P, S>();
}

class _PikeConsumerState<P extends PikeBase<S>, S>
    extends State<PikeConsumer<P, S>> {
  late P _pike;

  @override
  void initState() {
    super.initState();
    _pike = widget.pike ?? PikeProvider.of<P>(context);
  }

  @override
  void didUpdateWidget(PikeConsumer<P, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldPike = oldWidget.pike ?? PikeProvider.of<P>(context);
    final currentPike = widget.pike ?? oldPike;
    if (oldPike != currentPike) _pike = currentPike;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final pike = widget.pike ?? PikeProvider.of<P>(context);
    if (_pike != pike) _pike = pike;
  }

  @override
  Widget build(BuildContext context) => PikeBuilder<P, S>(
        pike: _pike,
        builder: widget.builder,
        builderWhen: (previous, current) {
          if (widget.listenerWhen?.call(previous, current) ?? true) {
            widget.listener(context, current);
          }
          return widget.builderWhen?.call(previous, current) ?? true;
        },
      );
}
