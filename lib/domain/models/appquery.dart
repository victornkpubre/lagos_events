// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lagos_events/app/constants.dart';

class AppFilterQuery {
  String field;
  Query type;
  Object value;
  Object? secondaryValue;

  AppFilterQuery({
    required this.field,
    required this.type,
    required this.value,
    this.secondaryValue,
  });
  
}

class AppSortQuery {
  String field;
  bool descendingOrder;

  AppSortQuery({
    required this.field,
    required this.descendingOrder,
  });
  
}
