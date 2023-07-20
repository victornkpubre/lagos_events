import 'package:flutter/material.dart';
import 'package:lagos_events/presentation/views/auth/auth.dart';
import 'package:lagos_events/presentation/views/auth/user_info.dart';
import 'package:lagos_events/presentation/views/home/home_view.dart';
import 'package:lagos_events/app/styles.dart';
import 'package:lagos_events/presentation/views/reminder/reminder_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: duskWood, // <-- SEE HERE
          onPrimary: greenAccent, // <-- SEE HERE
          surface: Colors.white,
          onSurface: Colors.black87, // <-- SEE HERE
        ),
        sliderTheme: const SliderThemeData()
      ),
      initialRoute: "/",
      routes: {
        '/' :(context) => const HomePage(),
        '/auth' :(context) => const AuthView(),
        '/userinfo' :(context) => const UserInfoView(),
        '/reminder' :(context) => const RemindersPage()
      },
    );
  }
}

