exports.handler = async (event) => {
    const response = {
        statusCode: 200,
        headers: {
            'Content-Type': 'text/plain'
        },
        body: '200 OK',
        isBase64Encoded: false
    };

    return response;
};
