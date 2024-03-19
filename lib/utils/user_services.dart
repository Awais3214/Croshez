import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserServices {
  Future getUserRole() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User gUser = auth.currentUser!;
    QuerySnapshot user = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: gUser.email)
        .get();
    dynamic userData = user.docs.first.get("role");
    if (userData is String) {
      userData = [userData];
    }
    return userData;
  }

  Future<bool> checkNewUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    var collection = FirebaseFirestore.instance.collection('users');
    bool isNewUser = false;
    QuerySnapshot email =
        await collection.where('email', isEqualTo: user.email).get();
    if (email.docs.isEmpty) {
      isNewUser = true;
    }

    return isNewUser;
  }

  void createUserInstance() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    FirebaseFirestore.instance.collection("users").doc(user.uid).set(
        {"fullname": user.displayName, "email": user.email}).catchError((_) {});
  }

  saveFCMTokenIntoDb(String documentId) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    Map<String, dynamic> fcmTokenMap = {"token": fcmToken};
    FirebaseFirestore.instance
        .collection('fcmToken')
        .doc(documentId)
        .set(fcmTokenMap);
  }

  Future<String> getFCMTokenFromDb(String documentId) async {
    QuerySnapshot fcmDocument = await FirebaseFirestore.instance
        .collection('fcmToken')
        .where(FieldPath.documentId, isEqualTo: documentId)
        .get();
    String fcmToken = fcmDocument.docs[0]['token'];
    return fcmToken;
  }
}
