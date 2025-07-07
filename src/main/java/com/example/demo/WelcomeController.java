package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class WelcomeController {
  @GetMapping("/")
  public String welcome() {
    return "multi branch github action !!!!";
  }
}
