import 'dart:io';
import 'package:lagos_events/domain/models/appquery.dart';
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/data/repository/datasources/firebase_datasource.dart';
import 'package:lagos_events/data/repository/base/repository_interfaces.dart';
import 'package:lagos_events/app/constants.dart';


class EventRepository extends EventRepositoryInterface {
  FirebaseDataSource firebaseDataSource = const FirebaseDataSource();

  EventRepository._internal();

  static final EventRepository instance = EventRepository._internal();
  factory EventRepository() {
    return instance;
  }

  @override
  Future<bool> createEvent(Event event, File eventImage) {
    return firebaseDataSource.createEvent(event, eventImage);
  }

  @override
  Future<List<Event>> getEventsByUser(String uid) {
    return firebaseDataSource.getEventsWithQuery(AppFilterQuery(field: "uid", type: Query.isEqualTo, value: uid));
  }

  @override
  Future<List<Event>> getEventsByIds(List<String> ids) async {
    List<Event> events = [];
    for(var id in ids) { 
      var events = await firebaseDataSource.getEventsWithQuery(AppFilterQuery(field: "id", type: Query.isEqualTo, value: id));
      if(events.isNotEmpty){
        Event eventResult = events.first;
        events.add(eventResult);
      }
    }
    return events;
  }

  @override
  Future<List<Event>> getAllEvents() {
    return firebaseDataSource.getAllEvents();
  }

  @override
  Future<List<Event>> getEvents(AppFilterQuery appQuery) {
    return firebaseDataSource.getEventsWithQuery(appQuery);
  }

  @override
  Future<List<Event>> sortEvents(AppSortQuery appQuery) {
    return firebaseDataSource.sortEventsWithQuery(appQuery);
  }

}
