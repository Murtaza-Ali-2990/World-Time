import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/world_time.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WorldTime worldTime;
  Timer timer;

  initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (time) {
      worldTime.addASec();
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    worldTime = ModalRoute.of(context).settings.arguments ?? worldTime;
    String imagePath = 'assets/' + (worldTime.isDay ? 'day.jpg' : 'night.jpg');
    Color bgColor = worldTime.isDay ? Colors.blue[200] : Colors.indigo[900];
    Color textColor = worldTime.isDay ? Colors.black : Colors.white;
    final location = worldTime.location.split('/');
    final locationText =
        location.length == 2 ? '${location[1]}, ${location[0]}' : location[0];
    _setPreferences();

    return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                )),
                child: Column(
                  children: [
                    SizedBox(height: 150.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          worldTime.time,
                          style: TextStyle(
                              color: textColor,
                              fontSize: 50.0,
                              letterSpacing: 3.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      '${locationText.replaceAll('_', ' ')}, ${worldTime.continent}',
                      style: TextStyle(
                          color: textColor, fontSize: 20.0, letterSpacing: 1.5),
                    ),
                    SizedBox(height: 250),
                    FlatButton.icon(
                        label: Text(
                          'Select Location',
                          style: TextStyle(fontSize: 20.0, color: textColor),
                        ),
                        icon: Icon(
                          Icons.edit_location,
                          size: 50.0,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/location');
                        }),
                  ],
                ))));
  }

  dispose() {
    super.dispose();
    timer.cancel();
  }

  _setPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('continent', worldTime.continent);
    prefs.setString('location', worldTime.location);
  }
}
