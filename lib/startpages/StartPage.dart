import 'package:daybyday/services/auth.dart';
import 'package:daybyday/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:daybyday/startpages/SignUpPage.dart';
import 'package:daybyday/startpages/LoginPage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  final AuthService _auth = AuthService();
  String errormessage;
  bool loading = false;


  navigateToLogin()async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
  }
  navigateToSignUp()async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpPage()));
  }
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;


    return loading ? Loading() :  Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: <Widget> [
            Container(
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.indigo[300], Colors.white70])),

                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[


                      Container(
                        child: Image (image: AssetImage('assets/applogo.png'),height: height*0.4,),
                      ),

                      SizedBox( height: 30),


                      Text(
                        "welcome to",
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                        ),
                      ),


                      Text (
                        "day by day",
                        style: TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.blue
                        ),
                      ),




                      SizedBox(height: 30.0),



                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          SizedBox(width: width*0.1),

                          SizedBox(
                            width: width*0.35,
                            child: RaisedButton(
                              padding: EdgeInsets.all(10),
                              onPressed: navigateToLogin,
                              child: Text('LOGIN',
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),

                              ),

                              color: Colors.blue,

                            ),
                          ),

                          SizedBox(width: width*0.1),

                          SizedBox(
                            width: width*0.35,
                            child: RaisedButton(
                              padding: EdgeInsets.all(10),
                              onPressed: navigateToSignUp,
                              child: Text('SIGN UP',
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              color: Colors.blue,

                            ),
                          ),

                          SizedBox(width: width*0.1),



                        ],
                      ),







                    ],
                  ),
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
