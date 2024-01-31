import '../metadata/models/phone_metadata.dart';

abstract class InternationalPrefixParser {
  ///  Removes the exit code from a phone number if present.
  ///
  ///  It expects a normalized [phoneNumber].
  ///  if phone starts with + it is removed
  ///  if starts with 00 or 011
  ///  we consider those as internationalPrefix as
  ///  they cover 4/5 of the international prefix

  /// exitCode phoneNumberWithoutExitCode
  static Map<String, dynamic> extractExitCode(
    String phoneNumber, {
    PhoneMetadata? callerCountryMetadata,
    PhoneMetadata? destinationCountryMetadata,
  }) {
    if (phoneNumber.startsWith('+')) {
      return {'exitCode': '+', 'phoneNumberWithoutExitCode': phoneNumber.substring(1)};
    }

    // if the caller country was provided it's easy, just remove the exit code
    // from the phone number
    if (callerCountryMetadata != null) {
      return _removeExitCodeWithMetadata(phoneNumber, callerCountryMetadata);
    }
    // if the caller country was not specified, a best guess is approximated.
    // 4/5 of the world wide numbers exit codes are 00 or 011
    // if a country code does not follow the international prefix
    // then we can assume it is not an international prefix
    // if no metadata was provided for the destination country
    // then no such check is made that a country code does not follow
    final countryCode = destinationCountryMetadata?.countryCode ?? '';
    if (phoneNumber.startsWith('00$countryCode')) {
      return {'exitCode': '00', 'phoneNumberWithoutExitCode': phoneNumber.substring(2)};
    }

    if (phoneNumber.startsWith('011$countryCode')) {
      return {'exitCode': '011', 'phoneNumberWithoutExitCode': phoneNumber.substring(3)};
    }

    return {'exitCode': '', 'phoneNumberWithoutExitCode': phoneNumber};
  }

  static Map<String, dynamic> _removeExitCodeWithMetadata(
    String phoneNumber,
    PhoneMetadata metadata,
  ) {
    final match = RegExp(metadata.internationalPrefix).matchAsPrefix(phoneNumber);
    if (match != null) {
      return {
        'exitCode': phoneNumber.substring(match.start, match.end),
        'phoneNumberWithoutExitCode': phoneNumber.substring(match.end)
      };
    }
    // if it does not start with the international prefix from the
    // country we assume the prefix is not present
    return {'exitCode': '', 'phoneNumberWithoutExitCode': phoneNumber};
  }
}
