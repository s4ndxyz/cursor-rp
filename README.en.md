# cursor-rp

[简体中文](README.md) | [Русский](README.ru.md) | [Français](README.fr.md) | [Español](README.es.md) | [العربية](README.ar.md)

## Introduction
Local reverse proxy tool. The concise introduction is intentional.

## Installation
1. Visit https://github.com/[NAME]/cursor-rp/releases to download dbwriter, modifier, and ccursor
2. Rename them to standard names and place them in the same directory

## Configuration and Usage

### 1. Account Management (dbwriter)
dbwriter is an account management tool for quickly switching Cursor account information. It supports direct application, account pool management, and other modes.

#### Basic Usage
```bash
# Direct application (without saving)
dbwriter apply -a <TOKEN> -m pro -s google
dbwriter apply -a <ACCESS_TOKEN> -r <REFRESH_TOKEN> -e user@example.com -m pro_plus -s auth0

# Save account to pool
dbwriter save -a <TOKEN> -e user@example.com -m pro -s google
dbwriter save -a <TOKEN> -e user@example.com -m free_trial -s github --apply  # Save and apply immediately

# Switch account from pool
dbwriter use -e user@example.com              # Select by email
dbwriter use -m pro                           # Select Pro account (first one if multiple)
dbwriter use --interactive                    # Interactive selection

# View account pool
dbwriter list                                 # List all accounts
dbwriter list -m pro                          # List specific membership type
dbwriter list --verbose                       # Show detailed info (including token preview)

# Manage account pool
dbwriter manage remove user@example.com       # Remove account
dbwriter manage disable user@example.com      # Disable account (soft delete)
dbwriter manage stats                         # Show statistics
```

#### Command Parameters

**Global Parameters**
| Parameter | Description | Default |
|-----------|-------------|---------|
| `--pool-db` | Account pool database path | `./accounts.db` |

**Subcommand: apply (direct application)**
| Parameter | Short | Description | Required |
|-----------|-------|-------------|----------|
| `--access-token` | `-a` | Access Token | ✅ |
| `--refresh-token` | `-r` | Refresh Token (defaults to same as access) | ❌ |
| `--email` | `-e` | Account email | ❌ |
| `--membership` | `-m` | Membership type | ✅ |
| `--signup-type` | `-s` | Registration method | ✅ |

**Subcommand: save (save to account pool)**
| Parameter | Short | Description | Required |
|-----------|-------|-------------|----------|
| `--access-token` | `-a` | Access Token | ✅ |
| `--refresh-token` | `-r` | Refresh Token | ❌ |
| `--email` | `-e` | Account email (recommended) | ❌ |
| `--membership` | `-m` | Membership type | ✅ |
| `--signup-type` | `-s` | Registration method | ✅ |
| `--apply` |  | Apply immediately after saving | ❌ |

**Subcommand: use (use from account pool)**
| Parameter | Short | Description | Mutually Exclusive |
|-----------|-------|-------------|-------------------|
| `--email` | `-e` | Select by email | With `-m` |
| `--membership` | `-m` | Select by membership type | With `-e` |
| `--interactive` | `-i` | Interactive selection | ❌ |

**Supported Type Values**
- **Membership types**: `free`, `pro`, `pro_plus`, `enterprise`, `free_trial`, `ultra`
- **Registration methods**: `unknown`, `auth0`, `google`, `github`

#### Usage Scenarios
1. **Temporary switching**: Use `apply` command to directly apply an account without saving locally
2. **Account collection**: Use `save` command to build an account pool for easy management of multiple accounts
3. **Quick switching**: Use `use` command to quickly switch between saved accounts
4. **Batch management**: Manage all account information through the account pool

#### Notes
- Token supports two modes: identical access/refresh tokens, or different tokens
- Account pool database is saved in `./accounts.db` by default, can be specified via `--pool-db`
- It's recommended to set an email for each account for easier identification and management
- When using `--verbose` to view detailed information, only the first 20 characters of tokens are displayed

### 2. Patching Cursor (modifier)
Close Cursor, apply patch (needs to be re-run after each update):
```bash
# Basic usage (auto-detect Cursor path)
/path/to/modifier --port 3000 --suffix .local

# Specify Cursor path
/path/to/modifier --cursor-path /path/to/cursor --port 3000 --suffix .local

# HTTPS configuration
/path/to/modifier --scheme https --port 443 --suffix .example.com

# Skip hosts detection (manage hosts manually)
/path/to/modifier --port 3000 --suffix .local --skip-hosts

# Save command for reuse
/path/to/modifier --port 3000 --suffix .local --save-command modifier.cmd

# Complete example
/path/to/modifier -C /path/to/cursor --scheme https -p 3000 --suffix .local --skip-hosts -s modifier.cmd --confirm --pass-token
```

