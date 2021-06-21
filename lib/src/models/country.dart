import 'dart:convert';

import 'package:dart_countries/src/generated/countries_capital.dart';
import 'package:dart_countries/src/generated/countries_continent.dart';
import 'package:dart_countries/src/generated/countries_currency.dart';
import 'package:dart_countries/src/generated/countries_dial_code.dart';
import 'package:dart_countries/src/generated/countries_flag.dart';
import 'package:dart_countries/src/generated/countries_languages.dart';
import 'package:dart_countries/src/generated/countries_name.dart';
import 'package:dart_countries/src/generated/countries_native.dart';
import 'package:dart_countries/src/generated/countries_phone_description.dart';

import 'phone_description.dart';

/// Country regroup informations for displaying a list of countries
class Country {
  final String isoCode;

  /// English name of the country
  String get name => countriesName[isoCode]!;

  /// The naame as the native would spell it
  String get nativeName => countriesNative[isoCode]!;
  String get capital => countriesCapital[isoCode]!;
  String get continent => countriesContinent[isoCode]!;
  List<String> get languages => countriesLanguages[isoCode]!;
  String get currencyCode => countriesCurrency[isoCode]!;

  /// emoji flag
  String get flag => countriesFlag[isoCode]!;

  /// description of what the country's phone number scheme
  PhoneDescription get phoneDescription => countriesPhoneDescription[isoCode]!;

  /// country dialing code to call them internationally
  String get dialCode => countriesDialcode[isoCode]!;

  /// returns "+ [dialCode]"
  String get displayDialCode => '+ $dialCode';

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
      'isoCode': isoCode,
      'phoneDescription': phoneDescription.toMap(),
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(map['isoCode']);
  }

  String toJson() => json.encode(toMap());

  factory Country.fromJson(String source) =>
      Country.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Country(name: $name, nativeName: $nativeName, capital: $capital, continent: $continent, languages: $languages, currencyCode: $currencyCode, flag: $flag, isoCode: $isoCode, phoneDescription: $phoneDescription)';
  }
}
