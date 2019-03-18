const querystring = require('querystring');
const https = require('https');

class GooglePlace {
  constructor(apiKey, outputFormat = "json") {
    this.apiKey = apiKey
    this.outputFormat = outputFormat
  }

  search(parameters) {
    parameters.key = apiKey;
    parameters.location = parameters.location || "-33.8670522,151.1957362";
    parameters.pagetoken = parameters.pagetoken || '';
    parameters._ = (new Date()).getTime().toString(36);
    if (typeof parameters.location === "object") parameters.location = parameters.location.toString();
    if (!parameters.rankby) parameters.radius = parameters.radius || 500;

    const options = {
      hostname: "maps.googleapis.com",
      path: "/maps/api/place/search/" + this.outputFormat + "?" + querystring.stringify(parameters)
    };
    const request = https.request(options,(res) => {
      
    });
    request.end();

  }


}
