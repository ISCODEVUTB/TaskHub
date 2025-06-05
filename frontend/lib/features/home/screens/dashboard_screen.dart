import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/section_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulación de datos relevantes
    final proyectos = [
      {
        'nombre': 'Proyecto Alpha',
        'tareasPendientes': 2,
        'tareasVencidas': 1,
        'tareasHoy': 1,
        'proximaTarea': 'Revisar entregables',
        'proximaFecha': DateTime.now().add(const Duration(hours: 3)),
      },
      {
        'nombre': 'Proyecto Beta',
        'tareasPendientes': 0,
        'tareasVencidas': 0,
        'tareasHoy': 0,
        'proximaTarea': '-',
        'proximaFecha': null,
      },
    ];
    final tareasUrgentes = [
      {
        'id': 1,
        'titulo': 'Revisar entregables',
        'proyecto': 'Proyecto Alpha',
        'fecha': DateTime.now().add(const Duration(hours: 3)),
        'prioridad': 'Alta',
      },
      {
        'id': 2,
        'titulo': 'Enviar informe',
        'proyecto': 'Proyecto Alpha',
        'fecha': DateTime.now().add(const Duration(days: 1)),
        'prioridad': 'Media',
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel principal'),
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
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text(
              '¡Hola! Aquí tienes un resumen de tus proyectos:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 18),
            Row(
              children:
                  proyectos
                      .map(
                        (p) => Expanded(
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.folder,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          p['nombre'] as String,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        color: AppColors.error,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${p['tareasVencidas']} vencidas',
                                        style: TextStyle(
                                          color: AppColors.error,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.today,
                                        color: AppColors.info,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${p['tareasHoy']} hoy',
                                        style: TextStyle(color: AppColors.info),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.pending_actions,
                                        color: AppColors.secondary,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${p['tareasPendientes']} pendientes',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (p['proximaTarea'] != '-')
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.schedule,
                                          color: AppColors.primary,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            'Próxima: ${p['proximaTarea']} (${p['proximaFecha'] != null ? (p['proximaFecha'] as DateTime).hour.toString().padLeft(2, '0') + ':' + (p['proximaFecha'] as DateTime).minute.toString().padLeft(2, '0') : '-'})',
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Tareas urgentes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...tareasUrgentes.map(
              (t) => Card(
                color:
                    t['prioridad'] == 'Alta'
                        ? AppColors.error.withAlpha(20)
                        : AppColors.warning.withAlpha(20),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: Icon(
                    t['prioridad'] == 'Alta' ? Icons.priority_high : Icons.flag,
                    color:
                        t['prioridad'] == 'Alta'
                            ? AppColors.error
                            : AppColors.warning,
                  ),
                  title: Text(
                    t['titulo'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Proyecto: ${t['proyecto']}\nPara: ${(t['fecha'] as DateTime).day.toString().padLeft(2, '0')}/${(t['fecha'] as DateTime).month.toString().padLeft(2, '0')} ${(t['fecha'] as DateTime).hour.toString().padLeft(2, '0')}:${(t['fecha'] as DateTime).minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: StatusBadge(status: t['prioridad'] == 'Alta' ? 'Pendiente' : 'En progreso'),
                  onTap: () => context.go('/task/${t['id']}'),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Accesos rápidos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.add_task, color: AppColors.primary),
                  label: const Text('Nueva tarea'),
                  onPressed: () {
                    Feedback.forTap(context);
                    context.go('/create-task');
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.folder, color: AppColors.primary),
                  label: const Text('Ver proyectos'),
                  onPressed: () {
                    Feedback.forTap(context);
                    context.go('/projects');
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.notifications, color: AppColors.info),
                  label: const Text('Notificaciones'),
                  onPressed: () {
                    Feedback.forTap(context);
                    context.go('/notifications');
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.person, color: AppColors.primary),
                  label: const Text('Perfil'),
                  onPressed: () {
                    Feedback.forTap(context);
                    context.go('/profile');
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.settings, color: AppColors.primary),
                  label: const Text('Configuración'),
                  onPressed: () {
                    Feedback.forTap(context);
                    context.go('/account-settings');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
