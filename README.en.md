# cursor-rp

[简体中文](README.md) | [Русский](README.ru.md) | [Français](README.fr.md) | [Español](README.es.md) | [العربية](README.ar.md)

## Introduction
Local reverse proxy. The introduction is concise, intentionally.

## Installation
Download modifier and ccursor from https://github.com/wisdgod/cursor-rp/releases, rename them to standard names and place them in the same directory.

## Configuration and Usage
Taking 2999 and .local as examples:

1. Open Cursor, use the command >Open User Settings in Cursor and copy the path.
2. Close Cursor, Patch it (every time after update):
   ```
   modifier --cursor-path /path/to/cursor --port 2999 --suffix .local local
   ```

3. It might incorrectly modify hosts, so you may need to manually update it by adding the following:
   ```
   127.0.0.1 api2.cursor.sh.local
   127.0.0.1 api3.cursor.sh.local
   127.0.0.1 repo42.cursor.sh.local
   127.0.0.1 api4.cursor.sh.local
   127.0.0.1 us-asia.gcpp.cursor.sh.local
   127.0.0.1 us-eu.gcpp.cursor.sh.local
   127.0.0.1 us-only.gcpp.cursor.sh.local
   ```

4. Run Service:
   ```
   ccursor /path/to/settings.json
   ```

## Important Configurations
Add the following items in settings.json:
- `ccursor.port`: This requires a 16-bit unsigned integer
- `ccursor.lockUpdates`: Whether to lock updates
- `ccursor.domainSuffix`: The .local mentioned above
- `ccursor.timezone`: The timezone identifier of your IP location (IANA standard)

## Update Mechanism
When there are any changes, use HTTP GET requests to the following paths:
- `/internal/TokenUpdate`
- `/internal/ChecksumUpdate`
- `/internal/ConfigUpdate`

---

Delete the repository and run away at any time. Disclaimer attached in the eula. Updates will not be frequent.

Feel free!