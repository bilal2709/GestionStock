# GestionStoc

Système de Gestion de Stock - README

Ce projet est un système de gestion de stock pour une petite entreprise de vente de maquettes d'avions en papier. Il permet de gérer les produits, les commandes, les clients, les catégories, et les fournisseurs via une API RESTful développée en Node.js.

Prérequis

1. Environnement logiciel

Node.js (version 14 ou supérieure) : https://nodejs.org/fr

MySQL (version 5.7 ou supérieure) : https://dev.mysql.com/downloads/

Postman ou un autre outil pour tester l'API (optionnel)

2. Dépendances globales

Installez les packages npm globaux si nécessaire :

npm install -g nodemon

Installation

1. Cloner le dépôt

Clonez le projet depuis GitHub :

git clone https://github.com/bilal2709/GestionStock.git


cd gestion-stock

2. Installer les dépendances

Installez les dépendances du projet avec npm :

npm install

3. Configurer la base de données

a) Créez la base de données

Connectez-vous à votre serveur MySQL et exécutez le script SQL fourni dans le fichier gestion_stock.sql pour créer et peupler la base de données :

mysql -u root -p < gestion_stock.sql

b) Configurer les paramètres de connexion

Dans le fichier app.js, assurez-vous que les informations de connexion à MySQL sont correctes :

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'root',
  database: 'GestionStock',
  port: 8889 // Remplacez par le port MySQL que vous utilisez
});

Utilisation

1. Lancer le serveur

Exécutez l'API en mode développement avec node :

node app.js

Le serveur sera disponible à l'adresse : http://localhost:3000.

2. Tester les endpoints

Utilisez Postman, CURL ou un navigateur pour tester les endpoints. Voici quelques exemples :

a) Lister les commandes par année

curl "http://localhost:3000/commandes?start=2025-01-01&end=2025-12-31"

b) Rechercher les commandes d’un client

curl "http://localhost:3000/clients/1/commandes"

c) Lister les commandes qui contiennent un article précis

curl "http://localhost:3000/produits/1/commandes"

d) Recherche multi-critères (client, date, statut, produit...)

curl "http://localhost:3000/recherche-commandes?client_id=1&date_min=2025-01-01&statut=en%20cours"

e) Produits les plus vendus 

curl "http://localhost:3000/statistiques/produits-plus-vendus"

d) Notifications de stock faible

curl "http://localhost:3000/produits/stock-faible?seuil=10"

Structure du projet

/
├── app.js               # Point d'entrée principal
├── gestion_stock.sql    # Script SQL pour créer et peupler la base de données
├── package.json         # Fichier de configuration npm
└── node_modules/        # Modules Node.js installés

Améliorations futures

Validation des données : Ajouter une validation stricte pour les champs d'entrée.

Protection contre les injections SQL : Utiliser des requêtes paramétrées.

Interface utilisateur (front-end) : Développer un front-end en React ou Vue.js.

Authentification : Implémenter un système d'utilisateur avec des rôles.

Support

Si vous rencontrez des problèmes, contactez Bilal ou ouvrez une issue sur le dépôt GitHub.

Merci d'utiliser le système de gestion de stock !
