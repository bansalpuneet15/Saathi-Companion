import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  User({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;
  Future<User> currentUser();
  Future<User> signInWithGoogle();

  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid);
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => _userFromFirebase(user as User));
    // return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser;
    return _userFromFirebase(user as User);
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );

        final QuerySnapshot result =
            await FirebaseFirestore.instance.collection('relatives').get();
        final List<DocumentSnapshot> documents = result.docs;
        bool userExits = false;
        for (var document in documents) {
          if (document.reference.id == authResult.user.uid) userExits = true;
        }
        if (!userExits) {
          try {
            await FirebaseFirestore.instance
                .collection('relatives')
                .doc(authResult.user.uid.toString())
                .set({
              'name': authResult.user.displayName,
              'email': authResult.user.email,
              'phoneNumber': '',
              'uid': authResult.user.uid,
              'elderUID': '',
              'picture':
                  'https://image.shutterstock.com/image-vector/profile-anonymous-face-icon-gray-260nw-789318310.jpg',
            });
          } catch (e) {
            print(e.toString());
          }
        }

        return _userFromFirebase(authResult.user as User);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    print('Puneet');
    await _firebaseAuth.currentUser.delete();
    print('Bansal');
    await _firebaseAuth.signOut();
  }
}
