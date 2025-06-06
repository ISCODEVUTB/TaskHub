import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../home/data/document_service.dart';
import '../../home/data/document_models.dart';

class DocumentEditScreen extends StatefulWidget {
  final DocumentDTO document;
  const DocumentEditScreen({super.key, required this.document});

  @override
  State<DocumentEditScreen> createState() => _DocumentEditScreenState();
}

class _DocumentEditScreenState extends State<DocumentEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _parentIdController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  late TextEditingController _metaDataController;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.document.name);
    _parentIdController = TextEditingController(text: widget.document.parentId ?? '');
    _descriptionController = TextEditingController(text: widget.document.description ?? '');
    _tagsController = TextEditingController(text: widget.document.tags?.join(', ') ?? '');
    _metaDataController = TextEditingController(text: widget.document.metaData?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _parentIdController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _metaDataController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      try {
        final tags = _tagsController.text.isNotEmpty
            ? _tagsController.text.split(',').map((e) => e.trim()).toList()
            : null;
        final metaData = _metaDataController.text.isNotEmpty
            ? Map<String, dynamic>.from(Uri.splitQueryString(_metaDataController.text))
            : null;
        await DocumentService().updateDocument(
          documentId: widget.document.id,
          name: _nameController.text,
          parentId: _parentIdController.text.isNotEmpty ? _parentIdController.text : null,
          description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
          tags: tags,
          metaData: metaData,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Documento actualizado', style: TextStyle(color: AppColors.textOnPrimary)),
            backgroundColor: AppColors.primary,
          ),
        );
        context.pop();
      } catch (e) {
        setState(() {
          _error = 'Error al actualizar documento: '
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
        title: const Text('Editar documento'),
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
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _parentIdController,
                decoration: const InputDecoration(labelText: 'ID Carpeta Padre'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(labelText: 'Tags (separados por coma)'),
              ),
              TextFormField(
                controller: _metaDataController,
                decoration: const InputDecoration(labelText: 'MetaData (key1=val1&key2=val2)'),
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