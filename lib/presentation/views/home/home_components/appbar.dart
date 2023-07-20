

import 'package:flutter/material.dart';
import 'package:lagos_events/app/styles.dart';

PreferredSizeWidget buildAppBar(Size size){
  String title = "Lagos Events";
  return AppBar(
    centerTitle: true,
    iconTheme: IconThemeData(color: purpleTint50),
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    title: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(title, style: titleStyle),
        ),
      ],
    ),
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(size.height*0.09),
      child: Column(
        children: <Widget>[
          Divider(color: greenAccent),
          TabBar(
            labelColor: purpleTint,
            indicatorColor: greenAccent,
            tabs: const <Widget>[
              Tab(
                text: 'Events',
              ),
              Tab(
                text: 'Calendar',
              ),
              Tab(
                text: 'My Events',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}