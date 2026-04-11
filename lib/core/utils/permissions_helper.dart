import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class PermissionsHelper {
  /// Toutes les permissions nécessaires pour la détection complète
  static const List<Permission> _allPermissions = [
    Permission.contacts,        // Pour NameDetector
    Permission.sms,             // Pour SMS detection
    Permission.phone,           // Pour phone state
    Permission.location,        // Pour geolocation
    Permission.mediaLibrary,    // Pour accès fichiers/photos
  ];

  /// Demander toutes les permissions avec retry et logs
  static Future<Map<Permission, PermissionStatus>> requestAllWithRetry() async {
    final Map<Permission, PermissionStatus> results = {};

    debugPrint('=== 📱 DEMANDE DE PERMISSIONS ===');

    for (final permission in _allPermissions) {
      try {
        debugPrint('Demande: ${permission.toString()}');
        var status = await permission.request();
        results[permission] = status;

        debugPrint('  → Résultat: ${status.toString()}');

        // Retry si refusé temporairement
        if (status.isDenied && !status.isPermanentlyDenied) {
          debugPrint('  → Nouvelle tentative...');
          final retryStatus = await permission.request();
          results[permission] = retryStatus;
          debugPrint('  → Retry résultat: ${retryStatus.toString()}');
        }

        // Log des permissions permanents
        if (status.isPermanentlyDenied) {
          debugPrint('  ⚠️  PERMANEMMENT REFUSÉE - Ouvrir les paramètres');
        }
      } catch (e) {
        debugPrint('  ❌ Erreur: $e');
        results[permission] = PermissionStatus.denied;
      }
    }

    debugPrint('=== 📋 RÉSUMÉ ===');
    _printSummary(results);

    return results;
  }

  /// Vérifier si les permissions essentielles sont accordées
  static bool hasEssentialPermissions(
      Map<Permission, PermissionStatus> results) {
    final hasContacts = results[Permission.contacts]?.isGranted == true;
    debugPrint('✅ Permissions essentielles: ${hasContacts ? "OK" : "MANQUANTES"}');
    return hasContacts;
  }

  /// Vérifier si toutes les permissions sont accordées
  static bool hasAllPermissions(Map<Permission, PermissionStatus> results) {
    final allGranted = results.values.every((status) => status.isGranted);
    debugPrint('✅ Toutes permissions: ${allGranted ? "OK" : "PARTIELLES"}');
    return allGranted;
  }

  /// Afficher un résumé des permissions
  static void _printSummary(Map<Permission, PermissionStatus> results) {
    for (var entry in results.entries) {
      final permission = entry.key.toString().split('.').last;
      final status = entry.value.toString().split('.').last;
      final icon = entry.value.isGranted ? '✅' : '❌';
      debugPrint('$icon $permission: $status');
    }
  }

  /// Ouvrir les paramètres de l'app
  static Future<void> openAppSettingsPage() async {
    debugPrint('📱 Ouverture des paramètres de l\'app...');
    await openAppSettings();
  }
}
