import 'package:dart_countries/dart_countries.dart';

void main(List<String> arguments) {
  final us = IsoCode.US;
  // final us = isoCodeConversionMap['US']; // alternatively

  // maps
  print(countriesName[us]);
  print(countriesNative[us]); // native name
  print(countriesContinent[us]);
  print(countriesCapital[us]);
  print(countriesCurrency[us]);
  print(countriesFlag[us]); // unicode flag wont display on windows yet
  print(countriesLanguages[us]);
  print(countriesDialcode[us]);
  print(countriesPhonenumberlengths[us]);
  print(countriesPhoneDescription[us]);

  // country class
  final allCountries = countries;
  allCountries.forEach((country) {
    if (country.currencyCode == 'USD') print(country.name);
  });
}
