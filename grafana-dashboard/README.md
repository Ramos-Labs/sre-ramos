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

## 0) 시작 전 체크
1. Grafana : `http://localhost:3000` (admin / admin)
2. DataSource 체크 : Prometheus가 default로 잡혀있어야 함. 없을 경우, connection 추가

<img width="1917" height="755" alt="Image" src="https://github.com/user-attachments/assets/a6937d66-1e00-4348-9af1-68f0ed5cc69e" />

`http://prometheus:9090` 입력

## 1) 대시보드 & 변수 만들기 (Templating)
1. Dashboards → New → New Dashboard → Add visualization
2. 앞서 default datasource로 추가한 prometheus 선택
3. panel 추가 시 아래와 같이 진행

<img width="1911" height="931" alt="Image" src="https://github.com/user-attachments/assets/569d1905-9d39-4a5b-ad52-7348124a61f8" />

- prom query : `count by (instance) (up)`

## 2) 패널#1 — CPU 사용률(노드 기준)
- Title : Node CPU Usage (%)
- Unit : Percent (0-100)
- Thresholds : 85%, 70%

<img width="1605" height="772" alt="Image" src="https://github.com/user-attachments/assets/2416e417-b8f2-46a6-8b3c-d23267ec51c4" />

```promql
(
  100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
)
* on (instance) group_left(nodename)
node_uname_info{job="node"}
```

## 3) 패널#2 — 컨테이너 CPU 사용률 Top N
- Title : Top 10 Container CPU Usage (%)
- Unit : Percent (0-100)
- Panel Type : Table 또는 Bar Chart
- Display : Top 10 containers

```promql
topk(10, 
  rate(container_cpu_usage_seconds_total{name!=""}[5m]) * 100
)
```

**설명**: `topk()` 함수로 CPU 사용률이 높은 상위 10개 컨테이너를 표시합니다.

## 4) 패널#3 — 메모리 사용량(노드)
- Title : Node Memory Usage (%)
- Unit : Percent (0-100)
- Thresholds : 90%, 80%

```promql
(
  (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes
) * 100
```

**옵션 쿼리** (더 상세한 메모리 정보):
```promql
100 - (
  (node_memory_MemAvailable_bytes * 100) / node_memory_MemTotal_bytes
)
```

## 5) 패널#4 — 컨테이너 재시작 감지(이벤트성 막대)
- Title : Container Restarts (Last 24h)
- Panel Type : Bar Chart 또는 State Timeline
- Time Range : Last 24 hours

```promql
increase(container_start_time_seconds{name!=""}[24h])
```

**대안 쿼리** (재시작 횟수 카운트):
```promql
changes(container_start_time_seconds{name!=""}[24h])
```

## 6) 패널#5 — 네트워크 I/O (노드)
- Title : Node Network I/O (bytes/sec)
- Unit : bytes/sec
- Panel Type : Time series (2개 시리즈: Receive, Transmit)

**수신 트래픽**:
```promql
rate(node_network_receive_bytes_total{device!="lo"}[5m])
```

**송신 트래픽**:
```promql
rate(node_network_transmit_bytes_total{device!="lo"}[5m])
```

## 7) 패널#6 — 디스크 사용률(노드)
- Title : Node Disk Usage (%)
- Unit : Percent (0-100)
- Thresholds : 90%, 80%

```promql
(
  (node_filesystem_size_bytes{fstype!="tmpfs"} - node_filesystem_avail_bytes{fstype!="tmpfs"}) / 
  node_filesystem_size_bytes{fstype!="tmpfs"}
) * 100
```

## 8) 패널#7 — 스프링부트 메트릭(옵션)
### JVM 메모리 사용률
- Title : JVM Memory Usage (MB)
- Unit : bytes

```promql
jvm_memory_used_bytes{area="heap"}
```

### JVM GC 횟수
- Title : JVM GC Collections/sec
- Unit : ops

```promql
rate(jvm_gc_pause_seconds_count[5m])
```

### HTTP 요청 비율
- Title : HTTP Requests/sec
- Unit : reqps

```promql
rate(http_server_requests_seconds_count[5m])
```

## 9) 탐색(Explore) & 변환(Transform) & Override

### Explore 기능 활용
1. **좌측 메뉴에서 Explore 클릭**
2. **쿼리 테스트**: 패널에 추가하기 전에 쿼리 결과 미리 확인
3. **시간 범위 조정**: 다양한 시간 범위에서 데이터 패턴 분석
4. **로그 연동**: Prometheus와 함께 로그 데이터 상관 분석

### Transform 기능
1. **Series to rows**: 시계열 데이터를 테이블 형태로 변환
2. **Reduce**: 평균, 최대값, 최소값 등 집계 함수 적용
3. **Filter by name**: 특정 메트릭만 필터링
4. **Rename by regex**: 범례 이름 정규식으로 변경

### Field Override
1. **Unit 설정**: 각 필드별로 다른 단위 적용
2. **Color scheme**: 값에 따른 색상 변경
3. **Thresholds**: 경고/위험 임계값 설정
4. **Display name**: 범례 이름 커스터마이징

## 10) 대시보드 알림(Alerts) 맛보기

### Alert Rule 생성
1. **패널 편집 → Alert 탭**
2. **Conditions 설정**:
   ```
   Query: A
   Function: last()
   Evaluator: is above 85
   ```
3. **Notification channels**: 이메일, Slack 등 설정

### 예시: CPU 사용률 알림
```yaml
Alert Name: High CPU Usage
Message: CPU usage is above 85% for {{ $labels.instance }}
Frequency: 10s
Conditions: 
  - Query A: CPU 사용률 쿼리
  - IS ABOVE: 85
```

## 11) 저장/공유/버전 관리 팁

### 대시보드 저장
1. **저장 버튼** 클릭
2. **Dashboard name & folder** 설정
3. **Tags 추가**: 검색 및 분류를 위한 태그

### 공유 옵션
1. **Share → Link**: URL 공유 (시간 범위 포함 가능)
2. **Share → Embed**: iframe으로 외부 사이트 임베드
3. **Share → Export**: JSON 형태로 대시보드 내보내기

### 버전 관리
1. **Dashboard settings → Versions**: 변경 이력 확인
2. **Save dashboard**: 변경사항 저장 시 코멘트 추가
3. **Compare versions**: 버전 간 차이점 비교
4. **Restore**: 이전 버전으로 복원

### 대시보드 관리 Best Practices
- **폴더 구조**: 환경별/팀별로 폴더 분류
- **태그 활용**: 용도별 태그 체계 구축
- **JSON 백업**: 정기적으로 대시보드 JSON 백업
- **템플릿 변수**: 재사용 가능한 대시보드 구성