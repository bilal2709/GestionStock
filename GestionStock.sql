-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:8889
-- Généré le : dim. 19 jan. 2025 à 12:07
-- Version du serveur : 8.0.35
-- Version de PHP : 8.2.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `GestionStock`
--

-- --------------------------------------------------------

--
-- Structure de la table `Categories`
--

CREATE TABLE `Categories` (
  `id` int NOT NULL,
  `nom` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `Categories`
--

INSERT INTO `Categories` (`id`, `nom`, `description`) VALUES
(1, 'Avions de chasse', 'Maquettes d\'avions de chasse en papier'),
(2, 'Avions commerciaux', 'Maquettes d\'avions commerciaux en papier'),
(3, 'Avions historiques', 'Maquettes d\'avions historiques en papier');

-- --------------------------------------------------------

--
-- Structure de la table `Clients`
--

CREATE TABLE `Clients` (
  `id` int NOT NULL,
  `nom` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `adresse` text COLLATE utf8mb4_general_ci,
  `telephone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `Clients`
--

INSERT INTO `Clients` (`id`, `nom`, `adresse`, `telephone`, `email`) VALUES
(1, 'Jean Dupont', '12 Rue des Lilas, Paris', '0612345678', 'jean.dupont@gmail.com'),
(2, 'Marie Curie', '34 Avenue des Champs, Lyon', '0623456789', 'marie.curie@gmail.com');

-- --------------------------------------------------------

--
-- Structure de la table `Commandes`
--

CREATE TABLE `Commandes` (
  `id` int NOT NULL,
  `client_id` int DEFAULT NULL,
  `date_commande` date NOT NULL,
  `statut` varchar(50) COLLATE utf8mb4_general_ci DEFAULT 'en attente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `Commandes`
--

INSERT INTO `Commandes` (`id`, `client_id`, `date_commande`, `statut`) VALUES
(1, 1, '2025-01-01', 'en cours'),
(2, 2, '2025-01-02', 'en attente'),
(3, 1, '2025-02-15', 'livrée'),
(4, 2, '2025-03-10', 'en attente'),
(5, 1, '2024-12-25', 'en cours');

-- --------------------------------------------------------

--
-- Structure de la table `Fournisseurs`
--

CREATE TABLE `Fournisseurs` (
  `id` int NOT NULL,
  `nom` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `adresse` text COLLATE utf8mb4_general_ci,
  `telephone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `Fournisseurs`
--

INSERT INTO `Fournisseurs` (`id`, `nom`, `adresse`, `telephone`, `email`) VALUES
(1, 'Fournisseur Alpha', '123 Rue Alpha, Paris', '0123456789', 'contact@alpha.com'),
(2, 'Fournisseur Beta', '456 Rue Beta, Lyon', '0987654321', 'contact@beta.com'),
(3, 'Fournisseur Gamma', '789 Rue Gamma, Toulouse', '0776543210', 'contact@gamma.com');

-- --------------------------------------------------------

--
-- Structure de la table `Lignes_Commande`
--

CREATE TABLE `Lignes_Commande` (
  `id` int NOT NULL,
  `commande_id` int DEFAULT NULL,
  `produit_id` int DEFAULT NULL,
  `quantite` int NOT NULL,
  `prix_unitaire` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `Lignes_Commande`
--

INSERT INTO `Lignes_Commande` (`id`, `commande_id`, `produit_id`, `quantite`, `prix_unitaire`) VALUES
(1, 1, 1, 2, 15.99),
(2, 1, 3, 1, 19.99),
(3, 2, 2, 1, 25.99),
(4, 3, 1, 3, 15.99),
(5, 3, 2, 1, 25.99),
(6, 4, 3, 2, 19.99),
(7, 5, 1, 4, 15.99),
(8, 5, 2, 2, 25.99);

-- --------------------------------------------------------

--
-- Structure de la table `Produits`
--

CREATE TABLE `Produits` (
  `id` int NOT NULL,
  `nom` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `prix_unitaire` decimal(10,2) NOT NULL,
  `quantite_en_stock` int NOT NULL,
  `categorie_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `Produits`
--

INSERT INTO `Produits` (`id`, `nom`, `description`, `prix_unitaire`, `quantite_en_stock`, `categorie_id`) VALUES
(1, 'F-16', 'Avion de chasse moderne', 15.99, 50, 1),
(2, 'Boeing 747', 'Avion commercial classique', 25.99, 30, 2),
(3, 'Spitfire', 'Avion de la Seconde Guerre mondiale', 19.99, 40, 3),
(4, 'Concorde', 'Avion commercial supersonique', 35.99, 5, 2),
(5, 'P-51 Mustang', 'Avion de chasse historique', 20.99, 2, 3),
(6, 'Airbus A380', 'Avion commercial moderne', 45.99, 10, 2);

-- --------------------------------------------------------

--
-- Structure de la table `Produits_Fournisseurs`
--

CREATE TABLE `Produits_Fournisseurs` (
  `produit_id` int NOT NULL,
  `fournisseur_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `Produits_Fournisseurs`
--

INSERT INTO `Produits_Fournisseurs` (`produit_id`, `fournisseur_id`) VALUES
(1, 1),
(2, 1),
(6, 1),
(3, 2),
(4, 2),
(5, 3),
(6, 3);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `Categories`
--
ALTER TABLE `Categories`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `Clients`
--
ALTER TABLE `Clients`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `Commandes`
--
ALTER TABLE `Commandes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id` (`client_id`);

--
-- Index pour la table `Fournisseurs`
--
ALTER TABLE `Fournisseurs`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `Lignes_Commande`
--
ALTER TABLE `Lignes_Commande`
  ADD PRIMARY KEY (`id`),
  ADD KEY `commande_id` (`commande_id`),
  ADD KEY `produit_id` (`produit_id`);

--
-- Index pour la table `Produits`
--
ALTER TABLE `Produits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categorie_id` (`categorie_id`);

--
-- Index pour la table `Produits_Fournisseurs`
--
ALTER TABLE `Produits_Fournisseurs`
  ADD PRIMARY KEY (`produit_id`,`fournisseur_id`),
  ADD KEY `fournisseur_id` (`fournisseur_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `Categories`
--
ALTER TABLE `Categories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `Clients`
--
ALTER TABLE `Clients`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `Commandes`
--
ALTER TABLE `Commandes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `Fournisseurs`
--
ALTER TABLE `Fournisseurs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `Lignes_Commande`
--
ALTER TABLE `Lignes_Commande`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `Produits`
--
ALTER TABLE `Produits`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `Commandes`
--
ALTER TABLE `Commandes`
  ADD CONSTRAINT `commandes_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `Clients` (`id`);

--
-- Contraintes pour la table `Lignes_Commande`
--
ALTER TABLE `Lignes_Commande`
  ADD CONSTRAINT `lignes_commande_ibfk_1` FOREIGN KEY (`commande_id`) REFERENCES `Commandes` (`id`),
  ADD CONSTRAINT `lignes_commande_ibfk_2` FOREIGN KEY (`produit_id`) REFERENCES `Produits` (`id`);

--
-- Contraintes pour la table `Produits`
--
ALTER TABLE `Produits`
  ADD CONSTRAINT `produits_ibfk_1` FOREIGN KEY (`categorie_id`) REFERENCES `Categories` (`id`);

--
-- Contraintes pour la table `Produits_Fournisseurs`
--
ALTER TABLE `Produits_Fournisseurs`
  ADD CONSTRAINT `produits_fournisseurs_ibfk_1` FOREIGN KEY (`produit_id`) REFERENCES `Produits` (`id`),
  ADD CONSTRAINT `produits_fournisseurs_ibfk_2` FOREIGN KEY (`fournisseur_id`) REFERENCES `Fournisseurs` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
