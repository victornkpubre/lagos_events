// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lagos_events/data/services/notification_service.dart';
import 'package:lagos_events/domain/utility/string_manipulation.dart';
import 'package:provider/provider.dart';
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/domain/models/reminder.dart';
import 'package:lagos_events/presentation/providers/reminder_provider.dart';

class ReminderButton extends StatefulWidget {
  final Event event;
  final ReminderTypes type;
  final String uid;

  const ReminderButton({
    Key? key,
    required this.event,
    required this.type,
    required this.uid,
  }) : super(key: key);

  @override
  State<ReminderButton> createState() => _ReminderButtonState();
}

class _ReminderButtonState extends State<ReminderButton> {

  DateTime _getDateForReminderType(){
    switch (widget.type) {
      case ReminderTypes.days2:
        return widget.event.date.subtract(const Duration(days: 2));
      case ReminderTypes.days1:
        return widget.event.date.subtract(const Duration(days: 1));
      case ReminderTypes.hours2:
        return widget.event.date.subtract(const Duration(hours: 2));
      case ReminderTypes.hours1:
        return widget.event.date.subtract(const Duration(hours: 1));
      case ReminderTypes.mins30:
        return widget.event.date.subtract(const Duration(minutes: 30));
      case ReminderTypes.mins15:
        return widget.event.date.subtract(const Duration(minutes: 15));
      default:
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: context.watch<ReminderProvider>().containsReminder(widget.type, widget.event)?
            const Color.fromRGBO(89, 234, 193, 0.3):
            const Color.fromRGBO(15, 57, 68, 1),
      ),
      child: ListTile(
        title: Text(reminderToText(widget.type)),
      ),
      onPressed: (){
        setState(() {
          if(context.read<ReminderProvider>().containsReminder(widget.type, widget.event)){
            Reminder? reminder = context.read<ReminderProvider>().getReminder(widget.type, widget.event);
            context.read<ReminderProvider>().removeReminder(reminder!);
            context.read<NotificationService>().cancleScheduledNotification(reminder);

          }else{
            int id = context.read<NotificationService>().scheduleNotification(_getDateForReminderType(), widget.event);
            context.read<ReminderProvider>().addReminder(widget.type, widget.event, widget.uid, id);
          }
        });

        // context.read<NotificationService>().scheduleNotification(DateTime.now().add(Duration(seconds: 10)), widget.event);
        
      },
    );
  }
}
