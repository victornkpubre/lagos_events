// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AppUser {
  String uid;
  String phoneNumber;
  String firstName;
  String lastName;
  List<String>? savedEvents;

  AppUser({
    required this.uid,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    this.savedEvents,
  });

  AppUser copyWith({
    String? uid,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    List<String>? savedEvents,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      savedEvents: savedEvents ?? this.savedEvents,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'savedEvents': savedEvents,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      phoneNumber: map['phoneNumber'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      savedEvents: map['savedEvents'] != null ? List<String>.from((map['savedEvents'] as List<dynamic>)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) => AppUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppUser(uid: $uid, phoneNumber: $phoneNumber, firstName: $firstName, lastName: $lastName, savedEvents: $savedEvents)';
  }

  @override
  bool operator ==(covariant AppUser other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.phoneNumber == phoneNumber &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      listEquals(other.savedEvents, savedEvents);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      phoneNumber.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      savedEvents.hashCode;
  }
}
