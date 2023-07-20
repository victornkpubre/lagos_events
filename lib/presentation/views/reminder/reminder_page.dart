// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lagos_events/domain/models/arguments.dart';
import 'package:lagos_events/presentation/providers/reminder_provider.dart';
import 'package:lagos_events/presentation/views/reminder/reminder_btn.dart';
import 'package:lagos_events/domain/models/appuser.dart';
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/domain/models/reminder.dart';
import 'package:provider/provider.dart';

class RemindersPage extends StatefulWidget {
  

  const RemindersPage({
    Key? key,
  }) : super(key: key);

  @override
  _RemindersPageState createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {

  _RemindersPageState ();



  @override
  Widget build(BuildContext context) {
    final ReminderArguments args = ModalRoute.of(context)!.settings.arguments as ReminderArguments;
    Size size = MediaQuery.of(context).size;
    Event event = args.event;
    AppUser  user = args.user;
    context.read<ReminderProvider>().getReminders(user.uid);

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
            title: const Center(
              child: Column(
                children: <Widget>[
                  Text('LagosEvents',style: TextStyle(color: Color.fromRGBO(207, 195, 226, 1))),
                ],
              ) 
            )
          ),
          body: Stack(
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
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),    
                    child: Wrap(
                      runSpacing: 5,
                      children: <Widget>[
                        Text(event.title,textAlign: TextAlign.left, style: const TextStyle(fontSize: 25, color: Color.fromRGBO(100, 100, 100, 1)),),
                        const Divider(
                          color: Color.fromRGBO(89, 234, 193, 1.0),
                          height: 15.0,
                          thickness: 2.0,
                        ),

                        ReminderButton(event: event, type: ReminderTypes.days2, uid: user.uid),
                        ReminderButton(event: event, type: ReminderTypes.days1, uid: user.uid),
                        ReminderButton(event: event, type: ReminderTypes.hours2, uid: user.uid),
                        ReminderButton(event: event, type: ReminderTypes.hours1, uid: user.uid),
                        ReminderButton(event: event, type: ReminderTypes.mins30, uid: user.uid),
                        ReminderButton(event: event, type: ReminderTypes.mins15, uid: user.uid),

                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(72, 92, 99, 1),
                          ),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: const Row(
                            children: <Widget>[
                              Expanded( child:Text('Close', textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300)))
                            ],    
                          )  
                        ),

                      ],
                    ),
                  )
                ],
              )
        ),
      ],
    );
  }
}