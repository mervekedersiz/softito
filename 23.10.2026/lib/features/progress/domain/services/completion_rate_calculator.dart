class CompletionRateResult {
  const CompletionRateResult({
    required this.completed,
    required this.planned,
    required this.ratio,
  });

  final int completed;
  final int planned;
  final double? ratio; // null if planned == 0

  int? get percentage => ratio != null ? (ratio! * 100).round() : null;

  String get formattedDisplay {
    if (ratio == null) return '—';
    return '%$percentage';
  }
}

class CompletionRateCalculator {
  static CompletionRateResult calculate({
    required int completed,
    required int planned,
  }) {
    if (planned == 0) {
      return const CompletionRateResult(completed: 0, planned: 0, ratio: null);
    }

    final safeCompleted = completed.clamp(0, planned);
    final ratio = safeCompleted / planned;
    return CompletionRateResult(
      completed: safeCompleted,
      planned: planned,
      ratio: ratio,
    );
  }
}
