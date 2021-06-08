# dart_countries

Dart const country list containing information relative to a country.

The advantage of this package over a json file is that the information is tree shakeable therefore the compiled executable will be smaller.

Country information:

  - name: English name
  - nativeName: Name spelled in country main language
  - capital
  - continent
  - languages
  - currencyCode
  - flag: emoji
  - isoCode
  - Phone metadata from google's "libphonenumber" (dial code, validation, etc)

