# Permissions de Transfert - Analyse Détaillée

## Architecture du Transfert

### Protocole
- **HOST (Sender)**: Crée un serveur HTTP qui expose les fichiers sélectionnés
- **CLIENT (Receiver)**: Se connecte au serveur HTTP du HOST et télécharge les fichiers
- **Communication**: HTTP simple sur le réseau local (LAN) via la même connexion WiFi

### Endpoints APIs
```
HOST → HTTP Server
├── GET /session       → Métadonnées des fichiers (sessionId, items[], sizes)
└── GET /file/<index>  → Flux brut du fichier (octet-stream)

CLIENT → Connexion HTTP
├── GET /session       → Récupère la liste
└── GET /file/<index>  → Télécharge chaque fichier
```

---

## Permissions Requises par Rôle

### 🧑‍💻 RÔLE HOST (Côté Envoyeur/Sender)

#### ✅ Permissions **OBLIGATOIRES**

| Permission | Raison | Android Version |
|------------|--------|-----------------|
| **INTERNET** | Créer et écouter le serveur HTTP | Tous (implicite) |
| **MANAGE_EXTERNAL_STORAGE** ou **READ_EXTERNAL_STORAGE** | Lire les fichiers sélectionnés | 11+ / ≤10 |
| **CAMERA** | Scanner QR du CLIENT pour obtenir l'URL | Tous (pour découverte) |
| **READ_CONTACTS** | Si on sélectionne des contacts à envoyer | Tous |

#### ⚠️ Permissions **OPTIONNELLES/RECOMMANDÉES**

| Permission | Raison | Android Version |
|------------|--------|-----------------|
| **NEARBY_WIFI_DEVICES** | Découvrir automatiquement les CLIENTs sur le réseau | 13+ |
| **CHANGE_NETWORK_STATE** | Forcer la connexion WiFi (si implémenté) | Tous |
| **ACCESS_NETWORK_STATE** | Vérifier la connectivité WiFi | Tous |

#### 📋 Sommaire HOST
```
Minimum requis:
✓ INTERNET
✓ READ_EXTERNAL_STORAGE (ou MANAGE_EXTERNAL_STORAGE)
✓ CAMERA (pour scanner QR)
✓ READ_CONTACTS (si sélection contacts)

Idéal (meilleure expérience):
✓ NEARBY_WIFI_DEVICES (Android 13+)
✓ ACCESS_NETWORK_STATE
```

---

### 📥 RÔLE CLIENT (Côté Récepteur/Receiver)

#### ✅ Permissions **OBLIGATOIRES**

| Permission | Raison | Android Version |
|------------|--------|-----------------|
| **INTERNET** | Télécharger les fichiers du HOST | Tous (implicite) |
| **MANAGE_EXTERNAL_STORAGE** ou **WRITE_EXTERNAL_STORAGE** | Écrire les fichiers téléchargés | 11+ / ≤10 |
| **CAMERA** | Scanner le QR du HOST pour récupérer l'URL | Tous |

#### ⚠️ Permissions **OPTIONNELLES/RECOMMANDÉES**

| Permission | Raison | Android Version |
|------------|--------|-----------------|
| **NEARBY_WIFI_DEVICES** | Découverte d'appareils HOST dans le réseau | 13+ |
| **ACCESS_NETWORK_STATE** | Vérifier l'état de la connexion WiFi | Tous |
| **BLUETOOTH** | Si implémentation BLE alternative (futur) | Tous |

#### 📋 Sommaire CLIENT
```
Minimum requis:
✓ INTERNET
✓ MANAGE_EXTERNAL_STORAGE (ou WRITE_EXTERNAL_STORAGE)
✓ CAMERA (scanner QR)

Idéal (meilleure expérience):
✓ NEARBY_WIFI_DEVICES (Android 13+)
✓ ACCESS_NETWORK_STATE
```

---

## Comparaison HOST vs CLIENT

