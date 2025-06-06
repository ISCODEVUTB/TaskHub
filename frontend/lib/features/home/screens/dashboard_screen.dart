import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/section_card.dart';
import '../data/project_service.dart';
import '../data/project_models.dart';
import '../data/notification_service.dart';
import '../data/notification_models.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<ProjectDTO>> _projectsFuture;
  late Future<List<NotificationDTO>> _notificationsFuture;
  final ProjectService _projectService = ProjectService();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _projectsFuture = _projectService.getProjects();
    _notificationsFuture = _notificationService.getUserNotifications();
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => context.pop(),
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
            FutureBuilder<List<ProjectDTO>>(
              future: _projectsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No tienes proyectos aún.'));
                }
                final proyectos = snapshot.data!;
                return SizedBox(
                  height: 210,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: proyectos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, idx) {
                      final p = proyectos[idx];
                      return SizedBox(
                        width: 320,
                        child: FutureBuilder<List<TaskDTO>>(
                          future: _projectService.getProjectTasks(p.id),
                          builder: (context, taskSnap) {
                            if (taskSnap.connectionState == ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            } else if (taskSnap.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text('Error al cargar tareas', style: TextStyle(color: AppColors.error)),
                              );
                            }
                            final tareas = taskSnap.data ?? [];
                            final now = DateTime.now();
                            final pendientes = tareas.where((t) => t.status == 'todo' || t.status == 'in_progress').length;
                            final vencidas = tareas.where((t) => (t.dueDate != null && t.dueDate!.isBefore(now) && (t.status == 'todo' || t.status == 'in_progress'))).length;
                            final hoy = tareas.where((t) => t.dueDate != null && t.dueDate!.year == now.year && t.dueDate!.month == now.month && t.dueDate!.day == now.day).length;
                            final proxima = tareas.where((t) => t.dueDate != null && (t.status == 'todo' || t.status == 'in_progress')).toList()
                              ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
                            final proximaTarea = proxima.isNotEmpty ? proxima.first.title : '-';
                            final proximaFecha = proxima.isNotEmpty ? proxima.first.dueDate : null;
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.folder, color: AppColors.primary),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            p.name,
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 18),
                                        const SizedBox(width: 4),
                                        Text('$vencidas vencidas', style: TextStyle(color: AppColors.error)),
                                        const SizedBox(width: 12),
                                        Icon(Icons.today, color: AppColors.info, size: 18),
                                        const SizedBox(width: 4),
                                        Text('$hoy hoy', style: TextStyle(color: AppColors.info)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.pending_actions, color: AppColors.secondary, size: 18),
                                        const SizedBox(width: 4),
                                        Text('$pendientes pendientes'),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    if (proximaTarea != '-')
                                      Row(
                                        children: [
                                          Icon(Icons.schedule, color: AppColors.primary, size: 18),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              'Próxima: $proximaTarea (${proximaFecha != null ? proximaFecha.hour.toString().padLeft(2, '0') + ':' + proximaFecha.minute.toString().padLeft(2, '0') : '-'})',
                                              style: const TextStyle(fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text('Tareas urgentes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              child: FutureBuilder<List<ProjectDTO>>(
                future: _projectsFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();
                  final proyectos = snapshot.data!;
                  return FutureBuilder<List<List<TaskDTO>>>(
                    future: Future.wait(proyectos.map((p) => _projectService.getProjectTasks(p.id))),
                    builder: (context, taskSnap) {
                      if (taskSnap.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (taskSnap.hasError) {
                        return Center(child: Text('Error al cargar tareas urgentes'));
                      }
                      final allTasks = taskSnap.data?.expand((e) => e).toList() ?? [];
                      final urgentes = allTasks.where((t) => t.priority == 'high' || t.priority == 'urgent').toList()
                        ..sort((a, b) => (a.dueDate ?? DateTime.now()).compareTo(b.dueDate ?? DateTime.now()));
                      if (urgentes.isEmpty) {
                        return const Text('No hay tareas urgentes.');
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: urgentes.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, idx) {
                          final t = urgentes[idx];
                          return Card(
                            color: t.priority == 'urgent'
                                ? AppColors.error.withAlpha(20)
                                : AppColors.warning.withAlpha(20),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ListTile(
                              leading: Icon(
                                t.priority == 'urgent' ? Icons.priority_high : Icons.flag,
                                color: t.priority == 'urgent' ? AppColors.error : AppColors.warning,
                              ),
                              title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Proyecto: ${t.projectId}\nPara: '
                                  '${t.dueDate != null ? '${t.dueDate!.day.toString().padLeft(2, '0')}/${t.dueDate!.month.toString().padLeft(2, '0')} ${t.dueDate!.hour.toString().padLeft(2, '0')}:${t.dueDate!.minute.toString().padLeft(2, '0')}' : '-'}'),
                              trailing: StatusBadge(status: t.status),
                              onTap: () => context.go('/task/${t.id}'),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text('Notificaciones recientes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: FutureBuilder<List<NotificationDTO>>(
                future: _notificationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error al cargar notificaciones'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No tienes notificaciones recientes.');
                  }
                  final notifs = snapshot.data!..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                  final ultimas = notifs.take(3).toList();
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ultimas.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, idx) {
                      final n = ultimas[idx];
                      return Card(
                        color: n.isRead ? null : AppColors.info.withAlpha(30),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.notifications, color: n.isRead ? AppColors.primary : AppColors.info),
                          title: Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold)),
                          subtitle: Text(n.message),
                          trailing: Text(
                            '${n.createdAt.day.toString().padLeft(2, '0')}/${n.createdAt.month.toString().padLeft(2, '0')} ${n.createdAt.hour.toString().padLeft(2, '0')}:${n.createdAt.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                          onTap: () => context.go('/notifications'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text('Accesos rápidos', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            FutureBuilder<List<ProjectDTO>>(
              future: _projectsFuture,
              builder: (context, snapshot) {
                final hasProjects = snapshot.hasData && snapshot.data!.isNotEmpty;
                return Wrap(
                  spacing: 12,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.add_task, color: AppColors.primary),
                      label: const Text('Nueva tarea'),
                      onPressed: hasProjects
                          ? () {
                              Feedback.forTap(context);
                              context.go('/projects');
                            }
                          : null,
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
