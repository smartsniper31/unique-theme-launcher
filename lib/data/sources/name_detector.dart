import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter/foundation.dart';
import '../models/detected_identity.dart';

/// Détecteur pour extraire le nom de l'utilisateur depuis plusieurs sources
class NameDetector {
  /// Récupère le nom depuis les contacts
  Future<String?> getNameFromContacts() async {
    try {
      debugPrint('🧑 [NameDetector] Tentative: Contacts...');
      
      // Vérifier et demander la permission
      final hasPermission = await FlutterContacts.requestPermission();
      if (!hasPermission) {
        debugPrint('❌ [NameDetector] Permission contacts refusée');
        return null;
      }

      final contacts = await FlutterContacts.getContacts(withProperties: true);
      if (contacts.isNotEmpty) {
        final name = contacts.first.displayName;
        debugPrint('✅ [NameDetector] Contact trouvé: $name');
        return name;
      }
      
      debugPrint('⚠️  [NameDetector] Aucun contact trouvé');
      return null;
    } catch (e) {
      debugPrint('❌ [NameDetector] Erreur Contacts: $e');
      return null;
    }
  }

  /// Récupère le nom depuis l'authentification Google
  Future<String?> getNameFromGoogle() async {
    try {
      debugPrint('🔑 [NameDetector] Tentative: Google Sign-In...');
      
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? account = await googleSignIn.signInSilently();
      
      if (account != null && account.displayName != null) {
        debugPrint('✅ [NameDetector] Google Name: ${account.displayName}');
        return account.displayName;
      }
      
      debugPrint('⚠️  [NameDetector] Pas de Google account en cache');
      return null;
    } catch (e) {
      debugPrint('❌ [NameDetector] Erreur Google: $e');
      return null;
    }
  }



  /// Détecte le nom via une détection composite et retourne une DetectedIdentity
  Future<DetectedIdentity> detect() async {
    debugPrint('🔍 [NameDetector] Démarrage détection complète...');

    // Priority 1: Google Sign-In (le plus fiable)
    var googleName = await getNameFromGoogle();
    if (googleName != null && googleName.isNotEmpty) {
      debugPrint('✨ [NameDetector] ✅ RÉSULTAT: $googleName (depuis Google)');
      return DetectedIdentity(
        name: googleName,
        source: NameSource.google,
        confidenceScore: 0.95,
      );
    }

    // Priority 2: Contacts (très fiable)
    var contactName = await getNameFromContacts();
    if (contactName != null && contactName.isNotEmpty) {
      debugPrint('✨ [NameDetector] ✅ RÉSULTAT: $contactName (depuis Contacts)');
      return DetectedIdentity(
        name: contactName,
        source: NameSource.contact,
        confidenceScore: 0.85,
      );
    }

    // Fallback: Nom générique
    debugPrint('⚠️  [NameDetector] ⚠️  RÉSULTAT: "User" (FALLBACK - permissions insuffisantes)');
    return DetectedIdentity(
      name: "User",
      source: NameSource.fallback,
      confidenceScore: 0.0,
    );
  }
}
