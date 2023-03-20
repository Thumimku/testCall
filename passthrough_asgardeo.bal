import ballerina/http;
import ballerina/log;
// import ballerina/io;
// import ballerina/regex;

listener http:Listener serviceListner = new (9090);

// http:ClientConfiguration apimEPConfig = {
//     secureSocket: {
//         enable: false
//     },
//     retryConfig: {
//         interval: 3000,
//         count: 3,
//         backOffFactor: 2.0,
//     },
// };

http:Client asgardeo = check new ("https://dev.api.asgardeo.io");

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"],
        allowCredentials: true,
        allowHeaders: ["*"],
        exposeHeaders: [],
        maxAge: 84900
    }
}
service http:Service / on serviceListner {
    
    resource function get jwks (http:Caller caller) returns error? {
        log:printError("hiiting the service resource");
        // string path = regex:replaceAll(req.rawPath, "/asgardeo/proxy", "");

        // if (http:HTTP_GET == req.method && path.includes(DEVPORTAL_ANNONYMOUS_PATH)) && 
        //         !path.includes(DEVPORTAL_SDK_DOWNLOAD_PATH_ELEMENT) {
        //     // In annonymous case if there are headers, we need to remove them
        //     req.removeHeader(http:AUTHORIZATION);
        //     req.removeHeader("cookie");
        // } else {
        //     JWTAuthResponse authResp = authenticate(<@untainted>caller, <@untainted>req);
        //     if (!authResp.authenticated) {
        //         sendUnauthorized(caller, authResp);
        //         return;
        //     }
        //     ChoreoUser user = <ChoreoUser>getAuthenticatedUser();

        //     if (!checkUserOrganizationAccess(caller, <string>organizationId)){
        //         return;
        //     }

        //     // Remove auth headers coming from choreo console
        //     req.removeHeader(http:AUTHORIZATION);
        //     req.removeHeader("cookie");

        //     string|error accessToken = "";
        //     if (path.includes(PUBLISHER_PATH_ELEMENT)) {
        //         accessToken = getAccessToken(PUBLISHER_REST_API_SCOPES);
        //     } else if (path.includes(DEVPORTAL_PATH_ELEMENT)) {
        //         accessToken = getAccessToken(DEVPORTAL_REST_API_SCOPES); 
        //     } else if (path.includes(ADMINPORTAL_PATH_ELEMENT)) {
        //         accessToken = getAccessToken(ADMINPORTAL_REST_API_SCOPES);
        //     }

        //     if (accessToken is error) {
        //         log:printError(handleError(accessToken));
        //         string msg = "Unable to get an access token to invoke APIM REST APIs";
        //         responseObj = {
        //             code: <int?> check accessToken.detail()["code"] ?: http:STATUS_INTERNAL_SERVER_ERROR,
        //             message: msg,
        //             description: <string?> check accessToken.detail()["message"] ?: ""
        //         };
        //         respondWithStatus(caller, responseObj);
        //         return;        
        //     } else {
        //         req.addHeader(http:AUTHORIZATION, AUTH_HEADER_BEARER + accessToken);
        //     }
        // }

        http:Response response = check asgardeo->get("/oauth2/jwks");
        // io:println("actual");
        // io:println(response);
        // response.removeHeader("access-control-allow-origin");
        // io:println("after removal");
        // io:println(response);
        response.addHeader("access-control-allow-origin", "*");
        // io:println("after adding back");
        // io:println(response);
        var result = caller->respond(<@untainted>response);
        if (result is error) {
            log:printError("Error occurred while responding the client from: %s with error", caller = caller.remoteAddress, 'error = result);
        }

        // if (clientResponse is http:Response) {

        // }
        // else if clientResponse is error {
        //     var responseObj = {
        //         code: http:STATUS_INTERNAL_SERVER_ERROR,
        //         message: clientResponse.,
        //         description: <string?> check clientResponse.detail()["message"] ?: ""
        //     };
        //     respondWithStatus(caller, <@untainted>responseObj);
        // }
    }

    resource function get openid\-configuration (http:Caller caller) returns error? {
        log:printError("hiiting the service resource");
        http:Response response = check asgardeo->get("/oauth2/token/.well-known/openid-configuration");
        response.addHeader("access-control-allow-origin", "*");
        var result = caller->respond(<@untainted>response);
        if (result is error) {
            log:printError("Error occurred while responding the client from: %s with error", caller = caller.remoteAddress, 'error = result);
        }
    }
}