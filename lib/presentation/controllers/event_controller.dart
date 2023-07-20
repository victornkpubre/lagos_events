import 'package:flutter/material.dart';
import 'package:lagos_events/domain/models/appquery.dart';
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/presentation/providers/events_provider.dart';
import 'package:lagos_events/app/constants.dart';
import 'package:provider/provider.dart';

class EventController {
  
  getEvents(BuildContext context) {
    context.read<EventProvider>().getEvents(null);
  }
  
  //Searching Methods
  void displaySearchResult(String searchText, BuildContext context,){
    List<Event> events = [];
    for( var e in context.read<EventProvider>().events) {
        if(e.title.toLowerCase().compareTo(searchText.toLowerCase()) == 0 || containsTag(searchText.toLowerCase(), e.tags)) {
          events.add(e);
        }
    }
    context.read<EventProvider>().setEvents = events;
  }

  bool containsTag(String query, List<String> tags){
    bool result = false;
    for (var element in tags) {
      if(element.contains(query)){
        result = true;
      }
    }
    return result;
  }

  //Filtering Methods
  void filterEventsByDate(BuildContext context, DateTime min, DateTime max){
    context.read<EventProvider>().getEvents(
      AppFilterQuery(
        field: "date",
        type: Query.isBetween,
        value: min.millisecondsSinceEpoch,
        secondaryValue: max.millisecondsSinceEpoch,
      )
    );
  }

  void filterEventsByFee(BuildContext context, int min, int max) {
    context.read<EventProvider>().getEvents(
      AppFilterQuery(
        field: "minFee",
        type: Query.isBetween,
        value: min,
        secondaryValue: max,
      )
    );
  }

  // Sorting Method
  Future<void> sortEventsByDateUpward(BuildContext context) async {
    await context.read<EventProvider>().sortEvents(AppSortQuery(field: "date", descendingOrder: false));
    List<Event> events = context.read<EventProvider>().events;
    events.sort((a,b) {
       return b.date.compareTo(a.date);
    });
    context.read<EventProvider>().setEvents = events;
  }

  Future<void> sortEventsByDateDownward(BuildContext context) async {
    await context.read<EventProvider>().sortEvents(AppSortQuery(field: "date", descendingOrder: true));
    List<Event> events = context.read<EventProvider>().events;
    events.sort((a,b){
       return a.date.compareTo(b.date);
    });
    context.read<EventProvider>().setEvents = events;
  }

  Future<void> sortEventsByFeeUpward(BuildContext context) async {
    await context.read<EventProvider>().sortEvents(AppSortQuery(field: "minFee", descendingOrder: false));
    List<Event> events = context.read<EventProvider>().events;
    events.sort((a,b){
       return b.fees[0].compareTo(a.fees[0]);
    });
    context.read<EventProvider>().setEvents = events;
  }

  Future<void> sortEventsByFeeDownward(BuildContext context) async {
    await context.read<EventProvider>().sortEvents(AppSortQuery(field: "minFee", descendingOrder: true));
    List<Event> events = context.read<EventProvider>().events;
    events.sort((a,b){
       return a.fees[0].compareTo(b.fees[0]);
    });
    context.read<EventProvider>().setEvents = events;
  }

}