import 'package:lagos_events/domain/models/appuser.dart';
import 'package:lagos_events/data/repository/base/repository_interfaces.dart';
import 'package:lagos_events/data/repository/datasources/firebase_datasource.dart';


class UserRepository extends UserRepositoryInterface {
  late FirebaseDataSource firebaseDataSource;

  UserRepository._internal();
  static final UserRepository _instance = UserRepository._internal();

  factory UserRepository() {
    _instance.firebaseDataSource = const FirebaseDataSource();
    return _instance;
  }

  @override
  Future<void> createUser(AppUser user) async {
    firebaseDataSource.setUser(user);
  }

  @override
  Future<AppUser?> getUser(String uid) async {
    return await firebaseDataSource.getUser(uid);
  }

  @override
  Future<void> updateUser(AppUser user) async {
    await firebaseDataSource.setUser(user);
  }

  @override
  Future<bool> userExists(String uid) async {
    var result = await firebaseDataSource.getUser(uid);
    return result != null? true: false;
  }

} 