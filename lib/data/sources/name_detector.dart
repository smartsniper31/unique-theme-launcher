import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../models/detected_identity.dart';

/// Détecteur pour extraire le nom de l'utilisateur depuis plusieurs sources
class NameDetector {
  /// Récupère le nom depuis les contacts
  Future<String?> getNameFromContacts() async {
    try {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      if (contacts.isNotEmpty) {
        return contacts.first.displayName;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Récupère le nom depuis l'authentification Google
  Future<String?> getNameFromGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? account = await googleSignIn.signInSilently();
      return account?.displayName;
    } catch (e) {
      return null;
    }
  }



  /// Détecte le nom via une détection composite et retourne une DetectedIdentity
  Future<DetectedIdentity> detect() async {
    // Try Google Sign-In first
    var googleName = await getNameFromGoogle();
    if (googleName != null && googleName.isNotEmpty) {
      return DetectedIdentity(
        name: googleName,
        source: NameSource.google,
        confidenceScore: 0.95,
      );
    }

    // Try Contacts
    var contactName = await getNameFromContacts();
    if (contactName != null && contactName.isNotEmpty) {
      return DetectedIdentity(
        name: contactName,
        source: NameSource.contact,
        confidenceScore: 0.85,
      );
    }

    // Fallback
    return DetectedIdentity(
      name: "User",
      source: NameSource.fallback,
      confidenceScore: 0.0,
    );
  }
}
