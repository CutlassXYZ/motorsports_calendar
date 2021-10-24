import 'package:json_annotation/json_annotation.dart';
import 'package:motorsports_calendar/models/sub_event.dart';

part 'motorsport_event.g.dart';

@JsonSerializable()
class MotorsportEvent {
  final String name;
  final String place;
  final String raceDate;
  final List<SubEvent> subEvents;

  MotorsportEvent({
    required this.name,
    required this.place,
    required this.raceDate,
    required this.subEvents,
  });

  factory MotorsportEvent.fromJson(Map<String, dynamic> json) =>
      _$MotorsportEventFromJson(json);

  Map<String, dynamic> toJson() => _$MotorsportEventToJson(this);
}
