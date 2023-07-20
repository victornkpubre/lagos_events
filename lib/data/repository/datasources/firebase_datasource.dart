import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lagos_events/domain/models/appquery.dart';
import 'package:lagos_events/domain/models/appuser.dart';
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/app/constants.dart' as app;
import 'package:lagos_events/domain/models/reminder.dart';
import 'package:lagos_events/domain/utility/string_manipulation.dart';
import 'package:lagos_events/presentation/widgets.dart';
import 'package:retry/retry.dart';

class FirebaseDataSource {
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;

  const FirebaseDataSource();

  //Event Functions
  Future<List<Event>> getAllEvents() async {
    List<Event> events = [];
    try {
      await retry(() async {
          events =  (await firestore
          .collection('events')
          .get())
          .docs
          .map((eventMap) => Event.fromMap(eventMap.data()))
          .toList();
          print(events.toString());
        },
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      
    } catch (e) {
      showErrorToastbar(e.toString());
      return events;
    }
    return events;
    
  }

  Future<List<Event>> getEventsWithQuery(AppFilterQuery query) async {
    List<Event> events = [];
    try {
      await retry(() async {
        var querySnapShot = (await getFilterQuery(query).get());
        events = querySnapShot
          .docs
          .map((eventMap) => Event.fromMap(eventMap.data()))
          .toList();
        },
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      
    } catch (e) {
      showErrorToastbar(e.toString());
      return events;
    }
    return events;
  }

  Future<List<Event>> sortEventsWithQuery(AppSortQuery sortQuery) async {
    List<Event> events = [];
    try {
      await retry(() async {
        var query = await firestore
        .collection('events')
        .orderBy(sortQuery.field, descending: sortQuery.descendingOrder)
        .get();
      
        return query
          .docs
          .map((eventMap) => Event.fromMap(eventMap.data()))
          .toList();
        },
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      
    } catch (e) {
      showErrorToastbar(e.toString());
      return events;
    }
    return events;
  }

  Query<Map<String, dynamic>> getFilterQuery(AppFilterQuery query) {
    switch (query.type) {
      case app.Query.isEqualTo:
        return ( firestore
          .collection('events')
          .where(query.field, isEqualTo: query.value));
      case app.Query.isNotEqualTo:
        return ( firestore
          .collection('events')
          .where(query.field, isNotEqualTo: query.value));
      case app.Query.isGreaterThan:
        return ( firestore
          .collection('events')
          .where(query.field, isGreaterThan: query.value));
      case app.Query.isGreaterThanOrEqualTo:
        return ( firestore
          .collection('events')
          .where(query.field, isGreaterThanOrEqualTo: query.value));
      case app.Query.isLessThan:
        return ( firestore
          .collection('events')
          .where(query.field, isLessThan: query.value));
      case app.Query.isLessThanOrEqualTo:
        return ( firestore
          .collection('events')
          .where(query.field, isLessThanOrEqualTo: query.value));
      case app.Query.isBetween:
        return ( firestore
          .collection('events')
          .where(query.field, isGreaterThanOrEqualTo: query.value)
          .where(query.field, isLessThanOrEqualTo: query.secondaryValue));
      default:
        return ( firestore
          .collection('events'));
    }
  }

  Future<bool> createEvent(Event event, File eventImage) async {
    try {
      //Upload Event Image
      String imageUrl = await (await storage.ref()
        .child('images')
        .child(DateTime.now().microsecondsSinceEpoch.toString())
        .putFile(eventImage)).ref.getDownloadURL();

      //Create Event Document 
      DocumentReference<Map<String, dynamic>> eventDoc = firestore.collection('events').doc();

      //Update Event
      event.imageUrl = imageUrl;
      event.id = eventDoc.id;

      //Upload Event
      eventDoc.set(event.toMap());
      return true;

    } catch (e) {
      showErrorToastbar(e.toString());
      return false;
    }
  }


  //User Functions
  Future<AppUser?> getUser(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>>? documentSnapShot = await firestore
      .collection('users')
      .doc(uid)
      .get();
      Map<String, dynamic>? userMap = documentSnapShot.data();
      return userMap!=null?AppUser.fromMap(userMap):null;
    } catch (e) {
      showErrorToastbar(e.toString());
      return null;
    }
  }

  Future<void> setUser(AppUser user) async {
    try {
      DocumentReference<Map<String, dynamic>> documentSnapShot = firestore
      .collection('users')
      .doc(user.uid);
    documentSnapShot.set(user.toMap());
    } catch (e) {
      showErrorToastbar(e.toString());
    }
    
  }


  //Reminder Functions
  Future<List<Reminder>> getReminders(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapShot = await firestore
        .collection('reminders')
        .where("uid", isEqualTo: uid).get();
      return querySnapShot
        .docs
        .map((eventMap) => Reminder.fromMap(eventMap.data()))
        .toList();
    } catch (e) {
      showErrorToastbar(e.toString());
      return [];
    }
    
  }

  Future<void> removeReminder(Reminder reminder) async {
    try {
      firestore
      .collection('reminders')
      .doc(reminder.id)
      .delete();
    } catch (e) {
      showErrorToastbar(e.toString());
    }
    
  }

  Future<Reminder?> createReminder(Event event, ReminderTypes type, String uid, int notificationid) async {
    Reminder reminder;
    try {
      DocumentReference<Map<String, dynamic>> documentSnapShot = firestore
        .collection('reminders')
        .doc();
      reminder = Reminder(
        id: documentSnapShot.id, 
        datetime: getDateTime(type, event), 
        uid: uid, 
        eventid: event.id,
        type: typeToString(type),
        notificationid: notificationid
      ); 
      documentSnapShot.set(reminder.toMap());
      return reminder;
    } catch (e) {
      showErrorToastbar(e.toString());
      return null;
    }
    
  }

  DateTime getDateTime(ReminderTypes type, Event event){
    switch (type) {
      case ReminderTypes.days2:
        return event.date.subtract(const Duration(days: 2));
      case ReminderTypes.days1:
        return event.date.subtract(const Duration(days: 1));
      case ReminderTypes.hours2:
        return event.date.subtract(const Duration(hours: 2));
      case ReminderTypes.hours1:
        return event.date.subtract(const Duration(hours: 1));
      case ReminderTypes.mins30:
        return event.date.subtract(const Duration(minutes: 30));
      case ReminderTypes.mins15:
        return event.date.subtract(const Duration(minutes: 15));
      default:
      return DateTime.now();
    }
  }

  //Admin Function - Reads the latest company contact
  Future<String> getContact() async {
    return ((await firestore
      .collection('admin')
      .doc("info")
      .get()).data()!["contact"] as String);
  }


}