// we are going to take a base file and replace tokens with values that we
// extracted from the data source

import 'dart:convert';
import 'dart:io';

import 'data_sources/country_info/country_info.extractor.dart';
import 'data_sources/phone_number/phone_metadata_extractor.dart';

const String OUTPUT_PATH = 'lib/src/generated/';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

void main() async {
  final countriesInfo = await getCountryInfo();
  final countriesPhoneDesc = await getPhoneDescriptionMap();
  // add phone info to the country info
  final phoneKey = 'phone';
  countriesPhoneDesc.entries
      .forEach((entry) => countriesInfo[entry.key][phoneKey] = entry.value);
  // remove places where phone info is null
  countriesInfo.removeWhere((key, value) => value[phoneKey] == null);
  generateMapFileForProperty(CountryInfoKeys.name, countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.native, countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.capital, countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.continent, countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.currency, countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.languages, countriesInfo);
  generateMapFileForProperty(
      'dialCode', countriesInfo, (c) => c.phone.dialCode);
}

generateMapFileForProperty(String property, Map<String, dynamic> map) {
  final newMap = Map.fromIterable(map.keys, value: (k) => map[k][property]);
  final fileName = 'countries_$property.dart';
  final content =
      'const countries${property.capitalize()} = ${jsonEncode(newMap)};';
  _generateFile(fileName: fileName, content: content);
}

_generateFile({required String fileName, required String content}) async {
  final file = await File(OUTPUT_PATH + fileName).create(recursive: true);
  content =
      '// This file was auto generated on ${DateTime.now().toIso8601String()}\n\n' +
          content;
  return file.writeAsString(content);
}
