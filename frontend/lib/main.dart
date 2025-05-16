import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'routes/app_router.dart';
import 'theme/theme.dart';
import 'theme/theme_provider.dart';
import 'features/auth/data/auth_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Provider para el tema
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // Provider para el servicio de autenticación
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const TaskHubApp(),
    ),
  );
}

class TaskHubApp extends StatelessWidget {
  const TaskHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      title: 'TaskHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es'), Locale('en')],
      routerConfig: AppRouter.router,
    );
  }
}
