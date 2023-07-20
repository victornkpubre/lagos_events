import 'dart:io';
import 'package:lagos_events/domain/models/appquery.dart';
import 'package:lagos_events/domain/models/appuser.dart';
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/domain/models/reminder.dart';

abstract class EventRepositoryInterface {
  Future<List<Event>> getEvents(AppFilterQuery appQuery);
  Future<List<Event>> getAllEvents();
  Future<bool> createEvent(Event event, File eventImage);
  Future<List<Event>> getEventsByUser(String uid);
  Future<List<Event>> getEventsByIds(List<String> ids);
  Future<List<Event>> sortEvents(AppSortQuery appQuery);
}

abstract class UserRepositoryInterface {
  Future<void> createUser(AppUser user);
  Future<AppUser?> getUser(String uid);
  Future<void> updateUser(AppUser user);
  Future<bool> userExists(String uid); 
}

abstract class ReminderRepositoryInterface {
  Future<bool> createReminder();
  Future<Reminder> getReminder(String id);
  Future<bool> deleteReminder(String id);
  Future<bool> updateReminder(String id);
}

abstract class AuthRepositoryInterface {
  Future<void> login(AppUser user);
  Future<bool> logout();
  Future<AppUser?> currentUser();
}