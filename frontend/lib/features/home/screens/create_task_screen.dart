import 'package:flutter/material.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/colors.dart';
import '../../home/data/project_service.dart';

class CreateTaskScreen extends StatefulWidget {
  final String? projectId;
  const CreateTaskScreen({super.key, this.projectId});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _assigneeIdController = TextEditingController();
  final _tagsController = TextEditingController();
  final _metadataController = TextEditingController();
  String _priority = 'medium';
  String _status = 'todo';
  bool _loading = false;
  String? _error;

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _dueDateController.text = picked.toIso8601String().substring(0, 10);
    }
  }

  Future<void> _saveTask() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final tags = _tagsController.text.isNotEmpty
          ? _tagsController.text.split(',').map((e) => e.trim()).toList()
          : null;
      final metadata = _metadataController.text.isNotEmpty
          ? Map<String, dynamic>.from(Uri.splitQueryString(_metadataController.text))
          : null;
      await ProjectService().createTask(
        projectId: widget.projectId!,
        title: _titleController.text,
        description: _descriptionController.text,
        assigneeId: _assigneeIdController.text.isNotEmpty ? _assigneeIdController.text : null,
        dueDate: _dueDateController.text.isNotEmpty ? DateTime.parse(_dueDateController.text) : null,
        priority: _priority,
        status: _status,
        tags: tags,
        metadata: metadata,
      );
      if (mounted) Navigator.of(context).pop(true);
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    _assigneeIdController.dispose();
    _tagsController.dispose();
    _metadataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear tarea'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Regresar',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary.withAlpha(25),
                          child: const Icon(
                            Icons.add_task_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Nueva tarea',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título de la tarea',
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      validator: (v) => v == null || v.isEmpty ? AppStrings.emptyField : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        prefixIcon: Icon(Icons.description_outlined),
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _dueDateController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de vencimiento',
                        prefixIcon: Icon(Icons.event),
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      readOnly: true,
                      onTap: _pickDueDate,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _assigneeIdController,
                      decoration: const InputDecoration(
                        labelText: 'ID de asignado',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _priority,
                      items: [
                        DropdownMenuItem(value: 'low', child: Text('Baja')),
                        DropdownMenuItem(value: 'medium', child: Text('Media')),
                        DropdownMenuItem(value: 'high', child: Text('Alta')),
                        DropdownMenuItem(value: 'urgent', child: Text('Urgente')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Prioridad',
                        prefixIcon: Icon(Icons.priority_high),
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      onChanged: (v) => setState(() => _priority = v ?? 'medium'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _status,
                      items: [
                        DropdownMenuItem(value: 'todo', child: Text('Por hacer')),
                        DropdownMenuItem(value: 'in_progress', child: Text('En progreso')),
                        DropdownMenuItem(value: 'review', child: Text('En revisión')),
                        DropdownMenuItem(value: 'done', child: Text('Hecha')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Estado',
                        prefixIcon: Icon(Icons.flag),
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      onChanged: (v) => setState(() => _status = v ?? 'todo'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _tagsController,
                      decoration: const InputDecoration(
                        labelText: 'Tags (separados por coma)',
                        prefixIcon: Icon(Icons.label),
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _metadataController,
                      decoration: const InputDecoration(
                        labelText: 'Metadata (key1=val1&key2=val2)',
                        prefixIcon: Icon(Icons.data_object),
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_error != null)
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                    ElevatedButton.icon(
                      onPressed: _loading ? null : _saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: Theme.of(context).textTheme.labelLarge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.save),
                      label: _loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Guardar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
