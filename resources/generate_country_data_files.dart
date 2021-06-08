// we are going to take a base file and replace tokens with values that we
// extracted from the data source

import 'dart:convert';
import 'dart:io';

import 'package:dart_countries/src/models/country.dart';
import 'package:dart_countries/src/models/phone_description.dart';

import 'generate_countries.dart';

const String DATA_TOKEN = '// data here';
const String COMMENT_TOKEN = '// comment here';
const String comment = '// This file was auto generated';
const String INPUT_PATH = 'resources/template_files';
const String TEMPLATE_COUNTRY_LIST = '$INPUT_PATH/template_country_list.dart';
const String TEMPLATE_COUNTRY_BY_ISO_CODE =
    '$INPUT_PATH/template_country_by_iso_code.dart';
const String TEMPLATE_COUNTRY_BY_DIAL_CODE =
    '$INPUT_PATH/template_country_by_dial_code.dart';
const String OUTPUT_PATH = 'lib/src/generated';
const String OUTPUT_LIST = '$OUTPUT_PATH/country_list.dart';
const String OUTPUT_BY_DIAL_CODE =
    '$OUTPUT_PATH/countries_by_dial_code_map.dart';
const String OUTPUT_BY_ISO_CODE = '$OUTPUT_PATH/countries_by_iso_code_map.dart';

void main() async {
  final countries = await getCountries();
  await createList(countries);
  await createByIsoCode(toIsoCodeMap(countries));
  await createByDialCode(toDialCodeMap(countries));
}

Future createList(List<Country> countries) async {
  final baseContent = await File(TEMPLATE_COUNTRY_LIST).readAsString();
  final dataOutput = getCountryListString(countries);
  final output = baseContent.replaceFirst(COMMENT_TOKEN, comment).replaceFirst(
        DATA_TOKEN,
        dataOutput,
      );
  final file = await File(OUTPUT_LIST).create(recursive: true);
  return file.writeAsString(output);
}

Future createByIsoCode(Map<String, Country> byIsoCode) async {
  final baseContent = await File(TEMPLATE_COUNTRY_BY_ISO_CODE).readAsString();
  final dataOutput = byIsoCode.entries.fold<String>(
      '', (a, b) => a + '"${b.key}": const ' + countryString(b.value) + ',\n');
  final output = baseContent.replaceFirst(COMMENT_TOKEN, comment).replaceFirst(
        DATA_TOKEN,
        dataOutput,
      );
  final file = await File(OUTPUT_BY_ISO_CODE).create(recursive: true);
  return file.writeAsString(output);
}

Future createByDialCode(Map<String, List<Country>> byDialCode) async {
  final baseContent = await File(TEMPLATE_COUNTRY_BY_DIAL_CODE).readAsString();
  final dataOutput = byDialCode.entries.fold<String>(
      '',
      (a, b) =>
          a + '"${b.key}": [\n' + getCountryListString(b.value) + '\n],\n');
  final output = baseContent.replaceFirst(COMMENT_TOKEN, comment).replaceFirst(
        DATA_TOKEN,
        dataOutput,
      );
  final file = await File(OUTPUT_BY_DIAL_CODE).create(recursive: true);
  return file.writeAsString(output);
}

String getCountryListString(List<Country> countries) {
  return countries.fold<String>(
      '', (a, b) => a + 'const ${countryString(b)}' + ',\n');
}

String countryString(Country country) {
  // this is a bit verbose but it's to have constants
  return '''Country(
  name: ${enc(country.name)}, 
  nativeName: ${enc(country.nativeName)},
  capital: ${enc(country.capital)},
  continent: ${enc(country.continent)},
  languages: ${enc(country.languages)},
  currencyCode: ${enc(country.currencyCode)},
  flag: ${enc(country.flag)}, 
  isoCode: ${enc(country.isoCode)}, 
  phoneDescription: ${phoneDescriptionString(country.phoneDescription)}, 
  )''';
}

String phoneDescriptionString(PhoneDescription desc) {
  return '''PhoneDescription(
      dialCode: ${enc(desc.dialCode)}, 
      leadingDigits: ${enc(desc.leadingDigits)},
      internationalPrefix: ${enc(desc.internationalPrefix)}, 
      nationalPrefix: ${enc(desc.nationalPrefix)},
      nationalPrefixForParsing: ${enc(desc.nationalPrefixForParsing)},
      nationalPrefixTransformRule: ${enc(desc.nationalPrefixTransformRule)},
      isMainCountryForDialCode: ${enc(desc.isMainCountryForDialCode)},
      validation: ${phoneValidationString(desc.validation)},
    )''';
}

String phoneValidationString(PhoneValidation v) {
  return '''PhoneValidation(
        general: ${phoneValidationRulesString(v.general)}, 
        mobile: ${phoneValidationRulesString(v.mobile)}, 
        fixedLine: ${phoneValidationRulesString(v.fixedLine)}, 
      )''';
}

String phoneValidationRulesString(PhoneValidationRules r) {
  return '''PhoneValidationRules(lengths: ${enc(r.lengths)}, pattern: ${enc(r.pattern)},)''';
}

String enc(v) {
  if (v is String) return 'r"$v"';
  if (v == null) return 'null';
  return jsonEncode(v);
}
