// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Event {
  String id;
  String uid;
  String title;
  String venue;
  DateTime date;
  List<int> fees;
  int minFee;
  List<String> tags;
  String imageUrl;
  int ranking;
  String contact;

  Event({
    this.id = "",
    this.uid = "",
    required this.title,
    required this.venue,
    required this.date,
    required this.fees,
    required this.minFee,
    required this.tags,
    this.imageUrl = "",
    this.ranking = 0,
    required this.contact,
  });

 


  Event copyWith({
    String? id,
    String? uid,
    String? title,
    String? venue,
    DateTime? date,
    List<int>? fees,
    int? minFee,
    List<String>? tags,
    String? imageUrl,
    int? ranking,
    String? contact,
  }) {
    return Event(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      venue: venue ?? this.venue,
      date: date ?? this.date,
      fees: fees ?? this.fees,
      minFee: minFee ?? this.minFee,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      ranking: ranking ?? this.ranking,
      contact: contact ?? this.contact,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'title': title,
      'venue': venue,
      'date': date.millisecondsSinceEpoch,
      'fees': fees,
      'minFee': minFee,
      'tags': tags,
      'imageUrl': imageUrl,
      'ranking': ranking,
      'contact': contact,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      uid: map['uid'] as String,
      title: map['title'] as String,
      venue: map['venue'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      fees: List<int>.from((map['fees'] as List<dynamic>)),
      minFee: map['minFee'] as int,
      tags: List<String>.from((map['tags'] as List<dynamic>)),
      imageUrl: map['imageUrl'] as String,
      ranking: map['ranking'] as int,
      contact: map['contact'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Event(id: $id, uid: $uid, title: $title, venue: $venue, date: $date, fees: $fees, minFee: $minFee, tags: $tags, imageUrl: $imageUrl, ranking: $ranking, contact: $contact)';
  }

  @override
  bool operator ==(covariant Event other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.uid == uid &&
      other.title == title &&
      other.venue == venue &&
      other.date == date &&
      listEquals(other.fees, fees) &&
      other.minFee == minFee &&
      listEquals(other.tags, tags) &&
      other.imageUrl == imageUrl &&
      other.ranking == ranking &&
      other.contact == contact;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      uid.hashCode ^
      title.hashCode ^
      venue.hashCode ^
      date.hashCode ^
      fees.hashCode ^
      minFee.hashCode ^
      tags.hashCode ^
      imageUrl.hashCode ^
      ranking.hashCode ^
      contact.hashCode;
  }
}

