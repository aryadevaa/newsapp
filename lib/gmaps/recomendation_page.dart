import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Untuk membuka Google Maps

class StationRecommendationPage extends StatelessWidget {
  final List<Map<String, String>> _stations = [
    {
      'name': 'TVRI Yogyakarta',
      'rating': '4.5',
      'address': 'Jl. Magelang No.km.4,5',
      'openingTime': '08:00',
      'description': 'Stasiun lokal TV nasional, parkirnya luas sekali',
      'latitude': '-7.765052081131627',
      'longitude': '110.36242086699404',
      'imageUrl': 'assets/img/placeholder.jpg',
    },
    {
      'name': 'Tvmu Stasiun Yogyakarta',
      'rating': '5.0',
      'address': 'Kantor Perusahaan, Yogyakarta',
      'openingTime': '08:00',
      'description':
          'Studio nya keren shhhh, sejuk, mana orang orangnya baik baik',
      'latitude': '-7.771722',
      'longitude': '110.375473',
      'imageUrl': 'assets/img/placeholder.jpg',
    },
    {
      'name': 'Jogja Istimewa Televisi (JITV)',
      'rating': '4.4',
      'address': 'Kota Yogyakarta, Daerah Istimewa Yogyakarta',
      'openingTime': '09:00',
      'description': 'Bagus siarannya dan memberi informasi sangat baik.',
      'latitude': '-7.766332',
      'longitude': '110.377277',
      'imageUrl': 'assets/img/placeholder.jpg',
    },
  ];

  // Fungsi untuk membuka Google Maps dengan koordinat lokasi stasiun
  _openGoogleMaps(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    // Mengonversi String menjadi Uri
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Tidak bisa membuka Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _stations.length,
        itemBuilder: (context, index) {
          final station = _stations[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.asset(station['imageUrl']!), // Gambar stasiun
              title: Text(station['name']!),
              subtitle: Text(
                '${station['rating']} ★\n${station['description']}',
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Membuka Google Maps ketika stasiun diklik
                _openGoogleMaps(
                  double.parse(station['latitude']!),
                  double.parse(station['longitude']!),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
