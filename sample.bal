import ballerina/http;
import ballerina/lang.runtime;

type RiskResponse record {
    boolean hasRisk;
};

type RiskRequest record {
    string ip;
};

// The `risk` resource is invoked  when a request is made to the `/risk` path.
service / on new http:Listener(8090) {
    resource function post risk(@http:Payload RiskRequest req) returns RiskResponse|error? {
        runtime:sleep(8);
        RiskResponse resp = {
            // hasRisk is true if the country code of the IP address is not the specified country code.
            hasRisk: true
        };
        return resp;
    }
}