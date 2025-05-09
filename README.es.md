# cursor-rp

[简体中文](README.md) | [English](README.en.md) | [Русский](README.ru.md) | [Français](README.fr.md) | [العربية](README.ar.md)

## Introducción
Proxy inverso local. La introducción es concisa, intencionalmente.

## Instalación
1. Descargue modifier y ccursor desde https://github.com/wisdgod/cursor-rp/releases
2. Renómbrelos a nombres estándar y colóquelos en el mismo directorio

## Configuración y uso
Tomando el puerto 3000 y .local como ejemplos:

### 1. Parchear Cursor
1. Abra Cursor, ejecute el comando `Open User Settings` y anote la ruta del archivo de configuración
2. Cierre Cursor, aplique el parche (debe volver a ejecutarse después de cada actualización):
   ```bash
   /path/to/modifier --cursor-path /path/to/cursor --port 3000 --suffix .local local
   ```

**Notas especiales**:
- Usuarios de Windows: No se requiere atención especial
- Usuarios de macOS: Se requiere firma manual debido a SIP (igual que Windows si SIP está desactivado)
- Usuarios de Linux: Necesita manejar el formato AppImage
- Scripts de referencia: [macos.sh](macos.sh) | [linux.sh](linux.sh) (PR bienvenidos)

### 2. Configurar Hosts
Si usa el parámetro `--skip-hosts`, agregue manualmente estos registros de hosts:
```
127.0.0.1 api2.cursor.sh.local api3.cursor.sh.local repo42.cursor.sh.local api4.cursor.sh.local us-asia.gcpp.cursor.sh.local us-eu.gcpp.cursor.sh.local us-only.gcpp.cursor.sh.local
```

### 3. Iniciar el servicio
```bash
/path/to/ccursor
```

## Detalles de configuración
En `config.toml`, comente o elimine los parámetros desconocidos, **NO los deje vacíos**.

Al migrar desde la versión 0.1.x, genere una plantilla de configuración usando:
```bash
/path/to/ccursor /path/to/settings.json
```

### Configuración básica
| Elemento | Descripción | Tipo | Requerido | Por defecto | Versión soportada |
|----------|-------------|------|------------|-------------|-------------------|
| `check-updates` | Verificar actualizaciones al inicio | bool | ❌ | false | 0.2.0+ |
| `github-token` | Token de acceso GitHub | string | ❌ | "" | 0.2.0+ |
| `usage-statistics` | Estadísticas de uso del modelo | bool | ❌ | true | 0.2.1+ |
| `current-override` | Identificador de anulación activo | string | ✅ | - | 0.2.0+ |

### Configuración del servicio (`service-config`)
| Elemento | Descripción | Tipo | Requerido | Por defecto | Versión soportada |
|----------|-------------|------|------------|-------------|-------------------|
| `port` | Puerto de escucha del servicio | u16 | ✅ | - | Todas las versiones |
| `lock-updates` | Bloquear actualizaciones | bool | ✅ | false | Todas las versiones |
| `domain-suffix` | Sufijo de dominio | string | ✅ | - | Todas las versiones |
| `proxy` | Configuración del servidor proxy | string | ❌ | "" | 0.2.0+ |
| `dns-resolver` | Resolvedor DNS (gai/hickory) | string | ❌ | "gai" | 0.2.0+ |
| `fake-email` | Configuración de correo electrónico falso | object | ❌ | {email="",sign-up-type="unknown",enable=false} | 0.2.0+ |
| `service-addr` | Configuración de dirección de servicio | object | ❌ | {mode="local",suffix=".example.com",port=8080} | 0.2.0+ |

### Configuración de anulaciones (`overrides`)
| Elemento | Descripción | Tipo | Requerido | Por defecto | Versión soportada |
|----------|-------------|------|------------|-------------|-------------------|
| `token` | Token de autenticación JWT | string | ❌ | - | Todas las versiones |
| `traceparent` | Preservar identificador de rastreo | bool | ❌ | false | 0.2.0+ |
| `client-key` | Hash de clave de cliente | string | ❌ | - | 0.2.0+ |
| `checksum` | Suma de verificación combinada | string | ❌ | - | 0.2.0+ |
| `client-version` | Número de versión del cliente | string | ❌ | - | 0.2.0+ |
| `timezone` | Identificador de zona horaria IANA | string | ❌ | - | Todas las versiones |
| `ghost-mode` | Configuración de modo privado | bool | ❌ | true | 0.2.0+ |
| `session-id` | Identificador único de sesión | string | ❌ | - | 0.2.0+ |

**Notas especiales**:
- Los elementos marcados como "0.2.0+" no estaban presentes en 0.1.x, pero los elementos marcados como "Todas las versiones" pueden no ser completamente equivalentes
- Los elementos de configuración con valores predeterminados pueden comentarse o eliminarse para evitar problemas potenciales

## Interfaces internas
Las interfaces bajo `/internal/` son controladas por archivos en el directorio internal (devuelve index.html cuando el archivo no existe), excepto las siguientes interfaces específicas:

### 1. TokenUpdate
**Función**: Actualizar el elemento de configuración current-override en tiempo de ejecución
**Parámetros**:
| Parámetro | Requerido | Descripción |
|-----------|-----------|-------------|
| key | ✅ | Identificador de configuración de anulación |

**Ejemplo**:
```bash
curl http://127.0.0.1:3000/internal/TokenUpdate?key=${KEY_NAME}
```

### 2. TokenAdd
**Función**: Obtener URL de autorización y tiempo de espera
**Retorna**: `["url",100]`, donde url es el enlace de autorización y 100 es el tiempo de espera en segundos

**Parámetros**:
| Parámetro | Requerido | Descripción |
|-----------|-----------|-------------|
| timezone | ✅ | Identificador de zona horaria IANA (p.ej., "Asia/Shanghai" o "America/Los_Angeles") |
| wait | ❌ | Tiempo de espera en segundos, por defecto 100 |
| client_version | ❌ | Número de versión del cliente, por defecto 0.49.6 |

**Ejemplo**:
```bash
# Uso básico
curl http://127.0.0.1:3000/internal/TokenAdd?timezone=Asia%2FShanghai

# Tiempo de espera personalizado
curl http://127.0.0.1:3000/internal/TokenAdd?timezone=Asia%2FShanghai&wait=50
```

### 3. ConfigUpdate
**Función**: Activar recarga del servicio después de actualizar el archivo de configuración

### 4. GetUsage
**Función**: Obtener estadísticas de uso del modelo

---

*Descargo de responsabilidad incluido en EULA. El proyecto puede terminar el mantenimiento en cualquier momento.*

Feel free!