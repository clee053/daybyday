import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.blue[300],
      width: width,
      height: height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              child: Image (image: AssetImage('assets/applogo.png'),height: height*0.3,),
            ),

            SizedBox( height: 30),

            SpinKitCircle(
              color: Colors.white,
              size: 50.0,
            ),


          ],
        ),
      ),
    );
  }
}