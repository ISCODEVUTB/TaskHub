import 'package:flutter/material.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/colors.dart';
import 'package:go_router/go_router.dart';

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
        title: const Text('Herramientas externas'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Regresar',
          onPressed: () {
            Feedback.forTap(context);
            context.pop();
          },
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: 3,
        separatorBuilder:
            (context, index) => Divider(height: 24, color: Theme.of(context).dividerColor),
        itemBuilder: (context, index) {
          final icons = [Icons.calendar_today, Icons.chat_bubble, Icons.analytics];
          final titles = ['Calendario', 'Chat', 'Análisis de datos'];
          final routes = ['/tool/calendario', '/tool/chat', '/tool/analytics'];
          final descriptions = [
            'Gestiona tus fechas importantes y eventos',
            'Comunícate con tu equipo en tiempo real',
            'Visualiza estadísticas y rendimiento',
          ];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.info.withAlpha(38),
                child: Icon(icons[index], color: AppColors.info, size: 32),
                radius: 28,
              ),
              title: Text(
                titles[index],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              subtitle: Text(
                descriptions[index],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 15),
              ),
              trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color, size: 28),
              onTap: () {
                Feedback.forTap(context);
                context.go(routes[index]);
              },
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              minVerticalPadding: 18,
            ),
          );
        },
      ),
    );
  }
}
