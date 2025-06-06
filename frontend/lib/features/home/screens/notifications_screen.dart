import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../home/data/notification_service.dart';
import '../../home/data/notification_models.dart';
import '../../../core/constants/colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationDTO> _notifications = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final notifs = await NotificationService().getUserNotifications();
      setState(() {
        _notifications = notifs;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _deleteNotification(String notificationId) async {
    try {
      await NotificationService().deleteNotification(notificationId);
      if (mounted) {
        setState(() {
          _notifications.removeWhere((n) => n.id == notificationId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notificación eliminada.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar notificación: $e')),
        );
      }
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await NotificationService().markNotificationAsRead(notificationId);
      await _fetchNotifications();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al marcar como leído: $e')),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await NotificationService().markAllNotificationsAsRead();
      await _fetchNotifications(); // Refresh the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Todas las notificaciones marcadas como leídas.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al marcar todas como leídas: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if there are any unread notifications to enable/disable the button
    // bool hasUnreadNotifications = _notifications.any((n) => !n.isRead);

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Regresar',
          onPressed: () {
            Feedback.forTap(context);
            context.pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Marcar todas como leídas',
            // onPressed: hasUnreadNotifications ? _markAllAsRead : null, // Optionally disable if all are read
            onPressed: _markAllAsRead,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _notifications.isEmpty
                  ? const Center(child: Text('No hay notificaciones'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(24.0),
                      itemCount: _notifications.length,
                      separatorBuilder: (context, index) => Divider(height: 24, color: Theme.of(context).dividerColor),
                      itemBuilder: (context, index) {
                        final notif = _notifications[index];
                        return Card(
                          elevation: notif.isRead ? 1 : 4,
                          color: notif.isRead ? Colors.grey[100] : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            leading: Icon(
                              notif.type == 'system'
                                  ? Icons.notifications
                                  : notif.type == 'task'
                                      ? Icons.check_circle
                                      : notif.type == 'document'
                                          ? Icons.insert_drive_file
                                          : Icons.info,
                              color: notif.priority == 'high'
                                  ? Colors.red
                                  : notif.priority == 'low'
                                      ? Colors.blueGrey
                                      : AppColors.primary,
                            ),
                            title: Text(
                              notif.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                                  ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(notif.message),
                                Text('Tipo: ${notif.type}'),
                                Text('Prioridad: ${notif.priority}'),
                                Text('Canales: ${notif.channels.join(", ")}'),
                                if (notif.relatedEntityType != null && notif.relatedEntityId != null)
                                  Text('Relacionado: ${notif.relatedEntityType} (${notif.relatedEntityId})'),
                                if (notif.scheduledAt != null)
                                  Text('Programada: ${notif.scheduledAt}'),
                                if (notif.sentAt != null)
                                  Text('Enviada: ${notif.sentAt}'),
                                Text('Creada: ${notif.createdAt}'),
                                if (notif.isRead && notif.readAt != null)
                                  Text('Leída: ${notif.readAt}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!notif.isRead)
                                  IconButton(
                                    icon: const Icon(Icons.mark_email_read, color: AppColors.primary),
                                    tooltip: 'Marcar como leído',
                                    onPressed: () => _markAsRead(notif.id),
                                  ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline, color: Colors.grey[600]),
                                  tooltip: 'Eliminar notificación',
                                  onPressed: () => _deleteNotification(notif.id),
                                ),
                              ],
                            ),
                            onTap: () {
                              Feedback.forTap(context);
                              // Acción al tocar la notificación (por ejemplo, navegar a la entidad relacionada)
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
