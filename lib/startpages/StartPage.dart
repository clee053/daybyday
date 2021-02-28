import 'package:daybyday/services/auth.dart';
import 'package:daybyday/shared/loading.dart';
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

                      Container(
                        child: SignInButton(
                          Buttons.GoogleDark,
                          text: "Sign in with Google",
                          padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
                          onPressed: () async {

                            dynamic result = await _auth.signInWithGoogle();
                            setState(() {
                              loading = true;
                            });
                            if(result == null){
                              print('Error signing in');
                            } else {
                              setState(() {
                                errormessage = 'Cannot log in with Google. Please try again later.';
                                loading = false;
                              });
                              print('Signed in');
                              print(result.uid);
                            }

                          },
                        ),
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
