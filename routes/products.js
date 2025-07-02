const router = require('express').Router();
const { getPool, sql } = require('../db');

// GET all /products
router.get('/products', async (req, res) => {
    const offset = parseInt(req.query.offset) || 0;
    const limit = parseInt(req.query.limit) || 10;

    const pool = await getPool();
    const result = await pool.request()
        .input('offset', sql.Int, offset)
        .input('limit', sql.Int, limit)
        .query(`
      SELECT * FROM dbo.PRODUCTS
      ORDER BY PRODUCTID
      OFFSET @offset ROWS
      FETCH NEXT @limit ROWS ONLY
    `);

    res.json(result.recordset);
});


// GET /products by id
router.get('/', async (req, res) => {
    const pool = await getPool();

    if (req.query.id) {
        const id = parseInt(req.query.id, 10);
        if (isNaN(id)) {
            return res.status(400).json({ error: 'Invalid ID' });
        }
        const result = await pool.request()
            .input('id', sql.Int, id)
            .query('SELECT * FROM PRODUCTS WHERE PRODUCTID = @id');

        return res.json(result.recordset[0] || {});
    } else {
        const offset = parseInt(req.query.offset) || 0;
        const limit = parseInt(req.query.limit) || 10;
        const result = await pool.request().query
            (`SELECT * FROM PRODUCTS`);
        return res.json(result.recordset);
    }
});


// POST /products
router.post('/', async (req, res) => {
    const { productName, price, stock } = req.body;
    if (!productName || price <= 0 || stock < 0) {
        return res.status(400).json({ error: 'Invalid input' });
    }

    const pool = await getPool();
    const result = await pool.request()
        .input('name', sql.NVarChar(100), productName)
        .input('price', sql.Decimal(10, 2), price)
        .input('stock', sql.Int, stock)
        .query(`
      INSERT INTO PRODUCTS (PRODUCTNAME, PRICE, STOCK)
      OUTPUT inserted.PRODUCTID AS PRODUCTID
      VALUES (@name, @price, @stock);
    `);

    // Now this should be a number
    const newId = result.recordset[0].PRODUCTID;
    res.status(201).json({ productId: newId });
});


// PUT /products by id
router.put('/', async (req, res) => {
    const { id, productName, price, stock } = req.body;
    if (!id || !productName || price <= 0 || stock < 0) {
        return res.status(400).json({ error: 'Invalid input' });
    }
    const pool = await getPool();
    await pool.request()
        .input('id', sql.Int, id)
        .input('name', sql.NVarChar(100), productName)
        .input('price', sql.Decimal(10, 2), price)
        .input('stock', sql.Int, stock)
        .query(`UPDATE PRODUCTS
            SET PRODUCTNAME=@name, PRICE=@price, STOCK=@stock 
            WHERE PRODUCTID=@id`);
    res.json({ updated: true });
});

// DELETE /products?id=#
router.delete('/', async (req, res) => {
    const { id } = req.query;
    if (!id) return res.status(400).json({ error: 'ID is required' });
    const pool = await getPool();
    await pool.request()
        .input('id', sql.Int, id)
        .query('DELETE FROM PRODUCTS WHERE PRODUCTID=@id');
    res.json({ deleted: true });
});

module.exports = router;