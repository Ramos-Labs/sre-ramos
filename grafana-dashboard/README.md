# Grafana Dashboard Hand's on
Hand's on : UI에서 직접 대시보드와 패널 만들어보며 익히기

- 참고 : [Grafana Documentation](https://grafana.com/docs/grafana/latest/?utm_source=grafana_gettingstarted)

## 사전 준비
```bash
./docker-compose up -d

# boot-sample(Spring Boot, Kotlin, Gradle 기반) 앱 실행 (스크립트)
./run-boot-sample.sh start

# 종료
./run-boot-sample.sh stop
```

> 스크립트는 boot-sample 앱을 빌드 후 백그라운드로 실행하며, 로그는 `boot-sample.log` 파일에 저장됩니다.

- 초기 사용자 계정 정보 : `admin` / `admin`
  - Password 변경 페이지가 나타나지만, 로컬 환경에서 테스트 목적 사용시 하단의 Skip 버튼으로 넘어가도 무방함.

Prometheus Targets: `http://localhost:9090/targets`에서 cadvisor, node-exporter, prometheus UP 확인

<img width="1908" height="793" alt="Image" src="https://github.com/user-attachments/assets/31fdb12d-7dcc-4caf-a61b-2aebf95d7510" />


## 1) 대시보드 & 변수 만들기 (Templating)

## 2) 패널#1 — CPU 사용률(노드 기준)

## 3) 패널#2 — 컨테이너 CPU 사용률 Top N

## 4) 패널#3 — 메모리 사용량(노드)

## 5) 패널#4 — 컨테이너 재시작 감지(이벤트성 막대)

## 6) 패널#5 — 네트워크 I/O (노드)

## 7) 패널#6 — 디스크 사용률(노드)

## 8) 패널#7 — 스프링부트 메트릭(옵션)

## 9) 탐색(Explore) & 변환(Transform) & Override

## 10) 대시보드 알림(Alerts) 맛보기
## 11) 저장/공유/버전 관리 팁