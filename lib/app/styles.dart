// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
Color purpleTint = const Color.fromRGBO(194, 174, 225, 1);
Color purpleTint50 = const Color.fromRGBO(186, 164, 225, 0.8);
Color greenAccent = const Color.fromRGBO(89, 234, 193, 1);
Color duskWood = const Color.fromRGBO(16,63,82,1);


class PrimaryText extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign textAlign;
  const PrimaryText({
    Key? key,
    required this.text,
    required this.color,
    required this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, textAlign: textAlign, style: TextStyle(fontSize: 16,color: color));
  }
}

class SecondaryText extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign textAlign;
  const SecondaryText({
    Key? key,
    required this.text,
    required this.color,
    required this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, textAlign: textAlign, style: TextStyle(fontSize: 14,color: color));
  }
}


TextStyle titleStyle = TextStyle(
  color: purpleTint,
  fontFamily: 'Sacramento',
  fontWeight: FontWeight.w500,
  fontSize: 30,
);
TextStyle tabHeaderStyle = TextStyle(
  color: purpleTint,
);

TextStyle eventDetailsStyle = const TextStyle(
  color: Color.fromRGBO(160, 160, 160, 1),
  fontFamily: 'poison',
  fontSize: 12
  
);

TextStyle eventDetailsStyleH1 = const TextStyle(
  color: Color.fromRGBO(160, 160, 160, 1),
  fontFamily: 'MontaseliSans',
  fontSize: 20
);

TextStyle eventDetailsStyleH2 = const TextStyle(
  color: Color.fromRGBO(160, 160, 160, 1),
  fontFamily: 'MontaseliSans',
  fontSize: 14
);


TextStyle drawerStyle = const TextStyle(
  color: Colors.grey,
  fontSize: 16
);
TextStyle drawerStyleH3 = const TextStyle(
  color: Colors.grey,
  fontSize: 12
);
