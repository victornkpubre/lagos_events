import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lagos_events/app/app.dart';
import 'package:lagos_events/presentation/providers/events_provider.dart';
import 'package:lagos_events/presentation/providers/reminder_provider.dart';
import 'package:lagos_events/presentation/providers/user_provider.dart';
import 'package:lagos_events/data/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:lagos_events/firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
        Provider<NotificationService>(create: (_) => NotificationService())
      ],
      child: const MyApp()
    )
  );
}

