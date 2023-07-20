import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {

String intro = "It is important that you understand what information Lagos Events collects and uses.No information is collected covertly and all personal information is stored on the user's phone";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        SizedBox(
          height: size.height,
          width: size.width,
  //        decoration: const BoxDecoration(
  //            image:  DecorationImage(
  //              image: AssetImage('assets/images/Moonlit_Asteroid.jpg'),
  //              fit: BoxFit.cover
  //            )
  //        ),
        ),
        Scaffold(
          backgroundColor: Colors.white70,
          appBar: AppBar(
            backgroundColor: Colors.white70,
            elevation: 0.0,
            centerTitle: true,
            title: const Column(
                children: <Widget>[
                  Text('Privacy Policy',style: TextStyle(color: Colors.black54)),
                ],
              ) 
          ),
          body: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                child: Text(intro)
              ),

              const Divider(color: Colors.grey,),

              Container(
                width: size.width,
                padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                child: const Text("Information Collection", textAlign: TextAlign.left,)
              ),
              
              Container(
                width: size.width*0.9,
                padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                child: const Text("Lagos Events does not save or collect any login information; information related to saved and uploaded events are stored on the users phone; All information related to events are stored on a remote database",
                  textAlign: TextAlign.left,
                )
              ),

              const Divider(color: Colors.grey,)

            ],
          ),
        ),
      ],
    );
  }
}