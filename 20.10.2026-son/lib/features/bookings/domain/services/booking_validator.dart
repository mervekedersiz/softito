/// Pure validation rules for the rental form. Each method returns a Turkish
/// error message, or `null` when the value is valid.
abstract final class BookingValidator {
  static String? location(String? value, {required String message}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  /// Start must be chosen and must not be in the past.
  static String? start(DateTime? start, DateTime now) {
    if (start == null) return 'Başlangıç tarih ve saatini seçin.';
    if (start.isBefore(now)) return 'Başlangıç zamanı geçmişte olamaz.';
    return null;
  }

  /// End must be chosen and strictly after the start (when known).
  static String? end(DateTime? end, DateTime? start) {
    if (end == null) return 'Bitiş tarih ve saatini seçin.';
    if (start != null && !end.isAfter(start)) {
      return 'Bitiş zamanı başlangıçtan sonra olmalı.';
    }
    return null;
  }
}
