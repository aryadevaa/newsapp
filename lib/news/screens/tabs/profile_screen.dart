import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart'; // Mengimpor package sensors_plus
import 'package:newsapp/conversion/conversion_page.dart';
import 'package:newsapp/login_signup/Authentication/login.dart';
import 'package:sensors_plus/sensors_plus.dart' as SensorsPlus;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  double _x = 0.0, _y = 0.0, _z = 0.0;

  @override
  void initState() {
    super.initState();
    // Langganan data accelerometer dari sensors_plus
    _accelerometerSubscription = SensorsPlus.accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      setState(() {
        _x = event.x;
        _y = event.y;
        _z = event.z;
      });
    });
  }

  @override
  void dispose() {
    // Batalkan langganan ketika halaman dihancurkan
    _accelerometerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Membungkus konten dalam SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Gambar Profil
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/img/profile.jpg'),
              ),
              SizedBox(height: 16),

              // Nama dan Detail Profil
              Text(
                'Aryadeva Bagus Saputra',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('123220186'),
              SizedBox(height: 10),

              // Menu Saran dan Kesan
              ListTile(
                leading: Icon(Icons.feedback),
                title: Text('Kesan dan Saran Mata Kuliah'),
              ),
              SizedBox(height: 5),
              Text(
                'Kesan saya selama mengikuti mata kuliah Teknologi & Pemrograman Mobile yaitu Mata kuliah Teknologi dan Pemrograman Mobile memberikan pemahaman yang mendalam tentang pengembangan aplikasi mobile. Pembelajaran yang berbasis proyek membuat saya lebih memahami implementasi konsep-konsep pemrograman dalam aplikasi nyata.',
              ),
              SizedBox(height: 5),
              Text(
                'Dan untuk Saran saya selama mengikuti mata kuliah Teknologi & Pemrograman Mobile yaitu jangan kasi banyak tugas pak, mahasiswanya pusing semua gara-gara projek akhir numpuk hehe',
              ),
              Divider(),

              // Menampilkan Data Accelerometer secara vertikal
              Text(
                'Accelerometer Data:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Column(
                // Menggunakan Column untuk menampilkan data secara vertikal
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('X: $_x', style: TextStyle(fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Y: $_y', style: TextStyle(fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Z: $_z', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Tombol konversi mata uang dan waktu
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConversionScreen()),
                  );
                },
                child: Text('Menu Tambahan'),
              ),
              SizedBox(height: 10),

              // Tombol Logout
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('LOGOUT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
