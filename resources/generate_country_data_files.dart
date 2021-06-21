// we are going to take a base file and replace tokens with values that we
// extracted from the data source

import 'dart:convert';
import 'dart:io';

import 'data_sources/country_info/country_info.extractor.dart';
import 'data_sources/phone_number/phone_metadata_extractor.dart';
import 'package:basic_utils/basic_utils.dart' show StringUtils;

import 'phone_encoder.dart';

const String OUTPUT_PATH = 'lib/src/generated/';

void main() async {
  final countriesInfo = await getCountryInfo();
  final countriesPhoneDesc = await getPhoneDescriptionMap();
  // remove places where phone info is null, as those places are
  // places where no one lives
  countriesInfo.removeWhere((key, value) => countriesPhoneDesc[key] == null);
  generateMapFileForProperty(CountryInfoKeys.name, countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.native, countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.capital, countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.continent, countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.currency, countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.languages, countriesInfo);
  generateMapFileForProperty(
    'dialCode',
    Map.fromIterable(
      countriesPhoneDesc.entries,
      key: (entry) => entry.key,
      value: (entry) => entry.value.toMap(),
    ),
  );
  generateMapFileForProperty(
    'phoneNumberLengths',
    Map.fromIterable(
      countriesPhoneDesc.entries,
      key: (entry) => entry.key,
      value: (entry) => {
        'phoneNumberLengths': {
          'mobile': entry.value.validation.mobile.lengths,
          'fixedLine': entry.value.validation.fixedLine.lengths,
        }
      },
    ),
  );

  generateMapFileForProperty(
    'phoneDescription',
    Map.fromIterable(
      countriesPhoneDesc.entries,
      key: (entry) => entry.key,
      value: (entry) =>
          {'phoneDescription': encodePhoneDescription(entry.value)},
    ),
  );
}

generateMapFileForProperty(String property, Map<String, dynamic> map) {
  final newMap = Map.fromIterable(map.keys, value: (k) => map[k][property]);
  final fileName =
      'countries_${StringUtils.camelCaseToLowerUnderscore(property)}.dart';
  final content =
      'const countries${StringUtils.capitalize(property)} = ${jsonEncode(newMap)};';
  _generateFile(fileName: fileName, content: content);
}

_generateFile({required String fileName, required String content}) async {
  final file = await File(OUTPUT_PATH + fileName).create(recursive: true);
  content =
      '// This file was auto generated on ${DateTime.now().toIso8601String()}\n\n' +
          content;
  return file.writeAsString(content);
}
