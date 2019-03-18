const jwt = require('jsonwebtoken');
const httpStatus = require('http-status');
const APIError = require('../helpers/APIError');
const config = require('../../config/config');
const User = require('./user.model');

var currenUserIndex = 0



function login(req, res, next){
    currenUserIndex += 1
    let username = req.body.username + currenUserIndex
    console.log(username)
    User.findOne({username}, (error, user) => {
        if (error) {
            next(error)
            return 
        }
        if (user === null) {
            return createuser(username, res, next)

        } else {
            return generateToken(user._doc, res, next)
        }
    })

}

function generateToken(user, res, next) {
    const token = jwt.sign({
        username: user.username
      }, config.jwtSecret);
      return res.json({token : token, ...user })
}

function createuser(username, res, next) {
    const user = User({
        username
    })
    user.save()
        .then(saveduser => generateToken(saveduser._doc, res, next))
        .catch(e => next(e));
}

function getUserById(req, res, next) {
    const {userid} = req.query
    User.findById(userid).populate('reactions').then(founduser => {
        if (!founduser) {
            return res.status(httpStatus.NOT_FOUND).send({msg : "user not found"})
        }
        return generateToken(founduser._doc, res, next)
    }).catch(e => next(e))
}

module.exports = {login, getUserById};