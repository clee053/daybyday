import 'package:daybyday/services/auth.dart';
import 'package:daybyday/shared/loading.dart';
import 'package:daybyday/startpages/LoginPage.dart';
import 'package:flutter/material.dart';

import 'StartPage.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final AuthService _auth = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email, password, name;
  String errormessage;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

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
                  child: Text('OK'))
            ],
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return loading ? Loading() :   Scaffold(

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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[


                        Container(
                          child: Image (image: AssetImage('assets/applogo.png'),height: height*0.3,),
                        ),

                        SizedBox(height: 20.0),

                        Text('create new account',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              Container(
                child: Container(
                  width: double.infinity,

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
                                    validator: (value)
                                    {
                                      if(value.isEmpty){
                                        return 'Enter Name';}
                                      return null;
                                    },
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Name',
                                      prefixIcon:Icon(Icons.person),
                                    ),
                                    onChanged: (input) => name = input


                                ),
                              ),

                              SizedBox(height: 10.0),
                              Container(
                                child: TextFormField(
                                  validator: (value)
                                  {
                                    final regExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                                    if(value.isEmpty){
                                      return 'Enter email';}
                                    if (!regExp.hasMatch(value)) {
                                      return 'Enter a correct email format';}
                                    return null;
                                  },
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon:Icon(Icons.email),
                                    ),
                                    onChanged: (input) => email = input


                                ),
                              ),

                              SizedBox(height: 10.0),

                              Container(
                                child: TextFormField(

                                  validator: (value)
                                  {
                                    if(value.length < 7){
                                      return 'Password must be more than 7 letters long';}
                                    return null;
                                  },
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon:Icon(Icons.lock),
                                    ),
                                    obscureText: true,
                                  onChanged: (input) => password = input


                                ),


                              ),

                              SizedBox(height: 10.0),

                              Container(
                                child: TextFormField(

                                  validator: (value)
                                  {
                                    if(value != _passwordController.value.text){
                                      return 'Passwords do not match!';}
                                    return null;
                                  },
                                  controller: _confirmPasswordController,
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    prefixIcon:Icon(Icons.lock),
                                  ),
                                  obscureText: true,
//


                                ),


                              ),


                              SizedBox(height: 20.0),

                              Container(
                                width: width*0.7,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[



                                    Expanded(
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

                                    SizedBox(width: 30.0),

                                    Expanded(
                                      child: RaisedButton(
                                        padding: EdgeInsets.all(10),
                                        onPressed: () async {
                                          if (_formKey.currentState.validate()) {
                                            setState(() => loading = true);
                                            dynamic result = await _auth.createUserWithEmailAndPassword(email, password, name);
                                            if (result == null) {
                                              setState(() {
                                                errormessage = 'Please try again later.';
                                                loading = false;
                                              });
                                              showError(errormessage);
                                            }
                                          }
                                        },
                                        child: Text('SIGN UP',
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
                              ),

                              SizedBox(height: 15.0),

                              ButtonTheme(
                                height: 30.0,

                                child: FlatButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                                  },

                                  child: Text("Don't want to set up an account? \n View other login methods",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15.0,
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
      ),
    );
  }
}

