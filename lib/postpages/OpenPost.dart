
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'EditPost.dart';

class OpenPost extends StatefulWidget {

  DocumentSnapshot docToOpen;
  OpenPost({this.docToOpen});
  // This leads from the document (post) selected in the list of posts view



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
    date.text = DateFormat.yMMMMd().format(widget.docToOpen.data()['actualdate'].toDate());
    super.initState();
  }

  Future<Null> saveAndShare() async {
    final RenderBox box = context.findRenderObject();

    if (image.text.isNotEmpty) {
    if (Platform.isAndroid) {
      var url = image.text;
      var response = await get(url);
      final documentDirectory = (await getExternalStorageDirectory()).path;
      File imgFile = new File('$documentDirectory/${title.text}.png');
      imgFile.writeAsBytesSync(response.bodyBytes);


        Share.shareFiles(['$documentDirectory/${title.text}.png'],
            text: (content.text != null ? content.text : title.text),
            subject: (title.text != null ? title.text : 'Insert subject'),
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      }
  }

    else if (image.text.isEmpty && content.text.isEmpty) {
        Share.share(
            title.text,
            subject: title.text,
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      }

    else if (image.text.isEmpty && title.text.isEmpty) {
      Share.share(
          content.text,
          subject: content.text,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }

    else {
      Share.share(
          title.text + content.text,
          subject: title.text,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }

    }

  Future<Null> saveAndShareIOS() async {
    final RenderBox box = context.findRenderObject();

    if (content.text.isEmpty) {
    Share.share(
        title.text,
        subject: title.text,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  else if (title.text.isEmpty) {
    Share.share(
        content.text,
        subject: content.text,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  else {
    Share.share(
        title.text + content.text,
        subject: title.text,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  }



  @override
  Widget build(BuildContext context) {

    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery.of(context).size.width;

    var useruid = FirebaseAuth.instance.currentUser.uid;
    final postref = FirebaseFirestore.instance.collection('users').doc(useruid).collection('posts');

    String _setDate;

    return Scaffold(

      appBar: AppBar(



        title: new Text(title.text),

        actions: [

          FlatButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>EditPost(docToEdit: widget.docToOpen,)));
          }, child: Text('Edit',
            style: TextStyle(
             color: Colors.white
            ), ),
          ),

          FlatButton(onPressed: (){

            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Delete post?'),
                    content: Text(
                        'This post will be deleted permanently.'
                    ),

                    actions: <Widget>[
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          setState(() {

                            Navigator.pop(context);

                          });
                        },
                      ),
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () async {
                          widget.docToOpen.reference.delete().whenComplete(() => Navigator.pop(context));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );



                });

          }, child: Text('Delete',
            style: TextStyle(
                color: Colors.white
            ),),
          ),

          if (Platform.isAndroid)
            PopupMenuButton(
            itemBuilder: (BuildContext bc) => [
              PopupMenuItem(child: Text("Share Post"), value: "sharepost"),
              if (image.text.isNotEmpty)
              PopupMenuItem(
                  child: Text("Download Image"), value: "downloadimage"),
            ],
            onSelected: (choice) => choiceAction(choice, context),
          )
          else
            //iOS
            PopupMenuButton(
              itemBuilder: (BuildContext bc) => [
                if (content.text.isNotEmpty || title.text.isNotEmpty && image.text.isEmpty)
                PopupMenuItem(child: Text("Share Post"), value: "sharepostios"),
                if (image.text.isNotEmpty)
                  PopupMenuItem(
                      child: Text("Download Image"), value: "downloadimage"),
              ],
              onSelected: (choice) => choiceAction(choice, context),
            ),



        ],

      ),

      body: StreamBuilder(
        stream: postref.snapshots(includeMetadataChanges: true),
        builder: (context, snapshot) {
          return Column(
            children: <Widget>[

              Container(
                child: Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,


                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[


                        Card(
                          color: Colors.white70,
                            child: SizedBox(
                            width: double.infinity,

                            height: height*0.8,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [
                                      if (image.text.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                          width: double.infinity,
                                          height: 400,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(image.text),
                                              fit: BoxFit.contain,

                                            ),
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
          );
        }
      ),
    );
  }

  choiceAction(choice, BuildContext context) {

    if (choice == "sharepost") {

      saveAndShare();
    }
    if (choice == "downloadimage") {
      try {
        // Saved with this method.
        var imageId =  ImageDownloader.downloadImage(image.text);
        if (imageId == null) {
          return;
        }
        showFlash(
          context: context,
          duration: const Duration(seconds: 5),
          builder: (context, controller) {
            return Flash(
              controller: controller,
              style: FlashStyle.floating,
              backgroundColor: Colors.pink[50],
              position: FlashPosition.top,
              boxShadows: kElevationToShadow[4],
              horizontalDismissDirection: HorizontalDismissDirection.horizontal,
              child: FlashBar(
                message: Text('Image saved!'),
                primaryAction: TextButton(
                  onPressed: () => controller.dismiss(),
                  child: Text('Dismiss'),
                ),
              ),
            );
          },
        );
      } on PlatformException catch (error) {
        print(error);
      }
    }

    if (choice == "sharepostios") {

      saveAndShareIOS();
    }


}

}








