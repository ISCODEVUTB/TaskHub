import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../home/data/project_service.dart';
import '../../home/data/project_models.dart';

class TaskDetailScreen extends StatefulWidget {
  final String? taskId;
  final String? projectId;
  const TaskDetailScreen({super.key, this.taskId, this.projectId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  TaskDTO? _task;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchTask();
  }

  Future<void> _fetchTask() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (widget.taskId == null || widget.projectId == null) throw Exception('ID de tarea o proyecto no proporcionado');
      final task = await ProjectService().getProjectTasks(widget.projectId!);
      final found = task.firstWhere((t) => t.id == widget.taskId, orElse: () => throw Exception('Tarea no encontrada'));
      setState(() {
        _task = found;
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

  Widget _buildDetail(TaskDTO task) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.task, color: AppColors.primary, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                task.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('ID: ${task.id}'),
        Text('Proyecto: ${task.projectId}'),
        Text('Creador: ${task.creatorId}'),
        if (task.assigneeId != null) Text('Asignado a: ${task.assigneeId}'),
        if (task.dueDate != null) Text('Fecha de vencimiento: ${task.dueDate}'),
        Text('Prioridad: ${task.priority}'),
        Text('Estado: ${task.status}'),
        if (task.tags != null && task.tags!.isNotEmpty) Text('Tags: ${task.tags!.join(", ")}'),
        if (task.metadata != null && task.metadata!.isNotEmpty) Text('Metadata: ${task.metadata}'),
        if (task.createdAt != null) Text('Creado: ${task.createdAt}'),
        if (task.updatedAt != null) Text('Actualizado: ${task.updatedAt}'),
        const SizedBox(height: 18),
        Text('Descripción', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const Divider(),
        Text(task.description ?? '-', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15)),
      ],
    );
  }

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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _task == null
                  ? const Center(child: Text('Tarea no encontrada'))
                  : Stack(
                      children: [
                        _buildDetail(_task!),
                        Positioned(
                          bottom: 24,
                          right: 24,
                          child: FloatingActionButton(
                            onPressed: () {
                              if (_task != null && widget.projectId != null) {
                                context.go('/edit-task', extra: {
                                  'task': _task!,
                                  'projectId': widget.projectId!
                                });
                              }
                            },
                            child: const Icon(Icons.edit),
                            tooltip: 'Editar tarea',
                          ),
                        ),
                      ],
                    ),
    );
  }
}
