import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notificaciones = [
      // ...tu lista de notificaciones...
    ];

    if (notificaciones.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Notificaciones'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 2,
          toolbarHeight: 48,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
          ),
          leading: Navigator.of(context).canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Regresar',
                  onPressed: () => context.pop(),
                )
              : null,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Preferencias de notificaciones',
              onPressed: () {
                Feedback.forTap(context);
                context.go('/notification-settings');
              },
            ),
          ],
        ),
        body: Center(child: Text('No hay notificaciones')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 2,
        toolbarHeight: 48,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Regresar',
                onPressed: () => context.pop(),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Preferencias de notificaciones',
            onPressed: () {
              Feedback.forTap(context);
              context.go('/notification-settings');
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: notificaciones.length,
        separatorBuilder:
            (context, index) => Divider(height: 24, color: Theme.of(context).dividerColor),
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.info.withAlpha(38),
                child: const Icon(Icons.notifications, color: AppColors.info),
              ),
              title: Text(
                'Notificación ${index + 1}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Este es el detalle de la notificación ${index + 1}.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color),
              onTap: () {
                Feedback.forTap(context);
                context.go('/task/${notificaciones[index].taskId}');
              },
            ),
          );
        },
      ),
    );
  }
}
