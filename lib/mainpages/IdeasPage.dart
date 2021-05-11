import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybyday/OpenIdeas.dart';
import 'package:daybyday/services/auth.dart';

import 'package:flutter/material.dart';

class IdeasPage extends StatefulWidget {
  @override
  _IdeasPageState createState() => _IdeasPageState();
}

class _IdeasPageState extends State<IdeasPage> {


  // final List<Color> Colours = <Color>[Colors.red[50], Colors.green[50], Colors.yellow[50], Colors.blue[50], Colors.deepPurple[50], Colors.pinkAccent[50], Colors.deepOrangeAccent[50]];


  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {


    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;


    final ideasref = FirebaseFirestore.instance.collection('ideas');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: new Text("Ideas"),
      ),

      body: StreamBuilder(
        stream: ideasref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(itemCount: snapshot.hasData?snapshot.data.docs.length: 0,
//                          show all posts. if there are no posts, it will show 0
                      itemBuilder: (_, index) {


                        return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                            // settings: RouteSettings(name: "/screen3"),
                                  builder: (_)=>OpenIdeas(ideaToOpen: snapshot.data.docs[index],)));
                            },

                            child: Container(
                              margin: EdgeInsets.all(10),
                              height: 150,
                              child: Card(

                                color: Colors.blue[50],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      child: Text(
                                          snapshot.data.docs[index].data()['Title'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25.0,
                                        ),

                                      ),
                                    ),

                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        child: Text(snapshot.data.docs[index].data()['Main'],
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 15.0,
                                          ),),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),



                        );

                      });
        },
      ),




    );
  }
}
