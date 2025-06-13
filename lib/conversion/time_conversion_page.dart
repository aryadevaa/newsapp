import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeConversionPage extends StatefulWidget {
  @override
  _TimeConversionPageState createState() => _TimeConversionPageState();
}

class _TimeConversionPageState extends State<TimeConversionPage> {
  String selectedTimeZone1 = 'WIB';
  String selectedTimeZone2 = 'WITA';

  String convertTime(DateTime now, String timeZone) {
    DateTime convertedTime;
    String timeZoneName;

    switch (timeZone) {
      case 'WIB':
        convertedTime = now.add(Duration(hours: 7));
        timeZoneName = 'Waktu Indonesia Barat';
        break;
      case 'WITA':
        convertedTime = now.add(Duration(hours: 8));
        timeZoneName = 'Waktu Indonesia Tengah';
        break;
      case 'WIT':
        convertedTime = now.add(Duration(hours: 9));
        timeZoneName = 'Waktu Indonesia Timur';
        break;
      case 'London':
        convertedTime = now.subtract(Duration(hours: 7));
        timeZoneName = 'Waktu London';
        break;
      default:
        convertedTime = now;
        timeZoneName = timeZone;
    }

    return DateFormat('HH:mm:ss').format(convertedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih Zona Waktu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Zona Waktu 1:'),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: selectedTimeZone1,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedTimeZone1 = newValue!;
                                });
                              },
                              items: ['WIB', 'WITA', 'WIT', 'London']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Zona Waktu 2:'),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: selectedTimeZone2,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedTimeZone2 = newValue!;
                                });
                              },
                              items: ['WIB', 'WITA', 'WIT', 'London']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          StreamBuilder<DateTime>(
            stream: Stream.periodic(
              Duration(seconds: 1),
              (_) => DateTime.now(),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                DateTime currentTime = snapshot.data ?? DateTime.now();
                return Column(
                  children: [
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Waktu Saat Ini',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedTimeZone1,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        convertTime(currentTime, selectedTimeZone1),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedTimeZone2,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        convertTime(currentTime, selectedTimeZone2),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
