const express = require('express');
const auth = require('./auth.controller')

const router = express.Router();

router.route('/login').post(auth.login);
router.route('/user').get(auth.getUserById);


module.exports = router