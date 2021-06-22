import 'package:dart_countries/dart_countries.dart';

void main(List<String> arguments) {
// creation
  // final allCountries = countries;
  // final us = Country.fromIsoCode('be');
  // final countries = [
  //   Country(IsoCode.US),
  // ];
  // countries.forEach((us) {
  //   print(us.name);
  //   // print(us.nativeName);
  //   // print(us.continent);
  //   // print(us.capital);
  //   // print(us.currencyCode);
  //   // print(us.dialCode);
  //   // print(us.displayDialCode);
  //   // print(us.flag);
  //   // print(us.languages);
  // });

  print(countriesPhoneDescription[IsoCode.US]);
  print(countriesCurrency[IsoCode.US]);
}
