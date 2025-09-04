# cursor-rp

[English](README.en.md) | [Русский](README.ru.md) | [Français](README.fr.md) | [Español](README.es.md) | [العربية](README.ar.md)

## 简介
本地反向代理工具。简洁的介绍是刻意为之。

## 安装
1. 访问 https://github.com/wisdgod/cursor-rp/releases 下载 modifier 和 ccursor
2. 将文件重命名为标准名称并放置在同一目录下

## 配置与使用

### 1. 修补 Cursor
1. 打开 Cursor，执行命令 `Open User Settings` 并记录设置文件路径
2. 关闭 Cursor，执行修补（每次更新后需重新执行）：
   ```bash
   # 基本用法（自动检测Cursor路径）
   /path/to/modifier --port 3000 --suffix .local
 
   # 指定Cursor路径
   /path/to/modifier --cursor-path /path/to/cursor --port 3000 --suffix .local
 
   # HTTPS配置
   /path/to/modifier --scheme https --port 443 --suffix .example.com
 
   # 跳过hosts检测（手动管理hosts）
   /path/to/modifier --port 3000 --suffix .local --skip-hosts
 
   # 保存命令以便复用
   /path/to/modifier --port 3000 --suffix .local --save-command modifier.cmd
   ```

### 命令参数说明
| 参数 | 简写 | 说明 | 示例 |
|------|------|------|------|
| `--cursor-path` | `-C` | Cursor安装路径（可选，自动检测） | `/Applications/Cursor.app` |
| `--scheme` | | 协议类型（http/https） | `https` |
| `--port` | `-p` | 服务端口 | `3000` |
| `--suffix` | | 域名后缀 | `.local` |
| `--skip-hosts` | | 跳过hosts文件修改 | - |
| `--save-command` | `-s` | 保存命令到文件 | `modifier.cmd` |
| `--confirm` | | 确认修改（相同状态不恢复） | - |
| `--debug` | | 调试模式 | - |

### 平台特别注意事项
- **Windows**：直接执行即可
- **macOS**：由于 SIP 机制需要手动签名（关闭 SIP 后可直接执行）
  - 参考脚本：[macos.sh](macos.sh)
- **Linux**：需处理 AppImage 打包格式
  - 参考脚本：[linux.sh](linux.sh)

欢迎提交 PR 改进平台适配脚本！

### 2. 配置 Hosts
若使用 `--skip-hosts` 参数，需手动添加以下 hosts 记录：
```
127.0.0.1 api2.cursor.sh.local api3.cursor.sh.local repo42.cursor.sh.local api4.cursor.sh.local us-asia.gcpp.cursor.sh.local us-eu.gcpp.cursor.sh.local us-only.gcpp.cursor.sh.local
```

### 3. 启动服务
```bash
/path/to/ccursor
```

## 配置说明
配置文件 `config.toml` 中的不明参数请注释或删除，**切勿留空**。

### 基础配置项
| 配置项 | 说明 | 类型 | 必需 | 默认值 | 支持版本 |
|--------|------|------|------|--------|----------|
| `check-updates` | 启动时检查更新 | bool | ❌ | false | 0.2.0+ |
| `github-token` | GitHub访问令牌 | string | ❌ | "" | 0.2.0+ |
| ~~`usage-statistics`~~ | ~~模型使用统计~~ | ~~bool~~ | ❌ | true | 0.2.1-0.2.x，已废弃，未来在数据库实现 |

### 服务配置(`service-config`)
| 配置项 | 说明 | 类型 | 必需 | 默认值 | 支持版本 |
|--------|------|------|------|--------|----------|
| `tls` | TLS证书配置 | object | ❌ | {cert_path="", key_path=""} | 0.3.0+ |
| `port` | 服务监听端口 | u16 | ✅ | - | 所有版本 |
| `dns-resolver` | DNS解析器(gai/hickory) | string | ❌ | "gai" | 0.2.0+ |
| `lock-updates` | 锁定更新 | bool | ✅ | false | 所有版本 |
| `fake-email` | 虚假电子邮件配置 | object | ❌ | {email="", sign-up-type="unknown", enable=false} | 0.2.0+ |
| `service-addr` | 服务地址配置 | object | ❌ | {scheme="http", suffix="", port=0} | 0.2.0+ |
| ~~`proxy`~~ | ~~代理配置~~ | ~~string~~ | ❌ | - | 0.2.0-0.2.x，已废弃，请迁移到`proxies._` |

### 代理池配置(`proxies`) - 0.3.0新增
| 配置项 | 说明 | 类型 | 必需 | 默认值 |
|--------|------|------|------|--------|
| `键名` | 配置标识符，与`overrides.键名`对应 | string | ❌ | - |
| `_` | 默认代理配置 | string | ❌ | "" |

### 映射配置(`override-mapping`) - 0.3.0新增
| 配置项 | 说明 | 类型 | 必需 | 默认值 |
|--------|------|------|------|--------|
| `Bearer Token前缀` | 映射到配置名称 | string | ❌ | - |
| `_` | 默认映射 | string | ❌ | - |

### 覆盖配置(`overrides.配置名`)
| 配置项 | 说明 | 类型 | 必需 | 默认值 | 支持版本 |
|--------|------|------|------|--------|----------|
| `token` | JWT认证令牌 | string | ❌ | - | 所有版本 |
| `traceparent` | 保留追踪标识 | bool | ❌ | false | 0.2.0+ |
| `client-key` | 客户端密钥哈希 | string | ❌ | - | 0.2.0+ |
| `checksum` | 组合哈希校验值 | object | ❌ | - | 0.2.0+ |
| `client-version` | 客户端版本号 | string | ❌ | - | 0.2.0+ |
| `config-version` | 配置版本(UUID) | string | ❌ | - | 0.3.0+ |
| `timezone` | IANA时区标识 | string | ❌ | - | 所有版本 |
| `privacy-mode` | 隐私模式设置 | bool | ❌ | true | 0.3.0+ |
| `session-id` | 会话唯一标识符(UUID) | string | ❌ | - | 0.2.0+ |

### 版本迁移说明
#### 0.2.x → 0.3.0
- **重大变更**：
  - 移除 `current-override`，改为动态Bearer Token映射
  - `service-config.proxy` 迁移到 `proxies._`
  - 新增 `proxies` 和 `override-mapping` 配置节
  - `ghost-mode` 重命名为 `privacy-mode`，并增强其功能
  - 新增 `config-version` 字段
  - 新增 `tls` 配置支持HTTPS

- **配置关系**：
  1. 客户端发送Bearer Token (如 `sk-test123`)
  2. 通过 `override-mapping` 查找配置名 (如 `sk-test` → `example`)
  3. 使用 `proxies.example` 的代理设置
  4. 使用 `overrides.example` 的覆盖配置

**特殊说明**：
- 空字符串 `""` 表示不使用代理
- `_` 键用作默认/回退配置
- 建议注释掉可选配置项，避免潜在问题

## 内部接口

### ConfigUpdate
**功能**：配置文件更新后触发服务重载

---

*免责声明包含在 EULA 中。项目可能随时终止维护。*

Feel free!