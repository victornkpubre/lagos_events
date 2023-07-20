import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lagos_events/domain/models/arguments.dart';
import 'package:lagos_events/presentation/controllers/user_controller.dart';
import 'package:lagos_events/domain/models/appuser.dart';
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/presentation/providers/user_provider.dart';
import 'package:lagos_events/domain/utility/string_manipulation.dart';
import 'package:lagos_events/app/styles.dart';
import 'package:lagos_events/presentation/widgets.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  final Size size;
  final Event event;

  const EventPage({
    Key? key,
    required this.size,
    required this.event,
  }): super(key: key);

  @override
  _EventPageState createState() => _EventPageState(size: size, event: event);
}

class _EventPageState extends State<EventPage> {
  Size size;
  Event event;
  final UserController _userController = UserController();

  _EventPageState({required this.size, required this.event});

  void unSaveEvent(BuildContext context, AppUser user, Event event) async{
    if(user.savedEvents != null){
      user.savedEvents!.remove(event.id);
      _userController.updateUser(context, user);
    }
  }

  void saveEvent(BuildContext context, AppUser user, Event event) async {
    user.savedEvents ??= [];
    if(!user.savedEvents!.contains(event.id)){
      user.savedEvents!.add(event.id);
      _userController.updateUser(context, user);
    }
  }

  bool isSavedEvent(BuildContext context, AppUser? user, Event event){
    if(user != null) {
      if(user.savedEvents != null) {
        return user.savedEvents!.contains(event.id);
      }
      else {
        return false;
      }
    }
    else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: <Widget>[
        Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
              image:  DecorationImage(
                image: AssetImage('assets/images/Moonlit_Asteroid.jpg'),
                fit: BoxFit.cover
              )
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            title: Column(
                children: <Widget>[
                  Text('LagosEvents',style: titleStyle),
                ],
              ) 
          ),
          body: SingleChildScrollView(child: Consumer<UserProvider>(
            builder: (context, provider, child) {
              AppUser? user = provider.user;

              return Container(
                width: size.width,
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  child: Column( 
                    children: <Widget>[
                      SizedBox(
                        width: size.width*0.6,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child:  CachedNetworkImage(
                            imageUrl: event.imageUrl,
                            placeholder: (context, url) => Padding(
                              padding: EdgeInsets.symmetric(vertical: size.height/24 ),
                              child: AppProgressIndicator(size: size),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child:  Text(event.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Color.fromRGBO(100, 100, 100, 1)),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child:  Text(event.venue, style: const TextStyle(color: Color.fromRGBO(100, 100, 100, 1))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child:  Text(dateToString(event), style: const TextStyle(color: Color.fromRGBO(100, 100, 100, 1))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child:  Text(feesToString(event), style: const TextStyle(color: Color.fromRGBO(100, 100, 100, 1))),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: const Color.fromRGBO(72, 92, 99, 1),
                          ),
                          onPressed: () async {
                            if( user == null) {
                              _userController.authenticateUser(context);
                            }
                            if(user != null) {
                              setState(() {
                                if(isSavedEvent(context, user, event)) {
                                  unSaveEvent(context, user, event);
                                }
                                else {
                                  saveEvent(context, user, event);
                                }
                              });
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              Expanded( child: Icon(
                                Icons.check_box,
                                color: (isSavedEvent(context, user, event))?
                                        const Color.fromRGBO(89, 234, 193, 1.0):
                                        const Color.fromRGBO(65, 65, 65, 1),
                              )),
                              const Expanded(
                                child: Text('Save Event', textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300))
                              ),
                            ],
                          )
                        )
                      ),

                      (!isSavedEvent(context, user, event))? Container(): Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: const Color.fromRGBO(72, 92, 99, 1),
                          ),
                          onPressed: (){
                            //Open Manage Reminders Screen
                            if( user == null) {
                              _userController.authenticateUser(context);
                            }
                            if(user != null) {
                              Navigator.pushNamed(context, '/reminder', arguments: ReminderArguments(event, user));
                            }
                          },
                          child: const Row(
                            children: <Widget>[
                              Expanded( child:Text('Manage Reminders', textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300)))
                            ],
                          )
                        )
                      ), 
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: const Color.fromRGBO(72, 92, 99, 1),
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: const Row(
                            children: <Widget>[
                              Expanded( child:Text('Close', textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300)))
                            ],
                          )  
                        )
                      ),                                 
                    ],
                  ),
                )
              );
            }
          )),
        ),
      ],
    );
  }
}