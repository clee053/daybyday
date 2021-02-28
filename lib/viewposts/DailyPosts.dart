import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybyday/mainpages/AllPosts.dart';
import 'package:daybyday/navigation/NavigationBar.dart';
import 'package:daybyday/postpages/EditPost.dart';
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

    var useruid = FirebaseAuth.instance.currentUser.uid;
    final postref = FirebaseFirestore.instance.collection('users').doc(useruid).collection('posts');

    final view = postref.orderBy('actualdate', descending: true);

    // final docRef = postref.where('year');


    return Scaffold(
      appBar: AppBar(
        title: new Text("View Posts By Date"),

        actions: [

          FlatButton(onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  NavigationBar()),
            );
          }, child: Text('Back',
            style: TextStyle(
                color: Colors.white
            ),),
          ),
        ],


      ),

      body: StreamBuilder(
        stream: view.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(
              itemCount: snapshot.hasData?snapshot.data.docs.length: 0,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot post = snapshot.data.docs[index];
                DateTime myDateTime = (snapshot.data.docs[index].data()['actualdate']).toDate();

                return SingleChildScrollView(
                  child: Column(
                    children: [

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              settings: RouteSettings(name: "/screen3"),
                              builder: (_)=>OpenPost(docToOpen: snapshot.data.docs[index],)));
                        },

                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                150, 20, 150, 20),
                            child: Text(DateFormat.yMMMd().format(myDateTime)),),
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
