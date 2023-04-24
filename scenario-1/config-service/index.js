exports.handler = async (event) => {
    const response = {
        statusCode: 200,
        headers: {
            'Content-Type': 'text/plain'
        },
        body: 'Hello from config service',
        isBase64Encoded: false
    };

    return response;

};
