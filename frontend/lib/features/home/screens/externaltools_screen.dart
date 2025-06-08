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
  bool _loading = true; // For existing connections
  String? _error; // For existing connections

  List<OAuthProviderDTO> _availableProviders = [];
  bool _providersLoading = true; // For fetching providers
  String? _providersError; // For fetching providers

  final ExternalToolsService _externalToolsService = ExternalToolsService();

  @override
  void initState() {
    super.initState();
    _fetchConnections();
    _fetchAvailableProviders(); // Added call
  }

  Future<void> _fetchAvailableProviders() async {
    setState(() {
      _providersLoading = true;
      _providersError = null;
    });
    try {
      final providers = await _externalToolsService.getOAuthProviders();
      if (mounted) {
        setState(() {
          _availableProviders = providers;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _providersError = 'Error al cargar proveedores: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _providersLoading = false;
        });
      }
    }
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
        onPressed: _showAvailableProvidersDialog, // Updated FAB onPressed
        tooltip: 'Conectar nueva herramienta',
        child: const Icon(Icons.add_link),
      ),
    );
  }

  IconData _iconForProvider(String providerType) {
    switch (providerType) {
      case 'github':
        return Icons.code;
      // Add other cases as defined in your ExternalToolType enum or data
      case 'google_drive': // Assuming 'google_drive' is a value from your ExternalToolType
        return Icons.cloud_outlined; // Corrected icon name
      default:
        return Icons.extension;
    }
  }

  void _handleProviderTap(OAuthProviderDTO provider) async {
    // Called when a provider is tapped in the dialog
    Navigator.of(context).pop(); // Close the dialog
    try {
      // For this subtask, redirectUri is omitted to use backend default
      final authUrl = await _externalToolsService.getAuthorizationUrl(provider.id);

      print('Authorization URL: $authUrl'); // Print to console
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Abrir esta URL para autorizar: $authUrl', maxLines: 3, overflow: TextOverflow.ellipsis),
            duration: const Duration(seconds: 10), // Longer duration for URL
            action: SnackBarAction(label: 'COPIAR', onPressed: () {
              // TODO: Implement copy to clipboard if 'clipboard' package is added
            }),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener URL de autorización: ${e.toString()}')),
        );
      }
    }
  }

  void _showAvailableProvidersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Use a StatefulBuilder if the dialog content needs its own state updates
        // For now, relying on _providersLoading, _providersError, _availableProviders from the main screen state.
        Widget content;
        if (_providersLoading) {
          content = const Center(child: CircularProgressIndicator());
        } else if (_providersError != null) {
          content = Text(_providersError!, style: const TextStyle(color: Colors.red));
        } else if (_availableProviders.isEmpty) {
          content = const Text('No hay proveedores de OAuth disponibles.');
        } else {
          content = SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _availableProviders.length,
              itemBuilder: (BuildContext context, int index) {
                final provider = _availableProviders[index];
                return ListTile(
                  leading: Icon(_iconForProvider(provider.type.toString().split('.').last.toLowerCase())), // Get string value of enum
                  title: Text(provider.name),
                  subtitle: Text(provider.type.toString().split('.').last),
                  onTap: () => _handleProviderTap(provider),
                );
              },
            ),
          );
        }

        return AlertDialog(
          title: const Text('Conectar nueva herramienta'),
          content: content,
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
