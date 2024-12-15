import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

/// Type for a widget listener that takes a [BuildContext]
/// and the current [S] state.
///
/// Example usage:
/// ```dart
/// PikeWidgetListener<int> myListener = (context, state) {
///   print("State changed: $state");
/// };
/// ```
typedef PikeWidgetListener<S> = void Function(BuildContext context, S state);

/// Type for a conditional listener that checks whether the state change
/// should be listened to.
///
/// Example usage:
/// ```dart
/// PikeWidgetListenerWhen<int> myListenerWhen = (newState, oldState) {
///   return newState != oldState; // Listen only when the state changes
/// };
/// ```
typedef PikeWidgetListenerWhen<S> = bool Function(S newState, S oldState);

/// A widget that listens for state changes in a [Pike] instance.
///
/// [P] - The type of Pike that this listener is working with.
/// [S] - The type of state being listened to.
///
/// Example usage:
/// ```dart
/// PikeListener<MyPike, int>(
///   pike: myPikeInstance,
///   listener: (context, state) {
///     print("State changed: $state");
///   },
///   listenerWhen: (newState, oldState) => newState != oldState,
///   child: MyWidget(),
/// );
/// ```
class PikeListener<P extends PikeBase<S>, S> extends StatefulWidget {
  /// Constructor for PikeListener widget.
  /// [child] - The widget that will be displayed inside the listener.
  /// [listener] - The function that will be triggered when the state changes.
  /// [pike] - The Pike instance to listen to, if provided.
  /// If null, it will be fetched from the context.
  /// [listenerWhen] - A condition function that determines
  /// when the listener should be triggered.

  const PikeListener({
    required this.child,
    required this.listener,
    super.key,
    this.pike,
    this.listenerWhen,
  });

  /// The Pike instance to listen to. If not provided, it will be retrieved
  /// from the context using `PikeProvider`.
  ///
  /// Example:
  /// ```dart
  /// PikeListener<Pike<MyState>, MyState>(
  ///   pike: myPikeInstance,
  ///   listener: (context, state) {
  ///     // Handle state changes
  ///   },
  /// );
  /// ```
  final P? pike;

  /// The child widget that will be rendered. This widget will be rebuilt
  /// when the Pike state changes.
  ///
  /// Example:
  /// ```dart
  /// PikeListener<Pike<MyState>, MyState>(
  ///   child: Text('State: ${state.toString()}'),
  /// );
  /// ```
  final Widget child;

  /// The listener function that is triggered whenever the Pike state changes.
  /// This function receives the [BuildContext] and the new [state] as arguments
  ///
  /// Example:
  /// ```dart
  /// PikeListener<Pike<MyState>, MyState>(
  ///   listener: (context, state) {
  ///     print('State changed to: $state');
  ///   },
  /// );
  /// ```
  final PikeWidgetListener<S> listener;

  /// A condition function that determines whether
  /// the listener should be triggered.
  ///
  /// It takes the [newState] and [oldState] and returns `true`
  /// if the listener should be called.
  ///
  /// Example:
  /// ```dart
  /// PikeListener<Pike<MyState>, MyState>(
  ///   listenerWhen: (newState, oldState) {
  ///     return newState != oldState;
  ///     // Only trigger listener if state has changed.
  ///   },
  /// );
  /// ```
  final PikeWidgetListenerWhen<S>? listenerWhen;

  @override
  // Creates the state for the PikeListener widget.
  // This will initialize the listener and state tracking logic.
  State<PikeListener<P, S>> createState() => _PikeListenerState<P, S>();
}

class _PikeListenerState<P extends PikeBase<S>, S>
    extends State<PikeListener<P, S>> {
  late P _pike;
  late S _previousState;
  bool haveListener = false;

  @override
  void initState() {
    super.initState();
    _pike = widget.pike ?? PikeProvider.of<P>(context);
    _setPreviousState();
    _addListener();
  }

  @override
  void didUpdateWidget(PikeListener<P, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldPike = oldWidget.pike ?? PikeProvider.of<P>(context);
    final currentPike = widget.pike ?? oldPike;
    if (oldPike == currentPike) return;
    if (haveListener) {
      _clearListener();
      _pike = currentPike;
      _setPreviousState();
    }
    _addListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final pike = widget.pike ?? PikeProvider.of<P>(context);
    if (_pike != pike) return;
    if (haveListener) {
      _clearListener();
      _pike = pike;
      _setPreviousState();
    }
    _addListener();
  }

  @override
  void dispose() {
    _clearListener();
    super.dispose();
  }

  /// The listener that is triggered when the state changes.
  void _listener() {
    if (widget.listenerWhen?.call(_previousState, _pike.state) ?? true) {
      if (!mounted) return;
      widget.listener(context, _pike.state);
      _setPreviousState();
    }
  }

  void _clearListener() {
    haveListener = false;
    _pike.removeListener(_listener);
  }

  void _addListener() {
    haveListener = true;
    _pike.addListener(_listener);
  }

  void _setPreviousState() => _previousState = _pike.state;

  @override
  Widget build(BuildContext context) => widget.child;
}
