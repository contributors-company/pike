import 'package:flutter/widgets.dart';
import 'package:pike/pike.dart';

class MultiPikeProvider extends StatelessWidget {
  const MultiPikeProvider({
    super.key,
    required this.providers,
    required this.child,
  });

  final List<PikeProvider<Object?>> providers;
  final Widget child;

  @override
  Widget build(BuildContext context) => providers.fold(
        child,
        (widget, provider) => provider.buildWithChild(widget),
      );
}
