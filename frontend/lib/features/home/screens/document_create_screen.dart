import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../home/data/document_service.dart';

class DocumentCreateScreen extends StatefulWidget {
  const DocumentCreateScreen({super.key});

  @override
  State<DocumentCreateScreen> createState() => _DocumentCreateScreenState();
}

class _DocumentCreateScreenState extends State<DocumentCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _projectIdController = TextEditingController();
  final _typeController = TextEditingController();
  final _parentIdController = TextEditingController();
  final _contentTypeController = TextEditingController();
  final _urlController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _metaDataController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _projectIdController.dispose();
    _typeController.dispose();
    _parentIdController.dispose();
    _contentTypeController.dispose();
    _urlController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _metaDataController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final tags = _tagsController.text.isNotEmpty
          ? _tagsController.text.split(',').map((e) => e.trim()).toList()
          : null;
      final metaData = _metaDataController.text.isNotEmpty
          ? Map<String, dynamic>.from(
              Uri.splitQueryString(_metaDataController.text))
          : null;
      await DocumentService().createDocument(
        name: _nameController.text,
        projectId: _projectIdController.text,
        type: _typeController.text,
        parentId: _parentIdController.text.isNotEmpty ? _parentIdController.text : null,
        contentType: _contentTypeController.text.isNotEmpty ? _contentTypeController.text : null,
        url: _urlController.text.isNotEmpty ? _urlController.text : null,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        tags: tags,
        metaData: metaData,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear documento'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 2,
        toolbarHeight: 48,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre *'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _projectIdController,
                decoration: const InputDecoration(labelText: 'ID de Proyecto *'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Tipo (file/folder/link) *'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _parentIdController,
                decoration: const InputDecoration(labelText: 'ID de Carpeta Padre'),
              ),
              TextFormField(
                controller: _contentTypeController,
                decoration: const InputDecoration(labelText: 'Content-Type (MIME)'),
              ),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(labelText: 'URL (para links o archivos)'),
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
              const SizedBox(height: 16),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Crear documento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 