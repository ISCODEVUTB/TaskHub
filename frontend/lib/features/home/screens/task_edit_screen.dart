import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // For date formatting
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
  // Removed _priorityController and _statusController

  late String _priority;
  late String _status;

  bool _isLoading = false;
  String? _error;

  // Maps for dropdown values and display names
  final Map<String, String> _priorityOptions = {
    'low': 'Baja',
    'medium': 'Media',
    'high': 'Alta',
    'urgent': 'Urgente',
  };

  final Map<String, String> _statusOptions = {
    'todo': 'Por hacer',
    'in_progress': 'En progreso',
    'review': 'En revisión',
    'done': 'Hecho',
  };

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description ?? '');
    _assigneeController = TextEditingController(text: widget.task.assigneeId ?? '');
    // Initialize DueDateController with formatted date or empty
    _dueDateController = TextEditingController(
        text: widget.task.dueDate != null
            ? DateFormat('yyyy-MM-dd').format(widget.task.dueDate!)
            : '');
    // Initialize state variables for priority and status
    _priority = widget.task.priority;
    _status = widget.task.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _assigneeController.dispose();
    _dueDateController.dispose();
    // Removed _priorityController.dispose() and _statusController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      try {
        DateTime? dueDate;
        if (_dueDateController.text.isNotEmpty) {
          try {
            dueDate = DateFormat('yyyy-MM-dd').parse(_dueDateController.text);
          } catch (e) {
            // Handle parsing error if needed, though DatePicker should prevent this
            if (mounted) {
              setState(() {
                _error = 'Formato de fecha inválido.';
                _isLoading = false;
              });
            }
            return;
          }
        }

        await ProjectService().updateTask(
          projectId: widget.projectId,
          taskId: widget.task.id,
          title: _titleController.text,
          description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
          assigneeId: _assigneeController.text.isNotEmpty ? _assigneeController.text : null,
          dueDate: dueDate,
          priority: _priority, // Use state variable
          status: _status,   // Use state variable
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

  Future<void> _selectDueDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (_dueDateController.text.isNotEmpty) {
      try {
        initialDate = DateFormat('yyyy-MM-dd').parse(_dueDateController.text);
      } catch (e) { /* Use DateTime.now() if parsing fails */ }
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
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
                decoration: const InputDecoration(labelText: 'Título', prefixIcon: Icon(Icons.title)),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción', prefixIcon: Icon(Icons.description)),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _assigneeController,
                decoration: const InputDecoration(labelText: 'ID Asignado', prefixIcon: Icon(Icons.person_outline)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dueDateController,
                decoration: const InputDecoration(
                  labelText: 'Fecha de vencimiento',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDueDate(context),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Prioridad', prefixIcon: Icon(Icons.priority_high)),
                items: _priorityOptions.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _priority = newValue;
                    });
                  }
                },
                validator: (value) => value == null || value.isEmpty ? 'Selecciona una prioridad' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Estado', prefixIcon: Icon(Icons.task_alt)),
                items: _statusOptions.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _status = newValue;
                    });
                  }
                },
                validator: (value) => value == null || value.isEmpty ? 'Selecciona un estado' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _save,
                icon: const Icon(Icons.save),
                label: Text(_isLoading ? 'Guardando...' : 'Guardar cambios'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 16)
                ),
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