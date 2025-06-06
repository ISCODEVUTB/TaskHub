import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Added import
import '../../home/data/external_tools_service.dart';
import '../../../core/constants/colors.dart';

// Define _CalendarEvent model class
class _CalendarEvent {
  final String summary;
  final String start;
  final String end;

  _CalendarEvent({required this.summary, required this.start, required this.end});

  factory _CalendarEvent.fromJson(Map<String, dynamic> json) {
    return _CalendarEvent(
      summary: json['summary']?.toString() ?? 'Sin resumen',
      // Assuming 'start' and 'end' from backend are already strings in desired format or simple strings.
      // If they are DateTime objects or need specific parsing, adjust here.
      // For now, directly using what backend provides or placeholder.
      start: json['dtstart']?.toString() ?? json['start']?.toString() ?? 'Fecha inicio desconocida',
      end: json['dtend']?.toString() ?? json['end']?.toString() ?? 'Fecha fin desconocida',
    );
  }
}

class ToolCalendarScreen extends StatefulWidget {
  const ToolCalendarScreen({super.key});

  @override
  State<ToolCalendarScreen> createState() => _ToolCalendarScreenState();
}

class _ToolCalendarScreenState extends State<ToolCalendarScreen> {
  List<_CalendarEvent> _events = []; // Updated type
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

  Future<void> _pickDateTime(BuildContext context, TextEditingController controller) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date == null) return; // User canceled DatePicker

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );
    if (time == null) return; // User canceled TimePicker

    final DateTime dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    // Backend expects "YYYY-MM-DDTHH:MM:SS"
    controller.text = DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateTime);
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ExternalToolsService().listCalendarEvents();
      // Assuming data['events'] is the key holding the list of event maps
      final eventList = data['events'] as List<dynamic>? ?? (data as List<dynamic>? ?? []); // Handle if data itself is the list
      if (mounted) {
        setState(() {
          _events = eventList.map((e) => _CalendarEvent.fromJson(e as Map<String, dynamic>)).toList();
        });
      }
    } catch (e) {
      if (mounted) { // Add mounted check
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
            TextFormField( // Changed to TextFormField for potential validation
              controller: _summaryController,
              decoration: const InputDecoration(labelText: 'Resumen'),
              validator: (value) => (value == null || value.isEmpty) ? 'El resumen es obligatorio' : null,
            ),
            TextFormField(
              controller: _startController,
              decoration: const InputDecoration(labelText: 'Inicio (YYYY-MM-DDTHH:MM:SS)'),
              readOnly: true,
              onTap: () => _pickDateTime(context, _startController),
              validator: (value) => (value == null || value.isEmpty) ? 'La fecha de inicio es obligatoria' : null,
            ),
            TextFormField(
              controller: _endController,
              decoration: const InputDecoration(labelText: 'Fin (YYYY-MM-DDTHH:MM:SS)'),
              readOnly: true,
              onTap: () => _pickDateTime(context, _endController),
              validator: (value) => (value == null || value.isEmpty) ? 'La fecha de fin es obligatoria' : null,
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
                          final event = _events[index];
                          return ListTile(
                            leading: const Icon(Icons.event, color: AppColors.primary),
                            title: Text(event.summary),
                            subtitle: Text('Inicio: ${event.start}\nFin: ${event.end}'),
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
