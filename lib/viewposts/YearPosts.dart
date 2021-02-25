import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class YearPosts extends StatefulWidget {
  @override
  _YearPostsState createState() => _YearPostsState();
}



class _YearPostsState extends State<YearPosts> {



  @override
  Widget build(BuildContext context) {

    var useruid = FirebaseAuth.instance.currentUser.uid;
    final postref = FirebaseFirestore.instance.collection('users').doc(useruid).collection('posts');

    final view = postref.where('year' , isEqualTo: '2021');

    // final docRef = postref.where('year');
    



    return Scaffold(
      appBar: AppBar(
        title: new Text("View Posts By Year"),),

      body: StreamBuilder(
          stream: view.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return ListView.builder(
                itemCount: snapshot.hasData?snapshot.data.docs.length: 0,
                itemBuilder: (BuildContext context, int index) {

                  DocumentSnapshot post = snapshot.data.docs[index];

                    // if (docRef!=null) {
                    //  print('yup');
                    //  // return RaisedButton(onPressed: null);
                    // // } else {
                    // //   print ('nope');
                    // // }

                  return SingleChildScrollView(
                      child: Column(
                        children: [

                            Card(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    150, 20, 150, 20),
                                child: Text(post.data()['year']),),
                            ),

                        ],
                      ),
                  );


    // } else if (docRef=='2021') {
    // print ('nope');
    // }
                // }





            });

          },
      ),





    );
  }
}
