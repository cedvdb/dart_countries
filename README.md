# dart_countries

Dart const countries maps containing information relative to a country.

## Maps

You can use the maps to only import the information that you need

  - countriesName[IsoCode.US]
  - countriesNative[IsoCode.US] // native name
  - countriesContinent[IsoCode.US]
  - countriesCapital[IsoCode.US]
  - countriesCurrency[IsoCode.US]
  - countriesFlag[IsoCode.US] // unicode flag wont display on windows yet
  - countriesLanguages[IsoCode.US]
  - countriesDialcode[IsoCode.US]
  - countriesPhonenumberlengths[IsoCode.US]
  - countriesPhoneDescription[IsoCode.US]

## Country class

Alternatively you can use the country class that contains all the info.

```dart
  countries.forEach((country) {
    if (country.currencyCode == 'USD') print(country.name);
  });

  print(Country(IsoCode.US).currencyCode);

```

