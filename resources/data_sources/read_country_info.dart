import 'dart:convert';
import 'dart:io';

/// reads the json file of country names which is an array of country information
Future<Map<String, dynamic>> getCountryAggregatedInfo() async {
  final filePath = 'resources/data_sources/countries_aggregated_info.json';
  final jsonString = await File(filePath).readAsString();
  Map<String, dynamic> info = jsonDecode(jsonString);
  return info;
}
