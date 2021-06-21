import 'dart:convert';

import 'package:dart_countries/src/models/phone_description.dart';

String encodePhoneDescription(PhoneDescription desc) {
  return '''PhoneDescription(
      dialCode: ${_enc(desc.dialCode)}, 
      leadingDigits: ${_enc(desc.leadingDigits)},
      internationalPrefix: ${_enc(desc.internationalPrefix)}, 
      nationalPrefix: ${_enc(desc.nationalPrefix)},
      nationalPrefixForParsing: ${_enc(desc.nationalPrefixForParsing)},
      nationalPrefixTransformRule: ${_enc(desc.nationalPrefixTransformRule)},
      isMainCountryForDialCode: ${_enc(desc.isMainCountryForDialCode)},
      validation: ${_phoneValidationString(desc.validation)},
    )''';
}

String _phoneValidationString(PhoneValidation v) {
  return '''PhoneValidation(
        general: ${_phoneValidationRulesString(v.general)}, 
        mobile: ${_phoneValidationRulesString(v.mobile)}, 
        fixedLine: ${_phoneValidationRulesString(v.fixedLine)}, 
      )''';
}

String _phoneValidationRulesString(PhoneValidationRules r) {
  return '''PhoneValidationRules(lengths: ${_enc(r.lengths)}, pattern: ${_enc(r.pattern)},)''';
}

String _enc(v) {
  if (v is String) return 'r"$v"';
  if (v == null) return 'null';
  return jsonEncode(v);
}
