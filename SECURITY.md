# 🔒 Security Policy

## Reporting Security Vulnerabilities

**Ne pas** signaler les failles de sécurité via des GitHub Issues publiques.

Pour rapporter une faille de sécurité, envoyez un email à : **[À COMPLÉTER : your-security-email@example.com]**

Veuillez inclure :
- Description détaillée de la vulnérabilité
- Étapes pour reproduire le problème
- Impact potentiel
- Suggestion de correction (si disponible)

Nous nous engageons à répondre dans les **48 heures** et à fournir une mise à jour régulièrement sur le statut de votre rapport.

---

## Versions Supportées

| Version | Support | Priorité |
|:---|:---|:---|
| 1.0.x | ✅ Entièrement supporté | Critique |
| < 1.0 | ❌ Non supporté | -- |

---

## Bonnes Pratiques de Sécurité

### Données Sensibles

- ✅ Le projet stocke **localement uniquement** sur l'appareil
- ❌ **Pas de** transmission de données personnelles au serveur
- ✅ Stockage chiffré avec Hive pour données locales
- ✅ Aucune clé API n'est exposée en code

### Permissions

- ✅ Uniquement les permissions nécessaires sont demandées
- ✅ Fallback gracieux si permissions sont refusées
- ✅ Pas de crash garantie même sans permissions

### Dépendances

- ✅ Mises à jour régulières des dépendances
- ✅ Vérification des vulnérabilités connues
- ✅ Audit de sécurité mensuel

---

## Divulgation Responsable

Nous apprécions la sécurité responsable et nous nous engageons à :

1. **Reconnaître** votre rapport de sécurité rapidement
2. **Enquêter** sur le problème signalé
3. **Fournir** une estimation du délai de correction
4. **Corriger** et publier la correction
5. **Créditer** le chercheur en sécurité (si souhaité)

---

## Standards de Sécurité

Cet application adhère à :

- [OWASP Mobile Top 10](https://owasp.org/www-project-mobile-top-10/)
- [Flutter Security Best Practices](https://flutter.dev/docs/development/security)
- [Android Security & Privacy Guidelines](https://developer.android.com/privacy-and-security)

---

## Historique de Sécurité

Aucune vulnérabilité critique rapportée à ce jour.

---

Pour plus d'informations, consultez notre [README](README.md) ou ouvrez une [Discussion](https://github.com/smartsniper31/unique-theme-launcher/discussions).
