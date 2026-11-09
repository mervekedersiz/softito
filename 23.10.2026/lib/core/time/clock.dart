abstract class Clock {
  const Clock();

  DateTime now();
  DateTime nowUtc();
}

class SystemClock extends Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();
}

class FixedClock extends Clock {
  const FixedClock(this.fixedDateTime);

  final DateTime fixedDateTime;

  @override
  DateTime now() => fixedDateTime;

  @override
  DateTime nowUtc() => fixedDateTime.toUtc();
}
