import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:croshez/utils/my_shared_preferecnces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String?> registration({
    required String email,
    required String password,
    required String fullname,
    // add other class variables here -> make a user doc
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        final val = value.user;
        saveUser(
          val,
          fullname,
          email,
        );
        await MySharedPreferecne().saveUserId(value.user?.uid);
      });
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    List<String> role = [];
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) async {
          // get role from db here
          String? userId = value.user?.uid;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get()
              .then(
            (DocumentSnapshot snapshot) {
              // Access the user's role information
              if (snapshot.exists) {
                Map<String, dynamic> data =
                    snapshot.data() as Map<String, dynamic>;
                for (int i = 0; i < data['role'].length; i++) {
                  role.add(data['role'][i]);
                }
              }
            },
          );
          await MySharedPreferecne().saveUserId(userId);
        },
      );
      return role[0];
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.code;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static saveUser(
    User? user,
    String fullname,
    String email,
  ) async {
    Map<String, dynamic> userData = {
      "fullname": fullname,
      "email": email,
    };

    await _db.collection("users").doc(user?.uid).set(userData);
  }

  static getRole(User? user) async {
    DocumentSnapshot userSnapshot =
        await _db.collection('users').doc(user?.uid).get();
    if (userSnapshot.exists) {
      return userSnapshot.get('role');
    } else {
      throw Exception('User not found in database');
    }
  }

  Future<String?> setRole(User? user, String role) async {
    try {
      await _db.collection('users').doc(user?.uid).update({
        'role':
            role, // Replace 'newRoleValue' with the desired new value for the 'role' variable
      });
      await MySharedPreferecne().saveUserType(role);
      return "Updated";
    } catch (e) {
      {
        return e.toString();
      }
    }
  }
}
