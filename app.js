const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const { body, validationResult } = require('express-validator');

const app = express();
const port = 3000;

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'root',
  database: 'GestionStock',
  port: 8889,
});

db.connect((err) => {
  if (err) {
    console.error('Erreur de connexion à la base de données:', err);
    process.exit(1);
  }
  console.log('Connecté à la base de données MySQL.');
});

// 1. Lister les commandes par année
app.get('/commandes', (req, res) => {
  const { start, end } = req.query;
  const query = 'SELECT * FROM Commandes WHERE date_commande BETWEEN ? AND ?';
  db.query(query, [start, end], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// 2. Rechercher les commandes d’un client
app.get('/clients/:id/commandes', (req, res) => {
  const { id } = req.params;
  const query = 'SELECT * FROM Commandes WHERE client_id = ?';
  db.query(query, [id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// 3. Lister les commandes qui contiennent un article précis
app.get('/produits/:id/commandes', (req, res) => {
  const { id } = req.params;
  const query = `
    SELECT c.id AS commande_id, c.date_commande, c.statut, lc.quantite
    FROM Commandes c
    JOIN Lignes_Commande lc ON c.id = lc.commande_id
    WHERE lc.produit_id = ?
  `;
  db.query(query, [id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// 4. Recherche multi-critères
app.get('/recherche-commandes', (req, res) => {
  let query = 'SELECT * FROM Commandes WHERE 1=1';
  const params = [];

  if (req.query.client_id) {
    query += ' AND client_id = ?';
    params.push(req.query.client_id);
  }
  if (req.query.date_min) {
    query += ' AND date_commande >= ?';
    params.push(req.query.date_min);
  }
  if (req.query.date_max) {
    query += ' AND date_commande <= ?';
    params.push(req.query.date_max);
  }
  if (req.query.statut) {
    query += ' AND statut = ?';
    params.push(req.query.statut);
  }

  db.query(query, params, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// 5. Statistiques : Produits les plus vendus
app.get('/statistiques/produits-plus-vendus', (req, res) => {
  const query = `
    SELECT p.nom, SUM(lc.quantite) AS total_vendus
    FROM Produits p
    JOIN Lignes_Commande lc ON p.id = lc.produit_id
    GROUP BY p.id
    ORDER BY total_vendus DESC
  `;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// 6. Gestion fine du stock
app.post('/commandes', [
  body('client_id').notEmpty().withMessage('Client ID est requis'),
  body('produits').isArray().withMessage('Produits doivent être un tableau'),
], (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { client_id, produits } = req.body;
  db.beginTransaction((err) => {
    if (err) return res.status(500).json({ error: err.message });

    const queryCommande = 'INSERT INTO Commandes (client_id, date_commande, statut) VALUES (?, NOW(), ?)';
    db.query(queryCommande, [client_id, 'en cours'], (err, result) => {
      if (err) return db.rollback(() => res.status(500).json({ error: err.message }));

      const commandeId = result.insertId;

      const queryLigneCommande = 'INSERT INTO Lignes_Commande (commande_id, produit_id, quantite, prix_unitaire) VALUES ?';
      const lignes = produits.map((produit) => [
        commandeId,
        produit.produit_id,
        produit.quantite,
        produit.prix_unitaire,
      ]);

      db.query(queryLigneCommande, [lignes], (err) => {
        if (err) return db.rollback(() => res.status(500).json({ error: err.message }));

        const queryStock = 'UPDATE Produits SET quantite_en_stock = quantite_en_stock - ? WHERE id = ?';

        produits.forEach((produit) => {
          db.query(queryStock, [produit.quantite, produit.produit_id], (err) => {
            if (err) return db.rollback(() => res.status(500).json({ error: err.message }));
          });
        });

        db.commit((err) => {
          if (err) return db.rollback(() => res.status(500).json({ error: err.message }));
          res.status(201).json({ message: 'Commande créée avec succès', commandeId });
        });
      });
    });
  });
});

// 7. Notifications de stock faible
app.get('/produits/stock-faible', (req, res) => {
  const seuil = req.query.seuil || 10;
  const query = 'SELECT * FROM Produits WHERE quantite_en_stock < ?';
  db.query(query, [seuil], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

app.listen(port, () => {
  console.log(`API de gestion de stock (V2) disponible sur http://localhost:${port}`);
});