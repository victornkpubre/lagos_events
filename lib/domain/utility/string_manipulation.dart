//EventsString Manipulation Method
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/domain/models/reminder.dart';

String feeToStringCompact(double fee, String name) {
  int feeInt = fee.toInt();
  String feeString = feeInt.toString();
  List<String> feeStrings = feeInt.toString().split('');
  if(feeStrings.length > 3) {
    feeStrings.insert(feeStrings.length - 3, 'k');
    feeString = feeStrings.join().substring(0, feeStrings.indexOf('k')+1);
  }
  return 'N$feeString';
}

String feesToString(Event event){
  String feeStr = '';
  for (var fee in event.fees) {
    feeStr = '${feeStr}N$fee, ';
  }
 
  return feeStr.substring(0, feeStr.length-2);
}

String tagsToString(Event event){
  String tagStr = '';
  for (var r in event.tags) {
      tagStr = '$tagStr#$r,  ' ;
  }
  return tagStr;
}


String dateToString(Event event){
  return '${event.date.year}-${event.date.month}-${event.date.day}';
}

String typeToString(ReminderTypes type){
  switch (type) {
    case ReminderTypes.days2 :
      return "days2";
    case ReminderTypes.days1 :
      return "days1";
    case ReminderTypes.hours2:
      return "hours2";
    case ReminderTypes.hours1:
      return "hours1";
    case ReminderTypes.mins30:
      return "mins30";
    case ReminderTypes.mins15:
      return "mins15";
    default:
      return "days2";
  }
}

String reminderToText(ReminderTypes type){
    switch (type) {
      case ReminderTypes.days2:
        return "2 Days Before";
      case ReminderTypes.days1:
        return "1 Day Before";
      case ReminderTypes.hours2:
        return "2 Hours Before";
      case ReminderTypes.hours1:
        return "1 Hour Before";
      case ReminderTypes.mins30:
        return "30 Minutes Before";
      case ReminderTypes.mins15:
        return "15 Minutes Before";
      default:
      return "";
    }
  }

// String eventRemindersToString(List<Reminder> reminders, Event event) {
//   String remStr = '';
//   reminders.forEach((rem) {
//     if(rem.eventid == event.id){
//       remStr = remStr + rem.datetime.toString() + ', ';
//     }
//   });
//   return remStr;
// }
