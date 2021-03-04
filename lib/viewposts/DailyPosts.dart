import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybyday/mainpages/AllPosts.dart';
import 'package:daybyday/navigation/NavigationBar.dart';
import 'package:daybyday/postpages/EditPost.dart';
import 'package:daybyday/postpages/OpenPost.dart';
import 'package:daybyday/viewposts/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyPosts extends StatefulWidget {
  @override
  _DailyPostsState createState() => _DailyPostsState();
}

class _DailyPostsState extends State<DailyPosts> {
  
  
Future getData(String collection) async {
  
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(useruid).collection('posts').get();
  return snapshot.docs;
}

Future queryData (String queryString) async {
  return FirebaseFirestore.instance.collection('users').doc(useruid).collection('posts').where(
    'title', isGreaterThanOrEqualTo: queryString
  ).get();
}


  @override
  Widget build(BuildContext context) {

    

    double height = MediaQuery.of(context).size.height;
    
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
          return Container(
            height: height,
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(10.0),

                  child: TextField(
                    onChanged: (val) {
                      // val.queryData(searchController.text).then ((value){
                      //
                      // })

                    },

                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.arrow_back),
                          iconSize: 20.0,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        contentPadding: EdgeInsets.only(left: 25.0),
                        hintText: 'Search by date',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0))),

                  ),
                ),

                SizedBox(height: 10),




                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.hasData?snapshot.data.docs.length: 0,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot post = snapshot.data.docs[index];
                        DateTime myDateTime = (snapshot.data.docs[index].data()['actualdate']).toDate();

                        return SingleChildScrollView(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                  // settings: RouteSettings(name: "/screen3"),
                                  builder: (_)=>OpenPost(docToOpen: snapshot.data.docs[index],)));
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
