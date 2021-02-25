import 'package:cloud_firestore/cloud_firestore.dart';


class UserType {

  final String uid;
  final String name;
  final String email;
  Timestamp datecreated;
  final String profilepicture;
  final String status;


  UserType({ this.uid, this.name, this.email, this.datecreated, this.profilepicture, this.status});

  UserType.fromData(Map<String, dynamic> data):
      uid = data['id'], name = data['name'], email = data['email'], datecreated = data['datecreated'],
        profilepicture = data['profilepicture'], status = data['status'];

  Map<String, dynamic> toJson(){
    return {
      'uid' : uid,
      'name' : name,
      'email' : email,
      'datecreated' : datecreated,
      'profilepicture' : profilepicture,
      'status' : status

    };
  }

}