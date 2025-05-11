import 'package:firebase_database/firebase_database.dart';

abstract class DataBaseService{
  Future<void> databaseRef(String path);
}

class DataBaseRef implements DataBaseService{
  @override
  Future<DatabaseReference> databaseRef(String path) async {
    return FirebaseDatabase.instance.ref(path);
  }
}
