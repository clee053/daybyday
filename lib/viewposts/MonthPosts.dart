import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MonthPosts extends StatefulWidget {
  @override
  _MonthPostsState createState() => _MonthPostsState();
}

class _MonthPostsState extends State<MonthPosts> {
  @override
  Widget build(BuildContext context) {

    var useruid = FirebaseAuth.instance.currentUser.uid;
    final postref = FirebaseFirestore.instance.collection('users').doc(useruid).collection('posts');

    final view = postref.orderBy("actualdate",
        descending: true);

    return Scaffold(
      appBar: AppBar(
        title: new Text("View Posts By Month"),),

      body: StreamBuilder(
        stream: view.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(
              itemCount: snapshot.hasData?snapshot.data.docs.length: 0,
              itemBuilder: (BuildContext context, int index) {

                DocumentSnapshot post = snapshot.data.docs[index];

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(150,20,150,20),
                          child: Row(
                              children: <Widget>[
                            Text(post.data()['month'].toString()),

                            Text(post.data()['year'].toString()),
                           ],
                          ),
                        ),
                      ),
                    ],
                  ),


                );

              });

        },
      ),





    );
  }
}
