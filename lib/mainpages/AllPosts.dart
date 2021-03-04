
import 'package:daybyday/postpages/OpenPost.dart';
import 'package:daybyday/viewposts/DailyPosts.dart';
import 'package:daybyday/viewposts/MonthPosts.dart';
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


  // yearData() {
  //   var useruid = FirebaseAuth.instance.currentUser.uid;
  //   CollectionReference collectionReference = FirebaseFirestore.instance.collection('users').doc(useruid).collection('posts');
  //   collectionReference.snapshots().listen((snapshot) {
  //
  //     setState(() {
  //       posts = snapshot.docs;
  //
  //     });
  //   });
  // }






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
              title: new Text("View Posts"),),



            body: StreamBuilder(
                stream: view.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  return Container(
                    height: height,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: ButtonTheme(
                                      minWidth: width,
                                      height: 50.0,
                                      buttonColor: Colors.blue[50],
                                      child: RaisedButton(
                                        onPressed: () {

                                          Navigator.push(context,
                                            MaterialPageRoute(
                                                // settings: RouteSettings(name: "/screen2"),
                                                builder: (context) => MonthPosts()),
                                          );

                                        },
                                        child: Text('Daily Posts',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,

                                          ),
                                        ),
                                      ),
                          ),
                        ),



                        Expanded(
                          child: ListView.builder(   itemCount: snapshot.hasData?snapshot.data.docs.length: 0,
//              show all posts. if there are no posts, it will show 0
                            itemBuilder: (_, index) {
                              DateTime myDateTime = (snapshot.data.docs[index].data()['actualdate'])
                                  .toDate();

                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      // settings: RouteSettings(name: "/screen3"),

                                      builder: (_)=>OpenPost(docToOpen: snapshot.data.docs[index],)));
                                },


                                child: Container(
                                  margin: EdgeInsets.all(15),
                                  width: 300,
                                  height: 400,

                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: snapshot.data.docs[index].data()['postimage'] != null ? NetworkImage(snapshot.data.docs[index].data()['postimage']) : AssetImage('assets/background.png'),
                                      fit: BoxFit.cover,
                                      colorFilter:
                                      ColorFilter.mode(Colors.black.withOpacity(0.5),
                                          BlendMode.dstATop),
                                    ),
                                  ),


                                  child: SingleChildScrollView(
                                    child: Column(

                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Padding(
                                                padding: const EdgeInsets.all(20),
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

                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(20,10,20,10),
                                          child: Text(snapshot.data.docs[index].data()['content']),),

                                        // if (snapshot.data.docs[index].data()['postimage'] != null)
                                        //   Image.network(
                                        //     snapshot.data.docs[index].data()['postimage']),
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








                // return Container(
                //   width: width,
                //   height: height,
                //
                //         child: ListView.builder(
                //           child: Padding(
                //             padding: const EdgeInsets.all(10.0),
                //             child: ButtonTheme(
                //               minWidth: width,
                //               height: 50.0,
                //               buttonColor: Colors.blue[50],
                //               child: RaisedButton(
                //                 onPressed: () {
                //
                //                   Navigator.push(context,
                //                     MaterialPageRoute(
                //                         settings: RouteSettings(name: "/screen1"),
                //                         builder: (context) => DailyPosts()),
                //                   );
                //
                //                 },
                //                 child: Text('Daily Posts',
                //                   style: TextStyle(
                //                     fontSize: 20.0,
                //                     fontWeight: FontWeight.bold,
                //
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),



                  // );



              }
            )
        );
  }

}