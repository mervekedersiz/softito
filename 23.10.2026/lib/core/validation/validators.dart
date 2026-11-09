final _uuidRegex = RegExp(
  r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
);

bool isValidUuid(String? value) {
  if (value == null) return false;
  return _uuidRegex.hasMatch(value);
}

String? validateHabitTitle(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return 'Lütfen bir başlık yazın.';
  if (text.length < 2) return 'Başlık en az 2 karakter olmalıdır.';
  if (text.length > 60) return 'Başlık en fazla 60 karakter olabilir.';
  return null;
}

String? validateRewardTitle(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return 'Lütfen ödül adı yazın.';
  if (text.length < 2) return 'Ödül adı en az 2 karakter olmalıdır.';
  if (text.length > 80) return 'Ödül adı en fazla 80 karakter olabilir.';
  return null;
}

String? validateDescription(String? value) {
  final text = value?.trim() ?? '';
  if (text.length > 500) return 'Açıklama en fazla 500 karakter olabilir.';
  return null;
}

String? validateTargetSteps(int? steps) {
  if (steps == null) return 'Hedef adım sayısı gereklidir.';
  if (steps < 1 || steps > 1000) {
    return 'Hedef 1 ile 1000 adım arasında olmalıdır.';
  }
  return null;
}
