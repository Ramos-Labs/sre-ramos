# sre-ramos
이 저장소는 로컬 환경에서 SRE 관련 테스트를 빠르게 수행할 수 있도록 Docker 기반으로 구성된 예제들을 제공합니다.

## 폴더별 주제
- `grafana-dashboard/` : Grafana Dashboard 테스트 환경

각 폴더는 독립적으로 실행할 수 있으며, 필요한 Docker 환경이 포함되어 있습니다.  
**주의⚠️ : 주제는 라모스 맘대로 추가될 예정**

---

## 빠른 시작

1. **Docker 설치**
	- [Docker 공식 사이트](https://www.docker.com/)에서 Docker Desktop을 설치하세요.

2. **레포지토리 클론**
	```bash
	git clone https://github.com/Ramos-Labs/sre-ramos.git
	cd sre-ramos
	```

3. **테스트 환경 실행**
	- 예시: Grafana Dashboard 테스트 환경 실행
	  ```bash
	  cd grafana-dashboard
	  docker-compose up -d
	  ```
	- 예시: Metric Collector 테스트 환경 실행
	  ```bash
	  cd metric-collector
	  docker-compose up -d
	  ```

4. **접속 및 확인**
	- Grafana: http://localhost:3000
	- Metric Collector: 환경에 따라 다름 (README 참고)

---

## 폴더 구조 예시

```
sre-ramos/
├── grafana-dashboard/
│   ├── docker-compose.yml
│   └── ...
├── (추가되는 예제프로젝트)/
│   ├── docker-compose.yml
│   └── ...
└── README.md
```

---

## 참고

- 각 폴더의 README.md에서 상세 사용법과 환경 설명을 확인하세요.