import 'package:flutter/material.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/colors.dart';
import 'task_detail_screen.dart';
import '../../../core/widgets/section_card.dart';
import '../../../core/widgets/navigation_utils.dart';

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
  String _assignee = '';
  String _status = 'Pendiente';

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

  void _saveTask() {
    if (_formKey.currentState?.validate() ?? false) {
      final newTask = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'dueDate': _dueDateController.text,
        'assignee': _assignee,
        'status': _status,
      };
      // Simula el guardado y navega a la pantalla de detalles
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (_) => TaskDetailScreen(taskId: 'simulada', taskData: newTask),
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
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
          onPressed: () => smartPop(context, fallbackRoute: '/projects'),
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
                      decoration: InputDecoration(
                        labelText: 'Título de la tarea',
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
                      ),
                      validator:
                          (v) =>
                              v == null || v.isEmpty
                                  ? AppStrings.emptyField
                                  : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        prefixIcon: Icon(Icons.description_outlined),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _dueDateController,
                      decoration: InputDecoration(
                        labelText: 'Fecha de vencimiento',
                        prefixIcon: Icon(Icons.event),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
                      ),
                      readOnly: true,
                      onTap: _pickDueDate,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Asignado a',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
                      ),
                      onChanged: (v) => _assignee = v,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _status,
                      items:
                          ['Pendiente', 'En progreso', 'Completado']
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                      decoration: InputDecoration(
                        labelText: 'Estado',
                        prefixIcon: Icon(Icons.flag),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
                      ),
                      onChanged:
                          (v) => setState(() => _status = v ?? 'Pendiente'),
                    ),
                    const SizedBox(height: 12),
                    StatusBadge(status: _status),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Feedback.forTap(context);
                        _saveTask();
                      },
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
                      label: const Text('Guardar'),
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
