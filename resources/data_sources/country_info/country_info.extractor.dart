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
  static final String flag = 'flag';
}

/// reads the json file of country names which is an array of country information
Future<Map<String, dynamic>> getCountryInfo() async {
  final filePath = 'resources/data_sources/country_info/country_info.json';
  final jsonString = await File(filePath).readAsString();
  Map<String, dynamic> info = jsonDecode(jsonString);
  info.forEach((key, value) =>
      info[key][CountryInfoKeys.flag] = _generateFlagEmojiUnicode(key));
  // keep only main currency
  info.forEach((key, value) {
    final main = info[key][CountryInfoKeys.currency].split(',').first;
    info[key][CountryInfoKeys.currency] = main;
  });
  return info;
}

String _generateFlagEmojiUnicode(String isoCode) {
  final base = 127397;
  return isoCode.codeUnits
      .map((e) => String.fromCharCode(base + e))
      .toList()
      .reduce((value, element) => value + element)
      .toString();
}
