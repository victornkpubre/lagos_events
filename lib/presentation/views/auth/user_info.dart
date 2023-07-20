// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lagos_events/domain/models/appuser.dart';
import 'package:lagos_events/domain/models/arguments.dart';
import 'package:lagos_events/data/repository/repositories/user_repository.dart';
import 'package:lagos_events/app/styles.dart';


class UserInfoView extends StatefulWidget {
  const UserInfoView({super.key});
 

  @override
  State<UserInfoView> createState() => _UserInfoViewState();
}

class _UserInfoViewState extends State<UserInfoView> {
  late Size size;
  bool loading = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();


  void showLoading(){
    setState(() {
      loading = true;
    });
  }
  void closeLoading(){
    setState(() {
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final UserInfoArguments args = ModalRoute.of(context)!.settings.arguments as UserInfoArguments;
    UserRepository userRepository = UserRepository();
  
    return Stack( children: <Widget>[
      Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          image:  DecorationImage(
            image: AssetImage('assets/images/Moonlit_Asteroid.jpg'),
            fit: BoxFit.cover
          )
        ),
      ),

      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: purpleTint50, //change your color here
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text('User Information', style: titleStyle),
        ),
        body: 
        Stack(
          children: [
            SingleChildScrollView( child: Center(
              child: Column(
                children: <Widget>[

                  //Title and Logo
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text("Lagos Events", style: titleStyle),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  ),
                  const SizedBox(height: 25),

                  //First Name Entry
                  SizedBox(
                    width: size.width*0.8,
                    child: TextField(
                      controller: firstNameController,
                      style: const TextStyle(color:Color.fromRGBO(207, 195, 226, 1),),
                      decoration: const InputDecoration(
                        hintText: 'First Name',
                        hintStyle: TextStyle(color: Color.fromRGBO(207, 195, 226, 1), fontWeight: FontWeight.w200),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:  Color.fromRGBO(207, 195, 226, 1))),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(207, 195, 226, 1))),                  
                      ),
                    ), 
                  ),

                  //Last Name Entry
                  SizedBox(
                    width: size.width*0.8,
                    child: TextField(
                      controller: lastNameController,
                      style: const TextStyle(color:Color.fromRGBO(207, 195, 226, 1),),
                      decoration: const InputDecoration(
                        hintText: 'Last Name',
                        hintStyle: TextStyle(color: Color.fromRGBO(207, 195, 226, 1), fontWeight: FontWeight.w200),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:  Color.fromRGBO(207, 195, 226, 1))),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(207, 195, 226, 1))),
                      ),
                    ), 
                  ),
                  const Divider(color: Colors.transparent),

                  SizedBox(
                    width: size.width*0.7,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: const Color.fromRGBO(72, 92, 99, 1),
                      ),
                      onPressed: () async {
                        if(firstNameController.text.isNotEmpty){
                          if(lastNameController.text.isNotEmpty){
                            AppUser user = AppUser(
                              uid: args.uid,
                              phoneNumber: args.phone,
                              firstName: firstNameController.text.trim(),
                              lastName: lastNameController.text.trim()
                            );

                            await userRepository.createUser(user);

                            Navigator.of(context).pop(user);
                          }
                          else {
                            Navigator.of(context).pop();
                          }
                        }
                        else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Enter', style: TextStyle(color: Color.fromRGBO(207, 195, 226, 1))),
                    ),
                  ),


                  
                ],
              ),
            )),

            //Loading Screen
            loading? Container(
              height: size.height,
              width: size.width,
              color: Colors.black38,
              child: Center(
                child: SizedBox(
                  width: 35,
                  child: CircularProgressIndicator(color: greenAccent)
                )
              )
            ): Container()
          ],
        )
      )
    ],);
  }
}