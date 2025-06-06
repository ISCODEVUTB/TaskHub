import 'package:flutter/material.dart';

class NotificationPreferencesPage extends StatelessWidget {
  const NotificationPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferencias de notificación')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Notificaciones por correo'),
            value: true,
            onChanged: (_) {},
          ),
          SwitchListTile(
            title: const Text('Alertas de tareas pendientes'),
            value: false,
            onChanged: (_) {},
          ),
          SwitchListTile(
            title: const Text('Resumen semanal'),
            value: true,
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }
}