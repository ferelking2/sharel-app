import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sharel_app/l10n/app_localizations.dart';
import 'core/theme/design_system.dart';
import 'core/router/app_router.dart';
import 'services/permission_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize storage structure (SHAREL root folder, subfolders, etc)
    debugPrint('[main] Initializing storage structure...');
    await StorageService().initialize();
    debugPrint('[main] ✓ Storage initialized');
  } catch (e) {
    debugPrint('[main] ✗ Storage initialization failed: $e');
  }

  try {
    // Request ALL FILES ACCESS permission at app launch
    // This is CRITICAL for SHAREL to function properly
    debugPrint('[main] Requesting All Files Access permission...');
    final status = await PermissionService.requestAllFilesAccess();
    debugPrint('[main] All Files Access permission: $status');
  } catch (e) {
    debugPrint('[main] ✗ Permission request failed: $e');
  }

  runApp(const ProviderScope(child: SharelApp()));
}

class SharelApp extends StatelessWidget {
  const SharelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SHAREL',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', ''),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}


