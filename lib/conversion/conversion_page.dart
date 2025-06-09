import 'package:flutter/material.dart';
import 'package:newsapp/conversion/currency_conversion_page.dart.dart';
import 'package:newsapp/gmaps/recomendation_page.dart';
import 'time_conversion_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: ConversionScreen(),
    );
  }
}

class ConversionScreen extends StatefulWidget {
  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  int currentIndex = 0;

  // Menambahkan halaman baru ke dalam list
  final List<Widget> _pages = [
    CurrencyConversionPage(),
    TimeConversionPage(),
    StationRecommendationPage(), // Halaman baru untuk rekomendasi stasiun TV
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Tambahan'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Mata Uang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Waktu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Stasiun TV', // Halaman baru
          ),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
    );
  }
}
