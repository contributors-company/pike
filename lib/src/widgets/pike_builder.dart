import 'package:flutter/cupertino.dart';
import 'package:pike/pike.dart';
import 'package:pike/src/widgets/pike_listener.dart';

class PikeBuilder<P extends Pike, S> extends StatefulWidget {
  const PikeBuilder({
    super.key,
    this.pike,
    required this.builder,
  });

  final P? pike;
  final Widget Function(BuildContext, S) builder;

  @override
  State<PikeBuilder<P, S>> createState() => _PikeBuilderState<P, S>();
}

class _PikeBuilderState<P extends Pike, S> extends State<PikeBuilder<P, S>> {
  late P pike;
  late S state;

  @override
  void initState() {
    super.initState();
    pike = widget.pike ?? PikeProvider.of<P>(context);
    state = pike.state;
  }

  @override
  void didUpdateWidget(PikeBuilder<P, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.pike ?? PikeProvider.of<P>(context);
    final currentBloc = widget.pike ?? oldBloc;

    if (oldBloc != currentBloc) {
      pike = currentBloc;
      state = pike.state;
    }
  }

  void _listener(BuildContext context, S state) => setState(() {
        this.state = state;
      });

  @override
  Widget build(BuildContext context) {
    return PikeListener<P, S>(
      pike: pike,
      listener: _listener,
      child: widget.builder(context, state),
    );
  }
}
