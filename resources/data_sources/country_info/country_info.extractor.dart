import 'dart:convert';
import 'dart:io';

import 'country_info.dart';

// this file is responsible of extracting the data from the country_names.json

/// returns a map of { countryCode: countryName }
Future<Map<String, CountryInfo>> getCountryInfosMap() async {
  final countryInfos = await _readCountryNameJson();
  final result = <String, CountryInfo>{};
  countryInfos.entries.forEach(
    (entry) => result[entry.key] = CountryInfo(
      name: entry.value['name'],
      nativeName: entry.value['native'],
      capital: entry.value['capital'],
      continent: entry.value['continent'],
      languages: (entry.value['languages'] as List)
          .map((el) => el as String)
          .cast<String>()
          .toList(),
      currencyCode: (entry.value['currency'] as String).split(',').first,
    ),
  );
  return result;
}

/// reads the json file of country names which is an array of country information
Future<Map<String, dynamic>> _readCountryNameJson() async {
  final filePath = 'resources/data_sources/country_info/country_info.json';
  final jsonString = await File(filePath).readAsString();
  return jsonDecode(jsonString);
}
