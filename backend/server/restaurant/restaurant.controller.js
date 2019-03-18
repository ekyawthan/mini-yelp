const jwt = require('jsonwebtoken');
const httpStatus = require('http-status');
const APIError = require('../helpers/APIError');
const config = require('../../config/config');
const Restaurant = require('./restaurant.model');
const Reaction = require('../reaction/react.model');
const User = require('../auth/user.model');
const mongoose = require('mongoose');

function get(req, res, next) {
    const {placeId} = req.query
    Restaurant.findOne({placeId})
        .populate('reactions')
        .exec((err, doc) => {
            if (err) {
                return res.json({status : false , message : 'doc not found'})
            }
            if (!doc) {
                return res.status(httpStatus.NOT_FOUND).send({msg : "not found"})
            }
            return res.json(doc)
    })
}

function update(req, res, next) {
    const {placeId,userid, id, reactionType} = req.body
    const reaction = Reaction({type: reactionType, restaurantID : placeId, userid})
    reaction.save().then(saved => {
        updateuserReaction(saved, userid)
        updatePlaceReaction(saved, placeId)
        return res.json(saved)
    }).catch(e => next(e))
}

function updateView(req, res, next) {
    const {placeId,userid} = req.body
    const viewReaction = Reaction({type : "view", restaurantID : placeId, userid})
    viewReaction.save()
        .then(saved => {
            updateuserReaction(saved, req.body.userid)
            const {userid, ...rest} = req.body
            return updateOrCreatePlaceReaction(saved, rest, res)
            //return res.json(saved)
        })
        .catch(e => next(e))
   
}

function updateuserReaction(reaction , userid) {
    User.update({_id : userid}, {$push : {reactions : reaction}}, (err, callback) => {
        console.log(callback)
    })
}

function updatePlaceReaction(reaction, placeId) {
    Restaurant.update({placeId : placeId}, {$push : {reactions : reaction}}, (err, callback) => console.log(callback))
}
function updateOrCreatePlaceReaction(reaction, place, res) {
   Restaurant.update({placeId : place.placeId}, {$push : {reactions : reaction}}, (err, callback) => {
       if (err) {
           console.log('error on resturant')
           return res.status(httpStatus.INTERNAL_SERVER_ERROR).send({msg : "error"})
       }
       if(callback.nModified == false) {
           const newplace = Restaurant({...place, reactions : [reaction]})
        //    newplace.reactions.push(reaction)
           newplace.save().then(saved => res.json(saved._doc)).catch(e => console.log(e))
       }else {
           Restaurant.findOne({placeId : place.placeId})
            .populate('reactions')
            .then(founded => res.json(founded))
            .catch(e => res.status(httpStatus.NOT_FOUND).send({msg : "not found"}))
       }
   })
}



function create(req, res, next) {
    const restaurant = Restaurant(req.body)
    restaurant.save().then(saved => res.json(saved._doc)).catch(e => next(e))
}

function remove(req, res, next) {

}

function byBatch(req, res,next) {
    const {ids} = req.query
    Restaurant.find({
        'placeId' :  {$in : ids.split(",")}
    }, (err, docs) => {
        if (err) {
            next(err)
            return 
        }
        return res.json({status : "Ok", result : [...docs]})
    }).populate('reactions')
}

module.exports = {create, update, get, remove, updateView, byBatch}