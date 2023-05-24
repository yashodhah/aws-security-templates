package com.example.aws.security.templates.orderservice.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("order")
public class OrderController {

    @GetMapping
    public ResponseEntity sayHello() {
        return ResponseEntity.ok().body("Hello from order service");
    }
}
