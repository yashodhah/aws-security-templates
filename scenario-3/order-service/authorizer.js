import axios from "axios";

export async function checkAuthorization(headers) {
    // Construct the request to the external auth service
    const requestOptions = {
        method: 'GET',
        url: 'https://external-auth-service.com/checkAuthorization',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': headers['authorization'] // pass the Authorization header from the original request
        }
    };

    try {
        // Make the request to the external auth service
        const response = await axios(requestOptions);

        // If the response status code is 200, return true
        if (response.status === 200) {
            return true;
        } else {
            return false;
        }
    } catch (error) {
        // If there is an error, log it and return false
        console.log(error);
        return false;
    }
}
