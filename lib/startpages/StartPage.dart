import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:daybyday/startpages/SignUpPage.dart';
import 'package:daybyday/startpages/LoginPage.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  navigateToLogin()async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
  }
  navigateToSignUp()async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpPage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: <Widget> [
            Container(
              child: Container(
                width: double.infinity,
                height: 800.0,

                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(height: 50.0),
                      Container(
                        child: Image (image: AssetImage('assets/applogo.png'),height: 300,),
                      ),
                      SizedBox(height: 20.0),

                      Text(
                        "Welcome to ",
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),


                      Text (
                        "day by day",
                        style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.blue
                        ),
                      ),




                      SizedBox(height: 50.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            padding: EdgeInsets.only(left:30, right:30),
                            onPressed: navigateToLogin,
                            child: Text('LOGIN',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            color: Colors.blue,

                          ),

                          SizedBox(width: 30.0),

                          RaisedButton(
                            padding: EdgeInsets.only(left:25, right:25),
                            onPressed: navigateToSignUp,
                            child: Text('SIGN UP',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            color: Colors.blue,

                          ),

                        ],
                      ),

                      SizedBox(height: 30.0),

                      SignInButton(

                        Buttons.GoogleDark,
                        text: "Sign up with Google",
                        onPressed: () {},
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
