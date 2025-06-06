import 'package:flutter/material.dart';

class ExternalToolsPage extends StatelessWidget {
  const ExternalToolsPage({super.key});

  final List<Map<String, dynamic>> tools = const [
    {
      'name': 'Calendario',
      'icon': Icons.calendar_today,
      'description': 'Gestiona tus fechas importantes y eventos',
    },
    {
      'name': 'Chat',
      'icon': Icons.chat_bubble,
      'description': 'Comunícate con tu equipo en tiempo real',
    },
    {
      'name': 'Analytics',
      'icon': Icons.analytics,
      'description': 'Visualiza estadísticas y rendimiento',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Herramientas Externas'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(tool['icon'], color: Theme.of(context).colorScheme.primary),
              title: Text(tool['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(tool['description']),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Aquí se puede implementar navegación a cada herramienta
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Abrir ${tool['name']}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}