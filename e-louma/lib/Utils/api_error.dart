/// Extraction des messages d'erreur renvoyés par l'API (NestJS / Express).
String extractApiErrorMessage(
  dynamic message, {
  String fallback = 'Une erreur est survenue',
}) {
  if (message == null) return fallback;
  if (message is String) {
    final trimmed = message.trim();
    return trimmed.isEmpty ? fallback : trimmed;
  }
  if (message is List) {
    final parts = message
        .map((e) => e?.toString().trim() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return fallback;
    return parts.join('\n');
  }
  if (message is Map) {
    final nested = message['message'] ?? message['error'] ?? message['msg'];
    if (nested != null) {
      return extractApiErrorMessage(nested, fallback: fallback);
    }
  }
  final asString = message.toString().trim();
  return asString.isEmpty ? fallback : asString;
}

/// Nettoie `Exception: ...` (éventuellement imbriqué) pour l'UI.
String cleanExceptionMessage(
  Object error, {
  String fallback = 'Une erreur est survenue',
}) {
  var text = error.toString().trim();
  while (text.startsWith('Exception:')) {
    text = text.substring('Exception:'.length).trim();
  }
  return text.isEmpty ? fallback : text;
}
