import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/colors.dart';

class ProjectEditScreen extends StatefulWidget {
  final String? projectId;
  const ProjectEditScreen({super.key, this.projectId});

  @override
  State<ProjectEditScreen> createState() => _ProjectEditScreenState();
}

class _ProjectEditScreenState extends State<ProjectEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _membersController;

  @override
  void initState() {
    super.initState();
    // Prefill with simulated data
    _nameController = TextEditingController(
      text: 'Proyecto ${widget.projectId}',
    );
    _descriptionController = TextEditingController(
      text: 'Descripción detallada del proyecto ${widget.projectId}',
    );
    _startDateController = TextEditingController(text: '2023-06-01');
    _endDateController = TextEditingController(text: '2023-12-31');
    _membersController = TextEditingController(
      text: 'Ana García, Carlos López, María Rodríguez',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _membersController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      // Save logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            AppStrings.success,
            style: TextStyle(color: AppColors.textOnPrimary),
          ),
          backgroundColor: AppColors.primary,
        ),
      );
      context.pop();
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().substring(0, 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar proyecto'),
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre del proyecto',
                          prefixIcon: const Icon(Icons.folder),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Campo obligatorio'
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Descripción',
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _startDateController,
                        decoration: InputDecoration(
                          labelText: 'Fecha de inicio',
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
                        ),
                        readOnly: true,
                        onTap: () => _pickDate(_startDateController),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _endDateController,
                        decoration: InputDecoration(
                          labelText: 'Fecha de fin',
                          prefixIcon: const Icon(Icons.event),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
                        ),
                        readOnly: true,
                        onTap: () => _pickDate(_endDateController),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _membersController,
                        decoration: InputDecoration(
                          labelText: 'Miembros (separados por coma)',
                          prefixIcon: const Icon(Icons.group),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Feedback.forTap(context);
                  _save();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.save),
                label: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
