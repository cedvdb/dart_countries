import 'dart:convert';
import 'dart:io';

/// reads the json file of country names which is an array of country information
Future<Map<String, dynamic>> readCountryInfo() async {
  final filePath = 'resources/countries_info.json';
  final jsonString = await File(filePath).readAsString();
  Map<String, dynamic> info = jsonDecode(jsonString);
  return info;
}
