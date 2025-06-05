import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/section_card.dart';

class TaskDetailScreen extends StatelessWidget {
  final String? taskId;
  final Map<String, dynamic>? taskData;
  const TaskDetailScreen({super.key, this.taskId, this.taskData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Tarea'),
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
      body:
          taskData == null
              ? Center(child: Text('Aquí van los detalles de la tarea $taskId'))
              : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _TaskDetailContent(taskData: taskData!),
                  ),
                ),
              ),
    );
  }
}

// Nuevo widget para manejar el estado local y la animación
class _TaskDetailContent extends StatefulWidget {
  final Map<String, dynamic> taskData;
  const _TaskDetailContent({required this.taskData});

  @override
  State<_TaskDetailContent> createState() => _TaskDetailContentState();
}

class _TaskDetailContentState extends State<_TaskDetailContent> {
  late String _status;

  @override
  void initState() {
    super.initState();
    _status = widget.taskData['status'] ?? 'Pendiente';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PopupMenuButton<String>(
              initialValue: _status,
              onSelected: (value) {
                setState(() {
                  _status = value;
                  widget.taskData['status'] = value;
                });
                // Animación visual: mostrar un SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Estado cambiado a "$value"'),
                    duration: const Duration(milliseconds: 900),
                    backgroundColor: Colors.black.withAlpha(220),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'Pendiente',
                  child: Text('Pendiente'),
                ),
                const PopupMenuItem(
                  value: 'En progreso',
                  child: Text('En progreso'),
                ),
                const PopupMenuItem(
                  value: 'Completado',
                  child: Text('Completado'),
                ),
              ],
              child: StatusBadge(status: _status),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.taskData['title'] ?? '',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.person,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Asignado a: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.taskData['assignee'] ?? '-'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: AppColors.secondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Fecha de vencimiento: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.taskData['dueDate'] ?? '-'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.info,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Estado: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_status),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          'Descripción',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Divider(),
        Text(
          widget.taskData['description'] ?? '-',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
        ),
      ],
    );
  }
}
