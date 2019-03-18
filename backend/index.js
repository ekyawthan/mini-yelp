const app = require('./config/express');
const config = require('./config/config');
const mongoose = require('mongoose');
const User = require('./server/auth/user.model')


Promise = require('bluebird');
mongoose.Promise = Promise;

const mongoUri = config.mongo.host;
mongoose.connect(mongoUri, { server: { socketOptions: { keepAlive: 1 } } });
mongoose.connection.on('error', () => {
  throw new Error(`unable to connect to database: ${mongoUri}`);
});



app.listen(config.port, () => {
    console.info(`serving on port ${config.port}`);
});

module.exports = app;