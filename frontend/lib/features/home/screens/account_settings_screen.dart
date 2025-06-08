import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../theme/theme_provider.dart';
import '../../auth/data/auth_service.dart'; // Added import

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta'),
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.lock, color: AppColors.primary),
                  title: const Text('Cambiar contraseña'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Feedback.forTap(context);
                    context.go('/change-password');
                  },
                ),
                Divider(color: Theme.of(context).dividerColor),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.error),
                  title: const Text('Cerrar sesión'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async { // Made async
                    Feedback.forTap(context);
                    final authService = Provider.of<AuthService>(context, listen: false);
                    await authService.signOut();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                ),
                Divider(color: Theme.of(context).dividerColor),
                SwitchListTile(
                  title: const Text('Tema oscuro'),
                  value: themeProvider.isDarkMode,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme();
                  },
                  secondary: const Icon(Icons.brightness_6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
