import 'package:flutter/cupertino.dart';
import 'package:pike/pike.dart';
import 'package:pike/src/widgets/pike_listener.dart';

typedef PikeBuilderWidget<S> = Widget Function(BuildContext, S);

typedef PikeBuilderWidgetWhen<S> = bool Function(S newState, S oldState);

class PikeBuilder<P extends Pike, S> extends StatefulWidget {
  const PikeBuilder({
    super.key,
    this.pike,
    required this.builder,
    this.builderWhen,
  });

  final P? pike;
  final PikeBuilderWidget<S> builder;
  final PikeBuilderWidgetWhen<S>? builderWhen;

  @override
  State<PikeBuilder<P, S>> createState() => _PikeBuilderState<P, S>();
}

class _PikeBuilderState<P extends Pike, S> extends State<PikeBuilder<P, S>> {
  late P pike;

  @override
  void initState() {
    super.initState();
    pike = widget.pike ?? PikeProvider.of<P>(context);
  }

  @override
  void didUpdateWidget(PikeBuilder<P, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.pike ?? PikeProvider.of<P>(context);
    final currentBloc = widget.pike ?? oldBloc;

    if (oldBloc != currentBloc) {
      pike = currentBloc;
    }
  }

  void _listener(BuildContext context, S state) => setState(() {});

  @override
  Widget build(BuildContext context) {
    return PikeListener<P, S>(
      pike: pike,
      listenerWhen: widget.builderWhen,
      listener: _listener,
      child: widget.builder(context, pike.state),
    );
  }
}
