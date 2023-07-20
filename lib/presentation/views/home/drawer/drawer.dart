

import 'package:flutter/material.dart';
import 'package:lagos_events/app/styles.dart';
import 'package:lagos_events/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about.dart';
import 'privacy_policy.dart';

buildDrawer(Size size, BuildContext context, void Function() authFunctiion){
  return Theme(
    data: Theme.of(context).copyWith(
      //Transparency 
      canvasColor: Colors.black.withOpacity(0.6),
    ),
    child : SizedBox( width: size.width*0.7, child: Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Text('Lagos Events', style: titleStyle),
          )),
          const Divider(color: Colors.grey,),
          const Divider(color: Colors.transparent,),
          
          Container(
            padding: const EdgeInsets.all(25),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  const Icon(Icons.phone_android, color: Colors.grey),
                  const SizedBox(width: 5,),
                  Text('Contact Us', style: drawerStyle),
                ],
              ),
              onTap: (){
                //initiate call
                String contact =  context.watch<UserProvider>().adminContact;
                if(contact.isNotEmpty){
                  launchUrl(Uri.parse("tel://$contact"));
                }
              },
            )
          ),
          Container(
            padding: const EdgeInsets.all(25),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  const Icon(Icons.lock_outline, color: Colors.grey),
                  const SizedBox(width: 5,),
                  Text('Privacy Policy', style: drawerStyle),
                ],
              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute<Widget>(
                  builder: (BuildContext context) =>const PrivacyPolicyPage()
                ));
              },
            )
          ),
          Container(
            padding: const EdgeInsets.all(25),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  const Icon(Icons.select_all, color: Colors.grey,),
                  const SizedBox(width: 5,),
                  Text('About App', style: drawerStyle),
                ],
              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute<Widget>(
                  builder: (BuildContext context) =>const AboutAppPage()
                ));
              },
            )
          ),
          Container(
            padding: const EdgeInsets.all(25),
            child: InkWell(
              onTap: authFunctiion,
              child: Row(
                children: <Widget>[
                  const Icon(Icons.lock_outline, color: Colors.grey),
                  const SizedBox(width: 5,),
                  Text(context.watch<UserProvider>().user != null ? 'LogOut': 'LogIn', style: drawerStyle),
                ],
              ),
            )
          ),

        ]
      ),
    )),
  );
}