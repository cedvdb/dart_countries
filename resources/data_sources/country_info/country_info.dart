class CountryInfo {
  final String name;
  final String nativeName;
  final String capital;
  final String continent;
  final List<String> languages;
  final String currencyCode;

  const CountryInfo({
    required this.name,
    required this.nativeName,
    required this.capital,
    required this.continent,
    required this.languages,
    required this.currencyCode,
  });
}
