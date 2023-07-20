import 'package:lagos_events/data/repository/datasources/firebase_datasource.dart';

class AdminRepository {
  late FirebaseDataSource firebaseDataSource;
  AdminRepository._internal();
  static final AdminRepository _instance = AdminRepository._internal();

  factory AdminRepository() {
    _instance.firebaseDataSource = const FirebaseDataSource();
    return _instance;
  }

  Future<String> getContact() async {
    String result = await firebaseDataSource.getContact();
    return result;
  }


}