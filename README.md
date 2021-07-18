# dart_countries

A set of informations about countries. Contains various maps and isoCodes.

## Maps

You can use the maps to only import the information that you need

  - countriesName[IsoCode.US]
  - countriesNative[IsoCode.FR] // native name
  - countriesContinent[IsoCode.ES]
  - countriesCapital[IsoCode.FR]
  - countriesCurrencyCode[IsoCode.US]
  - countriesFlag[IsoCode.US] // unicode flag wont display on windows yet
  - countriesLanguages[IsoCode.US]
  - countriesDialcode[IsoCode.FR]

## Country class

Alternatively you can use the country class that contains all the info (less tree shaking).

```dart
  countries.forEach((country) {
    if (country.currencyCode == 'USD') print(country.name);
  });

  print(Country(IsoCode.US).currencyCode);
```


