import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybyday/navigation/NavigationBar.dart';
import 'package:daybyday/postpages/OpenPost.dart';
import 'package:daybyday/viewposts/search.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthPosts extends StatefulWidget {
  @override
  _MonthPostsState createState() => _MonthPostsState();
}

class _MonthPostsState extends State<MonthPosts> {

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

    var currentmonth = DateFormat.MMMM().format(now).toString();
    var currentyear = now.year.toString();

    final view = postref.where('month', isEqualTo: currentmonth).where('year', isEqualTo: currentyear).orderBy('actualdate', descending: true);




    return Scaffold(
      appBar: AppBar(
        title: new Text("${currentyear} ${currentmonth} Posts"),

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
                        DocumentSnapshot post = snapshot.data.docs[index];
                        DateTime myDateTime = (snapshot.data.docs[index]
                            .data()['actualdate']).toDate();

                        if (!snapshot.hasData || snapshot.data.docs.isEmpty){
                          return Center(child: Text('No items found'));
                        }

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

