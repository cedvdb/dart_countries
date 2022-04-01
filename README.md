# dart_countries

A set of informations about countries. Contains various maps and isoCodes.

## Maps

You can use the maps to only import the information that you need

  - countriesName['US']
  - countriesNativeName['FR'] // native name, eg: France
  - countriesContinent['ES']  // Europe
  - countriesCapital['FR']  // Paris
  - countriesCurrencyCode['US']  // USD
  - countriesFlag['US'] // unicode flag wont display on windows yet
  - countriesLanguages['US']  //  ['en']
  - countriesCountryCode['FR']  // +33

## Country class

Alternatively you can use the country class that contains all the info (less tree shaking).

```dart
  countries.forEach((country) {
    if (country.currencyCode == 'USD') print(country.name);
  });

  print(Country(IsoCode.US).currencyCode);
```


