import 'dart:convert';
import 'dart:io';

import 'country_info_partial.extractor.dart';
import 'phone_number/phone_metadata_extractor.dart';

// merge various data sources into a single json file

class CountryInfoKeys {
  static final String name = 'name';
  static final String native = 'nativeName';
  static final String capital = 'capital';
  static final String continent = 'continent';
  static final String languages = 'languages';
  static final String currency = 'currencyCode';
  static final String flag = 'flag';
  static final String dialCode = 'dialCode';
  static final String phoneNumberLengths = 'phoneNumberLengths';
  static final String phoneDescription = 'phoneDescription';
}

void main() async {
  final countriesInfo = await getCountryInfoPartial();
  final countriesPhoneDesc = await getPhoneDescriptionMap();
  // remove places where phone info is null, as those places are
  // places where no one lives and also the opposite
  countriesInfo.removeWhere((key, value) => countriesPhoneDesc[key] == null);
  countriesPhoneDesc.removeWhere((key, value) => countriesInfo[key] == null);
  countriesPhoneDesc.forEach((key, value) {
    // add flag information
    countriesInfo[key][CountryInfoKeys.flag] = _generateFlagEmojiUnicode(key);
    // // we put the dial code at the root because it is an important info
    countriesInfo[key][CountryInfoKeys.dialCode] = value.dialCode;
    // add phone number lengths as it could be used for light validation
    // countriesInfo[key][CountryInfoKeys.phoneNumberLengths] = {
    //   'mobile': value.validation.mobile.lengths,
    //   'fixedLine': value.validation.fixedLine.lengths,
    // };
    // // add extended phone description
    // countriesInfo[key][CountryInfoKeys.phoneDescription] = value.toMap();
  });
  JsonEncoder encoder = JsonEncoder.withIndent('  ');
  generateFile(
      fileName: 'countries_aggregated_info.json',
      content: encoder.convert(countriesInfo));
}

String _generateFlagEmojiUnicode(String isoCode) {
  final base = 127397;
  return isoCode.codeUnits
      .map((e) => String.fromCharCode(base + e))
      .toList()
      .reduce((value, element) => value + element)
      .toString();
}

Future generateFile({
  required String fileName,
  required String content,
}) async {
  final file =
      await File('resources/data_sources/' + fileName).create(recursive: true);
  await file.writeAsString(content);
}
