abstract final class MessageValidator {
  static const maxLength = 280;

  static String? validate(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Write a message first.';
    }
    if (text.length > maxLength) {
      return 'Messages can have at most $maxLength characters.';
    }
    return null;
  }
}
