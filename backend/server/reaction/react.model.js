const Promise = require('bluebird');
const mongoose = require('mongoose');
const httpStatus = require('http-status');
const APIError = require('../helpers/APIError');

const ReactionSchema = new mongoose.Schema({
    type    : {
        type : String,
        enum: ['view','thump-up', 'thump-down'],
        default: 'view'
    },
    userid : {type : String, default : ""},
    restaurantID : {type : String, default : ""}
});


ReactionSchema.statics  = {

}

module.exports = mongoose.model('Reaction', ReactionSchema);