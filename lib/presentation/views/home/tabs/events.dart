import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lagos_events/presentation/controllers/event_controller.dart';
import 'package:lagos_events/presentation/controllers/user_controller.dart';
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/presentation/providers/events_provider.dart';
import 'package:lagos_events/app/constants.dart';
import 'package:lagos_events/domain/utility/string_manipulation.dart';
import 'package:lagos_events/app/styles.dart';
import 'package:lagos_events/presentation/widgets.dart';
import 'package:lagos_events/presentation/views/event/event_page.dart';
import 'package:provider/provider.dart';


class EventsTab extends StatefulWidget {
  final Size size;
  const EventsTab({super.key, required this.size});

  @override
  _EventsTabState createState() => _EventsTabState(size: size);
}

class _EventsTabState extends State<EventsTab> {
  Size size;

  _EventsTabState({required this.size});

  GlobalKey<AutoCompleteTextFieldState<String>> search_auto_completekey = GlobalKey();
  AutoCompleteTextField<String>? search_autoTextField;
  List<String> eventsTitles = [];
  final EventController _eventController = EventController();
  final UserController _userController = UserController();

  //State Variables
  DateTime minDate = gMinDate;
  DateTime maxDate = gMaxDate;
  double minFee = gMinFee;
  double maxFee = gMaxFee;
  bool filtering = false;
  bool sorting = false;
  bool loadin = false;
  String sortingState = 'None';
  String filteringState = 'None';
  String? current_tag;
  bool searching = false;
  double? filterTextSize;
  double? sortTextSize;
  RangeValues feeRangeValues = const RangeValues(0, 100000);
  

  //State Methods
  void resetDateFilter(){
    setState(() {
      minDate = gMinDate;
      maxDate = gMinDate;
    });
  }

  void resetFeeFilter(){
    setState(() {
      minFee = gMinFee;
      maxFee = gMaxFee;
    });
  }

  void resetTagFilter(){
    setState(() {
      filteringState = 'None';
      current_tag = null;
    });
  }

  void resetEvents() {
    _eventController.getEvents(context);
    sortingState = 'None';
    filteringState = 'None';
    resetDateFilter();
    resetFeeFilter();
  }

