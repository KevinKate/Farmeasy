import 'package:flutter/material.dart';

class Maize extends StatefulWidget {
  const Maize({Key key}) : super(key: key);

  @override
  State<Maize> createState() => _MaizeState();
}

class _MaizeState extends State<Maize> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Prediction"),
        centerTitle: true,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
        children: [Padding(
          padding: const EdgeInsets.only(left: 70,top: 40),
          child: Text("Predicted Output : Maize",style: TextStyle(fontSize: 20),),
        )]),
    );
  }
}
