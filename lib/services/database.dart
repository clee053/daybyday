import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybyday/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });
  //match to uid

  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');

  Future createUser(UserType user) async{
    try{
      await _userCollection.doc(user.uid).set(user.toJson());
    } catch(e){
      return e.message;
    }

  }

//get usercollection stream
Stream<QuerySnapshot> get usercollection {
  return _userCollection.snapshots();
// snapshot of the data that moment in time when returned to the app
}
}