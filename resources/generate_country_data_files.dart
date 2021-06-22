// we are going to take a base file and replace tokens with values that we
// extracted from the data source

import 'dart:convert';
import 'dart:io';

import 'data_sources/generate_countries_aggregated_info_json.dart';
import 'package:basic_utils/basic_utils.dart' show StringUtils;

import 'data_sources/read_country_info.dart';
import 'phone_encoder.dart';

const OUTPUT_PATH = 'lib/src/generated/';
const ISO_CODE_FILE = 'iso_codes.enum.dart';
const SRC = 'package:dart_countries/src';
const ISO_CODE_IMPORT = 'import "$SRC/generated/$ISO_CODE_FILE";';
final AUTO_GEN_COMMENT =
    '// This file was auto generated on ${DateTime.now().toIso8601String()}\n\n';
String generatedContent = '';

void main() async {
  final countriesInfo = await getCountryAggregatedInfo();
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
    generateMapFileForProperty(CountryInfoKeys.dialCode, countriesInfo),
    generateMapFileForProperty(
        CountryInfoKeys.phoneNumberLengths, countriesInfo),
    // generatePhoneDescMapFile(countriesPhoneDesc),
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

Future generateMapFileForProperty(
  String property,
  Map<String, dynamic> map, [
  Function(Map countryInfo)? extractor,
]) {
  final extractorFn = extractor ?? (countryInfo) => countryInfo[property];
  final newMap = Map.fromIterable(map.keys, value: (k) => extractorFn(map[k]));
  final fileName =
      'maps/countries_${StringUtils.camelCaseToLowerUnderscore(property)}.map.dart';
  String content = ISO_CODE_IMPORT +
      'const countries${property.substring(0, 1).toUpperCase()}${property.substring(1)} = {%%};';
  String body = '';
  newMap
      .forEach((key, value) => body += 'IsoCode.${key}: ${jsonEncode(value)},');
  content = content.replaceFirst('%%', body);
  return generateFile(fileName: fileName, content: content);
}

Future generatePhoneDescMapFile(Map phoneDescs) {
  String content =
      ISO_CODE_IMPORT + 'import "$SRC/models/phone_description.dart";';
  content += 'const countriesPhoneDescription = {%%};';
  String body = '';
  phoneDescs.forEach((key, value) {
    body += 'IsoCode.$key: ${encodePhoneDescription(value)},';
  });
  content = content.replaceFirst('%%', body);
  return generateFile(
    fileName: 'maps/countries_phone_description.map.dart',
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
