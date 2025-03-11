# cursor-rp

[English](README.en.md) | [Русский](README.ru.md) | [Français](README.fr.md) | [Español](README.es.md) | [العربية](README.ar.md)

## 简介
本地反代。介绍简练，是故意的。

## 安装
在 https://github.com/wisdgod/cursor-rp/releases 下载modifier和ccursor，重命名为标准名称并放在同一目录下

## 配置与使用
以2999与.local为例：

1. 打开Cursor，在Cursor使用命令>Open User Settings并复制路径
2. 关闭Cursor，Patch it（每次更新一次）:
   ```
   modifier --cursor-path /path/to/cursor --port 2999 --suffix .local local
   ```

3. 它可能会错误地修改hosts，所以你可能要手动更新它，添加以下内容：
   ```
   127.0.0.1 api2.cursor.sh.local
   127.0.0.1 api3.cursor.sh.local
   127.0.0.1 repo42.cursor.sh.local
   127.0.0.1 api4.cursor.sh.local
   127.0.0.1 us-asia.gcpp.cursor.sh.local
   127.0.0.1 us-eu.gcpp.cursor.sh.local
   127.0.0.1 us-only.gcpp.cursor.sh.local
   ```

4. 运行服务:
   ```
   ccursor /path/to/settings.json
   ```

## 重要配置
在settings.json添加以下项：
- `ccursor.port`: 这需要16位无符号整数
- `ccursor.lockUpdates`: 是否锁定更新
- `ccursor.domainSuffix`: 上面提到的.local
- `ccursor.timezone`: 你IP所在的时区标识符（IANA标准）

## 更新机制
当任何变动时使用http协议的GET请求以下对应路径：
- `/internal/TokenUpdate`
- `/internal/ChecksumUpdate`
- `/internal/ConfigUpdate`

---

随时删库跑路。免责声明附带在eula内。更新不会很频繁。

Feel free!