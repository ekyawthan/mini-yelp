const httpStatus = require('http-status');

class APIError extends Error {
    constructor(message, status = httpStatus.INTERNAL_SERVER_ERROR) {
        super(message)
        this.status = status
        this.name = this.constructor.name
        Error.captureStackTrace(this, this.name)
    }
}

module.exports = APIError;