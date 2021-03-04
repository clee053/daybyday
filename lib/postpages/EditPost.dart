// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';


import 'package:daybyday/navigation/NavigationBar.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

class EditPost extends StatefulWidget {

  DocumentSnapshot docToEdit;
  EditPost({this.docToEdit});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {

  final maxLines = 5;
  File _imageFile;
  String imageUrl;

  TextEditingController _dateController = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController image = TextEditingController();
  DateTime selectedDate = DateTime.now();



  Future<Null> _pickImageCamera() async {

    await Permission.camera.request();
    var permissionStatus = await Permission.camera.status;
    if (permissionStatus.isGranted) {
      File image = await ImagePicker.pickImage(source: ImageSource.camera);


      setState(() {
        _imageFile = image;
      });
    } else {
      print('Grant Permissions in settings and try again');
    }

  }

  Future<Null> _pickImageGallery() async {
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      File image = await ImagePicker.pickImage(source: ImageSource.gallery);


      setState(() {
        _imageFile = image;
      });


    } else {
      print('Grant Permissions in settings and try again');
    }

  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));


    setState(() {
      _imageFile = croppedFile ?? _imageFile;
      //return cropped otherwise return normal image
    });

  }

  uploadPicture() async {
    var useruid = FirebaseAuth.instance.currentUser.uid;
    final _storage = FirebaseStorage.instance;

    var fileUpload = File(_imageFile.path);

    if (_imageFile != null) {
      //Upload to Firebase
      var snapshot = await _storage.ref()
          .child('$useruid/post/${DateTime.now()}')
          .putFile(fileUpload);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      // await FirebaseFirestore.instance.collection("users").doc(useruid).collection('posts').add({'postimage': downloadUrl});

      setState(() {
        imageUrl = downloadUrl;
        image.text = downloadUrl;
      });
    } else {
      print('No Path Received');
    }
  }



  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }


  @override
  void initState(){
    title = TextEditingController(text: widget.docToEdit.data()['title']);
    content = TextEditingController(text: widget.docToEdit.data()['content']);
    _dateController.text = DateFormat.yMd().format(widget.docToEdit.data()['actualdate'].toDate());
    image = TextEditingController(text: widget.docToEdit.data()['postimage']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var dateformat = new DateTime.now().toString();

    String _setDate;
    // var useruid = FirebaseAuth.instance.currentUser.uid;
    // final ref = FirebaseFirestore.instance.collection('users').doc(useruid).collection('posts');
    return Scaffold(
      appBar: AppBar(

        title: new Text("${title.text}"),

        actions: [
          FlatButton(onPressed: (){

            var dateYear = selectedDate.year.toString();
            var dateMonth = DateFormat.MMMM().format(selectedDate);
            var dateDay = selectedDate.day.toString();
            var actualDate = DateFormat.yMMMd().format(selectedDate);

            widget.docToEdit.reference.update({
              'title': title.text,
              'content': content.text,
              'posttime' : FieldValue.serverTimestamp(),
              'actualdate': selectedDate,
              'year': dateYear,
              'month': dateMonth,
              'day': dateDay,
              'postimage': image.text,
              'searchdate': actualDate,
            }).whenComplete(() => Navigator.pop(context));
            Navigator.pop(context);
            // Navigator.pop(context);
            }, child: Text('Save',
            style: TextStyle(
                color: Colors.white
            ),),
          ),

          FlatButton(onPressed: (){
            widget.docToEdit.reference.delete().whenComplete(() => Navigator.pop(context));
            }, child: Text('Delete',
            style: TextStyle(
                color: Colors.white
            ),),
          ),
        ],

      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Container(
              child: Container(
                margin: EdgeInsets.all(12),
                width: double.infinity,
                height: 150.0,

                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[


                      Text(
                        'Choose Date',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 30),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          child: TextFormField(
                            style: TextStyle(fontSize: 40),
                            textAlign: TextAlign.center,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            controller: _dateController,
                            onSaved: (String val) {
                              _setDate = val;
                            },
                            decoration: InputDecoration(
                                disabledBorder:
                                UnderlineInputBorder(borderSide: BorderSide.none),
                                // labelText: 'Time',
                                contentPadding: EdgeInsets.only(top: 0.0)),
                          ),
                        ),
                      ),
                    ],
                  ), ), ), ),


            Container(
              child: Container(
                width: double.infinity,
                height: 380.0,

                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(12),
                        height: maxLines * 15.0,

                        child: TextField(
                          controller: title,
                          maxLines: maxLines,
//

                          decoration: InputDecoration(
                            fillColor: Colors.grey[300],
                            filled: true,
                            labelText: 'Title',
                            prefixIcon:Icon(Icons.add),
                          ),
//                                  onSaved: (input) => _post = input,


                        ), ),

                      Container(
                        margin: EdgeInsets.all(12),
                        height: maxLines * 50.0,

                        child: TextField(
                          controller: content,
                          maxLines: maxLines*5,
                          decoration: InputDecoration(
                            fillColor: Colors.grey[300],
                            filled: true,
                            labelText: 'What do you want to write?',
                            prefixIcon:Icon(Icons.add),
                          ),
//                                  onSaved: (input) => _post = input,


                        ), ),
                    ],
                  ), ), ), ),


            if (image.text.isNotEmpty) ... [
            Container(
              child: Container(
                margin: EdgeInsets.all(12),
                width: double.infinity,
                height: 1000,

                    child: Center(
                      child: Column (
                        children: [

                            Text(
                              'Edit photo:',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),

                          SizedBox(
                            height: 10,
                          ),

                          Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(image.text),
                                fit: BoxFit.contain,

                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                         
                                RaisedButton.icon(
                                  onPressed: () => _pickImageCamera(),
                                  label: Flexible(
                                    child: Text('Take a photo', overflow: TextOverflow.clip,
                                        ),
                                  ),
                                  icon: Icon(Icons.photo_camera),
                                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10)

                                ),

                              SizedBox(width: 20),

                              Flexible(
                                child: RaisedButton.icon(
                                  onPressed: () => _pickImageGallery(),
                                  label: Text('From gallery', overflow: TextOverflow.clip,),
                                  icon: Icon(Icons.photo_album),
                                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10)
                                ),
                              ),

                              SizedBox(width: 20),

                              Flexible(
                                child: RaisedButton.icon(
                                    label: Text('Delete photo', overflow: TextOverflow.clip,),
                                    icon: Icon(Icons.delete),
                                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                    onPressed: ()  {
                                      // setState(() {
                                      //   image.text = null;
                                      // });
                                      // widget.docToEdit.reference.update({
                                      //   'postimage': null,
                                      // });

                                      return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Delete photo?'),
                                              content: Text(
                                                  'This photo will be deleted permanently.'
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
                                                         setState(() {
                                                           image.text = null;
                                                         });
                                                          widget.docToEdit.reference.update({
                                                            'postimage': null,
                                                          });

                                                      return showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              content: Text(
                                                                  'The image has been deleted from this post.'
                                                              ),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  // color: Colors.blue[50],
                                                                  // textColor: Colors.white,
                                                                  child: Text('Ok'),
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      Navigator.pop(context);
                                                                      Navigator.pop(context);
                                                                      // pops the two alert dialogues
                                                                      Navigator.pop(context);
                                                                      // pops out of edit
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            );

                                                          }).whenComplete(() => Navigator.pop(context));
                                                      // pops out of open and back to daily post/view posts

                                                    }

                                                    catch (error) {
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
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          // RaisedButton.icon(
                          //   label: Text('No Image'),
                          //   icon: Icon(Icons.upload_sharp),
                          //   onPressed: uploadPicture,
                          // ),


                          Column(
                            children: [


                              if (_imageFile!=null) ...[

                                Text(
                                  'New photo:',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),

                                Image.file(_imageFile),

                                SizedBox(height: 20),


                                SizedBox(
                                  height: 10,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RaisedButton.icon(
                                        label: Text('Crop image'),
                                        icon: Icon(Icons.crop),
                                        onPressed: _cropImage
                                    ),

                                    SizedBox(width: 20),

                                    RaisedButton.icon(
                                        label: Text('Delete image'),
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            _imageFile = null;
                                          });
                                        }
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),

                                // ButtonTheme(
                                //   minWidth: 150.0,
                                //   height: 50.0,
                                //   buttonColor: Colors.blue[50],
                                //   child: RaisedButton(
                                //     onPressed: () async {
                                //       uploadPicture();
                                //     },
                                //
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //
                                //         Icon(Icons.upload_sharp),
                                //
                                //         Text('Save new photo',
                                //           style: TextStyle(
                                //             fontSize: 20.0,
                                //             fontWeight: FontWeight.bold,
                                //
                                //           ),
                                //         ),
                                //
                                //
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                //
                                // SizedBox(height: 20),

                                RaisedButton.icon(
                                    padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
                                    label: Text('Save new image'),
                                    icon: Icon(Icons.upload_sharp),
                                    onPressed: uploadPicture,
                                ),
                              ]
                            ],
                          ),




                        ],
                      ),
                    ),


                 ), ) ]

            else Container(
              child: Container(
                margin: EdgeInsets.all(12),
                width: double.infinity,
                height: 1000,

                child: Center(
                  child: Column (
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          RaisedButton.icon(
                            onPressed: () => _pickImageCamera(),
                            label: Text('Add a photo'
                            ),
                            icon: Icon(Icons.photo_camera),
                          ),

                          SizedBox(width: 20),

                          RaisedButton.icon(
                            onPressed: () => _pickImageGallery(),
                            label: Text('Add from gallery'),
                            icon: Icon(Icons.photo_album),
                          ),

                        ],
                      ),

                      SizedBox(height: 20),

                      // RaisedButton.icon(
                      //   label: Text('No Image'),
                      //   icon: Icon(Icons.upload_sharp),
                      //   onPressed: uploadPicture,
                      // ),


                      Column(
                        children: [
                          if (_imageFile!=null) ...[
                            Image.file(_imageFile),

                            SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RaisedButton.icon(
                                    label: Text('Crop image'),
                                    icon: Icon(Icons.crop),
                                    onPressed: _cropImage
                                ),

                                SizedBox(width: 20),

                                RaisedButton.icon(
                                    label: Text('Delete image'),
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        _imageFile = null;
                                      });
                                    }
                                ),
                              ],
                            ),

                            SizedBox(height: 20),

                            // ButtonTheme(
                            //   minWidth: 150.0,
                            //   height: 50.0,
                            //   buttonColor: Colors.blue[50],
                            //   child: RaisedButton(
                            //     onPressed: () async {
                            //       uploadPicture();
                            //     },
                            //
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //
                            //         Icon(Icons.upload_sharp),
                            //
                            //         Text('Save new photo',
                            //           style: TextStyle(
                            //             fontSize: 20.0,
                            //             fontWeight: FontWeight.bold,
                            //
                            //           ),
                            //         ),
                            //
                            //
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            //
                            // SizedBox(height: 20),

                            RaisedButton.icon(
                              padding: EdgeInsets.fromLTRB(90, 10, 90, 10),
                              label: Text('Upload image'),
                              icon: Icon(Icons.upload_sharp),
                              onPressed: uploadPicture,
                            ),
                          ]
                        ],
                      ),




                    ],
                  ),
                ),


              ), )


          ],
        ),
      ),
    );
  }
}



