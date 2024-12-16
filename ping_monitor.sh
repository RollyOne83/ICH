#!/bin/sh
echo "Введите адрес для пинга:"
read HOST
FAILED_COUNT=0
while true; do
PING_OUTPUT=$(ping -c 1 -W 1 "$HOST" 2>/dev/null)
PING_STATUS=$?
if [ $PING_STATUS -ne 0 ]; then
FAILED_COUNT=$((FAILED_COUNT + 1))
echo "Не удалось пинговать $HOST. Неудачных попыток: $FAILED_COUNT из 3."
else
PING_TIME=$(echo "$PING_OUTPUT" | grep -o "time=[0-9.]*" | cut -d= -f2)
if [ "$(echo "$PING_TIME > 100" | bc)" -eq 1 ]; then
echo "Время пинга $PING_TIME мс превышает 100 мс."
else
echo "Пинг $HOST успешен. Время: $PING_TIME мс."
fi
FAILED_COUNT=0
fi
if [ $FAILED_COUNT -ge 3 ]; then
echo "Не удалось выполнить пинг $HOST 3 раза подряд. Скрипт завершен."
break
fi
sleep 1
done