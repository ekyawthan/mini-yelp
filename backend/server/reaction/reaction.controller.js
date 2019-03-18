const Reaction = require('./react.model');

function create(req, res, next) {
    const {type, userid, restaurantID} = req.body;
    const reaction = Reaction({type, userid, restaurantID})
    reaction.save()
        .then(saved => res.json(saved))
        .catch(e => next(e))  
}

function update(req, res, next) {
    Reaction.findByIdAndUpdate(req.body.id, req.body, {upsert : true}, (error, doc) => {
        if (error) {
            next(error)
            return 
        }
        return res.json(doc)
    })
}

function remove(req, res, next) {
    Reaction.remove({_id : req.body.id}, err => {
        if (err) {
            next(err)
            return 
        }
        return res.json({deletion : true})
    })
}

module.exports = {create, update, remove }