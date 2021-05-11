
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybyday/postpages/AddDetailPost.dart';
import 'package:daybyday/postpages/AddNewPostPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:daybyday/services/auth.dart';
import 'package:intl/intl.dart';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
//
// //get the file name of the image selected from the gallery, so there will be unique names when stored in firestore
// import 'package:path/path.dart';






class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();


//  final FirebaseAuth _auth = FirebaseAuth.instance;
//  User user;
//  bool isloggedin = false;
//
//  checkAuthentification() async{
//    _auth.authStateChanges().listen((user)
//    {
//      if(user == null)
//      {
//        Navigator.push(context, MaterialPageRoute(builder: (context) => StartPage()));
//      }
//    });
//  }
//
//  signOut()async{
//
//    _auth.signOut();
//  }
//
//  getUser() async{
//    User firebaseUser =  _auth.currentUser;
//    await firebaseUser?.reload();
//    firebaseUser =  _auth.currentUser;
//
//    if (firebaseUser !=null)
//    {
//      setState(() {
//        this.user = firebaseUser;
//        this.isloggedin = true;
//      });
//    }
//  }
//
//  @override
//  void initState()
//  {
//    super.initState();
//    this.checkAuthentification();
//    this.getUser();
//  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    DateTime now = new DateTime.now();
    final DateFormat formatterdate = DateFormat('yMMMMd');
    final DateFormat formattertime = DateFormat('jm');
    final String formatdate = formatterdate.format(now);
    final String formattime = formattertime.format(now);


    var useruid = FirebaseAuth.instance.currentUser.uid;
    final userref = FirebaseFirestore.instance.collection('users').doc(useruid);


    return StreamBuilder(
        stream: userref.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {return const Text("Loading...");}
          var user = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: new Text("Home"),
            ),

            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Container(
                      color: Colors.pink[50],
                      width: width,
                      height: height*0.55,
                      child: Center(
                        child: Column(

                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            SizedBox(
                              height: 10.0,
                            ),

                            (user['profilepicture'] != null)
                                ? CircleAvatar(
                              radius: height*0.15,
                              backgroundImage: NetworkImage('${user['profilepicture']}'),
                            )
                                : CircleAvatar(
                              radius: height*0.15,
                              backgroundImage: AssetImage('assets/faces/happy.png'),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
//
                            Text(
                              "Hi ${user['name']}!",
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "$formatdate \n $formattime",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22.0
                              ),
                            ),


                          ],
                        ),
                      ),
                    ),

                  ),
                  Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 30.0,
                          ),
                          ButtonTheme(
                            minWidth: 300.0,
                            height: 50.0,
                            buttonColor: Colors.blue[50],
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      AddNewPostPage()),
                                );
                              },
                              child: Text('Add Quick Post',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),

                          ButtonTheme(
                            minWidth: 300.0,
                            height: 50.0,
                            buttonColor: Colors.blue[50],
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      AddDetailPost()),
                                );
                              },
                              child: Text('Add Detailed Post',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          ButtonTheme(
                            minWidth: 300.0,
                            height: 50.0,
                            buttonColor: Colors.blue[50],
                            child: RaisedButton(
                              onPressed: () async {
                                await _auth.signOut();
                              },
                              child: Text('Sign Out',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 30.0,
                          ),


                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );
        },
      );

  }
}

