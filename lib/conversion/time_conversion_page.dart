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
    String formattedTime = DateFormat('HH:mm:ss').format(now);

    if (timeZone == 'WIB') {
      DateTime wibTime = now.add(Duration(hours: 7));
      formattedTime = DateFormat('HH:mm:ss').format(wibTime);
    } else if (timeZone == 'WITA') {
      DateTime witaTime = now.add(Duration(hours: 8));
      formattedTime = DateFormat('HH:mm:ss').format(witaTime);
    } else if (timeZone == 'WIT') {
      DateTime witTime = now.add(Duration(hours: 9));
      formattedTime = DateFormat('HH:mm:ss').format(witTime);
    } else if (timeZone == 'London') {
      DateTime londonTime = now.subtract(Duration(hours: 7));
      formattedTime = DateFormat('HH:mm:ss').format(londonTime);
    }

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            'Konversi Waktu',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text('Zona Waktu 1:'),
              SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedTimeZone1,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTimeZone1 = newValue!;
                  });
                },
                items:
                    [
                      'WIB',
                      'WITA',
                      'WIT',
                      'London',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
            ],
          ),
          Row(
            children: [
              Text('Zona Waktu 2:'),
              SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedTimeZone2,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTimeZone2 = newValue!;
                  });
                },
                items:
                    [
                      'WIB',
                      'WITA',
                      'WIT',
                      'London',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
            ],
          ),
          SizedBox(height: 20),
          StreamBuilder<DateTime>(
            stream: Stream.periodic(
              Duration(seconds: 1),
              (_) => DateTime.now(),
            ), // Update setiap detik
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                DateTime currentTime = snapshot.data ?? DateTime.now();
                return Column(
                  children: [
                    Text(
                      'Waktu di $selectedTimeZone1: ${convertTime(currentTime, selectedTimeZone1)}',
                    ),
                    Text(
                      'Waktu di $selectedTimeZone2: ${convertTime(currentTime, selectedTimeZone2)}',
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
