#!/usr/bin/env bash

set -e

echo "▶ Vérification Flutter..."

if ! command -v flutter &> /dev/null; then
  echo "▶ Flutter non détecté, installation..."
    git clone https://github.com/flutter/flutter.git -b stable "$HOME/flutter"
      echo 'export PATH="$HOME/flutter/bin:$PATH"' >> "$HOME/.bashrc"
        export PATH="$HOME/flutter/bin:$PATH"
        else
          echo "✔ Flutter déjà installé"
          fi

          echo "▶ Flutter doctor"
          flutter doctor

          echo "▶ Activation du support Web"
          flutter config --enable-web

          echo "▶ Acceptation des licences Android (si nécessaire)"
          flutter doctor --android-licenses || true

          echo "▶ Nettoyage du projet"
          flutter clean

          echo "▶ Récupération des dépendances"
          flutter pub get

          echo "▶ Lancement Flutter Web (port 8080)"
          flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080