// we are going to take a base file and replace tokens with values that we
// extracted from the data source

import 'dart:convert';
import 'dart:io';

import 'data_sources/country_info/country_info.extractor.dart';
import 'data_sources/phone_number/phone_metadata_extractor.dart';
import 'package:basic_utils/basic_utils.dart' show StringUtils;

import 'phone_encoder.dart';

const OUTPUT_PATH = 'lib/src/generated/';
const ISO_CODE_FILE = './iso_codes.enum.dart';
const ISO_CODE_IMPORT = 'import "./$ISO_CODE_FILE";';
final AUTO_GEN_COMMENT =
    '// This file was auto generated on ${DateTime.now().toIso8601String()}\n\n';

void main() async {
  final countriesInfo = await getCountryInfo();
  final countriesPhoneDesc = await getPhoneDescriptionMap();
  // remove places where phone info is null, as those places are
  // places where no one lives and also the opposite
  countriesInfo.removeWhere((key, value) => countriesPhoneDesc[key] == null);
  countriesPhoneDesc.removeWhere((key, value) => countriesInfo[key] == null);
  generateIsoCodeEnum(countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.name, countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.native, countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.capital, countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.continent, countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.currency, countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.languages, countriesInfo);
  generateMapFileForProperty(CountryInfoKeys.flag, countriesInfo);
  countriesPhoneDesc
      .forEach((key, value) => countriesInfo[key]['dialCode'] = value.dialCode);
  generateMapFileForProperty('dialCode', countriesInfo);

  countriesPhoneDesc.forEach((key, value) {
    countriesInfo[key]['phoneNumberLengths'] = {
      'mobile': value.validation.mobile.lengths,
      'fixedLine': value.validation.fixedLine.lengths,
    };
  });
  generateMapFileForProperty('phoneNumberLengths', countriesInfo);
  generatePhoneDescFile(countriesPhoneDesc);
}

generateIsoCodeEnum(Map<String, dynamic> map) {
  String content = 'enum IsoCode {';
  map.keys.forEach((key) => content += '${key},');
  content += '}';
  generateFile(fileName: ISO_CODE_FILE, content: content);
}

generateMapFileForProperty(String property, Map<String, dynamic> map) {
  final newMap = Map.fromIterable(map.keys, value: (k) => map[k][property]);
  final fileName =
      'countries_${StringUtils.camelCaseToLowerUnderscore(property)}.map.dart';
  String content = ISO_CODE_IMPORT +
      'const countries${StringUtils.capitalize(property)} = {';
  newMap.forEach(
      (key, value) => content += 'IsoCode.${key}: ${jsonEncode(value)},');
  content += '};';
  generateFile(fileName: fileName, content: content);
}

generatePhoneDescFile(Map phoneDescs) {
  var content = ISO_CODE_IMPORT + 'import "../models/phone_description.dart";';
  content += 'const countriesPhoneDescription = {';
  phoneDescs.forEach((key, value) {
    content += 'IsoCode.$key: ${encodePhoneDescription(value)},';
  });
  content += '};';
  generateFile(
    fileName: 'countries_phone_description.map.dart',
    content: content,
  );
}

generateFile({required String fileName, required String content}) async {
  final file = await File(OUTPUT_PATH + fileName).create(recursive: true);
  content = AUTO_GEN_COMMENT + content;
  return file.writeAsString(content);
}
