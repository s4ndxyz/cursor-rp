# cursor-rp

[English](README.en.md) | [Русский](README.ru.md) | [Français](README.fr.md) | [Español](README.es.md) | [العربية](README.ar.md)

## 简介
本地反向代理工具。简洁的介绍是刻意为之。

## 安装
1. 访问 https://github.com/wisdgod/cursor-rp/releases 下载 modifier 和 ccursor
2. 将文件重命名为标准名称并放置在同一目录下

## 配置与使用
以端口 3000 和域名后缀 .local 为例：

### 1. 修补 Cursor
1. 打开 Cursor，执行命令 `Open User Settings` 并记录设置文件路径
2. 关闭 Cursor，执行修补（每次更新后需重新执行）：
   ```bash
   /path/to/modifier --cursor-path /path/to/cursor --port 3000 --suffix .local local
   ```

**特别注意**：
- Windows 用户：没有需要特别注意的
- macOS 用户：由于 SIP 机制需要手动签名（若已关闭 SIP 则与 Windows 操作相同）
- Linux 用户：需处理 AppImage 打包格式
- 参考脚本：[macos.sh](macos.sh) | [linux.sh](linux.sh)（欢迎提交 PR 改进）

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

从 0.1.x 版本迁移时，可通过以下命令生成配置模板：
```bash
/path/to/ccursor /path/to/settings.json
```

### 基础配置项
| 配置项 | 说明 | 类型 | 必需 | 默认值 | 支持版本 |
|--------|------|------|------|--------|----------|
| `check-updates` | 启动时检查更新 | bool | ❌ | false | 0.2.0+ |
| `github-token` | GitHub访问令牌 | string | ❌ | "" | 0.2.0+ |
| `usage-statistics` | 模型使用统计 | bool | ❌ | true | 0.2.1+ |
| `current-override` | 当前生效的覆盖配置标识 | string | ✅ | - | 0.2.0+ |

### 服务配置(`service-config`)
| 配置项 | 说明 | 类型 | 必需 | 默认值 | 支持版本 |
|--------|------|------|------|--------|----------|
| `port` | 服务监听端口 | u16 | ✅ | - | 所有版本 |
| `lock-updates` | 锁定更新 | bool | ✅ | false | 所有版本 |
| `domain-suffix` | 域名后缀 | string | ✅ | - | 所有版本 |
| `proxy` | 代理服务器配置 | string | ❌ | "" | 0.2.0+ |
| `dns-resolver` | DNS解析器(gai/hickory) | string | ❌ | "gai" | 0.2.0+ |
| `fake-email` | 虚假电子邮件配置 | object | ❌ | {email="",sign-up-type="unknown",enable=false} | 0.2.0+ |
| `service-addr` | 服务地址配置 | object | ❌ | {mode="local",suffix=".example.com",port=8080} | 0.2.0+ |

### 覆盖配置(`overrides`)
| 配置项 | 说明 | 类型 | 必需 | 默认值 | 支持版本 |
|--------|------|------|------|--------|----------|
| `token` | JWT认证令牌 | string | ❌ | - | 所有版本 |
| `traceparent` | 保留追踪标识 | bool | ❌ | false | 0.2.0+ |
| `client-key` | 客户端密钥哈希 | string | ❌ | - | 0.2.0+ |
| `checksum` | 组合哈希校验值 | string | ❌ | - | 0.2.0+ |
| `client-version` | 客户端版本号 | string | ❌ | - | 0.2.0+ |
| `timezone` | IANA时区标识 | string | ❌ | - | 所有版本 |
| `ghost-mode` | 隐私模式设置 | bool | ❌ | true | 0.2.0+ |
| `session-id` | 会话唯一标识符 | string | ❌ | - | 0.2.0+ |

**特殊说明**：
- 标记为“0.2.0+”的配置项在0.1.x中未出现，但标记为“所有版本”的配置也不一定完全等效
- 建议保留默认值的配置项可注释或删除，避免潜在问题

## 内部接口
`/internal/` 路径下的接口由 internal 目录文件控制（文件不存在时返回 index.html），除非使用以下特定接口：

### 1. TokenUpdate
**功能**：运行时更新 current-override 配置项
**参数**：
| 参数名 | 必需 | 说明 |
|--------|------|------|
| key | ✅ | 覆盖配置标识 |

**示例**：
```bash
curl http://127.0.0.1:3000/internal/TokenUpdate?key=${KEY_NAME}
```

### 2. TokenAdd
**功能**：获取授权URL和等待时间
**返回**：`["url",100]`，其中url为授权链接，100为等待秒数

**参数**：
| 参数名 | 必需 | 说明 |
|--------|------|------|
| timezone | ✅ | IANA时区标识（如"Asia/Shanghai"或"America/Los_Angeles"） |
| wait | ❌ | 等待秒数，默认100 |
| client_version | ❌ | 客户端版本号，默认0.49.6 |

**示例**：
```bash
# 基本用法
curl http://127.0.0.1:3000/internal/TokenAdd?timezone=Asia%2FShanghai

# 自定义等待时间
curl http://127.0.0.1:3000/internal/TokenAdd?timezone=Asia%2FShanghai&wait=50
```

### 3. ConfigUpdate
**功能**：配置文件更新后触发服务重载

### 4. GetUsage
**功能**：获取模型使用统计数据

---

*免责声明包含在 EULA 中。项目可能随时终止维护。*

Feel free!