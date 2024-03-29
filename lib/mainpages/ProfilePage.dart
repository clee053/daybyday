import 'dart:io';

import 'package:daybyday/postpages/ViewPosts.dart';
import 'package:daybyday/services/auth.dart';
import 'package:daybyday/shared/loading.dart';
import 'package:daybyday/startpages/CreateAccount.dart';


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';




class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final AuthService _auth = AuthService();
  String imageUrl;
  String useremail;

  navigateToCreateAccount()async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateAccount()));
  }


  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var useruid = FirebaseAuth.instance.currentUser.uid;
    final userref = FirebaseFirestore.instance.collection('users').doc(useruid);

    TextEditingController name = TextEditingController();
    TextEditingController status = TextEditingController();

    Future<void> changeName(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Change Name'),
              content: TextField(
                controller: name,
                decoration: InputDecoration(hintText: "What is your new name?"),
              ),

              actions: <Widget>[
                FlatButton(
                  // color: Colors.blue[50],
                  // textColor: Colors.white,
                  child: Text('Cancel'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                FlatButton(
                  // color: Colors.blue,
                  // textColor: Colors.white,
                  child: Text('Save'),
                  onPressed: () async {
                      await FirebaseFirestore.instance.collection('users').doc(useruid)
                          .update({'name': name.text}).whenComplete(() => Navigator.pop(context));
                  },
                ),
              ],
            );



          });
    }

    Future<void> updateStatus(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Update Status'),
              content: TextField(
                controller: status,
                decoration: InputDecoration(hintText: "What is your new status?"),
              ),

              actions: <Widget>[
                FlatButton(
                  // color: Colors.blue[50],
                  // textColor: Colors.white,
                  child: Text('Cancel'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                FlatButton(
                  // color: Colors.blue,
                  // textColor: Colors.white,
                  child: Text('Save'),
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('users').doc(useruid)
                        .update({'status': status.text}).whenComplete(() => Navigator.pop(context));
                  },
                ),
              ],
            );



          });
    }

    return StreamBuilder(
        stream: userref.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
          return Loading();
          }
          var user = snapshot.data;
          DateTime userDateCreated = user['datecreated'].toDate();
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: new Text("Profile"),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Container(
                  //
                  //     width: width,
                  //     height: 50.0,
                  //
                  //
                  //     child: Center(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: <Widget>[
                  //           SizedBox(width: 20),
                  //
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: <Widget>[
                  //               SizedBox(width: 280),
                  //               TextButton(
                  //                 onPressed: () {
                  //                   Navigator.push(context,
                  //                     MaterialPageRoute(
                  //                         builder: (context) => SettingPage()),
                  //                   );
                  //                 },
                  //                 child: Icon(Icons.settings,
                  //                   size: 30.0,
                  //                   color: Colors.black45,
                  //
                  //                 ),
                  //               ),
                  //               SizedBox(width: 10),
                  //             ],
                  //           ),
                  //
                  //
                  //         ],
                  //
                  //       ),
                  //     ),
                  // ),

                  Container(
                      width: width,
                      height: height*1.5,

                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            SizedBox(height: 20),

                            (user['profilepicture'] != null)
                                ? CircleAvatar(
                              radius: 75,
                              backgroundImage: NetworkImage('${user['profilepicture']}'),
                            )
                                : CircleAvatar(
                              radius: 75,
                              backgroundImage: AssetImage('assets/faces/happy.png'),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: width*0.8,
                              child: Text(
                                "${user['name']}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            SizedBox(height: 20),
                            Text(
                              "Joined: ${DateFormat.yMMMd().format(userDateCreated)}",

                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20.0,
                                fontStyle: FontStyle.italic,
                              ),
                            ),

                            SizedBox(
                              height: 20.0,
                            ),
                            (user['status'] != null)
                                ? Container(
                              width: width*0.8,
                                  child: Text(
                              '"${user['status']}"',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                    fontSize: 25.0
                              ),
                            ),
                                )
                                : Container(
                                  width: width*0.8,
                                  child: Text(
                              '"Update your status!"',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                    fontSize: 25.0
                              ),
                            ),
                                ),

                            SizedBox(
                              height: 30.0,
                            ),

                            ButtonTheme(
                              minWidth: width*0.8,
                              height: 50.0,
                              buttonColor: Colors.blue[50],
                              child: RaisedButton(
                                onPressed: ()
                                => uploadProfilePicture(),
                                child: Text('Change Profile Picture',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,

                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            ButtonTheme(
                              minWidth: width*0.8,
                              height: 50.0,
                              buttonColor: Colors.blue[50],
                              child: RaisedButton(
                                onPressed: ()  {
                                  changeName(context);

                                },
                                child: Text('Change Name',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,

                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),

                            (user['email'] == null)

                                ?ButtonTheme(
                              minWidth: width*0.8,
                              height: 50.0,
                              buttonColor: Colors.blue[50],
                              child: RaisedButton(
                                onPressed: ()  {
                                  return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Create a new account?'),
                                          content: Text(
                                              'You can save your posts and sign back in any time!'
                                          ),

                                          actions: <Widget>[
                                            FlatButton(
                                              // color: Colors.blue[50],
                                              // textColor: Colors.white,
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.pop(context);
                                                });
                                              },
                                            ),
                                            FlatButton(
                                              // color: Colors.blue,
                                              // textColor: Colors.white,
                                              child: Text('Yes'),
                                              onPressed: () async {
                                                navigateToCreateAccount();
                                              },
                                            ),
                                          ],
                                        );



                                      });
                                  // resetPassword(context);
                                },
                                child: Text('Create Account',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,

                                  ),
                                ),
                              ),
                            )



                                : ButtonTheme(
                              minWidth: width*0.8,
                              height: 50.0,
                              buttonColor: Colors.blue[50],
                              child: RaisedButton(
                                onPressed: ()  {
                                  return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Confirm Password Reset?'),
                                          content: Text(
                                              'The password reset link will be emailed to you at ${user['email']}.'
                                          ),

                                          actions: <Widget>[
                                            FlatButton(
                                              // color: Colors.blue[50],
                                              // textColor: Colors.white,
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.pop(context);
                                                });
                                              },
                                            ),
                                            FlatButton(
                                              // color: Colors.blue,
                                              // textColor: Colors.white,
                                              child: Text('Yes'),
                                              onPressed: () async {
                                                try {
                                                  final _auth = FirebaseAuth.instance;
                                                  await _auth.sendPasswordResetEmail(email: user['email']);
                                                  Navigator.pop(context);

                                                  return showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                              'The password reset link has been sent to your email.'
                                                          ),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              // color: Colors.blue[50],
                                                              // textColor: Colors.white,
                                                              child: Text('Ok!'),
                                                              onPressed: () {
                                                                setState(() {
                                                                  Navigator.pop(context);
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        );

                                                      });

                                                } catch (error) {
                                                  print(error.toString());
                                                  return null;
                                                }
                                              },
                                            ),
                                          ],
                                        );



                                      });
                                  // resetPassword(context);
                                },
                                child: Text('Change Password',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,

                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),

                            ButtonTheme(
                              minWidth: width*0.8,
                              height: 50.0,
                              buttonColor: Colors.blue[50],
                              child: RaisedButton(
                                onPressed: () {
                                  updateStatus(context);
                                },
                                child: Text('Change Status',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),

                            ButtonTheme(
                              minWidth: width*0.8,
                              height: 50.0,
                              buttonColor: Colors.blue[50],
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(
                                        settings: RouteSettings(name: "/screen2"),
                                        builder: (context) => ViewPosts()),
                                  );
                                },
                                child: Text('View Recent Posts',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),

                            ButtonTheme(
                              minWidth: width*0.8,
                              height: 50.0,
                              buttonColor: Colors.blue[50],
                              child: RaisedButton(
                                onPressed: () async {
                                  await _auth.signOut();
                                },
                                child: Text('Sign Out',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ),
                            ),







                          ],

                        ),
                      ),

                  ),



                ],
              ),
            ),
          );
        },
    );
  }