| Aspect | HOST (Sender) | CLIENT (Receiver) |
|--------|---------------|------------------|
| **Action Principale** | Créer serveur HTTP | Télécharger des fichiers |
| **Opération Fichiers** | **LIRE** | **ÉCRIRE** |
| **Permission Clé** | `READ_EXTERNAL_STORAGE` | `WRITE_EXTERNAL_STORAGE` |
| **Scanner QR** | ✓ Recommandé | ✓ Obligatoire |
| **Serveur HTTP** | ✓ Crée le serveur | ✗ Se connecte seulement |
| **Taille Payload** | Métadonnées + Fichiers | Fichiers reçus |

---

## État Actuel de l'App (Implémentation)

### ✅ Dans `main.dart`
```dart
// Déjà demandées:
✓ Permissions.manageExternalStorage (Android 11+)
✓ Permissions.storage (Android ≤10)
✓ Initialisation du storage SHAREL
```

### ✅ Dans `permission_service.dart`
```dart
// Méthodes disponibles:
✓ requestAllFilesAccess()              → MANAGE_EXTERNAL_STORAGE
✓ requestStoragePermission()           → Photos/Storage (version adaptive)
✓ requestCameraPermission()            → CAMERA
✓ requestNearbyWifiPermission()        → NEARBY_WIFI_DEVICES (Android 13+)
✓ getRequiredPermissions()             → Map<role: permissions>
```

### ✅ Dans `preparation_screen.dart`
```dart
// Affiche les permissions nécessaires avant le transfert:
✓ Demande toutes les permissions requises
✓ Bloque le transfert si permissions refusées
```

---

## Recommandation: Flux de Permissions Optimal

### 📋 Au lancement (`main.dart`)
```dart
1. Demander MANAGE_EXTERNAL_STORAGE
   → Crée le dossier SHAREL
   → Permet la lecture/écriture des fichiers

2. Demander INTERNET
   → Implicite dans AndroidManifest.xml
   → Pas de demande runtime nécessaire
```

### 📋 Avant Transfert (HOST ou CLIENT)
```dart
1. Vérifier le rôle (HOST ou CLIENT)

2. Si HOST:
   ✓ Camera → Pour scanner le QR du client
   ✓ Contacts → Si sélection de contacts
   ✓ Nearby WiFi → Pour découverte (Android 13+)

3. Si CLIENT:
   ✓ Camera → Pour scanner le QR du host
   ✓ Nearby WiFi → Pour découverte (Android 13+)

4. Bloque le transfert si permissions refusées
```

---

## Permissions à Déclarer dans `AndroidManifest.xml`

```xml
<!-- OBLIGATOIRES pour TOUS -->
<uses-permission android:name="android.permission.INTERNET" />

<!-- LECTURE/ÉCRITURE fichiers -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" 
    tools:ignore="ScopedStorage" />

<!-- CAMERA (scanner QR) -->
<uses-permission android:name="android.permission.CAMERA" />

<!-- CONTACTS (si sélection contacts) -->
<uses-permission android:name="android.permission.READ_CONTACTS" />

<!-- WIFI & RÉSEAU -->
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
<uses-permission android:name="android.permission.NEARBY_WIFI_DEVICES" 
    android:maxSdkVersion="32" />  <!-- Android 13+ -->

<!-- SERVICES BACKGROUND (optionnel pour transferts long terme) -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
```

---

## Résumé Exécutif

### ✅ Ce qui est actuellement activé
- ✓ `MANAGE_EXTERNAL_STORAGE` (au lancement)
- ✓ Dossier `SHAREL` créé automatiquement
- ✓ Permissions UI en place

### ⚡ À ajouter pour optimalisation
1. **Vérifier CAMERA** avant scanner QR
2. **Vérifier NEARBY_WIFI_DEVICES** (Android 13+) pour meilleure découverte
3. **Implémenter fallback** si permissions refusées

### 🎯 Structure finale recommandée
```
HOST Requirements:           CLIENT Requirements:
├─ MANAGE_EXTERNAL_STORAGE  ├─ MANAGE_EXTERNAL_STORAGE
├─ INTERNET (implicit)      ├─ INTERNET (implicit)
├─ CAMERA                   ├─ CAMERA
├─ READ_CONTACTS            ├─ NEARBY_WIFI_DEVICES
└─ NEARBY_WIFI_DEVICES      └─ ACCESS_NETWORK_STATE
```
