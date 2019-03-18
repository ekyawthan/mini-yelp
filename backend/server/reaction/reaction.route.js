const express = require('express');
const react = require('./reaction.controller');
const router = express.Router();

router.route('/').get((req, res) => res.send('hello from reaction'))
router.route('/add').post(react.create)
router.route('/update').put(react.update)
router.route('/delete').delete(react.remove)

module.exports = router;