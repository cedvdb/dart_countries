import 'dart:convert';

import 'package:dart_countries/src/generated/countries_capital.dart';
import 'package:dart_countries/src/generated/countries_continent.dart';
import 'package:dart_countries/src/generated/countries_currency.dart';
import 'package:dart_countries/src/generated/countries_languages.dart';
import 'package:dart_countries/src/generated/countries_name.dart';
import 'package:dart_countries/src/generated/countries_native.dart';

import 'phone_description.dart';

/// Country regroup informations for displaying a list of countries
class Country {
  /// English name of the country
  String get name => countriesName[isoCode]!;

  /// The naame as the native would spell it
  String get nativeName => countriesNative[isoCode]!;
  String get capital => countriesCapital[isoCode]!;
  String get continent => countriesContinent[isoCode]!;
  List<String> get languages => countriesLanguages[isoCode]!;
  String get currencyCode => countriesCurrency[isoCode]!;

  /// emoji flag
  final String flag;

  /// short country code
  final String isoCode;

  /// description of what the country's phone number scheme
  final PhoneDescription phoneDescription;

  /// country dialing code to call them internationally
  String get dialCode => phoneDescription.dialCode;

  /// returns "+ [dialCode]"
  String get displayDialCode => '+ $dialCode';

  const Country({
    required this.name,
    required this.nativeName,
    required this.capital,
    required this.continent,
    required this.languages,
    required this.currencyCode,
    required this.flag,
    required this.isoCode,
    required this.phoneDescription,
  });

  static Country fromIsoCode(String isoCode) {
    final country = countriesByIsoCode[isoCode.toUpperCase()];
    if (country == null) throw 'Invalid isoCode $isoCode';
    return country;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nativeName': nativeName,
      'capital': capital,
      'continent': continent,
      'languages': languages,
      'currencyCode': currencyCode,
      'flag': flag,
      'isoCode': isoCode,
      'phoneDescription': phoneDescription.toMap(),
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      name: map['name'],
      nativeName: map['nativeName'],
      capital: map['capital'],
      continent: map['continent'],
      languages: List<String>.from(map['languages']),
      currencyCode: map['currencyCode'],
      flag: map['flag'],
      isoCode: map['isoCode'],
      phoneDescription: PhoneDescription.fromMap(map['phoneDescription']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Country.fromJson(String source) =>
      Country.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Country(name: $name, nativeName: $nativeName, capital: $capital, continent: $continent, languages: $languages, currencyCode: $currencyCode, flag: $flag, isoCode: $isoCode, phoneDescription: $phoneDescription)';
  }
}
