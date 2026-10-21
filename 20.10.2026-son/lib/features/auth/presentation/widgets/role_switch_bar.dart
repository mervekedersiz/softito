import 'package:flutter/material.dart';
import '../../../../app/app_scope.dart';
import '../../domain/entities/user.dart';

/// Top bar or in-page banner showing active role and quick switcher for demonstration.
class RoleSwitchBar extends StatelessWidget {
  const RoleSwitchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final auth = AppScope.of(context).auth;

    return ListenableBuilder(
      listenable: auth,
      builder: (context, _) {
        final user = auth.currentUser;
        final currentRole = user?.role ?? UserRole.customer;

        Color roleColor;
        switch (currentRole) {
          case UserRole.admin:
            roleColor = Colors.deepOrange;
            break;
          case UserRole.driver:
            roleColor = Colors.teal;
            break;
          case UserRole.customer:
            roleColor = colors.primary;
            break;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: roleColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  currentRole == UserRole.admin ? Icons.admin_panel_settings : Icons.person_pin,
                  color: roleColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user?.name ?? 'Misafir',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: roleColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            currentRole.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      currentRole.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<UserRole>(
                tooltip: 'Yetkiyi Değiştir',
                icon: const Icon(Icons.swap_horiz, size: 20),
                onSelected: (role) {
                  auth.switchRole(role);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Aktif rol ${role.title} olarak güncellendi.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                itemBuilder: (context) => [
                  for (final role in UserRole.values)
                    PopupMenuItem(
                      value: role,
                      child: Row(
                        children: [
                          Icon(
                            role == currentRole ? Icons.check_circle : Icons.circle_outlined,
                            size: 18,
                            color: role == currentRole ? colors.primary : colors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 10),
                          Text(role.title),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
