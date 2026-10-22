class NfcPass {
  const NfcPass({
    required this.cardId,
    required this.holderName,
    required this.totalDailyMinutes,
    required this.remainingMinutes,
    required this.totalDailyRides,
    required this.remainingRides,
    this.isCardLinked = true,
  });

  final String cardId;
  final String holderName;
  final int totalDailyMinutes;
  final int remainingMinutes;
  final int totalDailyRides;
  final int remainingRides;
  final bool isCardLinked;

  double get minutesRatio => totalDailyMinutes > 0 ? (remainingMinutes / totalDailyMinutes) : 0.0;
  bool get hasRemainingQuota => remainingMinutes > 0 && remainingRides > 0;

  NfcPass copyWith({
    int? remainingMinutes,
    int? remainingRides,
    bool? isCardLinked,
  }) {
    return NfcPass(
      cardId: cardId,
      holderName: holderName,
      totalDailyMinutes: totalDailyMinutes,
      remainingMinutes: remainingMinutes ?? this.remainingMinutes,
      totalDailyRides: totalDailyRides,
      remainingRides: remainingRides ?? this.remainingRides,
      isCardLinked: isCardLinked ?? this.isCardLinked,
    );
  }
}
