const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

require('dotenv').config();

const productsRouter = require('./routes/products');

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.use('/products', productsRouter);

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`API listening on port ${port}`));

// import express from 'express';

// const app = express();
// const port = 8001;
// app.use(express.json());

// app.listen(port, () =>
//     console.log(`Server is running on http://localhost:${port}`));


// // In-memory product store
// let products = [];
// let nextId = 1;

// // Create a product
// app.post('/products', (req, res) => {
//     const { name, price } = req.body;
//     if (!name || price == null) {
//         return res.status(400).json({ error: 'Name and price are required.' });
//     }
//     const product = { id: nextId++, name, price };
//     products.push(product);
//     res.status(201).json(product);
// });

// // Get all products
// app.get('/products', (req, res) => {
//     res.json(products);
// });

// // Get a single product
// app.get('/products/:id', (req, res) => {
//     const product = products.find(p => p.id === parseInt(req.params.id));
//     if (!product) {
//         return res.status(404).json({ error: 'Product not found.' });
//     }
//     res.json(product);
// });

// // Update a product
// app.put('/products/:id', (req, res) => {
//     const product = products.find(p => p.id === parseInt(req.params.id));
//     if (!product) {
//         return res.status(404).json({ error: 'Product not found.' });
//     }
//     const { name, price } = req.body;
//     if (name !== undefined) product.name = name;
//     if (price !== undefined) product.price = price;
//     res.json(product);
// });

// // Delete a product
// app.delete('/products/:id', (req, res) => {
//     const index = products.findIndex(p => p.id === parseInt(req.params.id));
//     if (index === -1) {
//         return res.status(404).json({ error: 'Product not found.' });
//     }
//     products.splice(index, 1);
//     res.status(204).send();
// });

// const PORT = process.env.PORT || 3000;
// app.listen(PORT, () => {
//     console.log(`Server running on port ${PORT}`);
// });