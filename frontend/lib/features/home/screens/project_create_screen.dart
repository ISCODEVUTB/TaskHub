import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/navigation_utils.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _membersController = TextEditingController();

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _membersController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // ignore: unused_local_variable
      final projectName = _projectNameController.text;
      // Lógica para crear el proyecto
      context.pop();

      // Si necesitas pasar datos de vuelta a la pantalla anterior:
      // context.pop({'name': projectName});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear proyecto'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                        controller: _projectNameController,
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
                            (value) =>
                                value == null || value.isEmpty
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
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            _startDateController.text = picked
                                .toIso8601String()
                                .substring(0, 10);
                          }
                        },
                        readOnly: true,
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
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            _endDateController.text = picked
                                .toIso8601String()
                                .substring(0, 10);
                          }
                        },
                        readOnly: true,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _membersController,
                        decoration: InputDecoration(
                          labelText: 'Miembros iniciales (separados por coma)',
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
                  _submitForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.save),
                label: const Text('Crear proyecto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
