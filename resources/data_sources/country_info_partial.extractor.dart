import 'dart:convert';
import 'dart:io';

/// reads the json file of country names which is an array of country information
Future<Map<String, dynamic>> getCountryInfoPartial() async {
  final filePath =
      'resources/data_sources/country_info_partial/country_info_partial.json';
  final jsonString = await File(filePath).readAsString();
  Map<String, dynamic> info = jsonDecode(jsonString);
  return info;
}
