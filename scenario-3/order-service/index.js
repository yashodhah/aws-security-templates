import {checkAuthorization} from "./authorizer.js";

export async function handler(event) {
    // Call external auth service to check authorization
    const isAuthorized = await checkAuthorization(event);

    if (!isAuthorized) {
        return {
            statusCode: 401,
            body: 'Unauthorized'
        };
    }

    // If authorized, proceed with handling the request
    const response = {
        statusCode: 200,
        headers: {
            'Content-Type': 'text/plain'
        },
        body: 'Hello from order service',
        isBase64Encoded: false
    };

    return response;
};
