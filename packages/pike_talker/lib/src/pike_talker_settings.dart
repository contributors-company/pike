import 'package:pike/pike.dart';


class PikeTalkerSettings {
  const PikeTalkerSettings({
    this.enabled = true,
    this.printChanges = true,
    this.printEvents = true,
    this.printCreations = true,
    this.printClosings = true,
    this.printEventFullData = true,
    this.eventFilter,
  });


  final bool enabled;

  final bool printChanges;

  final bool printEvents;

  final bool printCreations;

  final bool printClosings;

  final bool printEventFullData;

  final bool Function(PikeBase<Object?> pike, Object? event)? eventFilter;
}