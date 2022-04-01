// we are going to take a base file and replace tokens with values that we
// extracted from the data source

import 'dart:convert';
import 'dart:io';

import 'country_info_reader.dart';
import 'package:basic_utils/basic_utils.dart' show StringUtils;

const OUTPUT_PATH = 'lib/src/generated/';
const ISO_CODE_FILE = 'iso_codes.enum.dart';
const SRC = 'package:dart_countries/src';
// const ISO_CODE_IMPORT = 'import "$SRC/generated/$ISO_CODE_FILE";';
final AUTO_GEN_COMMENT =
    '// This file was auto generated on ${DateTime.now().toIso8601String()}\n\n';

/// this file generates all the dart files from the json file
void main() async {
  // read json
  final countriesInfo = await readCountryInfo();

  String generatedContent = '';

  final addedExports = await Future.wait([
    generateIsoCodeEnum(countriesInfo),
    generateCountryList(countriesInfo),
    // generateIsoCodeConversionMap(countriesInfo),
    // iso code to property
    // generateIsoCodeSet(countriesInfo),
    generateIsoCodeToPropertyMapFile('name', countriesInfo),
    generateIsoCodeToPropertyMapFile('nativeName', countriesInfo),
    generateIsoCodeToPropertyMapFile('continent', countriesInfo),
    generateIsoCodeToPropertyMapFile('capital', countriesInfo),
    generateIsoCodeToPropertyMapFile('currencyCode', countriesInfo),
    generateIsoCodeToPropertyMapFile('languages', countriesInfo),
    generateIsoCodeToPropertyMapFile(
      'countryCode',
      countriesInfo,
      isIntValue: true,
    ),
    generateIsoCodeToPropertyMapFile('flag', countriesInfo),
  ]);

  generatedContent = addedExports.join('');
  generateFile(fileName: 'generated.dart', content: generatedContent);
}

/// generates all isoCodes
Future<String> generateIsoCodeEnum(Map<String, dynamic> countries) {
  String content = 'enum IsoCode {';
  countries.keys.forEach((key) => content += '${key},');
  content += '}';
  return generateFile(fileName: ISO_CODE_FILE, content: content);
}

/// generate isoCodeSet
Future<String> generateIsoCodeSet(Map<String, dynamic> countriesInfo) {
  var isoCodes = countriesInfo.keys;
  String content = 'const isoCodes = {%%};';
  String body = '';
  isoCodes.forEach((iso) => body += "'${iso}',");
  content = content.replaceFirst('%%', body);
  return generateFile(fileName: 'iso_code_set.dart', content: content);
}

/// generate country list
Future<String> generateCountryList(Map countries) {
  String content = "import '../country.dart';";
  content += "import 'iso_codes.enum.dart';";
  content += 'const countries = [%%];';
  String body = '';
  countries.forEach((key, value) => body += "const Country(IsoCode.$key),");
  content = content.replaceFirst('%%', body);
  return generateFile(fileName: 'countries.list.dart', content: content);
}

/// generate a conversion map for going from a string like "US" to IsoCode.US
// Future<String> generateIsoCodeConversionMap(Map countries) {
//   String content = ISO_CODE_IMPORT;
//   content += 'const isoCodeConversionMap = {%%};';
//   String body = '';
//   countries.forEach((key, value) => body += '"${key}": IsoCode.${key},');
//   content = content.replaceFirst('%%', body);
//   return generateFile(
//       fileName: 'iso_code_conversion.map.dart', content: content);
// }

/// generates a map where the iso code is the key and the property is the value
/// returns a string that is what should be added to the barrel to export the generated
/// file
Future<String> generateIsoCodeToPropertyMapFile(
  String property,
  Map<String, dynamic> map, {
  bool isIntValue = false,
}) {
  final extractorFn = (countryInfo) => countryInfo[property];
  final newMap = Map.fromIterable(map.keys, value: (k) => extractorFn(map[k]));
  final fileName =
      'maps/countries_${StringUtils.camelCaseToLowerUnderscore(property)}.map.dart';
  String content = '''import '../iso_codes.enum.dart';
  const countries${property.substring(0, 1).toUpperCase()}${property.substring(1)} = {%%};''';
  String body = '';
  newMap.forEach((key, value) {
    if (isIntValue)
      body += "IsoCode.$key: $value,";
    else
      body += "IsoCode.$key: ${jsonEncode(value)},";
  });
  content = content.replaceFirst('%%', body);
  return generateFile(fileName: fileName, content: content);
}

Future<String> generateFile({
  required String fileName,
  required String content,
}) async {
  final file = await File(OUTPUT_PATH + fileName).create(recursive: true);
  content = AUTO_GEN_COMMENT + content;
  await file.writeAsString(content);
  return "export '$fileName';";
}
