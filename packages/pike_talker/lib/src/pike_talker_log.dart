import 'package:pike/pike.dart';
import 'package:pike_talker/pike_talker.dart';
import 'package:talker/talker.dart';

sealed class PikeTalkerLog extends TalkerLog {
  PikeTalkerLog(super.message);
}

/// [Pike] event log model
class PikeEventLog extends PikeTalkerLog {
  PikeEventLog({
    required this.pike,
    required this.event,
    required this.settings,
  }) : super(settings.printEventFullData
            ? '${pike.runtimeType} receive event:\n$event'
            : '${pike.runtimeType} receive event: ${event.runtimeType}');

  final PikeBase<Object?> pike;
  final Object? event;
  final PikeTalkerSettings settings;

  @override
  String get key => TalkerLogType.pikeEvent.key;



  @override
  String generateTextMessage({
    TimeFormat timeFormat = TimeFormat.timeAndSeconds,
  }) {
    final sb = StringBuffer()
      ..write(displayTitleWithTime(timeFormat: timeFormat))
      ..write('\n$message');
    return sb.toString();
  }
}


interface class ILogType {
  ILogType({required this.key, required this.logLevel,});

  final String key;
  final LogLevel logLevel;
}

enum TalkerLogType implements Type {
  pikeEvent(key: 'pike-event', logLevel: LogLevel.info);

  const TalkerLogType({required this.key, required this.logLevel});

  @override
  final String key;

  @override
  final LogLevel logLevel;
}