#!/bin/bash
echo "🚀 Création du projet Wakoo..."

# Créer le projet Flutter
flutter create wakoo_app
cd wakoo_app

# Ajouter les dépendances
flutter pub add flutter_unity_widget
flutter pub add rive
flutter pub add lottie
flutter pub add http
flutter pub add provider
flutter pub add shared_preferences
flutter pub add path_provider

# Créer la structure de dossiers
mkdir -p lib/screens
mkdir -p lib/widgets
mkdir -p lib/services
mkdir -p lib/models
mkdir -p lib/utils
mkdir -p assets/animations
mkdir -p assets/images
mkdir -p assets/unity

echo "✅ Projet Wakoo créé avec succès!"
echo "📁 Structure créée dans wakoo_app/"
