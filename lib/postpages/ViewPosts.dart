
import 'package:daybyday/postpages/OpenPost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AddNewPostPage.dart';
import 'EditPost.dart';
import 'package:intl/intl.dart';

class ViewPosts extends StatefulWidget {
  // get docindex => null;



  @override
  _ViewPostsState createState() => _ViewPostsState();
}

class _ViewPostsState extends State<ViewPosts> {

  @override
  Widget build(BuildContext context) {

    // var docindex;

    var useruid = FirebaseAuth.instance.currentUser.uid;
    final postref = FirebaseFirestore.instance.collection('users').doc(useruid).collection('posts');

    final view = postref.orderBy("actualdate",
        descending: true);
//  note: changed descending = true (originally false) in the parameter query.dart so that I can use ascending!


    return Scaffold(
      appBar: AppBar(
        title: new Text("View Posts"),),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=> AddNewPostPage()));
        },
      ),
      body: StreamBuilder(
        stream: view.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

          return ListView.builder(
//            child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
                itemCount: snapshot.hasData?snapshot.data.docs.length: 0,
//              show all posts. if there are no posts, it will show 0
                itemBuilder: (_, index){
                  DateTime myDateTime = (snapshot.data.docs[index].data()['actualdate']).toDate();
                  // setState(() {
                  //   docindex = index;
                  // });



              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>OpenPost(docToOpen: snapshot.data.docs[index],)));
                },


                child: Container(
                 margin: EdgeInsets.all(15),
                  width: 300,
                  height: 400,


                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: snapshot.data.docs[index].data()['postimage'] != null ? NetworkImage(snapshot.data.docs[index].data()['postimage']) : AssetImage('assets/somin.png'),
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
                });
//          );
        }
      ),

      
    );
  }
}
