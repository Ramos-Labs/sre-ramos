# Grafana Dashboard Hand's on
Hand's on : UI에서 직접 대시보드와 패널 만들어보며 익히기

- 참고 : [Grafana Documentation](https://grafana.com/docs/grafana/latest/?utm_source=grafana_gettingstarted)

## 사전 준비
```bash
docker-compose up -d
```

- 초기 사용자 계정 정보 : `admin` / `admin`
  - Password 변경 페이지가 나타나지만, 로컬 환경에서 테스트 목적 사용시 하단의 Skip 버튼으로 넘어가도 무방함.

Prometheus Targets: `http://localhost:9090/targets`에서 cadvisor, node-exporter, prometheus UP 확인

<img width="1912" height="841" alt="Image" src="https://github.com/user-attachments/assets/a4d82e06-e735-4752-ab1f-0f40e40398c0" />