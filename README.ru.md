# cursor-rp

[简体中文](README.md) | [English](README.en.md) | [Français](README.fr.md) | [Español](README.es.md) | [العربية](README.ar.md)

## Введение
Локальный обратный прокси. Введение краткое, намеренно.

## Установка
Скачайте modifier и ccursor с https://github.com/wisdgod/cursor-rp/releases, переименуйте их в стандартные имена и поместите в одну директорию.

## Конфигурация и использование
Возьмем 2999 и .local в качестве примера:

1. Откройте Cursor, используйте команду >Open User Settings в Cursor и скопируйте путь.
2. Закройте Cursor, примените патч (запустите один раз после каждого обновления, запустите снова для восстановления):
   ```
   modifier --cursor-path /path/to/cursor --port 2999 --suffix .local local
   ```

3. Возможно, он неправильно изменит hosts, поэтому вам может потребоваться вручную обновить его, добавив следующее:
   ```
   127.0.0.1 api2.cursor.sh.local
   127.0.0.1 api3.cursor.sh.local
   127.0.0.1 repo42.cursor.sh.local
   127.0.0.1 api4.cursor.sh.local
   127.0.0.1 us-asia.gcpp.cursor.sh.local
   127.0.0.1 us-eu.gcpp.cursor.sh.local
   127.0.0.1 us-only.gcpp.cursor.sh.local
   ```

4. Запустите сервис:
   ```
   ccursor /path/to/settings.json
   ```

## Важные конфигурации
Добавьте следующие пункты в settings.json:
- `ccursor.port`: Требуется 16-битное беззнаковое целое число
- `ccursor.lockUpdates`: Блокировать ли обновления
- `ccursor.domainSuffix`: Упомянутый выше .local
- `ccursor.timezone`: Идентификатор часового пояса вашего IP-местоположения (стандарт IANA)

## Механизм обновления
При любых изменениях используйте HTTP GET запросы к следующим путям:
- `/internal/TokenUpdate`
- `/internal/ChecksumUpdate`
- `/internal/ConfigUpdate`

---

Удалите репозиторий и убегайте в любое время. Отказ от ответственности прилагается в eula. Обновления не будут частыми.

Feel free!