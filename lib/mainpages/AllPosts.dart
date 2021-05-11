
import 'package:daybyday/postpages/AddDetailPost.dart';
import 'package:daybyday/postpages/OpenPost.dart';
import 'package:daybyday/viewposts/DailyPosts.dart';
import 'package:daybyday/viewposts/MonthPosts.dart';
import 'package:daybyday/viewposts/SearchPosts.dart';
import 'package:daybyday/viewposts/YearPosts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';



class AllPosts extends StatefulWidget {
  @override
  _AllPostsState createState() => _AllPostsState();


}

class _AllPostsState extends State<AllPosts> {

  Map<dynamic, dynamic> posts;
  List Colours = [Colors.red[50], Colors.green[50], Colors.yellow[50], Colors.blue[50], Colors.deepPurple[50], Colors.pinkAccent[50], Colors.deepOrangeAccent[50]];


  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var useruid = FirebaseAuth.instance.currentUser.uid;
    final postref = FirebaseFirestore.instance.collection('users').doc(useruid).collection('posts');

    final view = postref.orderBy("actualdate",
        descending: true);


        return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: new Text("Posts"),

            actions: [
                PopupMenuButton(
                  itemBuilder: (BuildContext bc) => [
                    PopupMenuItem(child: Text("Search Posts"), value: "searchposts"),
                    PopupMenuItem(
                        child: Text("Today's Posts"), value: "dailyposts"),
                    PopupMenuItem(child: Text("This Month's Posts"), value: "thismonth"),
                    PopupMenuItem(child: Text("This Year's Posts"), value: "thisyear"),
                  ],
                  onSelected: (choice) => choiceAction(choice, context),
                ),


            ],),

            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=> AddDetailPost()));
              },
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
                              itemCount: snapshot.hasData?snapshot.data.docs.length: 0,
//              show all posts. if there are no posts, it will show 0
                            itemBuilder: ( context, index) {
                              DateTime myDateTime = (snapshot.data.docs[index]
                                  .data()['actualdate'])
                                  .toDate();

                              var image = snapshot.data.docs[index]
                                  .data()['postimage'];
                              if (image.isNotEmpty) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (_) =>
                                            OpenPost(docToOpen: snapshot.data.docs[index],)));
                                  },


                                  child: Container(
                                    margin: EdgeInsets.all(15),
                                    width: 300,
                                    height: 400,

                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            snapshot.data.docs[index]
                                                .data()['postimage']),
                                        fit: BoxFit.cover,
                                        colorFilter:
                                        ColorFilter.mode(
                                            Colors.black.withOpacity(0.5),
                                            BlendMode.dstATop),
                                      ),

                                    ),


                                    child: SingleChildScrollView(
                                      child: Column(

                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.baseline,
                                            children: [
                                              Flexible(
                                                // fit: FlexFit.loose,
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                                                  child: Text(
                                                    snapshot.data.docs[index]
                                                        .data()['title'],
                                                    style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 25.0,
                                                    ),),),
                                              ),
                                              Flexible(
                                                // fit: FlexFit.loose,
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                                                  child: Text(
                                                    DateFormat.yMMMd().format(
                                                        myDateTime),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 15.0,
                                                    ),),),
                                              ),

                                            ],
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                            child: Text(
                                                snapshot.data.docs[index]
                                                    .data()['content']),),

                                        ],
                                      ),
                                    ),
                                  ),

                                );
                              }
                             else
                               return GestureDetector(
                                 onTap: (){
                                   Navigator.push(context, MaterialPageRoute(
                                     // settings: RouteSettings(name: "/screen3"),

                                       builder: (_)=>OpenPost(docToOpen: snapshot.data.docs[index],)));
                                 },


                                 child: Container(
                                   margin: EdgeInsets.all(15),
                                   width: 300,
                                   // color: Colours[index],


                                   decoration: BoxDecoration(

                                     image: DecorationImage(
                                       image: AssetImage('assets/blue.png'),
                                       fit: BoxFit.cover,
                                       // colorFilter:
                                       // ColorFilter.mode(Colors.black.withOpacity(0.6),
                                       //     BlendMode.dstATop),
                                     ),
                                   ),



                                   child: SingleChildScrollView(
                                     child: Column(


                                       children: [
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           crossAxisAlignment: CrossAxisAlignment.baseline,
                                           children: [
                                             Flexible(
                                               fit: FlexFit.loose,
                                               child: Padding(
                                                 padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                                                 child: Text(snapshot.data.docs[index].data()['title'],
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 25.0,
                                                   ),),),
                                             ),
                                             Flexible(
                                               fit: FlexFit.loose,
                                               child: Padding(
                                                 padding: const EdgeInsets.all(10),
                                                 child: Text(DateFormat.yMMMd().format(myDateTime),
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 15.0,
                                                   ),),),
                                             ),

                                           ],
                                         ),

                                       ],
                                     ),
                                   ),
                                 ),

                               );

                      }),
                        ),
                      ],
                    ),


                  );





              }
            )
        );
  }

  choiceAction(choice, BuildContext context) {

      if (choice == "searchposts") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPosts()),
        );
      }
      if (choice == "dailyposts") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DailyPosts()),
        );
      }
      if (choice == "thismonth") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MonthPosts()),
        );
      }

      if (choice == "thisyear") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => YearPosts()),
        );
      }

  }

}