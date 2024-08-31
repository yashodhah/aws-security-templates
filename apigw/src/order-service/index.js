exports.handler = async (event) => {
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
