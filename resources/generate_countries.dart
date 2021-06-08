import 'package:dart_countries/src/models/country.dart';

import 'data_sources/country_info/country_info.extractor.dart';
import 'data_sources/phone_number/phone_metadata_extractor.dart';

/// generates the country instances via the source files
Future<List<Country>> getCountries() async {
  final namesMap = await getCountryInfosMap();
  final phoneDescriptionMap = await getPhoneDescriptionMap();
  return namesMap.entries
      .where((entry) => phoneDescriptionMap.containsKey(entry.key))
      .map(
    (entry) {
      try {
        return Country(
          name: entry.value.name,
          nativeName: entry.value.nativeName,
          capital: entry.value.capital,
          continent: entry.value.continent,
          currencyCode: entry.value.currencyCode,
          languages: entry.value.languages,
          flag: _generateFlagEmojiUnicode(entry.key),
          isoCode: entry.key,
          phoneDescription: phoneDescriptionMap[entry.key]!,
        );
      } catch (e) {
        print(e);
        throw 'exception on ${entry.key} ${entry.value}';
      }
    },
  ).toList();
}

/// Returns a [String] which will be the unicode of a Flag Emoji,
/// from a country [isoCode] passed as a parameter.
String _generateFlagEmojiUnicode(String isoCode) {
  final base = 127397;
  return isoCode.codeUnits
      .map((e) => String.fromCharCode(base + e))
      .toList()
      .reduce((value, element) => value + element)
      .toString();
}

/// given a list of countries we make a map to access them by isoCode
Map<String, Country> toIsoCodeMap(List<Country> countries) {
  final map = <String, Country>{};
  countries.forEach((element) {
    if (map[element.isoCode] != null) {
      throw 'duplicated country code';
    }
    map[element.isoCode] = element;
  });
  return map;
}

Map<String, List<Country>> toDialCodeMap(List<Country> countries) {
  final map = <String, List<Country>>{};
  countries.forEach((element) {
    if (map[element.dialCode] == null) {
      map[element.dialCode] = [];
    }
    // we insert the main country at the start of the array so it's easy to find
    if (element.phoneDescription.isMainCountryForDialCode == true) {
      map[element.dialCode]!.insert(0, element);
    } else {
      map[element.dialCode]!.add(element);
    }
  });
  return map;
}
