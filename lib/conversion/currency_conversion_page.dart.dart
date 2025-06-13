import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrencyConversionPage extends StatefulWidget {
  @override
  _CurrencyConversionPageState createState() => _CurrencyConversionPageState();
}

class _CurrencyConversionPageState extends State<CurrencyConversionPage> {
  double amount = 1.0;
  String selectedCurrency1 = 'USD';
  String selectedCurrency2 = 'IDR';
  final List<String> currencies = ['USD', 'EUR', 'IDR', 'JPY', 'GBP'];

  String formatCurrency(double amount, String currency) {
    final formatter = NumberFormat.currency(
      symbol: getCurrencySymbol(currency),
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  String getCurrencySymbol(String currency) {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'IDR':
        return 'Rp ';
      case 'JPY':
        return '¥';
      case 'GBP':
        return '£';
      default:
        return '';
    }
  }

  double convertCurrency(double amount, String fromCurrency, String toCurrency) {
    // Kurs tetap (dalam praktik nyata, ini seharusnya mengambil dari API)
    Map<String, double> rates = {
      'USD': 1.0,
      'EUR': 0.85,
      'IDR': 15000.0,
      'JPY': 110.0,
      'GBP': 0.73,
    };

    // Konversi ke USD dulu (mata uang dasar)
    double amountInUSD = amount / rates[fromCurrency]!;
    // Kemudian konversi ke mata uang tujuan
    return amountInUSD * rates[toCurrency]!;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    'Pilih Mata Uang',
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
                            Text('Dari:'),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: selectedCurrency1,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCurrency1 = newValue!;
                                });
                              },
                              items: currencies.map<DropdownMenuItem<String>>((String value) {
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
                            Text('Ke:'),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: selectedCurrency2,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCurrency2 = newValue!;
                                });
                              },
                              items: currencies.map<DropdownMenuItem<String>>((String value) {
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
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jumlah',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      setState(() {
                        amount = double.tryParse(text) ?? 1.0;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Masukkan jumlah',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hasil Konversi',
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
                              selectedCurrency1,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              formatCurrency(amount, selectedCurrency1),
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
                              selectedCurrency2,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              formatCurrency(
                                convertCurrency(amount, selectedCurrency1, selectedCurrency2),
                                selectedCurrency2,
                              ),
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
      ),
    );
  }
}
