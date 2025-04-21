const express = require('express');
const https = require('https');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 3100;

// Chemins vers les fichiers de certificat
const serverKey = fs.readFileSync(path.join(__dirname, 'localKeys', 'server-key.pem'));
const serverCert = fs.readFileSync(path.join(__dirname, 'localKeys', 'server-cert.pem'));
const caCert = fs.readFileSync(path.join(__dirname, 'localKeys', 'ca-cert.pem'));
const authorizedClients = fs.readFileSync(path.join(__dirname, 'localKeys', 'authorized_clients.pem'));

// Options pour HTTPS
const options = {
  key: serverKey,
  cert: serverCert,
  ca: caCert,
  requestCert: true, // Demander un certificat client
  rejectUnauthorized: false // Ne pas rejeter automatiquement les connexions sans certificat client valide
};

// Middleware pour servir des fichiers statiques
app.use(express.static(path.join(__dirname, 'public')));

// Route de base
app.get('/', (req, res) => {
  if (req.client.authorized) {
    const clientCert = req.socket.getPeerCertificate();

    console.log("clientCert : ",clientCert);
    const clientCertPEM = `-----BEGIN CERTIFICATE-----\n${clientCert.raw.toString('base64').match(/.{1,64}/g).join('\n')}\n-----END CERTIFICATE-----\n`;

    console.log("clientCertPEM",clientCertPEM);

    if (authorizedClients.includes(clientCertPEM)) {
      res.send('Hello, authenticated user!');
    } else {
      res.status(403).send('Forbidden: Unauthorized client certificate');
    }
  } else {
    res.status(403).send('Forbidden: Invalid client certificate');
  }
});

// Créer le serveur HTTPS
https.createServer(options, app).listen(port, () => {
  console.log(`HTTPS Server running at https://localhost:${port}`);
});