// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EditPost extends StatefulWidget {

  DocumentSnapshot docToEdit;
  EditPost({this.docToEdit});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {

  final maxLines = 5;

  TextEditingController _dateController = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  DateTime selectedDate = DateTime.now();


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
            var user =  FirebaseAuth.instance.currentUser;
            var dateYear = selectedDate.year;
            var dateMonth = selectedDate.month;
            var dateDay = selectedDate.day;

            widget.docToEdit.reference.update({
              'title': title.text,
              'content': content.text,
              'posttime' : FieldValue.serverTimestamp(),
              'actualdate': selectedDate,
              'year': dateYear.toString(),
              'month': dateMonth.toString(),
              'day': dateDay.toString(),
            }).whenComplete(() => Navigator.pop(context));}, child: Text('Save')),

          FlatButton(onPressed: (){
            widget.docToEdit.reference.delete().whenComplete(() => Navigator.pop(context));
            }, child: Text('Delete')),
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



