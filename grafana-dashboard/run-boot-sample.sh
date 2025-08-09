#!/bin/bash
# boot-sample(Spring Boot, Kotlin, Gradle 기반) 앱 빌드 및 백그라운드 실행 스크립트

cd "$(dirname "$0")/../boot-sample" || exit 1
./gradlew clean build
nohup java -jar ./build/libs/boot-sample.jar > boot-sample.log 2>&1 &
echo "boot-sample 앱이 백그라운드에서 실행 중입니다. (로그: boot-sample.log)"