### Command Parameters
| Parameter | Short | Description | Example |
|-----------|-------|-------------|---------|
| `--cursor-path` | `-C` | Cursor installation path (optional, auto-detect) | `/Applications/Cursor.app` |
| `--scheme` | | Protocol type (http/https) | `https` |
| `--port` | `-p` | Service port | `3000` |
| `--suffix` | | Domain suffix | `.local` |
| `--skip-hosts` | | Skip hosts file modification | - |
| `--save-command` | `-s` | Save command to file | `modifier.cmd` |
| `--confirm` | | Confirm changes (don't revert if identical state) | - |
| `--pass-token` | | Pass token validation (recommended) | - |
| `--debug` | | Debug mode | - |

### Platform-Specific Notes
- **Windows**: Execute directly
- **macOS**: Manual signing required due to SIP (same as direct execution if SIP is disabled)
  - Reference script: [macos.sh](macos.sh)
- **Linux**: Need to handle AppImage format
  - Reference script: [linux.sh](linux.sh)

PR contributions to improve platform adaptation scripts are welcome!

### 3. Configure Hosts
If using the `--skip-hosts` parameter, manually add these host records:
```
127.0.0.1 api2.cursor.sh.local api3.cursor.sh.local repo42.cursor.sh.local api4.cursor.sh.local us-asia.gcpp.cursor.sh.local us-eu.gcpp.cursor.sh.local us-only.gcpp.cursor.sh.local
```

### 4. Start Service
```bash
/path/to/ccursor
```

For IDE extension or plugin developers, add `--debug` parameter after starting ccursor to see detailed logs.

## Configuration Details
In `config.toml`, comment out or delete unknown parameters, **DO NOT leave them empty**.

### Basic Configuration
| Item | Description | Type | Required | Default | Supported Version |
|------|-------------|------|----------|---------|------------------|
| `check-updates` | Check updates on startup | bool | ❌ | false | 0.2.0+ |
| `github-token` | GitHub access token | string | ❌ | "" | 0.2.0+ |
| ~~`usage-statistics`~~ | ~~Model usage statistics~~ | ~~bool~~ | ❌ | true | 0.2.1-0.2.x, deprecated, future implementation in database |

### Service Configuration (`service-config`)
| Item | Description | Type | Required | Default | Supported Version |
|------|-------------|------|----------|---------|------------------|
| `tls` | TLS certificate configuration | object | ✅ | {cert_path="", key_path=""} | 0.3.0+ |
| `ip-addr` | Service listening IP address | object | ✅ | {ipv4="", ipv6=""} | 0.3.1+ |
| `port` | Service listening port | u16 | ✅ | - | All versions |
| `dns-resolver` | DNS resolver (gai/hickory) | string | ❌ | "gai" | 0.2.0+ |
| `lock-updates` | Lock updates | bool | ✅ | false | All versions |
| `fake-email` | Fake email configuration | object | ❌ | {email="", sign-up-type="unknown", enable=false} | 0.2.0+ |
| `service-addr` | Service address configuration | object | ❌ | {scheme="http", suffix="", port=0} | 0.2.0+ |
| ~~`proxy`~~ | ~~Proxy configuration~~ | ~~string~~ | ❌ | - | 0.2.0-0.2.x, deprecated, migrate to `proxies._` |

### Proxy Pool Configuration (`proxies`) - New in 0.3.0
| Item | Description | Type | Required | Default |
|------|-------------|------|----------|---------|
| `key_name` | Configuration identifier, corresponds to `overrides.key_name` | string | ❌ | - |
| `_` | Default proxy configuration | string | ❌ | "" |

### Mapping Configuration (`override-mapping`) - New in 0.3.0
| Item | Description | Type | Required | Default |
|------|-------------|------|----------|---------|
| `Bearer Token prefix` | Maps to configuration name | string | ❌ | - |
| `_` | Default mapping | string | ❌ | - |

### Override Configuration (`overrides.config_name`)
| Item | Description | Type | Required | Default | Supported Version |
|------|-------------|------|----------|---------|------------------|
| `token` | JWT authentication token | string | ❌ | - | All versions |
| `traceparent` | Preserve trace identifier | bool | ❌ | false | 0.2.0+ |
| `client-key` | Client key hash | string | ❌ | - | 0.2.0+ |
| `checksum` | Combined hash checksum | object | ❌ | - | 0.2.0+ |
| `client-version` | Client version number | string | ❌ | - | 0.2.0+ |
| `config-version` | Configuration version (UUID) | string | ❌ | - | 0.3.0+ |
| `timezone` | IANA timezone identifier | string | ❌ | - | All versions |
| `privacy-mode` | Privacy mode settings | bool | ❌ | true | 0.3.0+ |
| `session-id` | Session unique identifier (UUID) | string | ❌ | - | 0.2.0+ |

### Version Migration Notes
#### 0.2.x → 0.3.0
- **Major Changes**:
  - Removed `current-override`, replaced with dynamic Bearer Token mapping
  - Migrated `service-config.proxy` to `proxies._`
  - Added new `proxies` and `override-mapping` configuration sections
  - Renamed `ghost-mode` to `privacy-mode` with enhanced functionality
  - Added new `config-version` field
  - Added `tls` configuration for HTTPS support

- **Configuration Relationships**:
  1. Client sends Bearer Token (e.g., `sk-test123`)
  2. `override-mapping` looks up configuration name (e.g., `sk-test` → `example`)
  3. Uses proxy settings from `proxies.example`
  4. Uses override configurations from `overrides.example`

**Special Notes**:
- Empty string `""` means no proxy
- `_` key is used as default/fallback configuration
- Recommend commenting out optional configuration items to avoid potential issues
- The configuration file will always be updated when ccursor is closed. If you need to modify the configuration file, please choose GET /internal/ConfigUpdate or close then update

## Internal Interfaces

### ConfigUpdate
**Function**: Trigger service reload after configuration file update
**Limitation**: Cannot be triggered via domain access, needs external access with custom reverse proxy

---

*Disclaimer included in EULA. Project may terminate maintenance at any time.*

Feel free!