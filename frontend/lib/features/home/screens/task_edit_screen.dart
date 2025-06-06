import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../home/data/project_service.dart';
import '../../home/data/project_models.dart';

class TaskEditScreen extends StatefulWidget {
  final TaskDTO task;
  final String projectId;
  const TaskEditScreen({super.key, required this.task, required this.projectId});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _assigneeController;
  late TextEditingController _dueDateController;
  late TextEditingController _priorityController;
  late TextEditingController _statusController;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description ?? '');
    _assigneeController = TextEditingController(text: widget.task.assigneeId ?? '');
    _dueDateController = TextEditingController(text: widget.task.dueDate?.toString() ?? '');
    _priorityController = TextEditingController(text: widget.task.priority);
    _statusController = TextEditingController(text: widget.task.status);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _assigneeController.dispose();
    _dueDateController.dispose();
    _priorityController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      try {
        await ProjectService().updateTask(
          projectId: widget.projectId,
          taskId: widget.task.id,
          title: _titleController.text,
          description: _descriptionController.text,
          assigneeId: _assigneeController.text.isNotEmpty ? _assigneeController.text : null,
          dueDate: _dueDateController.text.isNotEmpty ? DateTime.tryParse(_dueDateController.text) : null,
          priority: _priorityController.text,
          status: _statusController.text,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarea actualizada', style: TextStyle(color: AppColors.textOnPrimary)),
            backgroundColor: AppColors.primary,
          ),
        );
        context.pop();
      } catch (e) {
        setState(() {
          _error = 'Error al actualizar tarea: '
              '${e.toString().replaceAll('Exception:', '').trim()}';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar tarea'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextFormField(
                controller: _assigneeController,
                decoration: const InputDecoration(labelText: 'ID Asignado'),
              ),
              TextFormField(
                controller: _dueDateController,
                decoration: const InputDecoration(labelText: 'Fecha de vencimiento (YYYY-MM-DD)'),
              ),
              TextFormField(
                controller: _priorityController,
                decoration: const InputDecoration(labelText: 'Prioridad'),
              ),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _save,
                icon: const Icon(Icons.save),
                label: const Text('Guardar cambios'),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 