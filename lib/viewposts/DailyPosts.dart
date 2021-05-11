import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:daybyday/models/post.dart';
import 'package:daybyday/navigation/NavigationBar.dart';

import 'package:daybyday/postpages/OpenPost.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyPosts extends StatefulWidget {
  @override
  _DailyPostsState createState() => _DailyPostsState();
}

class _DailyPostsState extends State<DailyPosts> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;

    var useruid = FirebaseAuth.instance.currentUser.uid;
    final postref = FirebaseFirestore.instance.collection('users')
        .doc(useruid)
        .collection('posts');

    var now = new DateTime.now();
    var today = DateFormat.yMMMd().format(now).toString();
    final view = postref.where('searchdate', isEqualTo: today);


    return Scaffold(
      appBar: AppBar(
        title: new Text("Today"),

        actions: [

          FlatButton(onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  NavigationBar()),
            );
          }, child: Text('Back to Home',
            style: TextStyle(
                color: Colors.white
            ),),
          ),
        ],


      ),

      body: StreamBuilder(
        stream: view.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

          return Container(
            height: height,
            child: Column(
              children: [


                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.hasData ? snapshot.data.docs.length : 0,
                      itemBuilder: (BuildContext context, int index) {
                        DateTime myDateTime = (snapshot.data.docs[index]
                            .data()['actualdate']).toDate();

                        return SingleChildScrollView(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                // settings: RouteSettings(name: "/screen3"),
                                  builder: (_) => OpenPost(
                                    docToOpen: snapshot.data.docs[index],)));
                            },

                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20, 20, 20, 20),
                                child: Column(
                                  children: [
                                    Text(DateFormat.yMMMd().format(myDateTime)),
                                  ],
                                ),),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        },
      ),


    );
  }

}
