import 'package:flutter/cupertino.dart';
import 'package:pike/pike.dart';

typedef PikeWidgetListener<S> = void Function(BuildContext context, S state);

class PikeListener<P extends Pike, S> extends StatefulWidget {
  const PikeListener({
    super.key,
    required this.child,
    this.pike,
    required this.listener,
  });

  final P? pike;
  final Widget child;
  final PikeWidgetListener<S> listener;

  @override
  State<PikeListener<P, S>> createState() => _PikeListenerState<P, S>();
}

class _PikeListenerState<P extends Pike, S> extends State<PikeListener<P, S>> {
  late P pike;

  @override
  void initState() {
    super.initState();
    pike = widget.pike ?? PikeProvider.of<P>(context);
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
      pike.addListener(_listener);
    }
  }

  void _listener() => widget.listener(context, pike.state);

  @override
  void dispose() {
    pike.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
