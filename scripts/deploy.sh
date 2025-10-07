#!/bin/bash

# Script de déploiement pour Wakoo
set -e

echo "🚀 Déploiement de Wakoo en cours..."

# Variables
ENVIRONMENT=${1:-production}
VERSION=${2:-latest}

# Couleurs pour les logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction de logging
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

# Vérifier les prérequis
check_prerequisites() {
    log "Vérification des prérequis..."
    
    if ! command -v docker &> /dev/null; then
        error "Docker n'est pas installé"
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        error "Docker Compose n'est pas installé"
    fi
    
    if [ ! -f ".env.${ENVIRONMENT}" ]; then
        error "Fichier .env.${ENVIRONMENT} non trouvé"
    fi
    
    log "Prérequis vérifiés ✅"
}

# Charger les variables d'environnement
load_environment() {
    log "Chargement des variables d'environnement..."
    export $(cat .env.${ENVIRONMENT} | xargs)
    log "Variables d'environnement chargées ✅"
}

# Construire les images Docker
build_images() {
    log "Construction des images Docker..."
    
    # Backend
    log "Construction de l'image backend..."
    docker build -t wakoo-backend:${VERSION} ./backend
    
    # Nginx
    log "Construction de l'image nginx..."
    docker build -t wakoo-nginx:${VERSION} ./nginx
    
    log "Images construites ✅"
}

# Déployer les services
deploy_services() {
    log "Déploiement des services..."
    
    # Arrêter les services existants
    log "Arrêt des services existants..."
    docker-compose -f docker-compose.yml down
    
    # Démarrer les nouveaux services
    log "Démarrage des nouveaux services..."
    docker-compose -f docker-compose.yml up -d
    
    # Attendre que les services soient prêts
    log "Attente du démarrage des services..."
    sleep 30
    
    # Vérifier la santé des services
    check_health
    
    log "Services déployés ✅"
}

# Vérifier la santé des services
check_health() {
    log "Vérification de la santé des services..."
    
    # Vérifier MongoDB
    if ! docker-compose exec -T mongodb mongosh --eval "db.runCommand('ping')" > /dev/null 2>&1; then
        error "MongoDB n'est pas accessible"
    fi
    log "MongoDB ✅"
    
    # Vérifier le backend
    if ! curl -f http://localhost:3000/api/health > /dev/null 2>&1; then
        error "Backend API n'est pas accessible"
    fi
    log "Backend API ✅"
    
    # Vérifier Nginx
    if ! curl -f http://localhost/health > /dev/null 2>&1; then
        error "Nginx n'est pas accessible"
    fi
    log "Nginx ✅"
    
    log "Tous les services sont opérationnels ✅"
}

# Nettoyer les anciennes images
cleanup() {
    log "Nettoyage des anciennes images..."
    
    # Supprimer les images non utilisées
    docker image prune -f
    
    # Supprimer les volumes non utilisés
    docker volume prune -f
    
    log "Nettoyage terminé ✅"
}

# Sauvegarder la base de données
backup_database() {
    log "Sauvegarde de la base de données..."
    
    BACKUP_DIR="./backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p $BACKUP_DIR
    
    # Sauvegarder MongoDB
    docker-compose exec -T mongodb mongodump --out /tmp/backup
    docker cp $(docker-compose ps -q mongodb):/tmp/backup $BACKUP_DIR/
    
    log "Sauvegarde terminée dans $BACKUP_DIR ✅"
}

# Fonction principale
main() {
    log "Démarrage du déploiement Wakoo v${VERSION} en environnement ${ENVIRONMENT}"
    
    check_prerequisites
    load_environment
    backup_database
    build_images
    deploy_services
    cleanup
    
    log "🎉 Déploiement terminé avec succès!"
    log "API disponible sur: http://localhost:3000"
    log "Monitoring disponible sur: http://localhost:3001"
}

# Gestion des erreurs
trap 'error "Erreur lors du déploiement"' ERR

# Exécuter le script
main "$@"
