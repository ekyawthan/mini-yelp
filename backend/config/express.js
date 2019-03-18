const express = require('express');
const bodyParser = require('body-parser');
const routes = require('../index.route');
const config = require('./config')


const app = express()

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));

app.use('/api', routes)

module.exports = app;

