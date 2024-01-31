import 'package:phone_numbers_parser/src/parsers/_country_code_parser.dart';
import 'package:test/test.dart';

void main() {
  group('_CountryCodeParser', () {
    test('should extract country calling code', () {
      expect(CountryCodeParser.extractCountryCode('33'), equals({'countryCode': '33', 'nsn': ''}));
      expect(CountryCodeParser.extractCountryCode('33479887766'),
          equals({'countryCode': '33', 'nsn': '479887766'}));
      expect(CountryCodeParser.extractCountryCode('18889997772'),
          equals({'countryCode': '1', 'nsn': '8889997772'}));
    });
  });
}
