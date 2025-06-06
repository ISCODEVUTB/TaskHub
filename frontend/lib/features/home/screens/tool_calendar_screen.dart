import 'package:flutter/material.dart';
import '../../home/data/external_tools_service.dart';
import '../../../core/constants/colors.dart';

class ToolCalendarScreen extends StatefulWidget {
  const ToolCalendarScreen({super.key});

  @override
  State<ToolCalendarScreen> createState() => _ToolCalendarScreenState();
}

class _ToolCalendarScreenState extends State<ToolCalendarScreen> {
  List<String> _events = [];
  bool _loading = true;
  String? _error;
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ExternalToolsService().listCalendarEvents();
      setState(() {
        _events = List<String>.from(data['events'] ?? []);
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

  Future<void> _createEvent() async {
    final summary = _summaryController.text.trim();
    final start = _startController.text.trim();
    final end = _endController.text.trim();
    if (summary.isEmpty || start.isEmpty || end.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos para crear un evento.')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await ExternalToolsService().createCalendarEvent(summary, start, end);
      _summaryController.clear();
      _startController.clear();
      _endController.clear();
      await _fetchEvents();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento creado')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear evento: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _summaryController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario externo'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 2,
        toolbarHeight: 48,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Regresar',
          onPressed: () {
            Feedback.forTap(context);
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Crear nuevo evento', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _summaryController,
              decoration: const InputDecoration(labelText: 'Resumen'),
            ),
            TextField(
              controller: _startController,
              decoration: const InputDecoration(labelText: 'Inicio (YYYY-MM-DD HH:MM)'),
            ),
            TextField(
              controller: _endController,
              decoration: const InputDecoration(labelText: 'Fin (YYYY-MM-DD HH:MM)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Crear evento'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
              ),
              onPressed: _loading ? null : _createEvent,
            ),
            const SizedBox(height: 24),
            const Text('Eventos del calendario', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (_loading)
              const Center(child: CircularProgressIndicator()),
            if (_error != null)
              Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            if (!_loading && _error == null)
              Expanded(
                child: _events.isEmpty
                    ? const Center(child: Text('No hay eventos'))
                    : ListView.separated(
                        itemCount: _events.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.event, color: AppColors.primary),
                            title: Text(_events[index]),
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
