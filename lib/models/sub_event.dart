import 'package:json_annotation/json_annotation.dart';

part 'sub_event.g.dart';

@JsonSerializable()
class SubEvent {
  final String name;
  final String time;
  final String date;

  SubEvent({
    required this.name,
    required this.time,
    required this.date,
  });

  factory SubEvent.fromJson(Map<String, dynamic> json) =>
      _$SubEventFromJson(json);

  Map<String, dynamic> toJson() => _$SubEventToJson(this);
}
