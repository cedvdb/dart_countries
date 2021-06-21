import 'dart:convert';
import 'dart:io';

// this file is responsible of extracting the data from the country_names.json

class CountryInfoKeys {
  static final String name = 'name';
  static final String native = 'native';
  static final String capital = 'capital';
  static final String continent = 'continent';
  static final String languages = 'languages';
  static final String currency = 'currency';
}

/// reads the json file of country names which is an array of country information
Future<Map<String, dynamic>> getCountryInfo() async {
  final filePath = 'resources/data_sources/country_info/country_info.json';
  final jsonString = await File(filePath).readAsString();
  return jsonDecode(jsonString);
}
