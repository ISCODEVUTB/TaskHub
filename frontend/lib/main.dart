import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'routes/app_router.dart';
import 'theme/theme.dart';
import 'theme/theme_provider.dart';
import 'features/auth/data/auth_service.dart';
import 'dart:async';
import 'dart:io';

// El guardado de logs en archivo solo es posible en escritorio/consola, no en web ni móvil.
Future<void> appendLog(String message) async {
  // ignore: avoid_print
  print(message);
  // No intentes guardar en archivo si corres en web
  // kIsWeb requiere importar foundation.dart, pero puedes usar try-catch para ignorar el error en web
  try {
    final file = File('taskhub_logs.txt');
    await file.writeAsString('$message\n', mode: FileMode.append, flush: true);
  } catch (_) {
    // No hacer nada si falla (por ejemplo, en web)
}
}

void main() {
  // Captura errores de Flutter
  FlutterError.onError = (FlutterErrorDetails details) async {
    FlutterError.presentError(details);
    final logMsg =
        'FLUTTER ERROR: ${details.exceptionAsString()}\n${details.stack ?? ''}';
    // Solo imprime, no intentes guardar en archivo si no es posible
    appendLog(logMsg);
  };

  // Captura errores no manejados de Dart
  runZonedGuarded(
    () {
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
    },
    (error, stack) {
      final logMsg = 'UNCAUGHT ERROR: $error\n$stack';
      appendLog(logMsg);
    },
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
