# dart_countries

A set of informations about countries. Contains various maps and isoCodes.

## Maps

You can use the maps to only import the information that you need

  - countriesName[IsoCode.US]
  - countriesNativeName[IsoCode.FR] // native name, eg: France
  - countriesContinent[IsoCode.ES]  // Europe
  - countriesCapital[IsoCode.FR]  // Paris
  - countriesCurrencyCode[IsoCode.US]  // USD
  - countriesFlag[IsoCode.US] // unicode flag wont display on windows yet
  - countriesLanguages[IsoCode.US]  //  ['en']
  - countriesCountryCode[IsoCode.FR]  // 33

## Country class

Alternatively you can use the country class that contains all the info (less tree shaking).

```dart
  countries.forEach((country) {
    if (country.currencyCode == 'USD') print(country.name);
  });

  print(Country(IsoCode.US).currencyCode);
```


