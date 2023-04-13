package org.example.aws.security.alb;

import com.amazonaws.services.lambda.runtime.events.ApplicationLoadBalancerRequestEvent;
import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.Test;

import java.util.Map;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.containsString;

@QuarkusTest
public class
LambdaHandlerTest {

    @Test
    public void testSimpleLambdaSuccess() throws Exception {
        // you test your lambdas by invoking on http://localhost:8081
        // this works in dev mode too

        given()
                .contentType("application/json")
                .accept("application/json")
                .body(getTestEvent())
                .when()
                .post()
                .then()
                .statusCode(200)
                .body("body", containsString("Hello from Order Service"));
    }

    private ApplicationLoadBalancerRequestEvent getTestEvent() {
        ApplicationLoadBalancerRequestEvent request = new ApplicationLoadBalancerRequestEvent();

        request.setHttpMethod("POST");
        request.setHeaders(Map.of("Content-Type", "application/json"));
        request.setIsBase64Encoded(false);

        return request;
    }

}
