import 'package:daybyday/startpages/StartPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:daybyday/startpages/LoginPage.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email;
  String errormessage;
  bool loading = false;

  // Future _passwordReset(String email) async {
  //   try {
  //     final _auth = FirebaseAuth.instance;
  //     await _auth.sendPasswordResetEmail(email: _email);
  //   } catch (error) {
  //     print(error.toString());
  //     return null;
  //   }
  // }

  Future<void> resetPassword(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm Password Reset?'),
            content: Text(
              'The password reset link will be emailed to you at $_email.'
            ),

            actions: <Widget>[
              FlatButton(
                // color: Colors.blue[50],
                // textColor: Colors.white,
                child: Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                // color: Colors.blue,
                // textColor: Colors.white,
                child: Text('Yes'),
                onPressed: () async {
                  try {
                    final _auth = FirebaseAuth.instance;
                    await _auth.sendPasswordResetEmail(email: _email);
                    Navigator.pop(context);
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(
                              'The password reset link has been sent to your email.'
                          ),
                          actions: <Widget>[
                            FlatButton(
                              // color: Colors.blue[50],
                              // textColor: Colors.white,
                              child: Text('Ok!'),
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => StartPage()));
                                });
                              },
                            ),
                          ],
                        );

                      });

                  } catch (error) {
                    print(error.toString());
                    return null;
                  }
                },
              ),
            ],
          );



        });
  }

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
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              Container(
                child: Container(
                  width: double.infinity,
                  height: 300.0,

                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        SizedBox(height: 50.0),
                        Container(
                          child: Image (image: AssetImage('assets/applogo.png'),height: 230,),
                        ),
                        SizedBox(height: 20.0),

                      ],
                    ),
                  ),
                ),
              ),

              Container(
                child: Container(
                  width: double.infinity,
                  height: 400.0,

                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

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

                              SizedBox(height: 30.0),

                              ButtonTheme(
                                minWidth: 280.0,
                                height: 40.0,

                                child: RaisedButton(
                                  onPressed: ()  {
                                    resetPassword(context);
                                  },

                                  child: Text('Reset Password',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  color: Colors.blue,

                                ),
                              ),

                              ButtonTheme(
                                minWidth: 280.0,
                                height: 40.0,

                                child: FlatButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                                  },

                                  child: Text('Back to Log In',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.black,
                                    ),
                                  ),



                                ),
                              ),

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

    );
  }
}
