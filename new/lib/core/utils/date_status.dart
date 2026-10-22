import '../models/enums.dart';

UrgencyStatus classifyDate(DateTime today, DateTime target) {
  final todayDate = DateTime(today.year, today.month, today.day);
  final targetDate = DateTime(target.year, target.month, target.day);
  final diffDays = targetDate.difference(todayDate).inDays;

  if (diffDays < 0) {
    return UrgencyStatus.expired;
  } else if (diffDays == 0) {
    return UrgencyStatus.today;
  } else if (diffDays <= 2) {
    return UrgencyStatus.urgent;
  } else if (diffDays <= 5) {
    return UrgencyStatus.upcoming;
  } else {
    return UrgencyStatus.safe;
  }
}

int daysRemaining(DateTime today, DateTime target) {
  final todayDate = DateTime(today.year, today.month, today.day);
  final targetDate = DateTime(target.year, target.month, target.day);
  return targetDate.difference(todayDate).inDays;
}
