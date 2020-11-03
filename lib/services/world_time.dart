import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WorldTime {
  final String continent, location;
  String time;
  String date;
  bool isDay;

  WorldTime({this.continent, this.location});

  Future<void> getTime() async {
    try {
      Response response = await get(
          'http://worldtimeapi.org/api/timezone/$continent/$location');
      Map data = jsonDecode(response.body);

      date = data['datetime'];
      int offset = data['raw_offset'];

      DateTime currentTime = DateTime.parse(date);
      currentTime = currentTime.add(Duration(seconds: offset));

      date = currentTime.toIso8601String();
      time = DateFormat.jms().format(currentTime);
      isDay = currentTime.hour > 6 && currentTime.hour < 20;
    } catch (e) {
      print('Couldn\'t fetch data.\nError: $e');
    }
  }

  addASec() {
    DateTime currentTime = DateTime.parse(date).add(Duration(seconds: 1));
    date = currentTime.toIso8601String();
    time = DateFormat.jms().format(currentTime);
    isDay = currentTime.hour > 6 && currentTime.hour < 20;
  }
}
