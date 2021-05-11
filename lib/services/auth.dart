
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybyday/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:daybyday/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserType _currentUser;
  UserType get currentUser => _currentUser;
  final GoogleSignIn googleSignIn = GoogleSignIn();


  //for google sign in
  
//   create user obj based on firebase user
  UserType _userFromFirebaseUser(User user) {
    return user != null ? UserType(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<UserType> get user {
    return _auth.authStateChanges()
        .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      _currentUser = UserType(
        uid: result.user.uid,
        email: null,
        name: 'Anonymous',
        datecreated: Timestamp.now()
      );
      await DatabaseService(uid: result.user.uid).createUser(_currentUser);
      return result.user;

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // create account for anon

  Future createAnon(String email, String password, String name) async {
    try {
      final currentuid = await FirebaseAuth.instance.currentUser.uid;
      final credential = EmailAuthProvider.credential(email: email, password: password);

      await FirebaseAuth.instance.currentUser.linkWithCredential(credential);
      // await DatabaseService(uid: currentuid).createUser(_currentUser);

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// log in with email and password

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await
      _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }


// register with email and password

  Future createUserWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // create a new user
      _currentUser = UserType(
        uid: result.user.uid,
        email: email,
        name: name,
          datecreated: Timestamp.now()

      );
      await DatabaseService(uid: result.user.uid).createUser(_currentUser);
      return result.user;

    } catch (error) {
      print(error.toString());
      return null;
    }
  }

// sign in with google

  Future<String> signInWithGoogle() async {

    String name;
    String email;
    String imageUrl;
    String profilepicture;
    Timestamp datecreated;
    var uid;

    try {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn
          .signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
          .authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(
          credential);
      final User user = authResult.user;

      if (user.metadata.creationTime == Timestamp.now().toDate()) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);

        print('signInWithGoogle succeeded: $user');

        assert(user.email != null);
        assert(user.displayName != null);
        assert(user.photoURL != null);

        // Store the retrieved data
        name = user.displayName;
        email = user.email;
        imageUrl = user.photoURL;
        uid = user.uid;
        datecreated = Timestamp.now();

        // Only taking the first part of the name, i.e., First Name
        if (name.contains(" ")) {
          name = name.substring(0, name.indexOf(" "));
        }

      // if (user != null) {

          _currentUser = UserType(
            uid: authResult.user.uid,
            name: name,
            email: email,
            datecreated: Timestamp.now(),
            profilepicture: imageUrl,
          );
          await DatabaseService(uid: authResult.user.uid).createUser(
              _currentUser);
          return '${authResult.user}';
        }
      // }

    }
    catch (error) {
      print(error.toString());
      return null;
    }
  }



// sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }

}