import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // Untuk membuka Google Maps
import 'package:geolocator/geolocator.dart';

class StationRecommendationPage extends StatefulWidget {
  @override
  _StationRecommendationPageState createState() =>
      _StationRecommendationPageState();
}

class _StationRecommendationPageState extends State<StationRecommendationPage> {
  List<Map<String, dynamic>> _stations = [];
  Position? _currentPosition;
  bool _isLoading = true;
  final String _apiKey =
      'AIzaSyDND2z8nC7XziFpwvd0VFLHpdC0D0mEEk0'; // Ganti dengan API key milikmu

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndFetchStations();
  }

  Future<void> _getCurrentLocationAndFetchStations() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    setState(() {
      _currentPosition = position;
    });
    await _fetchNearbyStations();
  }

  Future<void> _fetchNearbyStations() async {
    if (_currentPosition == null) return;
    final lat = _currentPosition!.latitude;
    final lng = _currentPosition!.longitude;
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=10000&keyword=television%20station&type=point_of_interest&key=$_apiKey',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List<dynamic>;
      setState(() {
        _stations =
            results.map((place) {
              String imageUrl = 'assets/img/placeholder.jpg';
              if (place['photos'] != null && place['photos'].isNotEmpty) {
                final photoRef = place['photos'][0]['photo_reference'];
                imageUrl =
                    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=50&photo_reference=$photoRef&key=$_apiKey';
              }
              return {
                'name': place['name'],
                'address': place['vicinity'] ?? '',
                'latitude': place['geometry']['location']['lat'],
                'longitude': place['geometry']['location']['lng'],
                'rating': place['rating']?.toString() ?? '-',
                'imageUrl': imageUrl,
              };
            }).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_stations.isEmpty) {
      return const Center(
        child: Text('Tidak ada stasiun televisi terdekat ditemukan.'),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Rekomendasi Stasiun TV Terdekat'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF9F9F9),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        itemCount: _stations.length,
        itemBuilder: (context, index) {
          final station = _stations[index];
          double? distance;
          if (_currentPosition != null) {
            distance =
                Geolocator.distanceBetween(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                  station['latitude'],
                  station['longitude'],
                ) /
                1000;
          }
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  _openGoogleMaps(station['latitude'], station['longitude']);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar dari Google Maps jika ada, placeholder jika tidak
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                            station['imageUrl'] != null &&
                                    station['imageUrl'] !=
                                        'assets/img/placeholder.jpg'
                                ? Image.network(
                                  station['imageUrl'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          Image.asset(
                                            'assets/img/placeholder.jpg',
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                )
                                : Image.asset(
                                  'assets/img/placeholder.jpg',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    station['name'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  station['rating'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              station['address'] ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            if (distance != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  'Jarak: ${distance.toStringAsFixed(2)} km',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.directions,
                          color: Colors.orange,
                          size: 28,
                        ),
                        onPressed: () {
                          _openGoogleMaps(
                            station['latitude'],
                            station['longitude'],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
