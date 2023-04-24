const isAuthorized = require("./authorizer");

exports.handler = async (event) => {
    // Get the access token from the request headers
    const accessToken = event.headers.Authorization.split(' ')[1];

    if(!await isAuthorized(accessToken)) {
        return {
            statusCode: 401,
            headers: {
                'Content-Type': 'text/plain'
            },
            body: 'Unauthorized',
            isBase64Encoded: false
        };
    }

    return  {
        statusCode: 200,
        headers: {
            'Content-Type': 'text/plain'
        },
        body: 'Hello from order service',
        isBase64Encoded: false
    };
};
