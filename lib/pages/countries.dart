import 'package:flutter/material.dart';

class Countries extends StatelessWidget {
  final continent;
  final locations;

  Countries(this.continent, this.locations);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Choose Location'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: locations.length * 2,
        itemBuilder: _genTile,
      ),
    );
  }

  Widget _genTile(BuildContext context, int index) {
    if (index.isEven) return Divider();

    int dex = index ~/ 2;
    final keyPair = locations[dex].split('/');
    final location =
        keyPair.length == 2 ? '${keyPair[1]}, ${keyPair[0]}' : keyPair[0];

    return ListTile(
      title: Text(
        location.replaceAll('_', ' '),
        style: TextStyle(fontSize: 15.0),
      ),
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false,
            arguments: {'continent': continent, 'location': locations[dex]});
      },
    );
  }
}
