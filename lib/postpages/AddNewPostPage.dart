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
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    String _setDate;
    dateTime = DateFormat.yMd().format(DateTime.now());
    var dateformat = new DateTime.now().toString();

    return Scaffold(
      appBar: AppBar(
        title: new Text("Add New Post!"),
        actions: [
          FlatButton(onPressed: () {

            var user =  FirebaseAuth.instance.currentUser;

            var dateYear = selectedDate.year;
            var dateMonth = selectedDate.month;
            var dateDay = selectedDate.day;

            //get the current UID, which is already in use, this will help also with the anonymous posts
            FirebaseFirestore.instance.collection("users").doc(user.uid).collection('posts').add({
              'title': title.text,
              'content': content.text,
              'posttime' : FieldValue.serverTimestamp(),
              'actualdate': selectedDate,
              'year': dateYear.toString(),
              'month': dateMonth.toString(),
              'day': dateDay.toString(),

            }








            ).whenComplete(() => Navigator.pop(context));
          }, child: Text('Save')),
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
                height: 400.0,

                  child: Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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




                ],
        ),
      ),
    );
  }
}


