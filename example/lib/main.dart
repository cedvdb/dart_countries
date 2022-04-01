import 'package:dart_countries/dart_countries.dart';

void main(List<String> arguments) {
  // maps
  print(countriesName[IsoCode.US]);
  print(countriesNativeName[IsoCode.US]); // native name
  print(countriesContinent[IsoCode.US]);
  print(countriesCapital[IsoCode.US]);
  print(countriesCurrencyCode[IsoCode.US]);
  print(countriesFlag[IsoCode.US]); // unicode flag wont display on windows yet
  print(countriesLanguages[IsoCode.US]);
  print(countriesCountryCode[IsoCode.US]);

  // country class
  final allCountries = countries;
  allCountries.forEach((country) {
    if (country.currencyCode == 'USD') print(country.name);
  });
}
