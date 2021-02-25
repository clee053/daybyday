
import 'package:daybyday/startpages/ForgotPassword.dart';
import 'package:flutter/material.dart';

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

//  checkAuthentification() async
//  {
//    _auth.authStateChanges().listen((user) async {
//      if (user != null) {
//        print(user);
//        Navigator.push(
//            context, MaterialPageRoute(builder: (context) => NavigationBar()));
//      }
//    });
//
//  }
//
//  @override
//  void initState()
//  {
//    super.initState();
//    this.checkAuthentification();
//  }
//
//  login()async
//  {
//    if (_formKey.currentState.validate())
//    {
//      _formKey.currentState.save();
//      try{
//        UserCredential user = await _auth.signInWithEmailAndPassword(email: _email, password: _password);
//      }
//
//      catch(e)
//      {
//        showError(e.errormessage);
//        print(e);
//      }
//    }
//  }

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
    //return either loading or scaffold
    return loading ? Loading() :  Scaffold(

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

                            SizedBox(height: 10.0),

                            Container(
                              child: TextFormField(
                                // ignore: missing_return
                                validator: (input)
                                {
                                  if(input.length < 7)
                                    return 'Password must be more than 7 letters long.';
                                },

                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon:Icon(Icons.lock),
                                ),
                                obscureText: true,
                                onChanged: (input) => _password = input,

                              ),
                            ),

                            SizedBox(height: 20.0),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                ButtonTheme(
                                  minWidth: 125.0,

                                  height: 40.0,

                                  child: RaisedButton(

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

                                SizedBox(width: 30.0),

                                ButtonTheme(
                                  minWidth: 125.0,
                                  height: 40.0,

                                  child: RaisedButton(

                                    onPressed: () async {

                                      if (_formKey.currentState.validate()) {
                                        setState(() => loading = true);
                                        dynamic result = await _auth.signInWithEmailAndPassword(_email, _password);
                                        if (result == null) {
                                          setState(() {
                                            errormessage = 'Wrong email or password';
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
                              ],
                            ),

                            SizedBox(height: 20.0),

                            ButtonTheme(
                              minWidth: 280.0,
                              height: 40.0,

                              child: RaisedButton(
                                onPressed: () async {
                                  dynamic result = await _auth.signInAnon();
                                  if(result == null){
                                    print('Error signing in');
                                    } else {
                                    setState(() {
                                      errormessage = 'Warning: Cannot save posts online without an account.';
                                      loading = true;
                                    });
                                    print('Signed in');
                                    print(result.uid);
                                    }
                              },
                                child: Text('Log in without account',
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPassword()));
                                },

                                child: Text('Forgot Password?',
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
