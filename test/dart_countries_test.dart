import 'package:dart_countries/dart_countries.dart';
import 'package:test/test.dart';

void main() {
  group('Country', () {
    test('should create with isoCode ', () {
      expect(Country.fromIsoCode('fr').name, equals('France'));
      expect(Country.fromIsoCode('FR').name, equals('France'));
      expect(
          () => Country.fromIsoCode('WRONG'), throwsA(TypeMatcher<Object>()));
    });

    test('should give the correct info for country US', () {
      final us = Country.fromIsoCode('us');
      expect(us.name, equals('United States'));
      expect(us.nativeName, equals('United States'));
      expect(us.continent, equals('NA'));
      expect(us.capital, equals('Washington D.C.'));
      expect(us.currencyCode, equals('USD'));
      expect(us.dialCode, equals('1'));
      expect(us.displayDialCode, equals('+ 1'));
      expect(us.languages, equals(['en']));
    });

    test('dial code for display', () {
      expect(Country.fromIsoCode('us').displayDialCode, equals('+ 1'));
    });
  });
}
