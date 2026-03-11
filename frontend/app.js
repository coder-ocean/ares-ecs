const express = require('express');
const axios = require('axios');

const app = express();
app.set('view engine', 'ejs');

const URL = process.env.BACKEND_URL || "/api";

app.get('/', async function(req, res) {
    try {

        const response = await axios.get(URL);
        const result = response.data;

        res.render('index', { data: result.data });

    } catch (err) {
        console.error(err);
        res.status(500).json({ msg: 'Internal Server Error.' });
    }
});

app.listen(3000, function(){
    console.log('Ares listening on port 3000!');
});