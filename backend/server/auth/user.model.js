const Promise = require('bluebird');
const mongoose = require('mongoose');
const httpStatus = require('http-status');
const APIError = require('../helpers/APIError');


const UserSchema = new mongoose.Schema({
    username: {
      type: String,
      unique: true,
      required: true,
      dropDups : true
    },
    createdAt: {
      type: Date,
      default: Date.now
    },
     viewed : {
      type: [mongoose.Schema.Types.ObjectId],
      default : []
    },
    reactions : {
      type : [{type : mongoose.Schema.Types.ObjectId, ref : "Reaction"}],
      default: []
    }
  });

  UserSchema.statics = {
      get(id) {
          return this.findByID(id)
            .exce()
            .then((user) => {
              if (user){
                  return user;
              }
              const err = new APIError('No such user exists', httpStatus.NOT_FOUND);
              return Promise.reject(err);
          });
      }
  }


  module.exports = mongoose.model('User', UserSchema);