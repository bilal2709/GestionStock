const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

app.use(bodyParser.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root', 
  password: 'root',
  database: 'GestionStock',
  port:8889,
});

db.connect((err) => {
  if (err) {
    console.error('Erreur de connexion à la base de données:', err);
    process.exit(1);
  }
  console.log('Connecté à la base de données MySQL.');
});

app.get('/produits', (req, res) => {
  db.query('SELECT * FROM Produits', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

app.post('/produits', (req, res) => {
  const { nom, description, prix_unitaire, quantite_en_stock, categorie_id } = req.body;
  const query = 'INSERT INTO Produits (nom, description, prix_unitaire, quantite_en_stock, categorie_id) VALUES (?, ?, ?, ?, ?)';
  db.query(query, [nom, description, prix_unitaire, quantite_en_stock, categorie_id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ id: results.insertId, ...req.body });
  });
});

app.put('/produits/:id', (req, res) => {
  const { id } = req.params;
  const { nom, description, prix_unitaire, quantite_en_stock, categorie_id } = req.body;
  const query = 'UPDATE Produits SET nom = ?, description = ?, prix_unitaire = ?, quantite_en_stock = ?, categorie_id = ? WHERE id = ?';
  db.query(query, [nom, description, prix_unitaire, quantite_en_stock, categorie_id, id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Produit mis à jour', changes: results.affectedRows });
  });
});

app.delete('/produits/:id', (req, res) => {
  const { id } = req.params;
  db.query('DELETE FROM Produits WHERE id = ?', [id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Produit supprimé', changes: results.affectedRows });
  });
});

app.get('/clients', (req, res) => {
  db.query('SELECT * FROM Clients', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

app.post('/clients', (req, res) => {
  const { nom, adresse, telephone, email } = req.body;
  const query = 'INSERT INTO Clients (nom, adresse, telephone, email) VALUES (?, ?, ?, ?)';
  db.query(query, [nom, adresse, telephone, email], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ id: results.insertId, ...req.body });
  });
});

app.get('/commandes', (req, res) => {
  const query = `SELECT Commandes.*, Clients.nom AS client_nom FROM Commandes 
                 JOIN Clients ON Commandes.client_id = Clients.id`;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

app.post('/commandes', (req, res) => {
  const { client_id, date_commande, statut } = req.body;
  const query = 'INSERT INTO Commandes (client_id, date_commande, statut) VALUES (?, ?, ?)';
  db.query(query, [client_id, date_commande, statut], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ id: results.insertId, ...req.body });
  });
});

app.listen(port, () => {
  console.log(`API de gestion de stock disponible sur http://localhost:${port}`);
});

