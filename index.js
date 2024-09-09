// index.js
const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());

app.get('/', (req, res) => {
    res.send('Welcome to the Math Calculator API!');
});

app.get('/add', (req, res) => {
    const { a, b } = req.query;
    const result = parseFloat(a) + parseFloat(b);
    res.json({ result });
});

app.get('/subtract', (req, res) => {
    const { a, b } = req.query;
    const result = parseFloat(a) - parseFloat(b);
    res.json({ result });
});

app.get('/multiply', (req, res) => {
    const { a, b } = req.query;
    const result = parseFloat(a) * parseFloat(b);
    res.json({ result });
});

app.get('/divide', (req, res) => {
    const { a, b } = req.query;
    if (b == 0) {
        return res.status(400).json({ error: 'Division by zero is not allowed' });
    }
    const result = parseFloat(a) / parseFloat(b);
    res.json({ result });
});

app.listen(port, () => {
    console.log(`Math Calculator API listening at http://localhost:${port}`);
});
