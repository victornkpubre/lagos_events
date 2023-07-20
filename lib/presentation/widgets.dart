import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lagos_events/presentation/controllers/user_controller.dart';
import 'package:lagos_events/app/styles.dart';

class AppProgressIndicator extends StatelessWidget {
  final Size size;
  const AppProgressIndicator({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width*0.5,
      height: size.height*0.5,
      child: Column(
        children: <Widget>[
          Center(
            child: Text("Loading", style: titleStyle)
          ),
          Center(
            child: CircularProgressIndicator(color: greenAccent),
          )
        ],
      ),
    );
  }
}

class NoEventsFound extends StatelessWidget {
  final Size size;
  const NoEventsFound({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Center (
          child: SizedBox(
            width: size.width*0.5,
            height: size.width*0.5,
            child: Column(
              children: <Widget>[
                Center( child:Image.asset(
                  'assets/images/logo.png',
                  color: const Color.fromRGBO(225, 225, 225, 0.2),
                  colorBlendMode: BlendMode.modulate,
                  fit: BoxFit.fill,
                )),
                Center(
                  child: PrimaryText(color: greenAccent, text: "No Events Found", textAlign: TextAlign.center,)
                )
              ],
            ),
          )
        );
  }
}

class LoginIsRequired extends StatelessWidget {
  final Size size;
  final UserController _userController = UserController();
  LoginIsRequired({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width*0.5,
      height: size.height,

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center( child:Image.asset(
              'assets/images/logo.png',
              color: const Color.fromRGBO(225, 225, 225, 0.2),
              colorBlendMode: BlendMode.modulate,
              fit: BoxFit.fill,
            )),
            Center(
              child: PrimaryText(color: greenAccent, text: "Login is Required", textAlign: TextAlign.center,)
            ),
            Center(
              child: SizedBox(
                width: size.width*0.7,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: const Color.fromRGBO(72, 92, 99, 1),
                  ),
                  onPressed: () async {
                    _userController.authenticateUser(context);
                  },
                  child: const Text('Login', style: TextStyle(color: Color.fromRGBO(207, 195, 226, 1))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

void showErrorToastbar(String error) {
  Fluttertoast.showToast(
      msg: error,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 4,
      backgroundColor: const Color.fromARGB(255, 94, 70, 68),
      textColor: Colors.white,
      fontSize: 16.0
  );
}