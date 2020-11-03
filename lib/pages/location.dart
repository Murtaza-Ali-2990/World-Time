import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:world_time_app/pages/countries.dart';

class Location extends StatefulWidget {
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final locationList = {
    'Africa': [],
    'America': [],
    'Antarctica': [],
    'Asia': [],
    'Atlantic': [],
    'Australia': [],
    'Europe': [],
    'Indian': [],
    'Pacific': []
  };
  List<String> continents = [];

  initState() {
    super.initState();
    _getLocations();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Choose Continent'),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: continents.length * 2,
          itemBuilder: _genItem,
        ));
  }

  _getLocations() async {
    try {
      Response response = await get('http://worldtimeapi.org/api/timezone');
      List<String> locations = jsonDecode(response.body).cast<String>();

      locations.forEach((location) {
        List<String> keyPair = location.split('/');
        if (locationList.containsKey(keyPair[0]))
          locationList[keyPair[0]]
              .add(keyPair[1] + (keyPair.length == 3 ? '/${keyPair[2]}' : ''));
      });

      continents = locationList.keys.toList();
      setState(() {});
    } catch (e) {
      print('Error here: $e');
    }
  }

  Widget _genItem(BuildContext context, int index) {
    if (index.isEven) return Divider();

    int dex = index ~/ 2;

    return ListTile(
      title: Text(
        continents[dex],
        style: TextStyle(fontSize: 15.0),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Countries(continents[dex], locationList[continents[dex]]),
            ));
      },
    );
  }
}
