
import 'package:daybyday/viewposts/DailyPosts.dart';
import 'package:daybyday/viewposts/MonthPosts.dart';
import 'package:daybyday/viewposts/YearPosts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AllPosts extends StatefulWidget {
  @override
  _AllPostsState createState() => _AllPostsState();


}

class _AllPostsState extends State<AllPosts> {

  Map<dynamic, dynamic> posts;


  // yearData() {
  //   var useruid = FirebaseAuth.instance.currentUser.uid;
  //   CollectionReference collectionReference = FirebaseFirestore.instance.collection('users').doc(useruid).collection('posts');
  //   collectionReference.snapshots().listen((snapshot) {
  //
  //     setState(() {
  //       posts = snapshot.docs;
  //
  //     });
  //   });
  // }






  @override
  Widget build(BuildContext context) {
    var useruid = FirebaseAuth.instance.currentUser.uid;
    final postref = FirebaseFirestore.instance.collection('users').doc(useruid).collection('posts');

    // final view = postref.orderBy("year",
    //     descending: true);
//  note: changed descending = true (originally false) in the parameter query.dart so that I can use ascending!


    return StreamBuilder(
      stream: postref.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Text("No posts!");
        }

        var posts = snapshot.data;

        return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: new Text("View Posts"),),

            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 500.0,

                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[


                          ButtonTheme(
                            minWidth: 300.0,
                            height: 50.0,
                            buttonColor: Colors.blue[50],
                            child: RaisedButton(
                              onPressed: () {

                                // postref.get().then((QuerySnapshot querySnapshot) => {
                                //   querySnapshot.docs.forEach((doc) {
                                //
                                //     return Card(
                                //         child: Text('${doc["title"]}'));
                                //
                                //   }),
                                //
                                //
                                //
                                // });

                                Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) => YearPosts()),
                                );

                              },
                              child: Text('Year',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          ButtonTheme(
                            minWidth: 300.0,
                            height: 50.0,
                            buttonColor: Colors.blue[50],
                            child: RaisedButton(
                              onPressed: () {

                                // postref.get().then((QuerySnapshot querySnapshot) => {
                                //   querySnapshot.docs.forEach((doc) {
                                //
                                //     return Card(
                                //         child: Text('${doc["title"]}'));
                                //
                                //   }),
                                //
                                //
                                //
                                // });

                                Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) => MonthPosts()),
                                );

                              },
                              child: Text('Month',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          ButtonTheme(
                            minWidth: 300.0,
                            height: 50.0,
                            buttonColor: Colors.blue[50],
                            child: RaisedButton(
                              onPressed: () {

                                // postref.get().then((QuerySnapshot querySnapshot) => {
                                //   querySnapshot.docs.forEach((doc) {
                                //
                                //     return Card(
                                //         child: Text('${doc["title"]}'));
                                //
                                //   }),
                                //
                                //
                                //
                                // });

                                Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) => DailyPosts()),
                                );

                              },
                              child: Text('Daily Posts',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                            ),
                          ),
                          // ActionChip(
                          //     avatar: CircleAvatar(
                          //       backgroundColor: Colors.grey.shade800,
                          //       child: Text('M'),
                          //     ),
                          //     label: Text('Month'),
                          //     onPressed: () {
                          //       print(
                          //           "If you stand for nothing, Burr, what’ll you fall for?");
                          //     }
                          // ),
                          // SizedBox(width: 10),
                          // ActionChip(
                          //     avatar: CircleAvatar(
                          //       backgroundColor: Colors.grey.shade800,
                          //       child: Text('W'),
                          //     ),
                          //     label: Text('Week'),
                          //     onPressed: () {
                          //       print(
                          //           "If you stand for nothing, Burr, what’ll you fall for?");
                          //     }
                          // ),
                        ],
                      ),
                    ),),

                  // Container(
                  //   width: double.infinity,
                  //   height: 50.0,
                  //   child: Center(
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: <Widget>[
                  //         ListView(
                  //     children: documents.map((doc) => Card(
                  //           child: ListTile(
                  //           title: Text(doc['title']),
                  //
                  //         ),
                  //         ))
                  //         .toList()),
                  //       ],
                  //     ),
                  //   ),
                  // ),


                ],
              ),


            )
        );
      },
    );
  }

}