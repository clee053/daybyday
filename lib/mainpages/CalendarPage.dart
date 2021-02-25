// import 'package:daybyday/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:daybyday/models/post.dart';

//https://medium.com/flutterdevs/display-dynamic-events-at-calendar-in-flutter-22b69b29daf6

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarController _controller;
  List<dynamic> _selectedEvents;
  Map<DateTime, List<dynamic>> _events;
  TextEditingController _eventController;




  // final AuthService _auth = AuthService();
  // Event is a map of key DateTime and lists the dynamic list of where this list is the list of events for that day


  @override
  void initState() {
    super.initState();

    final _selectedDay = DateTime.now();
    _controller = CalendarController();
    _eventController = TextEditingController();


    _events = {

      // _selectedDay: [
      //
      //   'Event B0',
      //   'Event C0'
      // ],
    };
    _selectedEvents = [];
  }

  Map<DateTime, dynamic> _groupEvents(List<Post> allEvents) {
    Map<DateTime, dynamic> data = {};
    allEvents.forEach((event) {
      DateTime date = DateTime(
          event.actualdate.year, event.actualdate.month, event.actualdate.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }


  // Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
  //   Map<String, dynamic> newMap = {};
  //   map.forEach((key, value) {
  //     newMap[key.toString()] = map[key];
  //   });
  //   return newMap;
  // }
  //
  // Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
  //   Map<DateTime, dynamic> newMap = {};
  //   map.forEach((key, value) {
  //     newMap[DateTime.parse(key)] = map[key];
  //   });
  //   return newMap;
  // }

  @override
  Widget build(BuildContext context) {

    var useruid = FirebaseAuth.instance.currentUser.uid;
    final dateref = FirebaseFirestore.instance.collection('users').doc(useruid).collection('posts');
    final _selectedDay = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: new Text("Calendar"),
      ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            _showAddDialog();

          },
        ),
      // body: StreamBuilder(
      //   stream: dateref.snapshots(),
      //   builder: (context, snapshot) {
      //
      //       return ListView.builder(
      //           itemCount: snapshot.hasData?snapshot.data.docs.length: 0,
      //           itemBuilder: (_, index){
      //           DateTime myDateTime = (snapshot.data.docs[index].data()['posttime']).toDate();
      //           });



          body: StreamBuilder(
            stream: dateref.snapshots(),
            builder: (context, snapshot)
            {
              var post = snapshot.data;
              if (snapshot.hasData) {
                final List<DocumentSnapshot> documents = snapshot.data.docs;
                  _events = {
                    _selectedDay: [
                      documents.map((doc) => Card(
                              child: ListTile(
                                title: Text(doc['title']),
                              ),))
                      // '${post['title']}'
                    ],

                  };
                  _selectedEvents = [

                    // '${post['title']}'
                  ];
                }

              // if (snapshot.hasData) {
              //   // <3> Retrieve `List<DocumentSnapshot>` from snapshot
              //   final List<DocumentSnapshot> documents = snapshot.data.docs;
              //   return ListView(
              //       children: documents
              //           .map((doc) => Card(
              //         child: ListTile(
              //           title: Text(doc['title']),
              //         ),
              //       ))
              //           .toList());
              // }



            return SingleChildScrollView (
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(10),
                    child: TableCalendar(
                      events: _events,
                      calendarStyle: CalendarStyle(
                        canEventMarkersOverflow: true,
                        todayColor: Colors.pink,
                        selectedColor: Theme.of(context).primaryColor,
                      ),
                    calendarController: _controller,
                      headerStyle: HeaderStyle(
                        decoration: BoxDecoration(
                          color: Colors.blue[200],
                        ),
                        headerMargin: const EdgeInsets.only(bottom: 20),
                          formatButtonShowsNext: false,
                        titleTextStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,

                        )
                      ),

                      onDaySelected: (date, events, holidays)  {
                        setState(()  {
                          _selectedEvents = events;
                          // if (snapshot.hasData) {
                          //   // <3> Retrieve `List<DocumentSnapshot>` from snapshot
                          //   final List<DocumentSnapshot> documents = snapshot.data.docs;
                          //   return ListView(
                          //       children: documents
                          //           .map((doc) => Card(
                          //         child: ListTile(
                          //           title: Text(doc['title']),
                          //         ),
                          //       ))
                          //           .toList());
                          // }
                        });
                      },

                      // day selected will add the event

                      // In TableCalendar, let us assign events as underscore events.
                      // Whenever the day is selected, set state,
                      // so interval calendar on the day selected property.

              ),

                  ),
                   ... _selectedEvents.map((event) => ListTile(

                    title: Text(event),
                  )),
                  // lists the event title out



                  // RaisedButton(
                  //   onPressed: () async {
                  //     await _auth.signOut();
                  //   },
                  //   child: Text('Sign out',
                  //     style: TextStyle(
                  //       fontSize: 20.0,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  //
                  // ),





                ],
            ),




            );

            }

          ),

      );

  }

  _showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: _eventController,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Save"),
              onPressed: () {
                if (_eventController.text.isEmpty) return;
                setState(() {
                  if (_events[_controller.selectedDay] != null) {
                    _events[_controller.selectedDay]
                        .add(_eventController.text);
                  } else {
                    _events[_controller.selectedDay] = [
                      _eventController.text
                    ];
                  }
                  });

                _eventController.clear();
                Navigator.pop(context);
                 },

            )
          ],
        ));



  }

}
