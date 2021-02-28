import 'package:daybyday/services/auth.dart';
import 'package:flutter/material.dart';

class IdeasPage extends StatefulWidget {
  @override
  _IdeasPageState createState() => _IdeasPageState();
}

class _IdeasPageState extends State<IdeasPage> {
  final AuthService _auth = AuthService();
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

                    ButtonTheme(
                      minWidth: 300.0,
                      height: 50.0,
                      buttonColor: Colors.blue[50],
                      child: RaisedButton(
                        onPressed: () async {
                          await _auth.signOut();
                        },
                        child: Text('Sign out',
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
