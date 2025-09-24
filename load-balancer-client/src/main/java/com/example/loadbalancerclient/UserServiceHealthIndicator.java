package com.example.loadbalancerclient;

import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class UserServiceHealthIndicator implements HealthIndicator {

    private final DiscoveryClient discoveryClient;

    public UserServiceHealthIndicator(DiscoveryClient discoveryClient) {
        this.discoveryClient = discoveryClient;
    }

    @Override
    public Health health() {
        List<ServiceInstance> instances = discoveryClient.getInstances("user-service");

        if (instances.isEmpty()) {
            return Health.down()
                    .withDetail("user-service", "No instances available")
                    .build();
        }

        return Health.up()
                .withDetail("user-service", instances.size() + " instances available")
                .withDetail("instances", instances.stream()
                        .map(ServiceInstance::getUri)
                        .collect(Collectors.toList()))
                .build();
    }
}