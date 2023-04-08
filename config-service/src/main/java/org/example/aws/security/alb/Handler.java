package org.example.aws.security.alb;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.ApplicationLoadBalancerRequestEvent;
import com.amazonaws.services.lambda.runtime.events.ApplicationLoadBalancerResponseEvent;

import javax.inject.Named;

@Named("config-service")
public class Handler implements RequestHandler<ApplicationLoadBalancerRequestEvent, ApplicationLoadBalancerResponseEvent> {

    @Override
    public ApplicationLoadBalancerResponseEvent handleRequest(ApplicationLoadBalancerRequestEvent applicationLoadBalancerRequestEvent, Context context) {
        ApplicationLoadBalancerResponseEvent response = new ApplicationLoadBalancerResponseEvent();

        response.setBody("Hello from Config Service");
        response.setStatusCode(200);
        response.setStatusDescription("200 OK");
        response.setIsBase64Encoded(false);

        return response;
    }
}
