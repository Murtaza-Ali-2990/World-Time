import 'package:flutter/material.dart';
import '../services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Map data;

  initState() {
    super.initState();
    data = {'continent': 'Asia', 'location': 'Kolkata'};
  }

  Widget build(BuildContext context) {
    bool _initial = ModalRoute.of(context).settings.arguments == null;
    data = ModalRoute.of(context).settings.arguments ?? data;

    _worldTimeSetup(_initial);

    return Scaffold(
        backgroundColor: Colors.blue[900],
        body: SpinKitRotatingCircle(color: Colors.white, size: 100.0));
  }

  _worldTimeSetup(bool _initial) async {
    if (_initial) await _addPreferences();
    await Future.delayed(Duration(seconds: 2));
    WorldTime worldTime =
        WorldTime(continent: data['continent'], location: data['location']);
    await worldTime.getTime();
    if (worldTime.time != null)
      Navigator.pushReplacementNamed(context, '/home', arguments: worldTime);
    else
      _createDialog();
  }

  Future<void> _addPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data['continent'] = prefs.getString('continent') ?? data['continent'];
    data['location'] = prefs.getString('location') ?? data['location'];
  }

  _createDialog() {
    Navigator.of(context)
        .push(PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, _, __) {
              return Material(
                type: MaterialType.transparency,
                child: SafeArea(
                    child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 100.0, horizontal: 10.0),
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Please check your Internet Connection',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                )),
              );
            }))
        .whenComplete(() {
      setState(() {});
    });
  }
}
