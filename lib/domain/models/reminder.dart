// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Reminder {
  String id;
  DateTime datetime;
  String uid;
  String eventid;
  String type;
  int notificationid;

  Reminder({
    required this.id,
    required this.datetime,
    required this.uid,
    required this.eventid,
    required this.type,
    required this.notificationid,
  });
 

  Reminder copyWith({
    String? id,
    DateTime? datetime,
    String? uid,
    String? eventid,
    String? type,
    int? notificationid,
  }) {
    return Reminder(
      id: id ?? this.id,
      datetime: datetime ?? this.datetime,
      uid: uid ?? this.uid,
      eventid: eventid ?? this.eventid,
      type: type ?? this.type,
      notificationid: notificationid ?? this.notificationid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'datetime': datetime.millisecondsSinceEpoch,
      'uid': uid,
      'eventid': eventid,
      'type': type,
      'notificationid': notificationid,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as String,
      datetime: DateTime.fromMillisecondsSinceEpoch(map['datetime'] as int),
      uid: map['uid'] as String,
      eventid: map['eventid'] as String,
      type: map['type'] as String,
      notificationid: map['notificationid'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Reminder.fromJson(String source) => Reminder.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Reminder(id: $id, datetime: $datetime, uid: $uid, eventid: $eventid, type: $type, notificationid: $notificationid)';
  }

  @override
  bool operator ==(covariant Reminder other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.datetime == datetime &&
      other.uid == uid &&
      other.eventid == eventid &&
      other.type == type &&
      other.notificationid == notificationid;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      datetime.hashCode ^
      uid.hashCode ^
      eventid.hashCode ^
      type.hashCode ^
      notificationid.hashCode;
  }

}

enum ReminderTypes{
  mins30, 
  mins15, 
  hours1, 
  hours2, 
  days1, 
  days2
}

