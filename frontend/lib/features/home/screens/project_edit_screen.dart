import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/colors.dart';
import '../data/project_service.dart';
import '../data/project_models.dart'; // Added import for ProjectDTO

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
  bool _isLoading = true; // Set to true initially as we'll be fetching
  String? _error;
  ProjectDTO? _project; // Added state variable for the project

  @override
  void initState() {
    super.initState();
    // Initialize controllers without text first
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _membersController = TextEditingController();

    _fetchProjectDetails(); // Call new method
  }

  Future<void> _fetchProjectDetails() async {
    if (widget.projectId == null) {
      setState(() {
        _error = 'ID de proyecto no disponible.';
        _isLoading = false;
      });
      return;
    }
    // Initial _isLoading is true, no need to set it again here unless re-fetching
    // If called for a refresh, then:
    // setState(() { _isLoading = true; _error = null; });
    try {
      final projectData = await ProjectService().getProjectById(widget.projectId!);
      if (mounted) {
        setState(() {
          _project = projectData;
          _nameController.text = projectData.name;
          _descriptionController.text = projectData.description ?? '';
          _startDateController.text = projectData.startDate?.toIso8601String().substring(0, 10) ?? '';
          _endDateController.text = projectData.endDate?.toIso8601String().substring(0, 10) ?? '';
          // _membersController is not directly tied to ProjectDTO fields for now
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error al cargar datos del proyecto: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

  void _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      try {
        await ProjectService().updateProject(
          projectId: widget.projectId!,
          name: _nameController.text,
          description: _descriptionController.text,
          startDate: DateTime.tryParse(_startDateController.text),
          endDate: DateTime.tryParse(_endDateController.text),
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proyecto actualizado', style: TextStyle(color: AppColors.textOnPrimary)),
            backgroundColor: AppColors.primary,
          ),
        );
        context.pop();
      } catch (e) {
        setState(() {
          _error = 'Error al actualizar proyecto: '
              '${e.toString().replaceAll('Exception:', '').trim()}';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
    Widget bodyContent;
    if (_isLoading) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      bodyContent = Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 16)),
        ),
      );
    } else if (_project == null) {
      bodyContent = const Center(child: Text('Proyecto no encontrado.'));
    } else {
      // Form content when data is loaded
      bodyContent = Padding(
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
                onPressed: _isLoading ? null : () {
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
              // Error display is now handled by the main bodyContent logic for _error
              // We can keep a smaller error display for save errors specifically if needed,
              // but the main _error will cover fetch errors.
              // For save errors, the existing display after the button is fine.
              if (_error != null && !_isLoading) ...[ // Show save error if not loading
                 const SizedBox(height: 12),
                 Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_project?.name ?? 'Editar proyecto'), // Dynamic title
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
      body: bodyContent,
    );
  }
}
