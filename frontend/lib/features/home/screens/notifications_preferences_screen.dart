import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class NotificationPreferencesPage extends StatelessWidget {
  const NotificationPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferencias de notificaciones'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configura cómo quieres recibir tus notificaciones:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: SwitchListTile(
                title: const Text('Notificaciones por correo'),
                value: true,
                onChanged: (v) {},
                secondary: const Icon(Icons.email, color: AppColors.primary),
                tileColor: Theme.of(context).cardColor,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: SwitchListTile(
                title: const Text('Notificaciones push'),
                value: false,
                onChanged: (v) {},
                secondary: const Icon(
                  Icons.notifications_active,
                  color: AppColors.info,
                ),
                tileColor: Theme.of(context).cardColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
