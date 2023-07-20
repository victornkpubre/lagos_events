import 'package:flutter/material.dart';
import 'package:lagos_events/data/repository/repositories/admin_repository.dart';
import 'package:lagos_events/domain/models/appuser.dart';
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/data/repository/repositories/auth_repository.dart';
import 'package:lagos_events/data/repository/repositories/event_repository.dart';
import 'package:lagos_events/data/repository/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  final UserRepository _userRepo = UserRepository();
  final EventRepository _eventsRepo = EventRepository();
  final AdminRepository _adminRepo = AdminRepository();

  AppUser? _user;
  List<Event> _userEventsSaved = [];
  List<Event> _userEventsUploaded = [];
  String _adminContact = "";

  String get adminContact => _adminContact;

  set adminContact(String value) {
    _adminContact = value;
  }

  
  AppUser? get user => _user;
  set user(AppUser? value) {
    _user = value;
  }
  List<Event> get userEventsSaved => _userEventsSaved;
  set userEventsSaved(List<Event> value) {
    _userEventsSaved = value;
  }
  List<Event> get userEventsUploaded => _userEventsUploaded;
  set userEventsUploaded(List<Event> value) {
    _userEventsUploaded = value;
  }


  Future<void> getCurrentUser() async {
    _user = await _authRepo.currentUser();
    await getMyEvents(_user);
    notifyListeners();
  }

  Future<void> getUserFromFirebase() async {
    if(_user != null){
      _user = await _userRepo.getUser(_user!.uid);
      await getMyEvents(_user);
      notifyListeners();
    }
  }

  Future<void> updateUser(AppUser appuser) async {
    await _userRepo.updateUser(appuser);
    _user = appuser;
    await getMyEvents(_user);
    notifyListeners();
  }

  Future<void> logoutUser() async {
    await _authRepo.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> loginUser(AppUser appuser) async {
    _authRepo.login(appuser);
    _user = appuser;
    await getMyEvents(_user);
    notifyListeners();
  }

  Future<void> getMyEvents(AppUser? user) async {
    getContact();
    if(user != null) {
      if(user.savedEvents != null) {
        _userEventsSaved = await _eventsRepo.getEventsByIds(user.savedEvents!);
      }
      _userEventsUploaded = await _eventsRepo.getEventsByUser(user.uid);
    }
  }

  Future<void> getContact() async {
    _adminContact = await _adminRepo.getContact();
    notifyListeners();
  }
}