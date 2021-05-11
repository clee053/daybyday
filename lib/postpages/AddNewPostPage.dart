import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';




class AddNewPostPage extends StatefulWidget {
  @override
  _AddNewPostPageState createState() => _AddNewPostPageState();
}

class _AddNewPostPageState extends State<AddNewPostPage> {
  final maxLines = 5;
  String dateTime;
  DateTime selectedDate = DateTime.now();


//  String _post;
  TextEditingController _dateController = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController image = TextEditingController();



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
        title: new Text("Add New Post"),
        actions: [
          FlatButton(onPressed: () {

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
              'postimage': image.text,
              'searchdate': actualDate,

            }
).whenComplete(() => Navigator.pop(context));

          }, child: Text('Save',
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
                width: width,
                height: height*0.2,

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




                ],
        ),
      ),
    );
  }
}


