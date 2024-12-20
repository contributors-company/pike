import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

class PikeSelector<P extends PikeBase<Object?>, V> extends StatefulWidget {

  const PikeSelector({
    Key? key,
    this.pike,
    required this.selector,
    required this.builder,
  }) : super(key: key);

  final P? pike;
  final V Function(P pike) selector;
  final Widget Function(BuildContext context, V value) builder;

  @override
  State<PikeSelector<P, V>> createState() => _PikeSelectorState<P, V>();
}

class _PikeSelectorState<P extends PikeBase<Object?>, V> extends State<PikeSelector<P, V>> {
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
      builder: (context, _) => widget.builder(context, widget.selector(_pike)),
    );
}