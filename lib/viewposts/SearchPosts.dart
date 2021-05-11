import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:daybyday/models/post.dart';
import 'package:daybyday/navigation/NavigationBar.dart';

import 'package:daybyday/postpages/OpenPost.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchPosts extends StatefulWidget {
  @override
  _SearchPostsState createState() => _SearchPostsState();
}

class _SearchPostsState extends State<SearchPosts> {
  TextEditingController _searchController = TextEditingController();

  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUsersPastTripsStreamSnapshots();
  }


  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [ ];

    if (_searchController.text != "") {
      for (var tripSnapshot in _allResults) {
        var searchdate = Post
            .fromSnapshot(tripSnapshot)
            .searchdate
            .toLowerCase();
        var title = Post
            .fromSnapshot(tripSnapshot)
            .title
            .toLowerCase();
        if (searchdate.contains(_searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getUsersPastTripsStreamSnapshots() async {
    var useruid = FirebaseAuth.instance.currentUser.uid;
    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(useruid)
        .collection('posts').orderBy('actualdate', descending: true)
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }


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

    final view = postref.orderBy('actualdate', descending: true);

    // final docRef = postref.where('year');


    return Scaffold(
      appBar: AppBar(
        title: new Text("Search Posts"),

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

                Padding(
                  padding: const EdgeInsets.all(10.0),

                  child: TextField(
                    controller: _searchController,
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
                        hintText: 'Search by title, date',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0))),

                  ),
                ),

                SizedBox(height: 10),

                Expanded(
                    child: ListView.builder(
                      itemCount: _resultsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildCard(context, _resultsList[index]);
                      },
                    )

                ),


              ],
            ),
          );
        },
      ),


    );
  }

  buildCard(BuildContext context, DocumentSnapshot document) {
    final post = Post.fromSnapshot(document);
    return new Container(
      child: Card(
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Row(children: <Widget>[
                      Text(
                          "${DateFormat.yMMMd()
                              .format(post.actualdate)
                              .toString()}"),
                      Spacer(),
                    ]),
                  ),
                ),
                SizedBox( width: 20),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Text(
                      post.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OpenPost(docToOpen: document)),
            );
          },
        ),
      ),
    );
  }
}

