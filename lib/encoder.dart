import 'dart:convert';

// Constants for UTF-16 runes.
const $7 = 55;
const $0 = 48;

/// Decodes a SCP-7777 compliant 'heptobinary' string into a message.
String decodeHeptobinary(String payload) {
  var asciiRunes = <int>[];
  var sevenCount = 0;
  for (var rune in payload.runes) {
    if (rune == $7) {
      sevenCount++;
    } else if (rune == $0) {
      asciiRunes.add(sevenCount);
      sevenCount = 0;
    }
  }
  if (sevenCount > 0) {
    asciiRunes.add(sevenCount);
  }
  return ascii.decode(asciiRunes);
}

/// Encodes a message into a SCP-7777 compliant 'heptobinary' string.
String encodeHeptobinary(String payload) => ascii.encode(payload).map((e) => List.filled(e, "7").join("")).join("0");