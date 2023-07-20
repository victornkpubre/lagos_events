import 'package:flutter/material.dart';
import 'package:lagos_events/domain/models/appuser.dart';
import 'package:lagos_events/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserController {
  
  Future<void> currentUser(BuildContext context) async {
    await context.read<UserProvider>().getCurrentUser();
  }

  Future<void> getCurrentUser(BuildContext context) async {
    await context.read<UserProvider>().getUserFromFirebase();
  }

  Future<void> updateUser(BuildContext context, AppUser user) async {
    return await context.read<UserProvider>().updateUser(user);
  }

  Future<void> logoutUser(BuildContext context) async {
    await context.read<UserProvider>().logoutUser();
  }

  Future<void> authenticateUser(BuildContext context) async {
    var user = await Navigator.pushNamed(context, '/auth');
    AppUser? appuser = user as AppUser?;
    if(appuser != null) {
      context.read<UserProvider>().loginUser(appuser);
    }
  }

}