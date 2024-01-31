import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:phone_numbers_parser/src/metadata/metadata_finder.dart';
import 'package:phone_numbers_parser/src/parsers/_international_prefix_parser.dart';
import 'package:test/test.dart';

void main() {
  group('_InternationalPrefixParser', () {
    final fix = InternationalPrefixParser.extractExitCode;

    test('should remove + prefix in all cases', () {
      expect(fix('+654'), {'exitCode': '+', 'phoneNumberWithoutExitCode': '654'});
      final metadata = MetadataFinder.findMetadataForIsoCode(IsoCode.US);
      expect(fix('+654', destinationCountryMetadata: metadata), {'exitCode': '+', 'phoneNumberWithoutExitCode': '654'});
      expect(fix('+654', callerCountryMetadata: metadata), {'exitCode': '+', 'phoneNumberWithoutExitCode': '654'});
    });

    test('should remove international prefix from caller', () {
      final metadataUS = MetadataFinder.findMetadataForIsoCode(IsoCode.US);
      final metadataFR = MetadataFinder.findMetadataForIsoCode(IsoCode.FR);
      expect(fix('01199', callerCountryMetadata: metadataUS), {'exitCode': '011', 'phoneNumberWithoutExitCode': '99'});
      expect(fix('0099', callerCountryMetadata: metadataFR), {'exitCode': '00', 'phoneNumberWithoutExitCode': '99'});
    });

    test('should remove remove 00 and 011 prefixes, if no metadata provided',
        () {
      expect(fix('00654'), {'exitCode': '00', 'phoneNumberWithoutExitCode': '654'});
      expect(fix('011654'), {'exitCode': '011', 'phoneNumberWithoutExitCode': '654'});
    });

    test('should not remove international prefix if country code not following',
        () {
      final frMetadata = MetadataFinder.findMetadataForIsoCode(IsoCode.FR);
      final beMetadata = MetadataFinder.findMetadataForIsoCode(IsoCode.BE);

      expect(
          fix('0032', destinationCountryMetadata: beMetadata), {'exitCode': '00', 'phoneNumberWithoutExitCode': '32'});
      expect(
          fix('0033', destinationCountryMetadata: beMetadata), {'exitCode': '', 'phoneNumberWithoutExitCode': '0033'});
      expect(fix('00777', destinationCountryMetadata: frMetadata),
          {'exitCode': '', 'phoneNumberWithoutExitCode': '00777'});
    });
  });
}
