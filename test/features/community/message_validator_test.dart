import 'package:flutter_test/flutter_test.dart';
import 'package:full_day_community_hub/core/validation/message_validator.dart';

void main() {
  group('MessageValidator', () {
    test('rejects blank messages', () {
      expect(MessageValidator.validate('   '), isNotNull);
    });

    test('accepts a trimmed message up to 280 characters', () {
      expect(MessageValidator.validate('Hola Full Day 🚀'), isNull);
      expect(MessageValidator.validate('a' * 280), isNull);
    });

    test('rejects messages over 280 characters', () {
      expect(MessageValidator.validate('a' * 281), isNotNull);
    });
  });
}
