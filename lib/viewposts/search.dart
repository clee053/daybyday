import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var useruid = FirebaseAuth.instance.currentUser.uid;

class SearchService {
  searchByDate(String searchField) {
    return FirebaseFirestore.instance.collection('users').doc(useruid).collection('posts')
        .where('month',
        isEqualTo: searchField.substring(0, 1).toString())
        .get();
  }
}