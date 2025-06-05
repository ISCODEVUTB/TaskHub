import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'projects_screen.dart';
import 'documents_screen.dart';
import 'notifications_screen.dart';
import 'externaltools_screen.dart';
import 'profile_screen.dart';
import '../../../core/constants/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isRailExtended = true;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const ProjectsPage(),
    const DocumentsPage(),
    const NotificationsPage(),
    const ExternalToolsPage(),
    const ProfilePage(),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleRail() {
    setState(() {
      _isRailExtended = !_isRailExtended;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: _isRailExtended,
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            leading: IconButton(
              icon: Icon(_isRailExtended ? Icons.arrow_back : Icons.menu),
              onPressed: _toggleRail,
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text(AppStrings.homeTitle),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.folder),
                label: Text(AppStrings.projectsTitle),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.description),
                label: Text(AppStrings.documentsTitle),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.notifications),
                label: Text(AppStrings.notificationsTitle),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.extension),
                label: Text(AppStrings.toolsTitle),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text(AppStrings.profileTitle),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}