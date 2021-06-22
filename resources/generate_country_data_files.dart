// we are going to take a base file and replace tokens with values that we
// extracted from the data source

import 'dart:convert';
import 'dart:io';

import 'data_sources/country_info/country_info.extractor.dart';
import 'data_sources/phone_number/phone_metadata_extractor.dart';
import 'package:basic_utils/basic_utils.dart' show StringUtils;

import 'phone_encoder.dart';

const OUTPUT_PATH = 'lib/src/generated/';
const ISO_CODE_FILE = 'iso_codes.enum.dart';
const ISO_CODE_IMPORT = 'import "./$ISO_CODE_FILE";';
final AUTO_GEN_COMMENT =
    '// This file was auto generated on ${DateTime.now().toIso8601String()}\n\n';
String generatedContent = '';

void main() async {
  final countriesInfo = await getCountryInfo();
  final countriesPhoneDesc = await getPhoneDescriptionMap();
  // remove places where phone info is null, as those places are
  // places where no one lives and also the opposite
  countriesInfo.removeWhere((key, value) => countriesPhoneDesc[key] == null);
  countriesPhoneDesc.removeWhere((key, value) => countriesInfo[key] == null);
  countriesPhoneDesc
      .forEach((key, value) => countriesInfo[key]['dialCode'] = value.dialCode);

  countriesPhoneDesc.forEach((key, value) {
    countriesInfo[key]['phoneNumberLengths'] = {
      'mobile': value.validation.mobile.lengths,
      'fixedLine': value.validation.fixedLine.lengths,
    };
  });
  await Future.wait([
    generateIsoCodeEnum(countriesInfo),
    generateCountryList(countriesInfo),
    generateIsoCodeConversionMap(countriesInfo),
    generateMapFileForProperty(CountryInfoKeys.name, countriesInfo),
    generateMapFileForProperty(CountryInfoKeys.native, countriesInfo),
    generateMapFileForProperty(CountryInfoKeys.capital, countriesInfo),
    generateMapFileForProperty(CountryInfoKeys.continent, countriesInfo),
    generateMapFileForProperty(CountryInfoKeys.currency, countriesInfo),
    generateMapFileForProperty(CountryInfoKeys.languages, countriesInfo),
    generateMapFileForProperty(CountryInfoKeys.flag, countriesInfo),
    generateMapFileForProperty('dialCode', countriesInfo),
    generateMapFileForProperty('phoneNumberLengths', countriesInfo),
    generatePhoneDescFile(countriesPhoneDesc),
  ]);
  generateFile(fileName: 'generated.dart', content: generatedContent);
}

Future generateIsoCodeEnum(Map<String, dynamic> countries) {
  String content = 'enum IsoCode {';
  countries.keys.forEach((key) => content += '${key},');
  content += '}';
  return generateFile(fileName: ISO_CODE_FILE, content: content);
}

Future generateCountryList(Map countries) {
  String content = ISO_CODE_IMPORT + 'import "../models/country.dart";';
  content += 'const countries = [%%];';
  String body = '';
  countries.forEach((key, value) => body += 'Country(IsoCode.${key}),');
  content = content.replaceFirst('%%', body);
  return generateFile(fileName: 'countries.list.dart', content: content);
}

Future generateIsoCodeConversionMap(Map countries) {
  String content = ISO_CODE_IMPORT;
  content += 'const isoCodeConversionMap = {%%};';
  String body = '';
  countries.forEach((key, value) => body += '"${key}": IsoCode.${key},');
  content = content.replaceFirst('%%', body);
  return generateFile(
      fileName: 'iso_code_conversion.map.dart', content: content);
}

Future generateMapFileForProperty(String property, Map<String, dynamic> map) {
  final newMap = Map.fromIterable(map.keys, value: (k) => map[k][property]);
  final fileName =
      'countries_${StringUtils.camelCaseToLowerUnderscore(property)}.map.dart';
  String content = ISO_CODE_IMPORT +
      'const countries${StringUtils.capitalize(property)} = {%%};';
  String body = '';
  newMap
      .forEach((key, value) => body += 'IsoCode.${key}: ${jsonEncode(value)},');
  content = content.replaceFirst('%%', body);
  return generateFile(fileName: fileName, content: content);
}

Future generatePhoneDescFile(Map phoneDescs) {
  String content =
      ISO_CODE_IMPORT + 'import "../models/phone_description.dart";';
  content += 'const countriesPhoneDescription = {%%};';
  String body = '';
  phoneDescs.forEach((key, value) {
    body += 'IsoCode.$key: ${encodePhoneDescription(value)},';
  });
  content = content.replaceFirst('%%', body);
  return generateFile(
    fileName: 'countries_phone_description.map.dart',
    content: content,
  );
}

Future generateFile({
  required String fileName,
  required String content,
}) async {
  final file = await File(OUTPUT_PATH + fileName).create(recursive: true);
  content = AUTO_GEN_COMMENT + content;
  await file.writeAsString(content);
  generatedContent += 'export "$fileName";';
}
