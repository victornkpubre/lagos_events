// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lagos_events/domain/models/appuser.dart';
import 'package:lagos_events/domain/models/event.dart';

class UserInfoArguments {
  final String uid;
  final String phone;
 
  UserInfoArguments(
    this.uid,
    this.phone,
  );
}

class ReminderArguments {
  final Event event;
  final AppUser user;

  ReminderArguments(
    this.event,
    this.user,
  );
  
}
