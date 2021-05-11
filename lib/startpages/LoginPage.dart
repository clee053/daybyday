
import 'package:daybyday/startpages/ForgotPassword.dart';
import 'package:daybyday/startpages/SignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'StartPage.dart';
import 'package:daybyday/shared/loading.dart';
import 'package:daybyday/services/auth.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password;
  String errormessage;
  bool loading = false;

  showError(String errormessage) {

    showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text('OK')

              ),
            ],
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    //return either loading or scaffold
    return loading ? Loading() :  Scaffold(

      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.indigo[200], Colors.white70])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Container(
                child: Container(
                  width: double.infinity,


                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        Container(
                          child: Image (image: AssetImage('assets/applogo.png'),height: height*0.3,),
                        ),

                        SizedBox(height: 20.0),

                        Text('log in',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),

                        Form(
                          key: _formKey,
                          child: Column (
                            children: <Widget>[
                              Container(
                                child: TextFormField(
                                  // ignore: missing_return
                                  validator: (input)

                                  {
                                    if(input.isEmpty)
                                      return 'Enter Email';
                                  },

                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon:Icon(Icons.email),
                                  ),
//
                                  onChanged: (input) => _email = input,


                                ),
                              ),

                              SizedBox(height: 10.0),

                              Container(
                                child: TextFormField(
                                  // ignore: missing_return
                                  // validator: (input)
                                  // {
                                  //   if(input.length < 7)
                                  //     return 'Password must be more than 7 letters long.';
                                  // },

                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon:Icon(Icons.lock),
                                  ),
                                  obscureText: true,
                                  onChanged: (input) => _password = input,

                                ),
                              ),

                              SizedBox(height: 10.0),

                              ButtonTheme(
                                minWidth: 280.0,
                                height: 30.0,

                                child: FlatButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPassword()));
                                  },

                                  child: Text('Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),



                                ),
                              ),


                              Container(
                                width: width*0.7,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: <Widget>[

                                    // SizedBox(width: 40.0),

                                    Expanded(
                                      child: ButtonTheme(
                                        child: RaisedButton(
                                          padding: EdgeInsets.all(10),
                                          onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> StartPage()));
                                          },
                                          child: Text('BACK',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),

                                          color: Colors.blue,

                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 30.0),

                                    Expanded(
                                      child: ButtonTheme(
                                        padding: EdgeInsets.all(10),
                                        child: RaisedButton(

                                          onPressed: () async {

                                            if (_formKey.currentState.validate()) {
                                              setState(() => loading = true);
                                              dynamic result = await _auth.signInWithEmailAndPassword(_email, _password);
                                              if (result == null) {
                                                setState(() {
                                                  errormessage = 'Wrong email or password. Please try again!';
                                                  loading = false;
                                                });

                                                showError(errormessage);


                                              }
                                            }

                                          },


                                          child: Text('LOGIN',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),

                                          color: Colors.blue,

                                        ),

                                      ),
                                    ),

                                    // SizedBox(width: 40.0),
                                  ],
                                ),

                              ),

                              SizedBox(height: 20.0),



                              Text('Or',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                              ),

                              SizedBox(height: 10.0),
                              // SizedBox( height: 30),

                              Container(
                                child: ButtonTheme(
                                  minWidth: width*0.6,
                                  height: 40.0,

                                  child: RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(10.0),
                                    ),
                                    onPressed: () async {
                                      dynamic result = await _auth.signInAnon();
                                      if(result == null){
                                        print('Error signing in');
                                      } else {
                                        setState(() {
                                          loading = true;
                                        });
                                        print('Signed in');
                                        print(result.uid);
                                      }
                                    },
                                    child: Text('Go anonymous',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                          // fontWeight: FontWeight.bold,
                                        color: Colors.black45,
                                      ),
                                    ),

                                    color: Colors.white,

                                  ),
                                ),
                              ),


                              SizedBox(height: 10.0),

                              SizedBox(
                                height: 40.0,
                                width: width*0.60,
                                child: SignInButton(
                                  Buttons.Google,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
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

                              ButtonTheme(
                                height: 30.0,

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    Text("Don't have an account yet?",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                    ),

                                    FlatButton(
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpPage()));
                                      },

                                      child: Text("Sign up now.",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.blue,
                                        ),
                                      ),





                                    ),
                                  ],
                                ),
                              ),





                              // Container(
                              //  width: width*0.65,
                              //   child: ButtonTheme(
                              //     minWidth: 280.0,
                              //     height: 40.0,
                              //
                              //     child: RaisedButton(
                              //       onPressed: () async {
                              //         dynamic result = await _auth.signInAnon();
                              //         if(result == null){
                              //           print('Error signing in');
                              //           } else {
                              //           setState(() {
                              //             errormessage = 'Warning: Cannot save posts online without an account.';
                              //             loading = true;
                              //           });
                              //           print('Signed in');
                              //           print(result.uid);
                              //           }
                              //     },
                              //       child: Text('LOG IN WITHOUT ACCOUNT',
                              //         style: TextStyle(
                              //           fontSize: 18.0,
                              //           fontWeight: FontWeight.bold,
                              //           color: Colors.white,
                              //         ),
                              //       ),
                              //
                              //       color: Colors.blue,
                              //
                              //     ),
                              //   ),
                              // ),



                            ],
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
      ),
    );
  }
}
