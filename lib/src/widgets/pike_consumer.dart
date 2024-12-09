import 'package:flutter/cupertino.dart';
import 'package:pike/pike.dart';

class PikeConsumer<P extends Pike<Object?, S>, S> extends StatefulWidget {
  const PikeConsumer({
    required this.builder,
    required this.listener,
    super.key,
    this.pike,
    this.builderWhen,
    this.listenerWhen,
  });

  final P? pike;
  final PikeBuilderWidget<S> builder;
  final PikeWidgetListener<S> listener;
  final PikeBuilderWidgetWhen<S>? builderWhen;
  final PikeWidgetListenerWhen<S>? listenerWhen;

  @override
  State<PikeConsumer<P, S>> createState() => _PikeConsumerState<P, S>();
}

class _PikeConsumerState<P extends Pike<Object?, S>, S>
    extends State<PikeConsumer<P, S>> {
  late P pike;

  @override
  void initState() {
    super.initState();
    pike = widget.pike ?? PikeProvider.of<P>(context);
  }

  @override
  void didUpdateWidget(PikeConsumer<P, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.pike ?? PikeProvider.of<P>(context);
    final currentBloc = widget.pike ?? oldBloc;

    if (oldBloc != currentBloc) {
      pike = currentBloc;
    }
  }

  @override
  Widget build(BuildContext context) => PikeBuilder<P, S>(
        pike: pike,
        builder: widget.builder,
        builderWhen: (previous, current) {
          if (widget.listenerWhen?.call(previous, current) ?? true) {
            widget.listener(context, current);
          }
          return widget.builderWhen?.call(previous, current) ?? true;
        },
      );
}
