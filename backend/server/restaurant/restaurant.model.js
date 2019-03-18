const mongoose = require('mongoose');
const Schema = mongoose.Schema

const RestaurantSchema =  new Schema({
    google_id           : {type : String},
    name                : {type : String, default : ""},
    placeId             : {type : String},
    priceLevel          : {type :Number},
    rating              : {type : Number},
    reference           : {type : String},
    userRatingsTotal    : {type : Number},
    reactions           : {type : [{type : Schema.Types.ObjectId, ref : "Reaction"}], default : []}
});

RestaurantSchema.statics = {

}

module.exports = mongoose.model('Resturant', RestaurantSchema);