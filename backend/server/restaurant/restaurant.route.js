const express = require('express');
const controller = require('./restaurant.controller')
const router = express.Router();


router.route('/', (req, res) => res.send('hello from resturant'))
router.route('/add').post(controller.create);
router.route('/update').post(controller.update);
router.route('/get').get(controller.get);
router.route('/remove').delete(controller.remove);
router.route('/view').post(controller.updateView);
router.route('/bybatch').get(controller.byBatch);


module.exports = router;
