import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lagos_events/presentation/providers/events_provider.dart';
import 'package:lagos_events/domain/utility/string_manipulation.dart';
import 'package:lagos_events/presentation/widgets.dart';
import 'package:lagos_events/presentation/views/event/event_page.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/app/constants.dart';
import 'package:lagos_events/app/styles.dart';

class CalendarTab extends StatefulWidget {
  final Size size;

  const CalendarTab({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  State<CalendarTab> createState() => _CalendarTabState(size: size);
}

class _CalendarTabState extends State<CalendarTab> {
  final Size size;
  Map<String, List<Event> > eventsDateMap = {};
  List<Event> currentEvents = [];
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  _CalendarTabState({required this.size});

  String dateToString(DateTime date) {
    return "${date.year}${date.month}${date.day}";
  }

  List<Event>? _getEventsFromDate(DateTime date) {
    if(eventsDateMap.isEmpty) {
      return null;
    }
    else {
      var result = eventsDateMap[dateToString(date)];
      return result;
    } 
  }

  void eventsListToMap() {
    eventsDateMap.clear();
    context.read<EventProvider>().events.forEach((e){
      String date = dateToString(e.date);
      if(eventsDateMap.containsKey(date)) {
        eventsDateMap[date]!.add(e);
      }
      else {
        eventsDateMap[date] = <Event>[];
        eventsDateMap[date]!.add(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        eventsListToMap();
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SingleChildScrollView(child: Column(
            children: <Widget>[

              //Calendar
              TableCalendar(
                firstDay: gMinDate,
                lastDay: gMaxDate,
                focusedDay: _focusedDay,
                eventLoader: (day) {
                  var result = _getEventsFromDate(day)??[];
                  return result;
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                    color: Colors.grey
                  )
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: greenAccent)
                  ),
                  selectedDecoration: BoxDecoration(
                    color: purpleTint,
                    shape: BoxShape.circle
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) => 
                  events.isNotEmpty? Container(
                    width: 15,
                    height: 15,
                    alignment: Alignment.bottomRight,
                    decoration: BoxDecoration(
                      color: greenAccent,
                      shape: BoxShape.circle
                    ),
                    child: Center(
                      child: Text(
                        '${events.length}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black87, fontSize: 11),
                      ),
                    ),
                  )
                  : null,
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (focusedDay, selectedDay){
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    currentEvents.clear();
                    for (var e in provider.events) {
                      if(selectedDay.year == e.date.year && selectedDay.month == e.date.month && selectedDay.day == e.date.day){
                        currentEvents.add(e);
                      }
                    }
                    
                  });    
                },
                
              ),
              const Divider(color: Colors.transparent),
              const Divider(color: Colors.transparent),

              //Events Title
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'Events', 
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 25
                  ),
                )
              ),
              
              const Divider(
                color: Color.fromRGBO(89, 234, 193, 1.0),
                thickness: 2.0,
              ),
              const Divider(color: Colors.transparent),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: currentEvents.length,
                itemBuilder: (BuildContext context, int index) {
                  String feeList = feesToString(currentEvents[index]);
                  return Column(children: <Widget>[
                    InkWell(
                    child : Container(
                      width: size.width*0.9,
                      color: const Color.fromRGBO(19, 58, 68, 1), 
                      child: Row(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: size.width*0.28
                            ),
                            child: CachedNetworkImage(
                              imageUrl: currentEvents[index].imageUrl,
                              placeholder: (context, url) => AppProgressIndicator(size: size),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ), 
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10,10,0,0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(currentEvents[index].title, style: eventDetailsStyleH1),
                                Text(currentEvents[index].venue, style: eventDetailsStyle),
                                const SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Gate Fee',  style: eventDetailsStyleH2),
                                    SizedBox(width: size.width*0.3, child: Text(feeList, style: eventDetailsStyle))
                                  ],       
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),

                        ),
                        
                      ],),
                    ),
                    onTap: () async {
                      
                      Navigator.of(context).push(MaterialPageRoute<Widget>(
                        builder: (BuildContext context) => EventPage(
                          size: size,
                          event: currentEvents[index],
                        )
                      ));
                    }),
                    const Divider(color: Colors.transparent,)
                  ],);
                },
              ),
            ],
          )),
          
        );
      }
    );
  }
}