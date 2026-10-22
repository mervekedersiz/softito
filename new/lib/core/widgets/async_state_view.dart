import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AsyncStateView<T> extends StatelessWidget {
  final AsyncSnapshot<T>? snapshot;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final Widget Function(BuildContext context, T data)? builder;
  final Widget? child;

  const AsyncStateView({
    super.key,
    this.snapshot,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.danger),
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Yeniden Dene'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (child != null) return child!;
    return const SizedBox.shrink();
  }
}
