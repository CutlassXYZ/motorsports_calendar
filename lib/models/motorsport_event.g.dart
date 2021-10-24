// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motorsport_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MotorsportEvent _$MotorsportEventFromJson(Map<String, dynamic> json) =>
    MotorsportEvent(
      name: json['name'] as String,
      place: json['place'] as String,
      raceDate: json['raceDate'] as String,
      subEvents: (json['subEvents'] as List<dynamic>)
          .map((e) => SubEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MotorsportEventToJson(MotorsportEvent instance) =>
    <String, dynamic>{
      'name': instance.name,
      'place': instance.place,
      'raceDate': instance.raceDate,
      'subEvents': instance.subEvents,
    };
