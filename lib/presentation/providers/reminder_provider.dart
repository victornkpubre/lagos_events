import 'package:flutter/material.dart';
import 'package:lagos_events/data/repository/repositories/reminder_repository.dart';
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/domain/models/reminder.dart';
import 'package:lagos_events/domain/utility/string_manipulation.dart';



class ReminderProvider extends ChangeNotifier {
  final ReminderRepository _reminderRepository = ReminderRepository();
  List<Reminder> _reminders = [];
  List<Reminder> get reminders => _reminders;
  set setReminders(List<Reminder> reminders) {
    _reminders = reminders;
    notifyListeners();
  }

  Future<void> getReminders(String uid) async {
    _reminders = await _reminderRepository.getReminders(uid);
    notifyListeners();
  }

  Reminder? getReminder(ReminderTypes type, Event event) {
    Reminder? result;
    for (var _reminder in _reminders) {
      if(typeToString(type).compareTo(_reminder.type) == 0  && event.id == _reminder.eventid){
        result = _reminder;
      }
    }
    return result;
  }

  bool containsReminder(ReminderTypes type, Event event) {
    bool result = false;
    for (var _reminder in _reminders) {
      if(typeToString(type).compareTo(_reminder.type) == 0  && event.id == _reminder.eventid){
        result = true;
      }
    }
    return result;
  }

  Future<void> addReminder(ReminderTypes type, Event event, String uid, int nid) async {
    Reminder? reminder = await _reminderRepository.addReminders(event, type, uid, nid);
    
    if(reminder != null) {
      reminders.add(reminder);
    }
    
    notifyListeners();
  }

  void removeReminder(Reminder reminder){
    _reminderRepository.removeReminders(reminder);
    _reminders.remove(reminder);
    notifyListeners();
  }


}