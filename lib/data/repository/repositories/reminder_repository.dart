import 'package:lagos_events/data/repository/datasources/firebase_datasource.dart';
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/domain/models/reminder.dart';


class ReminderRepository {

  FirebaseDataSource firebaseDataSource = const FirebaseDataSource();
  ReminderRepository._internal();

  static final ReminderRepository instance = ReminderRepository._internal();
  factory ReminderRepository() {
    return instance;
  }

  Future<List<Reminder>> getReminders(String uid) {
    return firebaseDataSource.getReminders(uid);
  }

  Future<Reminder?> addReminders(Event event, ReminderTypes type, String uid, int nid) {
    return firebaseDataSource.createReminder(event, type, uid, nid);
  }

  Future<void> removeReminders(Reminder reminder) {
    return firebaseDataSource.removeReminder(reminder);
  }

}