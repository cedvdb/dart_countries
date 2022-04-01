import 'package:dart_countries/dart_countries.dart';
import 'package:test/test.dart';

void main() {
  group('Country', () {
    test('should create with isoCode ', () {
      expect(Country(IsoCode.FR).name, equals('France'));
    });

    test('should give the correct info for country US', () {
      final us = Country(IsoCode.US);
      expect(us.name, equals('United States'));
      expect(us.nativeName, equals('United States'));
      expect(us.continent, equals('NA'));
      expect(us.capital, equals('Washington D.C.'));
      expect(us.currencyCode, equals('USD'));
      expect(us.countryCode, equals('1'));
      expect(us.displayDialCode, equals('+ 1'));
      expect(us.languages, equals(['en']));
    });

    test('dial code for display', () {
      expect(Country(IsoCode.US).displayDialCode, equals('+ 1'));
    });
  });
}
