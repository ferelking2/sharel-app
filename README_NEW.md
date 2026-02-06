# 📦 SHAREL – File Sharing App (Flutter Cross-Platform)

**Version:** 1.0.0  
**Status:** MVP (Early Beta)  
**Last Updated:** 2026-02-06

## 🎯 Overview

SHAREL est une application Flutter **cross-platform** (Android, iOS, Web, macOS, Linux, Windows) pour partager des fichiers simplement via réseau local (Wi‑Fi / Hotspot). Pas de cloud, pas de compte — juste un envoyeur et un receveur sur le même LAN.

### Caractéristiques principales

✅ **Multi-plateforme** : Android, iOS, Web (en préparation)  
✅ **Streaming de fichiers** : Pas d'upload cloud, transfert direct HTTP  
✅ **QR Code** : Partage d'URI facilement  
✅ **Sélection multi-fichiers** : Contacts, fichiers, photos, vidéos, musique, apps  
✅ **Progression live** : Suivi du téléchargement en temps réel  
✅ **Permissions granulaires** : Runtime requests (Android/iOS)  
✅ **Design moderne** : Material 3 + design adaptatif  
✅ **i18n** : Support français par défaut

---

## 📁 Structure du projet

```
sharel-app/
├── lib/
│   ├── main.dart                    # Point d'entrée app
│   ├── core/
│   │   ├── router/                  # GoRouter + routes
│   │   ├── theme/                   # Design System Material 3
│   │   └── extensions.dart          # Helpers
│   ├── model/                       # Modèles de données
│   ├── providers/                   # State (Riverpod)
│   ├── screens/ & view/             # UI screens
│   ├── services/                    # ShareEngine, permissions, logger
│   ├── viewmodel/                   # Logic/ViewModels
│   ├── widgets/                     # Composants réutilisables
│   └── l10n/                        # Traductions (i18n)
├── docs/                            # Documentation complète
│   ├── README.md                    # Index docs
│   ├── architecture/                # Architecture patterns
│   └── transfer/                    # Protocol, security, performance
├── android/                         # Config Android (AGP 8+)
├── ios/                             # Config iOS (Swift)
├── test/                            # Tests
├── pubspec.yaml                     # Dépendances
└── analysis_options.yaml            # Lints rules
```

---

## 🚀 Quick Start

### Installation

```bash
# Clone repo
git clone https://github.com/ferelking1/sharel-app.git
cd sharel-app

# Installez Flutter 3.10+
flutter --version

# Get deps
flutter pub get

# Générez clés i18n
flutter gen-l10n

# Run sur emulateur/device
flutter run
```

### Dev Web (local)

```bash
flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080
```

### Build

```bash
# Android APK
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

---

## 🔄 Workflow simplifié

### Envoyeur (Host)

1. Ouvrir l'app → Bouton **"Envoyer"**
2. Sélectionner fichiers (photos, vidéos, documents, etc.)
3. Cliquer **"Envoyer"**
4. App crée un serveur HTTP local && affiche **QR Code** + URL
5. Partager le code/URL au receveur

### Receveur (Client)

1. Ouvrir l'app → Bouton **"Recevoir"**
2. Scanner le **QR Code** (caméra)
3. App télécharge les fichiers vers `Downloads/`
4. Notification de succès

---

## 📚 Documentation

**Lire la docs complète :** [`/docs/README.md`](docs/README.md)

Topics clés :

- [Architecture & Patterns](docs/architecture/overview.md)
- [Workflow Transfert](docs/transfer/workflow_send_receive.md) 
- [Protocol HTTP](docs/transfer/protocol.md)
- [Sécurité & Tokens](docs/transfer/security.md)
- [Stockage & Permissions](docs/transfer/storage.md) + [Android](docs/permissions/android.md) / [iOS](docs/permissions/ios.md)
- [Performance & Timeouts](docs/transfer/performance.md)
- [Tests Checklist](docs/transfer/testing.md)
- [Troubleshooting](docs/troubleshooting/common_issues.md)
- [Roadmap v1.1-v2.0](docs/transfer/limitations_roadmap.md)

---

## 🔐 Sécurité (v1.0)

- ✅ SessionId unique par transfer
- ✅ Token UUID (futur: expiration)
- ✅ Auto-vérification serveur au démarrage
- ⬜ Accept/Reject (v1.1)
- ⬜ Trusted devices (v1.1)
- ⬜ TLS/Encryption (v2.0)

**Documentation sécurité :** [/docs/transfer/security.md](docs/transfer/security.md)

---

## 🛠️ Dépendances clés

```yaml
flutter_riverpod: ^2.x        # State management
go_router: ^10.x              # Navigation
permission_handler: ^11.x      # Permissions
image_picker: ^1.x             # Sélection d'images
video_player: ^2.x             # Preview vidéos
qr_flutter: ^4.x               # QR generation
qr_code_scanner: ^0.x          # QR scanning
shared_preferences: ^2.x       # Config locale
crypto: ^3.x                   # SHA-256, crypto
uuid: ^4.x                     # Unique IDs
intl: ^0.19.x                  # i18n
file_picker: ^5.x              # Sélection fichiers
```

---

## 🧪 Tests

### Manual (recommandé avant release)

Voir [/docs/transfer/testing.md](docs/transfer/testing.md) pour checklist **10 scénarios** complets.

```bash
# Analyse statique
flutter analyze

# Format
dart format lib/
```

### Automated (futur v1.1)

```bash
flutter test
```

---

## 🐛 Troubleshooting

### Erreurs fréquentes

| Problème | Solution |
|----------|----------|
| "No found" (404) | Attendre démarrage serveur, vérifier IP/port |
| Transfert interrompu | Wi-Fi check, réseau stable, permissions OK |
| Permission refusée | Aller Paramètres > Permissions > ✓ |
| Hash mismatchs | Fichier corrompu, retenter avec resume (v1.1) |

Voir docs complètes : [/docs/troubleshooting/common_issues.md](docs/troubleshooting/common_issues.md)

---

## 🎯 Prochaines étapes (Roadmap)

### v1.1 (Q1 2026)

- [ ] Session tokens + expiration
- [ ] Accept/Reject + Trusted devices  
- [ ] HTTP 206 Resume
- [ ] SHA-256 validation
- [ ] Manifest JSON + protocol versioning
- [ ] TransferId + logging correlé
- [ ] Tests automatisés

### v2.0 (Q2-Q3 2026)

- [ ] TLS local
- [ ] AES-256-GCM encryption
- [ ] Multi-clients + queue
- [ ] Bluetooth / Wi-Fi Direct
- [ ] Dossiers récursifs
- [ ] Export logs + rapport
- [ ] UI dark mode + animations

---

## 🤝 Contribuer

1. Fork le repo
2. Branch : `git checkout -b feature/my-feature`
3. Commit : `git commit -m 'Add feature'`
4. Push : `git push origin feature/my-feature`
5. PR!

**Code style :** Analyze + format via Flutter lints.

---

## 📄 Licence

MIT (voir LICENSE)

---

## 📞 Support

- **Issues:** https://github.com/ferelking1/sharel-app/issues
- **Discussions:** [GitHub Discussions](https://github.com/ferelking1/sharel-app/discussions)
- **Docs:** [/docs/README.md](docs/README.md)

---

**Made with ❤️ by the SHAREL team**
