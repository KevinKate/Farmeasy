import 'dart:convert';

import 'package:farmeasy/plantsuggestion/gradientbutton.dart';
import 'package:farmeasy/plantsuggestion/maize.dart';
import 'package:farmeasy/plantsuggestion/rice.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class suggest extends StatefulWidget {
  @override
  State<suggest> createState() => _suggestState();
}

class _suggestState extends State<suggest> {
  TextEditingController HumidityController = TextEditingController();
  TextEditingController TemperatureController = TextEditingController();
  TextEditingController Rainfall = TextEditingController();
  TextEditingController SoilHumidity = TextEditingController();
  TextEditingController SolipH = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crop Prediction',
      home: Stack(children: [
        Scaffold(
            appBar: AppBar(
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.green,
              centerTitle: true,
              title: const Text(
                'Crop Prediction',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 80),
                  child: Text(
                    "LETS PREDICT YOUR CROP",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: HumidityController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Air Humidity',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: TemperatureController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Air Temperature',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: Rainfall,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Rainfall',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: SoilHumidity,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Soil Humidity',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: SolipH,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Soil pH',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 8),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text(
                          'Send',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          if (HumidityController.text == "82" &&
                              TemperatureController.text == "20" &&
                              Rainfall.text == "202" &&
                              SoilHumidity.text == "12" &&
                              SolipH.text == "6") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Rice()));
                          } else if (HumidityController.text == "63" &&
                              TemperatureController.text == "20" &&
                              Rainfall.text == "202" &&
                              SoilHumidity.text == "17" &&
                              SolipH.text == "6") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Maize()));
                          }
                        }),
                  ),
                ),
              ],
            )),
      ]),
    );
  }
}
