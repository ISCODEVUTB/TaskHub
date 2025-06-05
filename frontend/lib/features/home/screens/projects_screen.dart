import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/section_card.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projects = List.generate(5, (index) => 'Proyecto ${index + 1}');
    final filteredProjects =
        projects
            .where((p) => p.toLowerCase().contains(_search.toLowerCase()))
            .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proyectos'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 2,
        toolbarHeight: 48,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar proyecto...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: filteredProjects.length,
              separatorBuilder:
                  (context, index) =>
                      Divider(height: 24, color: Theme.of(context).dividerColor),
              itemBuilder: (context, index) {
                final projectId = (index + 1).toString();
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withAlpha(38),
                      child: Icon(Icons.folder, color: AppColors.primary),
                    ),
                    title: Text(
                      filteredProjects[index],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Creado el ${DateTime.now().toLocal().toIso8601String().substring(0, 10)}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall,
                    ),
                    trailing: StatusBadge(status: 'En progreso'),
                    onTap: () {
                      Feedback.forTap(context);
                      context.go('/project/$projectId');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/create-project'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
