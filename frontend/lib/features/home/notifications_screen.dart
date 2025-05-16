import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text('Notificación ${index + 1}'),
            subtitle: Text("12/05/2025 10:0${index} AM"),
            leading: const Icon(Icons.info_outline),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Contenido de la notificación ${index + 1}...'),
              ),
            ],
          );
        },
      ),
    );
  }
}