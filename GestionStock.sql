-- MySQL Dump
--
-- Base de données : `GestionStock`
--

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET NAMES utf8mb4 */;

CREATE TABLE `Categories` (
  `id` int NOT NULL,
  `nom` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `Categories` (`id`, `nom`, `description`) VALUES
(1, 'Avions de chasse', 'Maquettes d\'avions de chasse en papier'),
(2, 'Avions commerciaux', 'Maquettes d\'avions commerciaux en papier'),
(3, 'Avions historiques', 'Maquettes d\'avions historiques en papier');

CREATE TABLE `Clients` (
  `id` int NOT NULL,
  `nom` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `adresse` text COLLATE utf8mb4_general_ci,
  `telephone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `Clients` (`id`, `nom`, `adresse`, `telephone`, `email`) VALUES
(1, 'Jean Dupont', '12 Rue des Lilas, Paris', '0612345678', 'jean.dupont@gmail.com'),
(2, 'Marie Curie', '34 Avenue des Champs, Lyon', '0623456789', 'marie.curie@gmail.com');

CREATE TABLE `Commandes` (
  `id` int NOT NULL,
  `client_id` int DEFAULT NULL,
  `date_commande` date NOT NULL,
  `statut` varchar(50) COLLATE utf8mb4_general_ci DEFAULT 'en attente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `Commandes` (`id`, `client_id`, `date_commande`, `statut`) VALUES
(1, 1, '2025-01-01', 'en cours'),
(2, 2, '2025-01-02', 'en attente');

CREATE TABLE `Fournisseurs` (
  `id` int NOT NULL,
  `nom` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `adresse` text COLLATE utf8mb4_general_ci,
  `telephone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `Fournisseurs` (`id`, `nom`, `adresse`, `telephone`, `email`) VALUES
(1, 'Fournisseur Alpha', '123 Rue Alpha, Paris', '0123456789', 'contact@alpha.com'),
(2, 'Fournisseur Beta', '456 Rue Beta, Lyon', '0987654321', 'contact@beta.com');

CREATE TABLE `Lignes_Commande` (
  `id` int NOT NULL,
  `commande_id` int DEFAULT NULL,
  `produit_id` int DEFAULT NULL,
  `quantite` int NOT NULL,
  `prix_unitaire` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `Lignes_Commande` (`id`, `commande_id`, `produit_id`, `quantite`, `prix_unitaire`) VALUES
(1, 1, 1, 2, 15.99),
(2, 1, 3, 1, 19.99),
(3, 2, 2, 1, 25.99);

CREATE TABLE `Produits` (
  `id` int NOT NULL,
  `nom` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `prix_unitaire` decimal(10,2) NOT NULL,
  `quantite_en_stock` int NOT NULL,
  `categorie_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `Produits` (`id`, `nom`, `description`, `prix_unitaire`, `quantite_en_stock`, `categorie_id`) VALUES
(1, 'F-16', 'Avion de chasse moderne', 15.99, 50, 1),
(2, 'Boeing 747', 'Avion commercial classique', 25.99, 30, 2),
(3, 'Spitfire', 'Avion de la Seconde Guerre mondiale', 19.99, 40, 3);

CREATE TABLE `Produits_Fournisseurs` (
  `produit_id` int NOT NULL,
  `fournisseur_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `Produits_Fournisseurs` (`produit_id`, `fournisseur_id`) VALUES
(1, 1),
(2, 1),
(3, 2);

ALTER TABLE `Categories`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `Clients`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `Commandes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id` (`client_id`);

ALTER TABLE `Fournisseurs`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `Lignes_Commande`
  ADD PRIMARY KEY (`id`),
  ADD KEY `commande_id` (`commande_id`),
  ADD KEY `produit_id` (`produit_id`);

ALTER TABLE `Produits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categorie_id` (`categorie_id`);

ALTER TABLE `Produits_Fournisseurs`
  ADD PRIMARY KEY (`produit_id`,`fournisseur_id`),
  ADD KEY `fournisseur_id` (`fournisseur_id`);

ALTER TABLE `Categories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

ALTER TABLE `Clients`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

ALTER TABLE `Commandes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

ALTER TABLE `Fournisseurs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

ALTER TABLE `Lignes_Commande`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

ALTER TABLE `Produits`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

ALTER TABLE `Commandes`
  ADD CONSTRAINT `commandes_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `Clients` (`id`);

ALTER TABLE `Lignes_Commande`
  ADD CONSTRAINT `lignes_commande_ibfk_1` FOREIGN KEY (`commande_id`) REFERENCES `Commandes` (`id`),
  ADD CONSTRAINT `lignes_commande_ibfk_2` FOREIGN KEY (`produit_id`) REFERENCES `Produits` (`id`);

ALTER TABLE `Produits`
  ADD CONSTRAINT `produits_ibfk_1` FOREIGN KEY (`categorie_id`) REFERENCES `Categories` (`id`);

ALTER TABLE `Produits_Fournisseurs`
  ADD CONSTRAINT `produits_fournisseurs_ibfk_1` FOREIGN KEY (`produit_id`) REFERENCES `Produits` (`id`),
  ADD CONSTRAINT `produits_fournisseurs_ibfk_2` FOREIGN KEY (`fournisseur_id`) REFERENCES `Fournisseurs` (`id`);

COMMIT;