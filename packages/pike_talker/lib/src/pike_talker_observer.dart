import 'package:pike/pike.dart';
import 'package:meta/meta.dart';
import 'package:pike_talker/pike_talker.dart';
import 'package:talker/talker.dart';

/// [BLoC] logger on [Talker] base
///
/// [talker] field is the current [Talker] instance.
/// Provide your instance if your application uses [Talker] as the default logger
/// Common Talker instance will be used by default
class TalkerBlocObserver extends PikeObserver {
  TalkerBlocObserver({
    Talker? talker,
    this.settings = const PikeTalkerSettings(),
  }) {
    _talker = talker ?? Talker();
  }

  late Talker _talker;
  final PikeTalkerSettings settings;

  @override
  @mustCallSuper
  void onEvent<P extends PikeBase<Object?>, Event>(P pike, Event event) {
    if (!settings.enabled || !settings.printEvents) {
      return;
    }
    final accepted = settings.eventFilter?.call(pike, event) ?? true;
    if (!accepted) {
      return;
    }
    _talker.logCustom(
      PikeEventLog(
        pike: pike,
        event: event,
        settings: settings,
      ),
    );
  }


  @override
  void onCreate<P extends PikeBase<Object?>>(
    P pike,
  ) {
    if (!settings.enabled || !settings.printCreations) {
      return;
    }
    // _talker.logCustom(BlocCreateLog(bloc: bloc));
  }

  @override
  void onDispose<P extends PikeBase<Object?>>(P pike) {
    if (!settings.enabled || !settings.printClosings) {
      return;
    }
    // _talker.logCustom(BlocCloseLog(bloc: bloc));
  }

  @override
  void onEmit<Event, State, P extends PikeBase<Object?>>(P pike, Change<Event, State> change) {

  }
}
