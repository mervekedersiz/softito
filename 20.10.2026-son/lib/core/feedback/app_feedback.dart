import 'package:flutter/material.dart';

/// Status types for application feedback and operation results.
enum AppFeedbackStatus {
  success('Başarılı', Icons.check_circle_rounded, Color(0xFF10B981)),
  failure('Hata / Başarısız', Icons.error_rounded, Color(0xFFEF4444)),
  warning('Dikkat', Icons.warning_amber_rounded, Color(0xFFF59E0B)),
  info('Bilgi', Icons.info_rounded, Color(0xFF3B82F6));

  const AppFeedbackStatus(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;
}

/// A structured feedback message describing an operation's outcome.
class AppFeedbackMessage {
  const AppFeedbackMessage({
    required this.title,
    required this.message,
    required this.status,
    this.actionLabel,
    this.onAction,
    this.code,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? const _DefaultTime();

  final String title;
  final String message;
  final AppFeedbackStatus status;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? code;
  final dynamic timestamp;
}

class _DefaultTime {
  const _DefaultTime();
  DateTime get now => DateTime.now();
}

/// In-app notification and feedback controller to display outcomes on screen.
class AppFeedbackController extends ChangeNotifier {
  AppFeedbackMessage? _current;
  final List<AppFeedbackMessage> _history = [];

  AppFeedbackMessage? get current => _current;
  List<AppFeedbackMessage> get history => List.unmodifiable(_history);

  void post({
    required String title,
    required String message,
    required AppFeedbackStatus status,
    String? actionLabel,
    VoidCallback? onAction,
    String? code,
  }) {
    _current = AppFeedbackMessage(
      title: title,
      message: message,
      status: status,
      actionLabel: actionLabel,
      onAction: onAction,
      code: code,
      timestamp: DateTime.now(),
    );
    _history.insert(0, _current!);
    if (_history.length > 50) _history.removeLast();
    notifyListeners();
  }

  void postSuccess({required String title, required String message, String? actionLabel, VoidCallback? onAction}) {
    post(title: title, message: message, status: AppFeedbackStatus.success, actionLabel: actionLabel, onAction: onAction);
  }

  void postFailure({required String title, required String message, String? code, String? actionLabel, VoidCallback? onAction}) {
    post(title: title, message: message, status: AppFeedbackStatus.failure, code: code, actionLabel: actionLabel, onAction: onAction);
  }

  void clear() {
    _current = null;
    notifyListeners();
  }
}

/// Visual banner component showing the latest success or failure directly on screen.
class AppFeedbackBanner extends StatelessWidget {
  const AppFeedbackBanner({
    required this.feedback,
    this.onDismiss,
    super.key,
  });

  final AppFeedbackMessage feedback;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = feedback.status.color;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 6,
            child: Container(
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(feedback.status.icon, color: statusColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            feedback.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          if (feedback.code != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                feedback.code!,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        feedback.message,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                      if (feedback.actionLabel != null && feedback.onAction != null) ...[
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: feedback.onAction,
                          child: Text(
                            feedback.actionLabel!,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (onDismiss != null)
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    color: theme.colorScheme.onSurfaceVariant,
                    onPressed: onDismiss,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Full interactive status dialog for major events (e.g. payment success/failure, booking outcomes).
Future<void> showAppStatusDialog({
  required BuildContext context,
  required String title,
  required String message,
  required AppFeedbackStatus status,
  String? detailCode,
  String? primaryButtonLabel,
  VoidCallback? onPrimary,
  String? secondaryButtonLabel,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      final color = status.color;

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(status.icon, color: color, size: 44),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (detailCode != null) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    detailCode,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (secondaryButtonLabel != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(secondaryButtonLabel),
                      ),
                    ),
                  if (secondaryButtonLabel != null) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: color),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onPrimary?.call();
                      },
                      child: Text(primaryButtonLabel ?? 'Tamam'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
