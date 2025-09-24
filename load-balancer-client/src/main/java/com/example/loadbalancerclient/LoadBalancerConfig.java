package com.example.loadbalancerclient;

import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.loadbalancer.annotation.LoadBalancerClient;
import org.springframework.cloud.loadbalancer.core.RandomLoadBalancer;
import org.springframework.cloud.loadbalancer.core.ReactorLoadBalancer;
import org.springframework.cloud.loadbalancer.core.RoundRobinLoadBalancer;
import org.springframework.cloud.loadbalancer.core.ServiceInstanceListSupplier;
import org.springframework.cloud.loadbalancer.support.LoadBalancerClientFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;

@Configuration
@LoadBalancerClient(name = "user-service")
public class LoadBalancerConfig {

    @Bean
    public ReactorLoadBalancer<ServiceInstance> reactorLoadBalancer(Environment environment, LoadBalancerClientFactory loadBalancerClientFactory) {
        String name = "user-service";
        // You can choose between different load balancing strategies:
        // RoundRobinLoadBalancer - Default round-robin
        // RandomLoadBalancer - Random selection
        return new RoundRobinLoadBalancer(loadBalancerClientFactory.getLazyProvider(name, ServiceInstanceListSupplier.class), name);
    }
}

