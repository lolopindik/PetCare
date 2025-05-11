import 'package:firebase_auth/firebase_auth.dart';

class UserService {

  static Future<User?> getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    return user;
  }

  static Future<String> getUserUuid() async {
    final user = await getUser();
    if (user != null) {
      return user.uid;
    }
    return 'unknow';
  }
}