  void showDateRanger() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: gMinDate,
      lastDate: gMaxDate,
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if(picked != null) {
      setState(() {
        minDate = picked.start;
        maxDate = picked.end;
        filteringState = 'ByDate';
        _eventController.filterEventsByDate(context, minDate, maxDate);
      });
    }
  }

  void showFeeRangePicker() async{
    await showDialog<Widget>(
      context: context,
      builder: (context){
        return Dialog(
          backgroundColor: duskWood,
          child: Padding(padding: const EdgeInsets.all(25), child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //Min Max Markers
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: PrimaryText(
                        text: "Max",
                        color: greenAccent,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: PrimaryText(
                        text: "Max",
                        color: greenAccent,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ],
              ),

              //Range Slider
              StatefulBuilder(
                builder: (BuildContext context, state) {
                  return RangeSlider(
                    activeColor: greenAccent,
                    values: feeRangeValues,
                    labels: RangeLabels(feeRangeValues.start.round().toString(), feeRangeValues.end.round().toString()),
                    min: 0,
                    max: 100000,
                    divisions: 100,
                    onChanged: (values) {
                      state(() {
                        feeRangeValues = values;
                      });
                    },
                  );
                },
              ),
              
              //Ok Button
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: PrimaryText(
                    text: "Ok",
                    color: greenAccent,
                    textAlign: TextAlign.end,
                  )
                ),
                onTap: (){
                  setState((){
                    minFee = feeRangeValues.start;
                    maxFee = feeRangeValues.end;
                    filteringState = 'ByFee';
                    _eventController.filterEventsByFee(context, minFee.toInt(), maxFee.toInt());
                    Navigator.pop(context);
                  });
                },
              )
              
            ],
          )),
        );
      }
    );

  }

  //Build Functions
  _buildEvent(Event event){
    return InkWell(
      onTap: () async {
        _userController.getCurrentUser(context);
        Navigator.of(context).push(MaterialPageRoute<Widget>(
          builder: (BuildContext context) =>EventPage(
            size: size,
            event: event,
          )
        ));
      },
      child : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GridTile(
            child: CachedNetworkImage(
              imageUrl: event.imageUrl,
              placeholder: (context, url) => Padding(
                padding: EdgeInsets.symmetric(vertical: size.height/12 ),
                child: AppProgressIndicator(size: size),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const Divider(color: Colors.transparent),
          
          Text(event.title,
            textAlign: TextAlign.center, 
            style: eventDetailsStyleH1
          ),
          Text(
            event.venue,
            textAlign: TextAlign.center,
            style: eventDetailsStyle,),
          Text(
            //Write function to display proper ordinal suffix
            '${weekdays[event.date.weekday-1]}, ${event.date.day}th, ${months[event.date.month]} ${event.date.year}', 
            textAlign: TextAlign.start, 
            style: eventDetailsStyle,),
          Text(feesToString(event), textAlign: TextAlign.start, style: eventDetailsStyle,),
          Text('Contact: ${event.contact}', textAlign: TextAlign.start, style: eventDetailsStyle,),
          Text(tagsToString(event), textAlign: TextAlign.start, style: eventDetailsStyle,),
                
          const Divider(color: Colors.transparent),
          const Divider(color: Colors.transparent),
          const Divider(color: Colors.transparent),
          const Divider(color: Colors.transparent),
        ],
      )
    );
  }


  @override
  void initState() {
    filterTextSize = size.width*0.03;
    sortTextSize = size.width*0.03;
    super.initState();
  }

  void eventsListToAutoCompleteTitles(List<Event> events) {
    Set<String> temp = {};
    for (var e in events) {
      temp.add(e.title);
      temp.addAll(e.tags);
    }
    eventsTitles = temp.toList();
  }

  @override
  Widget build(BuildContext context) {   

        return Stack( 
          children: [
            Column(
              children: <Widget>[
                //Event Sort and Fliter Section
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: <Widget>[
                      
                      //Sorting Section
                      Expanded( 
                        child: Container(
                          alignment: Alignment.bottomLeft, 
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                child: Container (
                                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                                  alignment: Alignment.topLeft, 
                                  child: const PrimaryText(text:"Sort", textAlign: TextAlign.end, color: Color.fromRGBO(207, 195, 226, 1))
                                ),
                                onTap: (){
                                  setState((){
                                    if(sorting) {
                                      sorting = false;
                                    }
                                    else {
                                      sorting = true;
                                      filtering = false;
                                    }
                                    resetEvents();
                                  });
                                },
                              ),
      
                              //Sorting Options 
                              Visibility(
                                visible: sorting,
                                child: Container ( 
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        //Sorting By Date
                                        InkWell(
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(0, 7, 15, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    SecondaryText(
                                                      text: 'By Date', 
                                                      textAlign: TextAlign.end,
                                                      color: (sortingState.compareTo('ByDateUp')==0) || (sortingState.compareTo('ByDateDown')==0)? 
                                                        const Color.fromRGBO(89, 234, 193, 1.0):
                                                        const Color.fromRGBO(207, 195, 226, 1),
                                                    ),
                                                    (sortingState.compareTo('ByDateUp')==0)?  
                                                    Icon(
                                                      Icons.arrow_upward,
                                                      size: 18,
                                                      color: (sortingState.compareTo('ByDateUp')==0) || (sortingState.compareTo('ByDateDown')==0)? 
                                                        const Color.fromRGBO(89, 234, 193, 1.0):
                                                        const Color.fromRGBO(207, 195, 226, 1),
                                                    ):
                                                    Icon(
                                                      Icons.arrow_downward,
                                                      size: 18,
                                                      color: (sortingState.compareTo('ByDateUp')==0) || (sortingState.compareTo('ByDateDown')==0)? 
                                                        const Color.fromRGBO(89, 234, 193, 1.0):
                                                        const Color.fromRGBO(207, 195, 226, 1),
                                                    ),
                                                  ],
                                                ),

                                                //Cancle Icon
                                                Visibility(
                                                  visible: sortingState.compareTo('ByDateUp')==0 || sortingState.compareTo('ByDateDown')==0,
                                                  child: Container(
                                                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                    child: InkWell(
                                                      onTap: (){
                                                        setState(() {
                                                          _eventController.getEvents(context);
                                                          sortingState = 'None';
                                                        });
                                                      },
                                                      child: const Icon(Icons.close, color:Color.fromRGBO(89, 234, 193, 1.0), size: 18,),
                                                    )
                                                  ),
                                                )
                                              ],
                                            )
                                          ),
                                          onTap: (){
                                            setState(() {
                                              if((sortingState.compareTo('ByDateUp')==0)){
                                                _eventController.sortEventsByDateDownward(context);
                                                sortingState = 'ByDateDown';
                                              }
                                              else{
                                                _eventController.sortEventsByDateUpward(context);
                                                sortingState = 'ByDateUp';
                                              }
                                            });
                                          },
                                        ),
      
                                        //Sorting By Fee
                                        InkWell(
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      SecondaryText(
                                                        text: 'By Fee',
                                                        textAlign: TextAlign.end,
                                                        color: (sortingState.compareTo('ByFeeUp')==0) || (sortingState.compareTo('ByFeeDown')==0)? 
                                                        const Color.fromRGBO(89, 234, 193, 1.0):
                                                        const Color.fromRGBO(207, 195, 226, 1),
                                                      ),
                                                      (sortingState.compareTo('ByFeeUp')==0)?
                                                      Icon(
                                                        Icons.arrow_upward,
                                                        size: 18,
                                                        color: (sortingState.compareTo('ByFeeUp')==0) || (sortingState.compareTo('ByFeeDown')==0)? 
                                                          const Color.fromRGBO(89, 234, 193, 1.0):
                                                          const Color.fromRGBO(207, 195, 226, 1),
                                                      ):
                                                      Icon(
                                                        Icons.arrow_downward,
                                                        size: 18,
                                                        color: (sortingState.compareTo('ByFeeUp')==0) || (sortingState.compareTo('ByFeeDown')==0)? 
                                                          const Color.fromRGBO(89, 234, 193, 1.0):
                                                          const Color.fromRGBO(207, 195, 226, 1),
                                                      ),
                                                    ],
                                                  ),

                                                  //Cancle Icon
                                                  Visibility(
                                                    visible: sortingState.compareTo('ByFeeUp')==0 || sortingState.compareTo('ByFeeDown')==0,
                                                    child: Container(
                                                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                      child: InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                            _eventController.getEvents(context);
                                                            sortingState = 'None';
                                                          });
                                                        },
                                                        child: const Icon(Icons.close, color: Color.fromRGBO(89, 234, 193, 1.0), size: 18,),
                                                      )
                                                    ),
                                                  )
                                                ],
                                              )
                                          ),
                                          onTap: (){
                                            setState(() {
                                              if((sortingState.compareTo('ByFeeUp')==0)){
                                                _eventController.sortEventsByFeeDownward(context);
                                                sortingState = 'ByFeeDown';
                                              }
                                              else{
                                                _eventController.sortEventsByFeeUpward(context);
                                                sortingState = 'ByFeeUp';
                                              }
                                            });
                                          },
                                        ),
                                                                      
                                      ],
                                    ),
                                  )
                                ),
                              )
      
                            ],
                          )
                        )
                      ),
      
                      //Filtering Section
                      Expanded( 
                        child: Container(
                          alignment: Alignment.topRight, 
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                child: Container (
                                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                                  alignment: Alignment.topRight,
                                  child:  const PrimaryText(text:"Filter", textAlign: TextAlign.end, color: Color.fromRGBO(207, 195, 226, 1))
                                ),
                                onTap: (){
                                  setState(() {
                                    if(filtering) {
                                      filtering = false;
                                    }
                                    else {
                                      filtering = true;
                                      sorting = false;
                                    }
                                    resetEvents();
                                  });
                                },
                              ),
      
                              //Flitering Options
                              Visibility(
                                visible: filtering,
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0.0, 15.0, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
      
                                        //Filter By Date
                                        InkWell(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Visibility(
                                                visible: filteringState == 'ByDate',
                                                child: Icon(Icons.close, color: filteringState == 'ByDate'? const Color.fromRGBO(89, 234, 193, 1.0) : const Color.fromRGBO(207, 195, 226, 1), size: 18),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                child: SecondaryText(
                                                  text: '${months[minDate.month]} ${minDate.day} - ${months[maxDate.month]} ${maxDate.day}',
                                                  textAlign: TextAlign.end,
                                                  color: filteringState == 'ByDate'? const Color.fromRGBO(89, 234, 193, 1.0) : const Color.fromRGBO(207, 195, 226, 1)
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: (){
                                            if(filteringState == 'ByDate') {
                                              filteringState = 'None';
                                              resetDateFilter();
                                              _eventController.getEvents(context);
                                            }
                                            else {
                                              resetFeeFilter();
                                              resetTagFilter();
                                              showDateRanger();
                                            }
                                          },
                                        ),
      
                                        //Filter By Fee
                                        InkWell(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Visibility(
                                                visible: filteringState == 'ByFee',
                                                child: Icon(Icons.close, color:filteringState == 'ByFee'? const Color.fromRGBO(89, 234, 193, 1.0) : const Color.fromRGBO(207, 195, 226, 1), size: 18,),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                child: SecondaryText(
                                                  text: '${feeToStringCompact(minFee,'Min')} - ${feeToStringCompact(maxFee,'Max')}', 
                                                  textAlign: TextAlign.end,
                                                  color: filteringState == 'ByFee'? const Color.fromRGBO(89, 234, 193, 1.0) : const Color.fromRGBO(207, 195, 226, 1)
                                                )
                                              )   
                                            ],
                                          ), 
                                          onTap: (){
                                            if(filteringState == 'ByFee') {
                                              filteringState = 'None';
                                              resetFeeFilter();
                                              _eventController.getEvents(context);
                                            }else{
                                              resetDateFilter();
                                              resetTagFilter();
                                              showFeeRangePicker();
                                            }
                                          },
                                        ), 
      
                                      ],
                                    ),
                                  )
                                ),
                              )
                            ],
                          )
                        )
                      ),
                    ],
                  ),      
                ),    
      
                Stack(
                  children: <Widget>[
                    //Search Icon(Close Icon)
                    Positioned(
                      right: 10,
                      top: 10,
                      width: 50,
                      child: IconButton(
                        icon: searching? const Icon(Icons.close, color: Colors.grey,): const Icon(Icons.search, color: Colors.grey,),
                        onPressed: (){
                          setState(() {
                            if(!searching) {
                              filteringState ='None';
                              sortingState = 'None';
                              filtering = false;
                              sorting  = false;
                              searching = true;
                            }else{
                              searching = false;
                              _eventController.getEvents(context);
                            }
                          });
                        },
                      ),
                    ),
      
                    Container(
                      width: size.width,
                      height: filtering || sorting? size.height*0.6: size.height*0.7,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        children: <Widget>[
                          const Divider(
                            color: Color.fromRGBO(89, 234, 193, 1.0),
                            height: 5.0,
                            thickness: 2.0,
                          ), 
                          //Search Box
                          Visibility(
                            visible: searching,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                              child: Container(
                                child: search_autoTextField = AutoCompleteTextField<String>(
                                  clearOnSubmit: false,
                                  style: const TextStyle(color:Color.fromRGBO(207, 195, 226, 1),),
                                  decoration: const InputDecoration(
                                    hintText: 'search',
                                    hintStyle: TextStyle(color: Color.fromRGBO(207, 195, 226, 1), fontWeight: FontWeight.w200),
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:  Color.fromRGBO(207, 195, 226, 1))),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(207, 195, 226, 1))),
                                  ), 
                                  key: search_auto_completekey,
                                  suggestions: eventsTitles,
                                  itemFilter: (item, query) {
                                    return item.toLowerCase().contains(query.toLowerCase());
                                  },
                                  itemBuilder: (context, string){
                                    return Container(
                                      padding: const EdgeInsets.fromLTRB(10,5,10,5),
                                      color: Colors.white38,
                                      child: Text(string, style: const TextStyle(color: Colors.grey)),
                                    );
                                  }, 
                                  itemSorter: (String a, String b){
                                    return a.compareTo(b);
                                  }, 
                                  itemSubmitted: (item) {
                                    setState((){
                                      search_autoTextField!.textField!.controller!.text = item.toLowerCase();
                                      if(item.toLowerCase().length > 3){
                                        _eventController.displaySearchResult(item.toLowerCase(), context);
                                      }
                                    });
                                  },
                                ),
                              ),  
                            )
                          ),
      
                          Consumer<EventProvider>(
                            builder: (context, provider, child) { 
                              eventsListToAutoCompleteTitles(provider.events);
                              List<Event> events = provider.events;
                              return Expanded(
                                child: SizedBox(
                                width: size.width*0.6,
                                
                                //List of Events
                                  child: events.isEmpty? Expanded(child: NoEventsFound(size: size)): ListView.builder(
                                    itemCount: events.length,
                                    itemBuilder: (context, index) {
                                      return _buildEvent(events[index]);
                                    }, 
                                  ),
                                )
                              );
                            }
                          )                           
                        ],
                      )
                    ),
                  ],
                ),        
              ],
            ),
          ],
        );

  }

  
}