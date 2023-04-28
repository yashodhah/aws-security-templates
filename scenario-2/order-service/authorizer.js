import {CognitoJwtVerifier} from "aws-jwt-verify";

const userPoolId = process.env.USER_POOL_ID;
const clientId = process.env.CLIENT_ID;
const scope = process.env.SCOPE;

// Verifier that expects valid access tokens:
const verifier = CognitoJwtVerifier.create({
    userPoolId: userPoolId,
    tokenUse: "access",
    clientId: clientId,
    scope: scope
});

export async function isAuthorized(headers) {
    if (headers.hasOwnProperty('authorization')) {
        const accessToken = headers.authorization.split(' ')[1];

        return isValidToken(accessToken);
    } else {
        console.log("No Access token");
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

