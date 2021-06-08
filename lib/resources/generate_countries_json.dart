import 'dart:convert';
import 'dart:io';

import 'generate_countries.dart';

/// generats a json representation of the data

void main() async {
  final countries = await getCountries();
  final encoder = JsonEncoder.withIndent('  ');
  await File('resources/countries.json')
      .writeAsString(encoder.convert(countries.map((c) => c.toMap()).toList()));
}
