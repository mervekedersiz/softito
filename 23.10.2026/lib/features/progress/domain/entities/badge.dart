class AppBadge {
  const AppBadge({
    required this.code,
    required this.title,
    required this.description,
    required this.emoji,
    this.earnedAtUtc,
    this.evidenceId,
  });

  final String code;
  final String title;
  final String description;
  final String emoji;
  final DateTime? earnedAtUtc;
  final String? evidenceId;

  bool get isEarned => earnedAtUtc != null;

  AppBadge copyWith({
    DateTime? Function()? earnedAtUtc,
    String? Function()? evidenceId,
  }) {
    return AppBadge(
      code: code,
      title: title,
      description: description,
      emoji: emoji,
      earnedAtUtc: earnedAtUtc != null ? earnedAtUtc() : this.earnedAtUtc,
      evidenceId: evidenceId != null ? evidenceId() : this.evidenceId,
    );
  }

  static const List<AppBadge> allCatalog = [
    AppBadge(
      code: 'first_step',
      title: 'İlk Adım',
      description: 'İlk planlı alışkanlığını tamamladın.',
      emoji: '🌱',
    ),
    AppBadge(
      code: 'in_the_rhythm',
      title: 'Ritim Buldum',
      description: 'Bir alışkanlıkta 7 planlı gün üst üste seri yakaladın.',
      emoji: '🔥',
    ),
    AppBadge(
      code: 'started_again',
      title: 'Yeniden Başladım',
      description: 'Kaçırılan planlı bir günden sonra vazgeçmeyip devam ettin.',
      emoji: '💪',
    ),
    AppBadge(
      code: 'first_ticket',
      title: 'İlk Bilet',
      description: 'İlk kişisel deneyim ödül biletini kazandın.',
      emoji: '🎟️',
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AppBadge && other.code == code);

  @override
  int get hashCode => code.hashCode;
}
