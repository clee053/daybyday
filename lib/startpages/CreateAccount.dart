import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybyday/navigation/NavigationBar.dart';
import 'package:daybyday/services/auth.dart';
import 'package:daybyday/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();


  final AuthService _auth = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email, password, name;
  String errormessage;



//  checkAuthentification() async
//  {
//    _auth.authStateChanges().listen((user) async {
//      if (user != null) {
//        Navigator.push(
//            context, MaterialPageRoute(builder: (context) => NavigationBar()));
//      }
//    });
//  }
//
//  @override
//  void initState()
//  {
//    super.initState();
//    this.checkAuthentification();
//  }
//
//  signUp()async
//  {
//    if (_formKey.currentState.validate())
//    {
//      _formKey.currentState.save();
//      try{
//        UserCredential user = await _auth.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
//        if (user != null)
//        {
//          await _auth.currentUser.updateProfile(displayName: _nameController.text);
//        }
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

    return Scaffold(

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
            children: <Widget> [
              Container(
                child: Container(
                  width: double.infinity,


                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        SizedBox(height: 50.0),
                        Container(
                          child: Image (image: AssetImage('assets/applogo.png'),height: 230,),
                        ),
                        SizedBox(height: 20.0),

                        Text('create account',
                          style: TextStyle(
                            fontSize: 40,
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
                                      if(value.isEmpty){
                                        return 'Enter email';}
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
//                                  onSaved: (input) => _password = input


                                ),


                              ),


                              SizedBox(height: 20.0),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  RaisedButton(
                                    padding: EdgeInsets.only(left:25, right:25),
                                    onPressed: () async {
                                      var user =  FirebaseAuth.instance.currentUser;
                                      if (_formKey.currentState.validate()) {

                                        FirebaseFirestore.instance.collection("users").doc(user.uid).update({
                                          'name': name,
                                          'email': email,
                                        });

                                       await _auth.createAnon(email, password, name).whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (context)=> NavigationBar())));

                                        // if (result == null) {
                                        //   setState(() {
                                        //     errormessage = 'Please fill in all fields properly.';
                                        //
                                        //   });
                                        //   showError(errormessage);
                                        // }
                                      }
                                    },
                                    child: Text('Create Account',
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