uploadProfilePicture() async{
  var useruid = FirebaseAuth.instance.currentUser.uid;
  final _picker = ImagePicker();
  final _storage = FirebaseStorage.instance;
  PickedFile image;


  //Check Permission
  await Permission.photos.request();
  var permissionStatus = await Permission.photos.status;
  if (permissionStatus.isGranted) {
    //Select Image
   image = await _picker.getImage(source: ImageSource.gallery);
    var fileUpload = File(image.path);


   File croppedFile = await ImageCropper.cropImage(
       sourcePath: fileUpload.path,
       aspectRatioPresets: Platform.isAndroid
           ? [
         CropAspectRatioPreset.square,
       ]
           : [
             CropAspectRatioPreset.square,

       ],
       androidUiSettings: AndroidUiSettings(
           toolbarTitle: 'Cropper',
           toolbarColor: Colors.blue,
           toolbarWidgetColor: Colors.white,
           initAspectRatio: CropAspectRatioPreset.square,
           lockAspectRatio: false),
       iosUiSettings: IOSUiSettings(
         title: 'Cropper',
       ));


   setState(() {
     fileUpload = croppedFile;
   });

    if (fileUpload != null) {
      //Upload to Firebase
      var snapshot = await _storage.ref()
          .child('$useruid/${DateTime.now()}')
          .putFile(fileUpload);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(useruid)
          .update({'profilepicture': downloadUrl});

      setState(() {
        imageUrl = downloadUrl;
      });

    } else {
      print('No Path Received');
    }
  }
    else {
      print('Grant Permissions in settings and try again');
  }


}


}