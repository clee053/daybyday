import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'EditPost.dart';

class OpenPost extends StatefulWidget {

  DocumentSnapshot docToOpen;
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

    String _setDate;
    // var useruid = FirebaseAuth.instance.currentUser.uid;
    // final ref = FirebaseFirestore.instance.collection('users').doc(useruid).collection('posts');
    return Scaffold(
      appBar: AppBar(

        title: new Text("${title.text}"),

        actions: [

          FlatButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>EditPost(docToEdit: widget.docToOpen,)));
          }, child: Text('Edit')),

          FlatButton(onPressed: (){
            widget.docToOpen.reference.delete().whenComplete(() => Navigator.pop(context));
          }, child: Text('Delete')),
        ],

      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Container(
              child: Container(
                margin: EdgeInsets.all(10),
                width: double.infinity,
                height: 700.0,

                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                    // crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    if (image.text !=null) Container(
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
      ),
    );
  }
}








