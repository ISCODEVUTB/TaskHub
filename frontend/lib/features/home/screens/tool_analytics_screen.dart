import 'package:flutter/material.dart';
import '../../home/data/external_tools_service.dart';
import '../../../core/constants/colors.dart';

class ToolAnalyticsScreen extends StatefulWidget {
  const ToolAnalyticsScreen({super.key});

  @override
  State<ToolAnalyticsScreen> createState() => _ToolAnalyticsScreenState();
}

class _ToolAnalyticsScreenState extends State<ToolAnalyticsScreen> {
  final TextEditingController _cardIdController = TextEditingController();
  Map<String, dynamic>? _analyticsData;
  bool _loading = false;
  String? _error;

  Future<void> _fetchAnalytics() async {
    setState(() {
      _loading = true;
      _error = null;
      _analyticsData = null;
    });
    try {
      final cardId = int.tryParse(_cardIdController.text.trim());
      if (cardId == null) {
        setState(() {
          _error = 'ID de tarjeta inválido';
        });
        return;
      }
      // Aquí deberías obtener el sessionToken y metabaseUrl reales
      final sessionToken = 'demo_token';
      final metabaseUrl = 'https://metabase.example.com';
      final data = await ExternalToolsService().getMetabaseCardData(cardId, sessionToken, metabaseUrl);
      setState(() {
        _analyticsData = data;
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

  @override
  void dispose() {
    _cardIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics (Metabase)'),
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
            const Text('ID de tarjeta de Metabase:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cardIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Ej: 123'),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _loading ? null : _fetchAnalytics,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnPrimary,
                  ),
                  child: _loading
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Consultar'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_error != null)
              Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            if (_analyticsData != null)
              Expanded(
                child: SingleChildScrollView(
                  child: _buildAnalyticsData(_analyticsData!),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsData(Map<String, dynamic> data) {
    if (data.isEmpty) {
      return const Text('No hay datos para mostrar.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${e.key}: ', style: const TextStyle(fontWeight: FontWeight.bold)),
              Expanded(child: Text('${e.value}')),
            ],
          ),
        );
      }).toList(),
    );
  }
}
