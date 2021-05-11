import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OpenIdeas extends StatefulWidget {


  DocumentSnapshot ideaToOpen;
  // This leads from the document (post) selected in the list of posts view
  OpenIdeas({this.ideaToOpen});

  @override
  _OpenIdeasState createState() => _OpenIdeasState();
}

class _OpenIdeasState extends State<OpenIdeas> {


  TextEditingController title = TextEditingController();
  TextEditingController main = TextEditingController();
  TextEditingController sub = TextEditingController();
  TextEditingController image = TextEditingController();



  @override
  void initState(){
    title = TextEditingController(text: widget.ideaToOpen.data()['Title']);
    main = TextEditingController(text: widget.ideaToOpen.data()['Main']);
    sub = TextEditingController(text: widget.ideaToOpen.data()['Sub']);
    image = TextEditingController(text: widget.ideaToOpen.data()['Image']);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;

    double width = MediaQuery.of(context).size.width;

    final ideasref = FirebaseFirestore.instance.collection('ideas');

    return Scaffold(

      appBar: AppBar(

        title: new Text(title.text),

      ),

      body: StreamBuilder(
          stream: ideasref.snapshots(),
          builder: (context, snapshot) {

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[

                  Container(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      width: double.infinity,



                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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


                                        SizedBox(
                                          height: 10,
                                        ), //SizedBox

                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            title.text,
                                            style: TextStyle(
                                              fontSize: 25,
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
                                            main.text,
                                            style: TextStyle(
                                              fontSize: 20,
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
                                            sub.text,

                                            style: TextStyle(
                                              fontSize: 20,
                                            ), //Textstyle
                                          ),
                                        ),


                                        SizedBox(
                                          height: 10,
                                        ),

                                        if (image.text.isNotEmpty)
                                        Container(
                                          width: width*0.8,
                                          height: height*0.35,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(image.text),
                                              fit: BoxFit.contain,

                                            ),
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

