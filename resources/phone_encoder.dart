import 'dart:convert';

import 'package:dart_countries/src/models/phone_description.dart';

String encodePhoneDescription(PhoneDescription desc) {
  return '''PhoneDescription(
      dialCode: ${enc(desc.dialCode)}, 
      leadingDigits: ${enc(desc.leadingDigits)},
      internationalPrefix: ${enc(desc.internationalPrefix)}, 
      nationalPrefix: ${enc(desc.nationalPrefix)},
      nationalPrefixForParsing: ${enc(desc.nationalPrefixForParsing)},
      nationalPrefixTransformRule: ${enc(desc.nationalPrefixTransformRule)},
      isMainCountryForDialCode: ${enc(desc.isMainCountryForDialCode)},
      validation: ${phoneValidationString(desc.validation)},
    )''';
}

String phoneValidationString(PhoneValidation v) {
  return '''PhoneValidation(
        general: ${phoneValidationRulesString(v.general)}, 
        mobile: ${phoneValidationRulesString(v.mobile)}, 
        fixedLine: ${phoneValidationRulesString(v.fixedLine)}, 
      )''';
}

String phoneValidationRulesString(PhoneValidationRules r) {
  return '''PhoneValidationRules(lengths: ${enc(r.lengths)}, pattern: ${enc(r.pattern)},)''';
}

String enc(v) {
  if (v is String) return 'r"$v"';
  if (v == null) return 'null';
  return jsonEncode(v);
}
