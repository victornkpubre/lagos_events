import 'package:flutter/material.dart';
import 'package:lagos_events/presentation/controllers/user_controller.dart';
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/presentation/providers/user_provider.dart';
import 'package:lagos_events/domain/utility/string_manipulation.dart';
import 'package:provider/provider.dart';
import 'package:lagos_events/domain/models/appuser.dart';
import 'package:lagos_events/presentation/widgets.dart';

class MyEventsTab extends StatefulWidget {
  final Size size;
  const MyEventsTab({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  State<MyEventsTab> createState() => _MyEventsTabState(size: size);
}

class _MyEventsTabState extends State<MyEventsTab> {
  Size size;
  final UserController _userController = UserController();
  _MyEventsTabState({required this.size});


  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser(){
    _userController.currentUser(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        AppUser? user = provider.user;
        List<Event> savedEvents = provider.userEventsSaved;
        List<Event> uploadedEvents = provider.userEventsUploaded;

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: user == null? LoginIsRequired(size: size): SingleChildScrollView(
            child: Column(
              children: <Widget>[

                //Saved Events Title
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Saved',
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
                //Saved Events List
                savedEvents.isEmpty? NoEventsFound(size: size): ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: savedEvents.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        const Divider(color: Colors.transparent),
                        InkWell( 
                          onTap: (){
                            
                          },
                          child: Container(
                          color: const Color.fromRGBO(15, 57, 68, 1),
                          child: Column(
                            
                            children: <Widget>[
                              ListTile(
                                leading: Container(
                                  constraints: const BoxConstraints(maxWidth: 100), 
                                  child: Image.network(savedEvents[index].imageUrl)
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child:Text(savedEvents[index].title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(100, 100, 100, 1)))
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          const Text('Venue - ', textAlign: TextAlign.left,style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color:Color.fromRGBO(100, 100, 100, 1))),
                                          Expanded(child: Text(savedEvents[index].venue,  style: const TextStyle(fontSize: 12, color: Color.fromRGBO(100, 100, 100, 1))))
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          const Text('Date - ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(100, 100, 100, 1))),
                                          Expanded(child: Text(dateToString(savedEvents[index]), style: const TextStyle(fontSize: 11, color: Color.fromRGBO(100, 100, 100, 1)),))
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          const Text('Gate Fee - ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(100, 100, 100, 1))),
                                          Expanded(child:Text(feesToString(savedEvents[index]),  style: const TextStyle(fontSize: 11, color:Color.fromRGBO(100, 100, 100, 1))))
                                        ],
                                      ),
                                                        
                                      
                                    ],
                                  ),
                                )
                              ),
                              
                              // Container(
                              //   padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                              //   child: eventRemindersToString(savedEvents[index]).compareTo('')==0? 
                              //   Text('No Reminders', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(100, 100, 100, 1))): 
                              //   Row(
                              //     children: <Widget>[
                              //       Text('Reminders : ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(100, 100, 100, 1))),
                              //       Expanded(child:Text(eventRemindersToString(savedEvents[index]),  style: TextStyle(fontSize: 11, color: Color.fromRGBO(100, 100, 100, 1))))
                              //     ],
                              //   )
                              // ),
                              Container(
                                width: size.width*0.8,
                                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Text(tagsToString(savedEvents[index]), textAlign: TextAlign.left, style: const TextStyle(fontSize: 11, color: Color.fromRGBO(100, 100, 100, 1)),),
                              ),
                            ],
                          )
                        )),
                        
                      ],
                    );
                  },
                ),
                const Divider(color: Colors.transparent),
                const Divider(color: Colors.transparent),




                //Uploaded Events Title
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Uploaded Events',
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
                //Uploaded Events List
                uploadedEvents.isEmpty? NoEventsFound(size: size): ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: uploadedEvents.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        const Divider(color: Colors.transparent),
                        InkWell( 
                          onTap: (){
                            //
                          },
                          child: Container(
                          color: const Color.fromRGBO(15, 57, 68, 1),
                          child: Column(
                            
                            children: <Widget>[
                              ListTile(
                                leading: Container(
                                  constraints: const BoxConstraints(maxWidth: 100), 
                                  child: Image.network(uploadedEvents[index].imageUrl)
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child:Text(uploadedEvents[index].title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(100, 100, 100, 1)))
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          const Text('Venue - ', textAlign: TextAlign.left,style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color:Color.fromRGBO(100, 100, 100, 1))),
                                          Expanded(child: Text(uploadedEvents[index].venue,  style: const TextStyle(fontSize: 12, color: Color.fromRGBO(100, 100, 100, 1))))
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          const Text('Date - ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(100, 100, 100, 1))),
                                          Expanded(child: Text(dateToString(uploadedEvents[index]), style: const TextStyle(fontSize: 11, color: Color.fromRGBO(100, 100, 100, 1)),))
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          const Text('Gate Fee - ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(100, 100, 100, 1))),
                                          Expanded(child:Text(feesToString(uploadedEvents[index]),  style: const TextStyle(fontSize: 11, color:Color.fromRGBO(100, 100, 100, 1))))
                                        ],
                                      ),
                                                        
                                      
                                    ],
                                  ),
                                )
                              ),
                              
                              // Container(
                              //   padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                              //   child: eventRemindersToString(uploadedEvents[index]).compareTo('')==0? 
                              //   Text('No Reminders', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(100, 100, 100, 1))): 
                              //   Row(
                              //     children: <Widget>[
                              //       Text('Reminders : ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(100, 100, 100, 1))),
                              //       Expanded(child:Text(eventRemindersToString(uploadedEvents[index]),  style: TextStyle(fontSize: 11, color: Color.fromRGBO(100, 100, 100, 1))))
                              //     ],
                              //   )
                              // ),
                              Container(
                                width: size.width*0.8,
                                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Text(tagsToString(uploadedEvents[index]), textAlign: TextAlign.left, style: const TextStyle(fontSize: 11, color: Color.fromRGBO(100, 100, 100, 1)),),
                              ),
                            ],
                          )
                        )),
                        
                      ],
                    );
                  },
                ),
                const Divider(color: Colors.transparent),
                const Divider(color: Colors.transparent),
              ],
            )
          ),
          
        );
      }
    );
  }
}

