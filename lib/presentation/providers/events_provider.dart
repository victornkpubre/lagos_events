import 'package:flutter/material.dart';
import 'package:lagos_events/domain/models/appquery.dart';
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/data/repository/repositories/event_repository.dart';

class EventProvider extends ChangeNotifier {
  final EventRepository _eventRepository = EventRepository();
  List<Event> _events = [];
  List<Event> get events => _events;
  set setEvents(List<Event> events) {
    _events = events;
  }

  Future<void> getEvents(AppFilterQuery? query) async {
    if(query == null){
      _events = await _eventRepository.getAllEvents();
    }
    else {
      _events = await _eventRepository.getEvents(query);
    }
    notifyListeners();
  }

  Future<void> sortEvents(AppSortQuery query) async {
    _events = await _eventRepository.sortEvents(query);
    notifyListeners();
  }

}