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