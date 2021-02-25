
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybyday/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:daybyday/models/user.dart';

class AuthService {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserType _currentUser;
  UserType get currentUser => _currentUser;
  
//   create user obj based on firebase user
  UserType _userFromFirebaseUser(User user) {
    return user != null ? UserType(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<UserType> get user {
    return _auth.authStateChanges()
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // // GET UID
  // Future<String> getCurrentUID() async {
  //   return (await _auth.currentUser).uid;
  // }
  //
  // // GET CURRENT USER
  // Future getCurrentUser() async {
  //   return await _auth.currentUser;
  // }
  //



  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      // User user = result.user;
      // return _userFromFirebaseUser(user);

      _currentUser = UserType(
        uid: result.user.uid,
        email: 'email',
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

// log in with email and password

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
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

      // get the user back with uid from firebase

//      await DatabaseService(uid: user.uid).updateUserData('new user', 100);
      // passing in dummy data for the new user as a set up

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