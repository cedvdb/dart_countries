import 'dart:convert';

import 'package:dart_countries/dart_countries.dart';
import 'package:dart_countries/src/generated/generated.dart';

/// Country regroup informations for displaying a list of countries
class Country {
  final IsoCode isoCode;

  /// English name of the country
  String get name => countriesName[isoCode]!;

  /// The naame as the native would spell it
  String get nativeName => countriesNativeName[isoCode]!;
  String get capital => countriesCapital[isoCode]!;
  String get continent => countriesContinent[isoCode]!;
  List<String> get languages => countriesLanguages[isoCode]!;
  String get currencyCode => countriesCurrencyCode[isoCode]!;

  /// emoji flag
  String get flag => countriesFlag[isoCode]!;

  /// country calling code to call them internationally
  int get countryCode => countriesCountryCode[isoCode]!;

  /// returns "+ [countryCode]"
  String get displayDialCode => '+ $countryCode';

  const Country(this.isoCode);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nativeName': nativeName,
      'capital': capital,
      'continent': continent,
      'languages': languages,
      'currencyCode': currencyCode,
      'flag': flag,
      'isoCode': isoCode.name,
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(IsoCode.values.byName(map['isoCode']));
  }

  String toJson() => json.encode(toMap());

  factory Country.fromJson(String source) =>
      Country.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Country(name: $name, nativeName: $nativeName, capital: $capital, continent: $continent, languages: $languages, currencyCode: $currencyCode, flag: $flag, isoCode: $isoCode)';
  }
}
