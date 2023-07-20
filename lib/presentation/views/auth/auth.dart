
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lagos_events/domain/models/appuser.dart';
import 'package:lagos_events/domain/models/arguments.dart';
import 'package:lagos_events/data/repository/repositories/user_repository.dart';
import 'package:lagos_events/app/styles.dart';
import 'package:lagos_events/presentation/widgets.dart';


class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}


class _AuthViewState extends State<AuthView> {
  late AuthCredential authCredentials;
  late String _verificationId;
  final TextEditingController _mobileController = TextEditingController();
  String error = "";
  bool loading = false;

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
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
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
    
              SizedBox(
                width: size.width*0.7,
                child: Row(
                  children: [
                    Text(
                      "+234"
                    ),
                    TextField(
                      controller: _mobileController,
                      style: const TextStyle(color:Color.fromRGBO(207, 195, 226, 1)),
                      decoration: const InputDecoration(
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(color: Color.fromRGBO(207, 195, 226, 1), fontWeight: FontWeight.w200),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:  Color.fromRGBO(207, 195, 226, 1))),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(207, 195, 226, 1))),                  
                      ),
                    ),
                  ],
                ), 
              ),
    
              SizedBox(
                width: size.width*0.7,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: const Color.fromRGBO(72, 92, 99, 1),
                  ),
                  onPressed: () async {
                    if(_mobileController.text.isNotEmpty){
                      login("+234${_mobileController.text.trim()}" , context);
                    }
                  },
                  child: const Text('Login', style: TextStyle(color: Color.fromRGBO(207, 195, 226, 1))),
                ),
              ),

              SizedBox(
                width: size.width*0.7,
                child: Text(error, style: const TextStyle(color: Colors.redAccent))
              )
    
            ],
          ),

          loading? AppProgressIndicator(size: size,): Container()
        ],
      ),
    );
  }

  void login(String mobile, BuildContext context) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    showLoading();
  
    await auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) async {
        await auth.signInWithCredential(authCredential).then((result) async {
          user = result.user;
          if(user != null){
            AppUser? appUser = await getUser(user!.uid, user!.phoneNumber!);
            Navigator.pop(context, appUser);
          }
        }).catchError((e){
          setState(() {
            error = e.toString();
          });
        });
        closeLoading();
      },
      verificationFailed: (FirebaseAuthException authException){
        closeLoading();
        setState(() {
          error = authException.message??"";
        });
      },
      codeSent: (verificationId, forceResendingToken ) async {
        _verificationId = verificationId;
        user = await showOtpCodeDialog();
        closeLoading();
        if(user != null){
          AppUser? appUser = await getUser(user!.uid, user!.phoneNumber!);
          Navigator.pop(context, appUser);
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
        print(verificationId);
        print("Timout");
      }
    );


  } 

  Future showOtpCodeDialog() {
    TextEditingController codeController = TextEditingController();
    String smsCode = '';
    
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: duskWood,
        title: Text("Enter SMS Code", style: eventDetailsStyleH1,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: codeController,
              style: const TextStyle(color:Color.fromRGBO(207, 195, 226, 1),),
              decoration: const InputDecoration(
                hintText: 'Enter Contact Number',
                hintStyle: TextStyle(color: Color.fromRGBO(207, 195, 226, 1), fontWeight: FontWeight.w200),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:  Color.fromRGBO(207, 195, 226, 1))),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(207, 195, 226, 1))),                  
              ),
            ),

          ],
        ),
        actions: <Widget>[
          SizedBox(
            width: double.maxFinite,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: greenAccent,
              ),
              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                smsCode = codeController.text.trim();
                PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: smsCode);
                auth.signInWithCredential(credential).then((result) {
                  Navigator.pop(context, result.user);
                }).catchError((e){
                  print(e);
                });
              },
              child: const Text("Done"),
            ),
          )
        ],
      )
    );
  }

  Future<AppUser?> getUser(String uid, String phone) async {
    UserRepository userRepo = UserRepository();
    if(await userRepo.userExists(uid)) {
      return await userRepo.getUser(uid);
    }
    else {
      var user = await Navigator.pushNamed(context, '/userinfo', arguments: UserInfoArguments(uid, phone));
      AppUser? appUser = user as AppUser?;
      return appUser;
    }
  }

}