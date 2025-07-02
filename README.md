# Full Product CRUD App - Backend

This is the backend API for a full product CRUD (Create, Read, Update, Delete) application. It is built with Node.js, Express, and connects to a Microsoft SQL Server database.

## Features

- RESTful API for managing products
- Pagination support for product listing
- Environment-based configuration
- CORS enabled for cross-origin requests

## Project Structure

```
Backend/
├── .env
├── db.js
├── index.js
├── package.json
├── README.md
├── routes/
│   └── products.js
└── sql/
    └── init.sql
```

## Setup

### 1. Clone the repository

```sh
git clone <https://github.com/Pov-Phally/Full-CRUD-App.git>
cd Backend
```

### 2. Install dependencies

```sh
npm install
```

### 3. Configure environment variables

Edit the `.env` file with your SQL Server credentials:

```
DB_USER=admin
DB_PASS=123456789
DB_SERVER=DESKTOP-4B599UL\SQLEXPRESS
DB_DATABASE=CRUD App
DB_PORT=1433
PORT=3000
```

### 4. Initialize the database

Run the SQL script in [`sql/init.sql`](sql/init.sql) on your SQL Server to create the `PRODUCTS` table and insert sample data.

### 5. Start the server

```sh
npm start
```

The API will run on `http://localhost:3000` by default.

## API Endpoints

### Get all products (with pagination)

```
GET /products/products?offset=0&limit=10
```

### Get product by ID

```
GET /products?id=1
```

### Create a new product

```
POST /products
Content-Type: application/json

{
  "productName": "Sample Product",
  "price": 12.99,
  "stock": 5
}
```

### Update a product

```
PUT /products
Content-Type: application/json

{
  "id": 1,
  "productName": "Updated Name",
  "price": 15.99,
  "stock": 10
}
```

### Delete a product

```
DELETE /products?id=1
```