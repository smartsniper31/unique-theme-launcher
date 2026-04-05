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

  final storage = UserStorage();
  await storage.init();

  try {
    if (!(await storage.exists())) {
      final results = await PermissionsHelper.requestAllWithRetry();
      
      if (PermissionsHelper.hasEssentialPermissions(results)) {
        final installer = InstallThemeUseCase(
          nameDetector: NameDetector(),
          deviceDetector: DeviceDetector(),
          batteryDetector: BatteryDetector(),
          wifiDetector: WifiDetector(),
          storage: storage,
        );
        await installer.execute();
      }
    }
  } catch (e) {
    debugPrint("Erreur lors de l'installation : $e");
  }

  UserProfile? profile = await storage.loadProfile();

  if (profile == null) {
    debugPrint("ERREUR CRITIQUE : Impossible de charger le profil");
    profile = UserProfile.fallback();
    await storage.saveProfile(profile);
  }

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
      child: DynamicThemeApp(profile: profile!),
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
