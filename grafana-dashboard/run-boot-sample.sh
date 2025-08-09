
#!/bin/bash
# boot-sample(Spring Boot, Kotlin, Gradle 기반) 앱 빌드 및 실행/종료 함수 제공 스크립트


# 절대경로로 변환
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$SCRIPT_DIR/../boot-sample"
JAR_PATH="$APP_DIR/build/libs/boot-sample.jar"
LOG_PATH="$APP_DIR/boot-sample.log"
PID_PATH="$APP_DIR/boot-sample.pid"

function start_app() {
		cd "$APP_DIR" || exit 1
		./gradlew clean build
		# 로그/PID 파일 생성 보장
		touch "$LOG_PATH" "$PID_PATH"
		nohup java -jar "$JAR_PATH" > "$LOG_PATH" 2>&1 &
		echo $! > "$PID_PATH"
		sleep 1
		PID=$(cat "$PID_PATH")
		if ps -p "$PID" > /dev/null 2>&1; then
			echo "boot-sample 앱이 백그라운드에서 실행 중입니다. (PID: $PID, 로그: $LOG_PATH)"
		else
			echo "앱 실행에 실패했습니다. 로그를 확인하세요: $LOG_PATH"
		fi
}

function stop_app() {
	if [ -f "$PID_PATH" ]; then
		PID=$(cat "$PID_PATH")
		if [ -n "$PID" ] && ps -p "$PID" > /dev/null 2>&1; then
			kill "$PID" && rm -f "$PID_PATH"
			echo "boot-sample 앱이 종료되었습니다. (PID: $PID)"
		else
			echo "실행 중인 boot-sample 앱이 없습니다. (PID 파일만 존재)"
			rm -f "$PID_PATH"
		fi
	else
		echo "실행 중인 boot-sample 앱이 없습니다."
	fi
}

case "$1" in
	start)
		start_app
		;;
	stop)
		stop_app
		;;
	*)
		echo "사용법: $0 {start|stop}"
		;;
esac
