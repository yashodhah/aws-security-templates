import {isAuthorized} from "./authorizer.js";

export async function handler(event) {
    if (!await isAuthorized(event.headers)) {
        return {
            statusCode: 401,
            headers: {
                'Content-Type': 'text/plain'
            },
            body: 'Unauthorized',
            isBase64Encoded: false
        };
    }

    return {
        statusCode: 200,
        headers: {
            'Content-Type': 'text/plain'
        },
        body: 'Hello from order service',
        isBase64Encoded: false
    };
}
