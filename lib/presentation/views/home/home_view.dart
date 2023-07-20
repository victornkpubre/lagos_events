import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lagos_events/presentation/controllers/event_controller.dart';
import 'package:lagos_events/presentation/controllers/user_controller.dart';
import 'package:lagos_events/presentation/providers/events_provider.dart';
import 'package:lagos_events/data/services/notification_service.dart';
import 'package:lagos_events/presentation/views/home/drawer/drawer.dart';
import 'package:lagos_events/presentation/views/home/home_components/appbar.dart';
import 'package:lagos_events/presentation/views/home/home_components/fab.dart';
import 'package:lagos_events/presentation/widgets.dart';
import 'package:lagos_events/presentation/providers/user_provider.dart';
import 'package:lagos_events/presentation/views/home/tabs/calendar.dart';
import 'package:lagos_events/presentation/views/home/tabs/events.dart';
import 'package:lagos_events/presentation/views/home/tabs/my_events.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map< DateTime, List > eventsDateMap = {};
  final EventController _eventController = EventController();
  final UserController _userController = UserController();


  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationService>().initialize();
      _eventController.getEvents(context);
      _userController.currentUser(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
        DefaultTabController(
          length: 3,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              floatingActionButton: buildFAB(size, context),
              appBar: buildAppBar(size),
              drawer: buildDrawer(size, context, 
                (){
                  if(context.watch<UserProvider>().user == null ){
                  _userController.authenticateUser(context);
                  }
                  else {
                    _userController.logoutUser(context);
                  }
                }
              ),
              body: Consumer<EventProvider>(
                builder: (context, provider, child) {
                  return provider.events.isEmpty? 
                  Center(child: AppProgressIndicator(size: size)):
                  TabBarView(
                    children: <Widget>[
                      //Screen 1
                      EventsTab(
                        size: size,
                      ),

                      //Screen 2
                      CalendarTab(
                        size: size,
                      ),
                      
                      //Screen3
                      MyEventsTab(
                        size: size,
                      )
                    ],
                  );
                }
              ),
          
          ),
        )
        
      ],
    );
  }
}