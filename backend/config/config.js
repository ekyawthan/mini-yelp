const Joi = require('joi');

require('dotenv').config()

const envVarsSchema = Joi.object({
    PORT: Joi.number().default(3000),
    JWT_SECRET : Joi.string().required(),
    MONGO_HOST: Joi.string(),
    MONGO_PORT : Joi.number().default(27017),
    GOOGLE_API_KEY : Joi.string().required()
}).unknown().required();

const {error , value: envVars} = Joi.validate(process.env, envVarsSchema);
if (error) {
    throw new Error(`Config valudation failed wiht ${error.message}`);
}

const config = {
    port : envVars.PORT,
    jwtSecret : envVars.JWT_SECRET,
    mongo : {
        host : envVars.MONGO_HOST,
        port : envVars.MONGO_PORT
    },
    google_api_key : envVars.GOOGLE_API_KEY
}

module.exports = config;