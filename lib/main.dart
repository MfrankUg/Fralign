import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/fralign_provider.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => FralignProvider(),
      child: const FralignApp(),
    ),
  );
}

class FralignApp extends StatelessWidget {
  const FralignApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FralignProvider>();

    // Adapt system UI overlay to match theme.
    final isDark = provider.themeMode == ThemeMode.dark;
    SystemChrome.setSystemUIOverlayStyle(
      isDark
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: const Color(0xFF0F172A),
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: const Color(0xFFF8FAFC),
            ),
    );

    return MaterialApp(
      title: 'Fralign',
      debugShowCheckedModeBanner: false,
      theme: FralignTheme.light(),
      darkTheme: FralignTheme.dark(),
      themeMode: provider.themeMode,
      home: const HomeScreen(),
    );
  }
}
