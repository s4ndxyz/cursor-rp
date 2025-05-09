# cursor-rp

[简体中文](README.md) | [Русский](README.ru.md) | [Français](README.fr.md) | [Español](README.es.md) | [العربية](README.ar.md)

## Introduction
Local reverse proxy. The introduction is concise, intentionally.

## Installation
1. Download modifier and ccursor from https://github.com/wisdgod/cursor-rp/releases
2. Rename them to standard names and place them in the same directory

## Configuration and Usage
Taking port 3000 and .local as examples:

### 1. Patch Cursor
1. Open Cursor, execute command `Open User Settings` and note the settings file path
2. Close Cursor, apply patch (needs to be re-run after each update):
   ```bash
   /path/to/modifier --cursor-path /path/to/cursor --port 3000 --suffix .local local
   ```

**Special Notes**:
- Windows users: No special attention needed
- macOS users: Manual signing required due to SIP (same as Windows if SIP is disabled)
- Linux users: Need to handle AppImage format
- Reference scripts: [macos.sh](macos.sh) | [linux.sh](linux.sh) (PRs welcome)

### 2. Configure Hosts
If using `--skip-hosts` parameter, manually add these host records:
```
127.0.0.1 api2.cursor.sh.local api3.cursor.sh.local repo42.cursor.sh.local api4.cursor.sh.local us-asia.gcpp.cursor.sh.local us-eu.gcpp.cursor.sh.local us-only.gcpp.cursor.sh.local
```

### 3. Start Service
```bash
/path/to/ccursor
```

## Configuration Details
In `config.toml`, comment out or delete unknown parameters, **DO NOT leave them empty**.

When migrating from version 0.1.x, generate a config template using:
```bash
/path/to/ccursor /path/to/settings.json
```

### Basic Configuration
| Item | Description | Type | Required | Default | Supported Version |
|------|-------------|------|----------|---------|------------------|
| `check-updates` | Check updates on startup | bool | ❌ | false | 0.2.0+ |
| `github-token` | GitHub access token | string | ❌ | "" | 0.2.0+ |
| `usage-statistics` | Model usage statistics | bool | ❌ | true | 0.2.1+ |
| `current-override` | Current active override identifier | string | ✅ | - | 0.2.0+ |

### Service Configuration (`service-config`)
| Item | Description | Type | Required | Default | Supported Version |
|------|-------------|------|----------|---------|------------------|
| `port` | Service listening port | u16 | ✅ | - | All versions |
| `lock-updates` | Lock updates | bool | ✅ | false | All versions |
| `domain-suffix` | Domain suffix | string | ✅ | - | All versions |
| `proxy` | Proxy server configuration | string | ❌ | "" | 0.2.0+ |
| `dns-resolver` | DNS resolver (gai/hickory) | string | ❌ | "gai" | 0.2.0+ |
| `fake-email` | Fake email configuration | object | ❌ | {email="",sign-up-type="unknown",enable=false} | 0.2.0+ |
| `service-addr` | Service address configuration | object | ❌ | {mode="local",suffix=".example.com",port=8080} | 0.2.0+ |

### Override Configuration (`overrides`)
| Item | Description | Type | Required | Default | Supported Version |
|------|-------------|------|----------|---------|------------------|
| `token` | JWT authentication token | string | ❌ | - | All versions |
| `traceparent` | Preserve trace identifier | bool | ❌ | false | 0.2.0+ |
| `client-key` | Client key hash | string | ❌ | - | 0.2.0+ |
| `checksum` | Combined hash checksum | string | ❌ | - | 0.2.0+ |
| `client-version` | Client version number | string | ❌ | - | 0.2.0+ |
| `timezone` | IANA timezone identifier | string | ❌ | - | All versions |
| `ghost-mode` | Privacy mode settings | bool | ❌ | true | 0.2.0+ |
| `session-id` | Session unique identifier | string | ❌ | - | 0.2.0+ |

**Special Notes**:
- Items marked "0.2.0+" were not present in 0.1.x, but items marked "All versions" may not be completely equivalent
- Configuration items with default values can be commented out or deleted to avoid potential issues

## Internal Interfaces
Interfaces under `/internal/` are controlled by files in the internal directory (returns index.html when file doesn't exist), except for the following specific interfaces:

### 1. TokenUpdate
**Function**: Update current-override configuration item at runtime
**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| key | ✅ | Override configuration identifier |

**Example**:
```bash
curl http://127.0.0.1:3000/internal/TokenUpdate?key=${KEY_NAME}
```

### 2. TokenAdd
**Function**: Get authorization URL and wait time
**Return**: `["url",100]`, where url is the authorization link and 100 is the waiting time in seconds

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| timezone | ✅ | IANA timezone identifier (e.g., "Asia/Shanghai" or "America/Los_Angeles") |
| wait | ❌ | Wait time in seconds, default 100 |
| client_version | ❌ | Client version number, default 0.49.6 |

**Example**:
```bash
# Basic usage
curl http://127.0.0.1:3000/internal/TokenAdd?timezone=Asia%2FShanghai

# Custom wait time
curl http://127.0.0.1:3000/internal/TokenAdd?timezone=Asia%2FShanghai&wait=50
```

### 3. ConfigUpdate
**Function**: Trigger service reload after configuration file update

### 4. GetUsage
**Function**: Get model usage statistics

---

*Disclaimer included in EULA. Project may terminate maintenance at any time.*

Feel free!