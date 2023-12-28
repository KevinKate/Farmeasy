import 'package:flutter/material.dart';

class Rice extends StatefulWidget {
  const Rice({Key key}) : super(key: key);

  @override
  State<Rice> createState() => _RiceState();
}

class _RiceState extends State<Rice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Prediction"),
          centerTitle: true,
        ),
        body:  Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
        children: [
             Image.asset(
           'assets/images/ricej.jpg',
           width: 600,
           height: 240,
           fit: BoxFit.cover,
         ),
           Padding(
         padding: const EdgeInsets.only(left: 70,top: 40),

            child: Text("Predicted Output : Rice",style: TextStyle(fontSize: 20),),
        )]),
        );
  }
}
