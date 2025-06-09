import 'package:flutter/material.dart';

class CurrencyConversionPage extends StatefulWidget {
  @override
  _CurrencyConversionPageState createState() => _CurrencyConversionPageState();
}

class _CurrencyConversionPageState extends State<CurrencyConversionPage> {
  double amount = 1.0;
  double convertedAmount = 0.0;
  String selectedCurrency = 'USD';
  final List<String> currencies = ['USD', 'EUR', 'IDR'];

  void convertCurrency() {
    setState(() {
      if (selectedCurrency == 'USD') {
        convertedAmount = amount * 1.0;
      } else if (selectedCurrency == 'EUR') {
        convertedAmount = amount * 0.85;
      } else if (selectedCurrency == 'IDR') {
        convertedAmount = amount * 15000.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            'Konversi Mata Uang',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (text) {
              setState(() {
                amount = double.tryParse(text) ?? 1.0;
              });
              convertCurrency();
            },
            decoration: InputDecoration(
              labelText: 'Jumlah Uang (USD)',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          DropdownButton<String>(
            value: selectedCurrency,
            onChanged: (String? newValue) {
              setState(() {
                selectedCurrency = newValue!;
              });
              convertCurrency();
            },
            items:
                currencies.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
          ),
          SizedBox(height: 20),
          Text(
            'Hasil Konversi: $convertedAmount $selectedCurrency',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
