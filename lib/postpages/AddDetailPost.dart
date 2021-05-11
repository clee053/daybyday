import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';


class AddDetailPost extends StatefulWidget {
  @override
  _AddDetailPostState createState() => _AddDetailPostState();
}

class _AddDetailPostState extends State<AddDetailPost> {
  final maxLines = 5;
  String dateTime;
  DateTime selectedDate = DateTime.now();
  File _imageFile;
  String imageUrl;



//  String _post;
  TextEditingController _dateController = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController _imageController = TextEditingController();


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
            toolbarColor: Colors.blue,
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

    UploadTask _uploadTask;

    var fileUpload = File(_imageFile.path);

    if (_imageFile != null) {
      //Upload to Firebase
      var snapshot = await _storage.ref()
          .child('$useruid/post/${DateTime.now()}')
          .putFile(fileUpload);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        imageUrl = downloadUrl;
        _imageController.text = imageUrl;


        showFlash(
          context: context,
          duration: const Duration(seconds: 2),
          builder: (context, controller) {
            return Flash(
              controller: controller,
              backgroundColor: Colors.blue,
              style: FlashStyle.floating,
              boxShadows: kElevationToShadow[4],
              horizontalDismissDirection: HorizontalDismissDirection.horizontal,
              child: FlashBar(
                message: Text('Image uploaded. Remember to save post!'),
              ),
            );
          },
        );
      });
    } else {
      print('No Path Received');
      setState(() {
        _imageController.text = null;
      });
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
        _dateController.text = DateFormat.yMMMMd().format(selectedDate);
      });
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMMMMd().format(DateTime.now());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String _setDate;
    dateTime = DateFormat.yMMMMd().format(DateTime.now());
    var dateformat = new DateTime.now().toString();

    return Scaffold(
      appBar: AppBar(
        title: new Text("Add Detailed Post"),
        actions: [
          FlatButton(onPressed: () async {

            var user =  FirebaseAuth.instance.currentUser;
            final data = FirebaseFirestore.instance.collection("users").doc(user.uid).collection('posts');

            var dateYear = selectedDate.year.toString();
            var dateMonth = DateFormat.MMMM().format(selectedDate);
            var dateDay = selectedDate.day.toString();
            var actualDate = DateFormat.yMMMd().format(selectedDate);

            //get the current UID, which is already in use, this will help also with the anonymous posts
            data.add({
              'title': title.text,
              'content': content.text,
              'posttime' : FieldValue.serverTimestamp(),
              'actualdate': selectedDate,
              'year': dateYear,
              'month': dateMonth,
              'day': dateDay,
              'postimage': _imageController.text,
              'searchdate': actualDate,

            }).whenComplete(() => Navigator.pop(context));
          }, child: Text('Save',
            style: TextStyle(
                color: Colors.white
            ),),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            Container(
              child: Container(
                margin: EdgeInsets.all(12),
                width: width,
                height: height*0.15,

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
                width: width,


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
//                              validator: (input)
//
//                                  {
//                                  if(input.isEmpty)
//                                  return 'Please do not leave blank!';
//                                  },

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
                        height: maxLines * 70.0,

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


            Column (
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RaisedButton.icon(
                        onPressed: () => _pickImageCamera(),
                        label: Text('Take a photo!'),
                        icon: Icon(Icons.photo_camera),
                        ),

                      SizedBox(width: 20),

                      RaisedButton.icon(
                        onPressed: () => _pickImageGallery(),
                        label: Text('From Gallery'),
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

                      SizedBox(
                        width: width*0.8,
                        child: ButtonTheme(
                          height: 50.0,
                          buttonColor: Colors.blue[50],
                          child: RaisedButton(
                            onPressed: () async {



                              uploadPicture();



                            },

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Icon(Icons.upload_sharp),

                                Text('Upload Photo',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,

                                  ),
                                ),


                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                    ]
                  ],
                ),




              ],
            ),




          ],
        ),
      ),
    );
  }
}




