import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var useruid = FirebaseAuth.instance.currentUser.uid;
final data = FirebaseFirestore.instance.collection("users").doc(useruid).collection('posts');

class Search {
  searchByDate(String searchField) {
    return data.where('month',
        isEqualTo: searchField.substring(0, 1).toString())
        .get();
  }
}