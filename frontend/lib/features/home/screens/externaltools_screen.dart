import 'package:flutter/material.dart';
import '../../home/data/external_tools_service.dart';
import '../../home/data/external_tools_models.dart';
import '../../../core/constants/colors.dart';

class ExternalToolsScreen extends StatefulWidget {
  const ExternalToolsScreen({super.key});

  @override
  State<ExternalToolsScreen> createState() => _ExternalToolsScreenState();
}

class _ExternalToolsScreenState extends State<ExternalToolsScreen> {
  List<ExternalToolConnectionDTO> _connections = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchConnections();
  }

  Future<void> _fetchConnections() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final conns = await ExternalToolsService().getUserConnections();
      setState(() {
        _connections = conns;
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

  Future<void> _disconnect(String connectionId) async {
    try {
      await ExternalToolsService().deleteConnection(connectionId);
      await _fetchConnections();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al desconectar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Herramientas externas'),
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
              : _connections.isEmpty
                  ? const Center(child: Text('No hay conexiones'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(24.0),
                      itemCount: _connections.length,
                      separatorBuilder: (context, index) => Divider(height: 24, color: Theme.of(context).dividerColor),
                      itemBuilder: (context, index) {
                        final conn = _connections[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.secondary.withAlpha(38),
                              child: Icon(
                                _iconForProvider(conn.providerType),
                                color: AppColors.secondary,
                              ),
                            ),
                            title: Text(
                              conn.accountName ?? conn.providerType,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Proveedor: ${conn.providerType}'),
                                if (conn.accountEmail != null) Text('Email: ${conn.accountEmail}'),
                                if (conn.isActive) const Text('Estado: Activa', style: TextStyle(color: Colors.green)),
                                if (!conn.isActive) const Text('Estado: Inactiva', style: TextStyle(color: Colors.red)),
                                if (conn.expiresAt != null) Text('Expira: ${conn.expiresAt}'),
                                if (conn.lastUsedAt != null) Text('Último uso: ${conn.lastUsedAt}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.link_off, color: AppColors.primary),
                              tooltip: 'Desconectar',
                              onPressed: () => _disconnect(conn.id),
                            ),
                            onTap: () {
                              // Acción al tocar la conexión (por ejemplo, ver recursos externos)
                            },
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para conectar nueva herramienta externa
          // Por ejemplo: Navigator.of(context).pushNamed('/externaltools/connect');
        },
        tooltip: 'Conectar herramienta',
        child: const Icon(Icons.add_link),
      ),
    );
  }

  IconData _iconForProvider(String providerType) {
    switch (providerType) {
      case 'github':
        return Icons.code;
      case 'google_drive':
        return Icons.cloud;
      case 'dropbox':
        return Icons.cloud_upload;
      case 'onedrive':
        return Icons.cloud_done;
      case 'slack':
        return Icons.chat;
      case 'jira':
        return Icons.bug_report;
      case 'trello':
        return Icons.view_kanban;
      default:
        return Icons.extension;
    }
  }
}
