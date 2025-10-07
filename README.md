# Wakoo - Application Immobilière 3D

## 🏗️ Description

Wakoo est une application mobile innovante qui permet de visualiser et suivre la construction d'un projet immobilier étape par étape. L'application utilise la réalité augmentée, l'intelligence artificielle et des animations 3D pour offrir une expérience immersive unique.

## ✨ Fonctionnalités

### 🎯 Fonctionnalités Principales
- **Visualisation 3D Interactive** : Animation étape par étape de la construction
- **Intelligence Artificielle** : Génération d'images cohérentes pour chaque étape
- **Suivi de Progression** : Monitoring en temps réel de l'avancement
- **Gestion de Projets** : Création et suivi de projets immobiliers
- **Authentification Sécurisée** : Système de connexion et gestion des utilisateurs

### 🛠️ Technologies Utilisées

#### Frontend (Mobile)
- **Flutter** : Framework de développement mobile
- **Unity** : Moteur 3D pour les animations
- **Rive** : Animations vectorielles
- **Lottie** : Animations JSON

#### Backend
- **Node.js** : Runtime JavaScript
- **Express.js** : Framework web
- **MongoDB** : Base de données NoSQL
- **JWT** : Authentification

#### IA & Images
- **DALL-E 3** : Génération d'images
- **Stable Diffusion** : Alternative IA
- **Image-to-Image** : Cohérence entre étapes

## 🚀 Installation

### Prérequis
- Flutter SDK 3.13.0+
- Node.js 18+
- MongoDB 7.0+
- Unity 2022.3+
- Docker (optionnel)

### Installation Flutter
```bash
# Cloner le repository
git clone https://github.com/wakoo/wakoo-app.git
cd wakoo-app

# Installer les dépendances
flutter pub get

# Configurer les variables d'environnement
cp .env.example .env
```

### Installation Backend
```bash
cd backend
npm install

# Configurer les variables d'environnement
cp .env.example .env
```

### Installation avec Docker
```bash
# Démarrer tous les services
docker-compose up -d

# Vérifier le statut
docker-compose ps
```

## 🏃‍♂️ Démarrage Rapide

### Développement
```bash
# Démarrer le backend
cd backend
npm run dev

# Démarrer l'application Flutter
flutter run
```

### Production
```bash
# Déployer avec Docker
./scripts/deploy.sh production

# Vérifier les services
curl http://localhost:3000/api/health
```

## 📱 Utilisation

### 1. Création de Projet
1. Ouvrir l'application Wakoo
2. Se connecter ou créer un compte
3. Cliquer sur "Nouveau Projet"
4. Remplir les informations du projet
5. Sélectionner le type de construction

### 2. Visualisation 3D
1. Ouvrir un projet existant
2. Cliquer sur "Visualisation 3D"
3. Utiliser les contrôles pour naviguer
4. Jouer l'animation étape par étape

### 3. Génération d'Images IA
1. Sélectionner une étape de construction
2. Cliquer sur "Générer avec IA"
3. Décrire l'image souhaitée
4. Lancer la génération
5. Utiliser l'image générée

## 🧪 Tests

### Tests Flutter
```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter test integration_test/

# Tests de performance
flutter test --coverage
```

### Tests Backend
```bash
cd backend
npm test
npm run test:coverage
```

## 📊 Monitoring

### Métriques Disponibles
- **Performance** : Temps de réponse, FPS
- **Utilisation** : CPU, Mémoire, Stockage
- **Erreurs** : Logs d'erreurs, Exceptions
- **Utilisateurs** : Sessions actives, Conversions

### Accès aux Dashboards
- **Grafana** : http://localhost:3001
- **Prometheus** : http://localhost:9090
- **API Health** : http://localhost:3000/api/health

## 🔧 Configuration

### Variables d'Environnement

#### Frontend (.env)
```env
API_BASE_URL=http://localhost:3000
DEBUG_MODE=true
UNITY_ENABLED=true
```

#### Backend (.env)
```env
NODE_ENV=development
PORT=3000
MONGODB_URI=mongodb://localhost:27017/wakoo
JWT_SECRET=your_secret_key
OPENAI_API_KEY=your_openai_key
```

### Configuration Unity
1. Ouvrir Unity Hub
2. Importer le projet Unity
3. Configurer les paramètres de build
4. Exporter pour Android/iOS

## 🚀 Déploiement

### Déploiement Automatique
```bash
# Déploiement en production
./scripts/deploy.sh production

# Déploiement en staging
./scripts/deploy.sh staging
```

### Déploiement Manuel
```bash
# Build Android
flutter build apk --release
flutter build appbundle --release

# Build iOS
flutter build ios --release

# Build Backend
docker build -t wakoo-backend ./backend
```

## 📚 Documentation

### Documentation Technique
- [Architecture](docs/architecture.md)
- [API Reference](docs/api.md)
- [Unity Integration](docs/unity.md)
- [AI Integration](docs/ai.md)

### Documentation Utilisateur
- [Guide Utilisateur](docs/user-guide.md)
- [FAQ](docs/faq.md)
- [Support](docs/support.md)

## 🤝 Contribution

### Comment Contribuer
1. Fork le repository
2. Créer une branche feature
3. Commiter les changements
4. Pousser vers la branche
5. Ouvrir une Pull Request

### Standards de Code
- **Flutter** : Suivre les guidelines Flutter
- **Backend** : ESLint + Prettier
- **Tests** : Couverture > 80%
- **Documentation** : Commentaires JSDoc

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 📞 Support

### Contact
- **Email** : support@wakoo.bj
- **Téléphone** : +229 XX XX XX XX
- **Site Web** : https://wakoo.bj

### Issues
- [GitHub Issues](https://github.com/wakoo/wakoo-app/issues)
- [Bug Reports](https://github.com/wakoo/wakoo-app/issues/new?template=bug_report.md)
- [Feature Requests](https://github.com/wakoo/wakoo-app/issues/new?template=feature_request.md)

## 🎯 Roadmap

### Version 1.1
- [ ] Intégration Mobile Money
- [ ] Notifications push
- [ ] Mode hors ligne
- [ ] Synchronisation cloud

### Version 1.2
- [ ] Réalité augmentée
- [ ] Chat en temps réel
- [ ] Rapports PDF
- [ ] Export vidéo

### Version 2.0
- [ ] IA conversationnelle
- [ ] Marketplace matériaux
- [ ] Collaboration équipe
- [ ] Analytics avancés

---

**Développé avec ❤️ pour le Bénin**
