import 'package:dart_countries/dart_countries.dart';

void main(List<String> arguments) {
  // maps
  print(countriesName['US']);
  print(countriesNativeName['US']); // native name
  print(countriesContinent['US']);
  print(countriesCapital['US']);
  print(countriesCurrencyCode['US']);
  print(countriesFlag['US']); // unicode flag wont display on windows yet
  print(countriesLanguages['US']);
  print(countriesDialCode['US']);

  // country class
  final allCountries = countries;
  allCountries.forEach((country) {
    if (country.currencyCode == 'USD') print(country.name);
  });
}
