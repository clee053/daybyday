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
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByDate(value).then((QuerySnapshot snapshot) {
        for (int i = 0; i < snapshot.docs.length; ++i) {
          queryResultSet.add(snapshot.docs[i].data());
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['Search'].toLowerCase().contains(value.toLowerCase()) ==  true) {
          if (element['Search'].toLowerCase().indexOf(value.toLowerCase()) ==0) {
            setState(() {
              tempSearchStore.add(element);
            });
          }
        }
        // if (element['Search'].startsWith(capitalizedValue)) {
        //   setState(() {
        //     tempSearchStore.add(element);
        //   });
        // }
      });
    }
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
                      initiateSearch(val);
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
                                      children: tempSearchStore.map((element) {
                                        return buildResultCard(element);
                                      }).toList())
                              ),
                            ),
                            // padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            // primary: false,
                            // shrinkWrap: true,
                            // children: tempSearchStore.map((element) {
                            // return buildResultCard(element);
                            // }).toList()),
                          ),); }),
                ),


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

  Widget buildResultCard(data) {

    DateTime myDateTime = (data['actualdate']).toDate();
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2.0,
        child: Container(
            child: Center(
                child: Text(DateFormat.yMMMd().format(myDateTime),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                )
            )
        )
    );
  }
}
