import 'package:lagos_events/domain/models/appuser.dart';
import 'package:lagos_events/data/repository/base/repository_interfaces.dart';
import 'package:lagos_events/data/repository/datasources/local_datasource.dart';


class AuthRepository extends AuthRepositoryInterface {
  late LocalDataSource localDataSource;
  AuthRepository._internal();
  static final AuthRepository _instance = AuthRepository._internal();

  factory AuthRepository() {
    _instance.localDataSource = LocalDataSource();
    return _instance;
  }


  @override
  Future<bool> logout() async {
    return await localDataSource.localUserLogout();
  }


  @override
  Future<AppUser?> currentUser() async {
    return await localDataSource.getCurrentUser();
  }

  @override
  Future<void> login(AppUser user) async {
    return await localDataSource.localUserLogin(user);
  }


}