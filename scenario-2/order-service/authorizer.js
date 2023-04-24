import { CognitoJwtVerifier } from "aws-jwt-verify";

const userPoolId = process.env.USER_POOL_ID;
const clientId = process.env.CLIENT_ID;

// Verifier that expects valid access tokens:
const verifier = CognitoJwtVerifier.create({
    userPoolId: userPoolId,
    tokenUse: "access",
    clientId: clientId,
});

async function isAuthorized(headers) {
    if (headers.hasOwnProperty('Authorization')) {
        const accessToken = headers.Authorization.split(' ')[1];

        return isValidToken(accessToken);
    } else {
        return false;
    }
}

async function isValidToken(token) {
    try {
        const payload = await verifier.verify(
            token
        );

        console.log("Token is valid. Payload:", payload);

        return true;
    } catch {
        console.log("Token not valid!");
        return false;
    }
}

module.exports = isAuthorized;
