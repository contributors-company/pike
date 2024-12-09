import 'package:flutter/cupertino.dart';
import 'package:pike/pike.dart';

typedef PikeWidgetListener<S> = void Function(BuildContext context, S state);

typedef PikeWidgetListenerWhen<S> = bool Function(S newState, S oldState);

class PikeListener<P extends Pike<Object?, S>, S> extends StatefulWidget {
  const PikeListener({
    required this.child,
    required this.listener,
    super.key,
    this.pike,
    this.listenerWhen,
  });

  final P? pike;
  final Widget child;
  final PikeWidgetListener<S> listener;
  final PikeWidgetListenerWhen<S>? listenerWhen;

  @override
  State<PikeListener<P, S>> createState() => _PikeListenerState<P, S>();
}

class _PikeListenerState<P extends Pike<Object?, S>, S>
    extends State<PikeListener<P, S>> {
  late P pike;
  late S _previousState;

  @override
  void initState() {
    super.initState();
    pike = widget.pike ?? PikeProvider.of<P>(context);
    _previousState = pike.state;
    pike.addListener(_listener);
  }

  @override
  void didUpdateWidget(PikeListener<P, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.pike ?? PikeProvider.of<P>(context);
    final currentBloc = widget.pike ?? oldBloc;

    if (oldBloc != currentBloc) {
      oldBloc.removeListener(_listener);
      pike = currentBloc;
      _previousState = pike.state;
      pike.addListener(_listener);
    }
  }

  void _listener() {
    if (widget.listenerWhen?.call(_previousState, pike.state) ?? true) {
      if (!mounted) return;
      widget.listener(context, pike.state);
      _previousState = pike.state;
    }
  }

  @override
  void dispose() {
    pike.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
