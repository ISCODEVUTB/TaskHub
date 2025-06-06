import 'package:flutter/material.dart';
import '../../home/data/notification_service.dart';
import '../../home/data/notification_models.dart';
import '../../../core/constants/colors.dart';

class NotificationsPreferencesScreen extends StatefulWidget {
  const NotificationsPreferencesScreen({super.key});

  @override
  State<NotificationsPreferencesScreen> createState() => _NotificationsPreferencesScreenState();
}

class _NotificationsPreferencesScreenState extends State<NotificationsPreferencesScreen> {
  NotificationPreferencesDTO? _prefs;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  // Campos editables
  bool? _emailEnabled;
  bool? _pushEnabled;
  bool? _smsEnabled;
  bool? _inAppEnabled;
  bool? _digestEnabled;
  String? _digestFrequency;
  bool? _quietHoursEnabled;
  String? _quietHoursStart;
  String? _quietHoursEnd;

  @override
  void initState() {
    super.initState();
    _fetchPreferences();
  }

  Future<void> _fetchPreferences() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final prefs = await NotificationService().getNotificationPreferences();
      setState(() {
        _prefs = prefs;
        _emailEnabled = prefs.emailEnabled;
        _pushEnabled = prefs.pushEnabled;
        _smsEnabled = prefs.smsEnabled;
        _inAppEnabled = prefs.inAppEnabled;
        _digestEnabled = prefs.digestEnabled;
        _digestFrequency = prefs.digestFrequency;
        _quietHoursEnabled = prefs.quietHoursEnabled;
        _quietHoursStart = prefs.quietHoursStart;
        _quietHoursEnd = prefs.quietHoursEnd;
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

  Future<void> _savePreferences() async {
    setState(() {
      _saving = true;
    });
    try {
      await NotificationService().updateNotificationPreferences(
        NotificationPreferencesDTO(
          userId: _prefs!.userId,
          emailEnabled: _emailEnabled ?? true,
          pushEnabled: _pushEnabled ?? true,
          smsEnabled: _smsEnabled ?? false,
          inAppEnabled: _inAppEnabled ?? true,
          digestEnabled: _digestEnabled ?? false,
          digestFrequency: _digestFrequency,
          quietHoursEnabled: _quietHoursEnabled ?? false,
          quietHoursStart: _quietHoursStart,
          quietHoursEnd: _quietHoursEnd,
          preferencesByType: _prefs?.preferencesByType,
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preferencias guardadas')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      setState(() {
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferencias de notificaciones'),
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _prefs == null
                  ? const Center(child: Text('No se pudieron cargar las preferencias'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwitchListTile(
                            title: const Text('Notificaciones por email'),
                            value: _emailEnabled ?? true,
                            onChanged: (v) => setState(() => _emailEnabled = v),
                          ),
                          SwitchListTile(
                            title: const Text('Notificaciones push'),
                            value: _pushEnabled ?? true,
                            onChanged: (v) => setState(() => _pushEnabled = v),
                          ),
                          SwitchListTile(
                            title: const Text('Notificaciones por SMS'),
                            value: _smsEnabled ?? false,
                            onChanged: (v) => setState(() => _smsEnabled = v),
                          ),
                          SwitchListTile(
                            title: const Text('Notificaciones in-app'),
                            value: _inAppEnabled ?? true,
                            onChanged: (v) => setState(() => _inAppEnabled = v),
                          ),
                          SwitchListTile(
                            title: const Text('Resumen (digest)'),
                            value: _digestEnabled ?? false,
                            onChanged: (v) => setState(() => _digestEnabled = v),
                          ),
                          if (_digestEnabled ?? false)
                            DropdownButtonFormField<String>(
                              value: _digestFrequency,
                              decoration: const InputDecoration(labelText: 'Frecuencia del resumen'),
                              items: const [
                                DropdownMenuItem(value: 'daily', child: Text('Diario')),
                                DropdownMenuItem(value: 'weekly', child: Text('Semanal')),
                              ],
                              onChanged: (v) => setState(() => _digestFrequency = v),
                            ),
                          SwitchListTile(
                            title: const Text('Horario de silencio (quiet hours)'),
                            value: _quietHoursEnabled ?? false,
                            onChanged: (v) => setState(() => _quietHoursEnabled = v),
                          ),
                          if (_quietHoursEnabled ?? false)
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _quietHoursStart,
                                    decoration: const InputDecoration(labelText: 'Inicio (HH:MM)'),
                                    onChanged: (v) => _quietHoursStart = v,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _quietHoursEnd,
                                    decoration: const InputDecoration(labelText: 'Fin (HH:MM)'),
                                    onChanged: (v) => _quietHoursEnd = v,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: _saving
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Icon(Icons.save),
                              label: const Text('Guardar preferencias'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.textOnPrimary,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: _saving ? null : _savePreferences,
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
