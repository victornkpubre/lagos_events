import 'package:flutter/material.dart';


class AboutAppPage extends StatefulWidget {
  const AboutAppPage({super.key});

  @override
  _AboutAppPageState createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;


    return Stack(
      children: <Widget>[
        SizedBox(
          height: size.height,
          width: size.width,
        ),
        Scaffold(
          backgroundColor: Colors.white70,
          appBar: AppBar(
            backgroundColor: Colors.white70,
            elevation: 0.0,
            centerTitle: true,
            title: const Column(
                children: <Widget>[
                  Text('About App',style: TextStyle(color: Colors.black54)),
                ],
              ) 
          ),
          body: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                child: const Text("Lagos events provides a free event hub; users can discovery and upload events using our simple but robust facility. Users can also set reminder, Who wants to discover an events only to forget about it on the D-day. ")
              ),

              const Divider(color: Colors.grey,),
            ],
          ),
        ),
      ],
    );
  }
}