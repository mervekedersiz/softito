import 'package:flutter/widgets.dart';

/// Returns [duration], or zero when the user asked to reduce motion.
Duration motionDuration(
  BuildContext context, [
  Duration duration = const Duration(milliseconds: 250),
]) {
  return MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}
