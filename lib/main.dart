import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'data/storage/user_storage.dart';
import 'data/models/user_profile.dart';
import 'domain/usecases/install_theme_usecase.dart';
import 'data/sources/name_detector.dart';
import 'data/sources/device_detector.dart';
import 'data/sources/battery_detector.dart';
import 'data/sources/wifi_detector.dart';
import 'presentation/providers/dynamic_theme.dart';
import 'presentation/providers/living_name_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/welcome_screen.dart';
import 'core/utils/permissions_helper.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  debugPrint('═' * 60);
  debugPrint('🚀 [MAIN] Startup unique_theme_launcher...');
  debugPrint('═' * 60);

  final storage = UserStorage();
  await storage.init();
  debugPrint('✅ [MAIN] Storage initié');

  try {
    if (!(await storage.exists())) {
      debugPrint('📱 [MAIN] Première installation détectée');
      debugPrint('📋 [MAIN] Demande des permissions...');
      
      final results = await PermissionsHelper.requestAllWithRetry();
      final hasPermissions = PermissionsHelper.hasEssentialPermissions(results);

      if (hasPermissions) {
        debugPrint('✅ [MAIN] Permissions essentielles accordées');
        debugPrint('🔧 [MAIN] Lancement InstallThemeUseCase...');
        
        final installer = InstallThemeUseCase(
          nameDetector: NameDetector(),
          deviceDetector: DeviceDetector(),
          batteryDetector: BatteryDetector(),
          wifiDetector: WifiDetector(),
          storage: storage,
        );
        await installer.execute();
        debugPrint('✅ [MAIN] Installation complétée');
      } else {
        debugPrint('⚠️  [MAIN] Permissions insuffisantes - utilisation fallback');
      }
    } else {
      debugPrint('✅ [MAIN] Profil existant trouvé');
    }
  } catch (e) {
    debugPrint('❌ [MAIN] Erreur lors de l\'installation : $e');
  }

  UserProfile? profile = await storage.loadProfile();

  if (profile == null) {
    debugPrint('❌ [MAIN] ERREUR CRITIQUE : Impossible de charger le profil');
    profile = UserProfile.fallback();
    await storage.saveProfile(profile);
  }

  debugPrint('✅ [MAIN] Profil chargé: ${profile.identity.name}');
  debugPrint('═' * 60);
  debugPrint('🎨 [MAIN] Lancement UI...');

  FlutterNativeSplash.remove();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DynamicTheme(profile!, storage),
        ),
        ChangeNotifierProvider(
          create: (_) => LivingNameProvider(),
        ),
      ],
      child: DynamicThemeApp(profile: profile),
    ),
  );
}

class DynamicThemeApp extends StatelessWidget {
  final UserProfile profile;

  const DynamicThemeApp({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unique Theme Launcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      // 🎬 LOGIQUE DE ROUTING - C'EST ICI LA MAGIE
      home: Consumer<DynamicTheme>(
        builder: (context, themeProvider, _) {
          // Vérifier si l'utilisateur a vu l'écran de bienvenue
          if (!themeProvider.profile.hasSeenWelcome) {
            // ✨ Premier lancement: afficher WelcomeScreen
            return WelcomeScreen(
              userName: themeProvider.profile.identity.name,
            );
          }

          // Lancements ultérieurs: afficher HomeScreen
          return const HomeScreen();
        },
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
