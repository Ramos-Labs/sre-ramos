package me.ramos.bootsample.adapter.webIn

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class L7HealthController {

    @GetMapping("/l7/health")
    fun healthCheck(): String {
        return "Hello, World! I'm Ramos😁 L7 Health Check OK"
    }
}