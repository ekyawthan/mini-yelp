const express = require('express');
const authRoute = require('./server/auth/auth.route');
const restaurantRoute = require('./server/restaurant/restaurant.route');
const reactionRoutes = require('./server/reaction/reaction.route');
const router =  express.Router();

router.get('/ping', (req, res) => 
    res.send('Ok')
);
router.use('/auth', authRoute)
router.use('/restaurant', restaurantRoute)
router.use('/reaction', reactionRoutes)

module.exports = router;
