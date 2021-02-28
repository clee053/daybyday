import 'package:daybyday/postpages/ViewPosts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'EditPost.dart';

class OpenPost extends StatefulWidget {



  DocumentSnapshot docToOpen;
  // This leads from the document (post) selected in the list of posts view
  OpenPost({this.docToOpen});


  @override
  _OpenPostState createState() => _OpenPostState();
}

class _OpenPostState extends State<OpenPost> {

  final maxLines = 5;

  TextEditingController date = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController image = TextEditingController();
  DateTime selectedDate = DateTime.now();


  @override
  void initState(){
    title = TextEditingController(text: widget.docToOpen.data()['title']);
    content = TextEditingController(text: widget.docToOpen.data()['content']);
    image = TextEditingController(text: widget.docToOpen.data()['postimage']);
    date.text = DateFormat.yMMMd().format(widget.docToOpen.data()['actualdate'].toDate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var useruid = FirebaseAuth.instance.currentUser.uid;
    final postref = FirebaseFirestore.instance.collection('users').doc(useruid).collection('posts');

    String _setDate;

    return Scaffold(

      appBar: AppBar(



        title: new Text(title.text),

        actions: [

          FlatButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(
                settings: RouteSettings(name: "/screen4"),
                builder: (_)=>EditPost(docToEdit: widget.docToOpen,)));
          }, child: Text('Edit',
            style: TextStyle(
             color: Colors.white
            ), ),
          ),

          FlatButton(onPressed: (){
            widget.docToOpen.reference.delete().whenComplete(() => Navigator.pop(context));
          }, child: Text('Delete',
            style: TextStyle(
                color: Colors.white
            ),),
          ),
        ],

      ),

      body: StreamBuilder(
        stream: postref.snapshots(includeMetadataChanges: true),
        builder: (context, snapshot) {
          // var post = docToOpen.data;

        // var currentdocindex = ViewPosts().docindex;

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Container(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    height: 700.0,

                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[


                          Card(
                            color: Colors.white70,
                              child: SizedBox(
                              width: double.infinity,
                              height: 600,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        if (image.text.isNotEmpty)
                                          Container(
                                          width: double.infinity,
                                          height: 400,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(image.text),
                                              fit: BoxFit.contain,

                                            ),
                                          ),
                                        ) else Container(),

                                        SizedBox(
                                          height: 10,
                                        ), //SizedBox

                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text(
                                                  date.text,
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w500,
                                                  ), //Textstyle
                                                ),
                                              ),

                                        SizedBox(
                                          height: 10,
                                        ),



                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text(
                                                  title.text,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ), //Textstyle
                                                ),
                                              ),



                                        SizedBox(
                                          height: 10,
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            content.text,

                                            style: TextStyle(
                                              fontSize: 20,
                                            ), //Textstyle
                                          ),
                                        ),



                                        //Text
                                      ],
                                    ),
                                  ),
                                ),
                          ), ),


                        ],
                      ), ), ), ),


              ],
            ),
          );
        }
      ),
    );
  }
}








