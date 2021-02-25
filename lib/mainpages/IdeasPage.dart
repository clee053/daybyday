import 'package:flutter/material.dart';

class IdeasPage extends StatefulWidget {
  @override
  _IdeasPageState createState() => _IdeasPageState();
}

class _IdeasPageState extends State<IdeasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: new Text("Sign In"),
      ),
      body: Column (
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 400.0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget> [

                    Image(image: AssetImage('assets/applogo.png'),
                    height: 300,),

                  ],

                ),
              ),
              ),

          Container(
            child: Container(
              width: double.infinity,
              height: 100.0,

              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/somin.png'),
                    ),

                  ],

                ),
              ),
            ),
          ),

        ],
      ),




    );
  }
}
