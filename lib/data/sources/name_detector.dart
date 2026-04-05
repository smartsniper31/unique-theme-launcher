import 'dart:async';
import 'package:telephony/telephony.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:contacts_service/contacts_service.dart';
import '../models/detected_identity.dart';

class NameDetector {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<DetectedIdentity> detect() async {
    final google = await getFromGoogleAccount();
    if (google != null)
      return DetectedIdentity(
          name: google, source: NameSource.google, confidenceScore: 0.95);

    final contact = await getFromMyContact();
    if (contact != null)
      return DetectedIdentity(
          name: contact, source: NameSource.contact, confidenceScore: 0.85);

    final sms = await getFromSms();
    if (sms != null)
      return DetectedIdentity(
          name: sms, source: NameSource.sms, confidenceScore: 0.70);

    return DetectedIdentity(
        name: "Utilisateur", source: NameSource.fallback, confidenceScore: 0.1);
  }

  Future<String?> getFromSms() async {
    try {
      final telephony = Telephony.instance;

      List<SmsMessage> messages = await telephony
          .getInboxSms(columns: [SmsColumn.ADDRESS, SmsColumn.BODY]);

      for (var msg in messages) {
        final name = _extractNameFromSender(msg.address ?? "");
        if (name != null) return name;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String? _extractNameFromSender(String sender) {
    final regex = RegExp(r'^([A-Za-zÀ-ÿ\s]+)\s*[<\(]?');
    final match = regex.firstMatch(sender);
    final found = match?.group(1)?.trim().split(' ').first;
    if (found != null && RegExp(r'^[0-9+]+$').hasMatch(found)) return null;
    return found;
  }

  Future<String?> getFromGoogleAccount() async {
    try {
      final account = await _googleSignIn.signInSilently();
      return account?.displayName?.split(' ').first;
    } catch (_) {
      return null;
    }
  }

  Future<String?> getFromMyContact() async {
    try {
      Iterable<Contact> contacts =
          await ContactsService.getContacts(query: "Moi");
      if (contacts.isNotEmpty) return contacts.first.givenName;
      return null;
    } catch (_) {
      return null;
    }
  }
}
