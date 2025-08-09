package me.ramos.bootsample

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class BootSampleApplication

fun main(args: Array<String>) {
    runApplication<BootSampleApplication>(*args)
}
