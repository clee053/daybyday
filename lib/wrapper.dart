import 'package:flutter/material.dart';
import 'package:daybyday/startpages/StartPage.dart';
import 'package:daybyday/startpages/authenticate.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    Returns data from currentuser through stream
  final user = Provider.of<UserType>(context);
  print (user);
      // return either the Home or Authenticate widget
    if (user == null) {
      return StartPage();
    } else {
      return Authenticate();
    }

  }
}

