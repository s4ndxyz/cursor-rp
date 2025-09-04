# cursor-rp

[简体中文](README.md) | [English](README.en.md) | [Русский](README.ru.md) | [Français](README.fr.md) | [العربية](README.ar.md)

## Introducción
Proxy inverso local. La introducción es concisa, intencionalmente.

## Instalación
1. Descargue modifier y ccursor desde https://github.com/[NAME]/cursor-rp/releases
2. Renómbrelos a nombres estándar y colóquelos en el mismo directorio

## Configuración y uso

### 1. Parchear Cursor
1. Abra Cursor, ejecute el comando `Open User Settings` y anote la ruta del archivo de configuración
2. Cierre Cursor, aplique el parche (debe volver a ejecutarse después de cada actualización):
   ```bash
   # Uso básico (detección automática de la ruta de Cursor)
   /path/to/modifier --port 3000 --suffix .local
 
   # Especificar ruta de Cursor
   /path/to/modifier --cursor-path /path/to/cursor --port 3000 --suffix .local
 
   # Configuración HTTPS
   /path/to/modifier --scheme https --port 443 --suffix .example.com
 
   # Omitir detección de hosts (gestión manual de hosts)
   /path/to/modifier --port 3000 --suffix .local --skip-hosts
 
   # Guardar comando para reutilización
   /path/to/modifier --port 3000 --suffix .local --save-command modifier.cmd
   ```

### Parámetros de comandos
| Parámetro | Abreviatura | Descripción | Ejemplo |
|-----------|-------------|-------------|---------|
| `--cursor-path` | `-C` | Ruta de instalación de Cursor (opcional, auto-detección) | `/Applications/Cursor.app` |
| `--scheme` | | Tipo de protocolo (http/https) | `https` |
| `--port` | `-p` | Puerto de servicio | `3000` |
| `--suffix` | | Sufijo de dominio | `.local` |
| `--skip-hosts` | | Omitir modificación del archivo hosts | - |
| `--save-command` | `-s` | Guardar comando en archivo | `modifier.cmd` |
| `--confirm` | | Confirmar cambios (no revertir si el estado es idéntico) | - |
| `--debug` | | Modo de depuración | - |

### Notas específicas de plataforma
- **Windows**: Ejecución directa
- **macOS**: Firma manual requerida debido a SIP (igual que ejecución directa si SIP está desactivado)
  - Script de referencia: [macos.sh](macos.sh)
- **Linux**: Necesita manejar el formato AppImage
  - Script de referencia: [linux.sh](linux.sh)

¡Las contribuciones PR para mejorar los scripts de adaptación de plataforma son bienvenidas!

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

### Configuración básica
| Elemento | Descripción | Tipo | Requerido | Por defecto | Versión soportada |
|----------|-------------|------|------------|-------------|-------------------|
| `check-updates` | Verificar actualizaciones al inicio | bool | ❌ | false | 0.2.0+ |
| `github-token` | Token de acceso GitHub | string | ❌ | "" | 0.2.0+ |
| ~~`usage-statistics`~~ | ~~Estadísticas de uso del modelo~~ | ~~bool~~ | ❌ | true | 0.2.1-0.2.x, obsoleto, implementación futura en base de datos |

### Configuración del servicio (`service-config`)
| Elemento | Descripción | Tipo | Requerido | Por defecto | Versión soportada |
|----------|-------------|------|------------|-------------|-------------------|
| `tls` | Configuración de certificado TLS | object | ❌ | {cert_path="", key_path=""} | 0.3.0+ |
| `port` | Puerto de escucha del servicio | u16 | ✅ | - | Todas las versiones |
| `dns-resolver` | Resolvedor DNS (gai/hickory) | string | ❌ | "gai" | 0.2.0+ |
| `lock-updates` | Bloquear actualizaciones | bool | ✅ | false | Todas las versiones |
| `fake-email` | Configuración de correo electrónico falso | object | ❌ | {email="", sign-up-type="unknown", enable=false} | 0.2.0+ |
| `service-addr` | Configuración de dirección de servicio | object | ❌ | {scheme="http", suffix="", port=0} | 0.2.0+ |
| ~~`proxy`~~ | ~~Configuración del servidor proxy~~ | ~~string~~ | ❌ | - | 0.2.0-0.2.x, obsoleto, migrar a `proxies._` |

### Configuración del pool de proxys (`proxies`) - Nuevo en 0.3.0
| Elemento | Descripción | Tipo | Requerido | Por defecto |
|----------|-------------|------|------------|-------------|
| `nombre_clave` | Identificador de configuración, corresponde a `overrides.nombre_clave` | string | ❌ | - |
| `_` | Configuración proxy por defecto | string | ❌ | "" |

### Configuración de mapeo (`override-mapping`) - Nuevo en 0.3.0
| Elemento | Descripción | Tipo | Requerido | Por defecto |
|----------|-------------|------|------------|-------------|
| `Prefijo del token Bearer` | Mapea al nombre de configuración | string | ❌ | - |
| `_` | Mapeo por defecto | string | ❌ | - |

### Configuración de anulaciones (`overrides.nombre_config`)
| Elemento | Descripción | Tipo | Requerido | Por defecto | Versión soportada |
|----------|-------------|------|------------|-------------|-------------------|
| `token` | Token de autenticación JWT | string | ❌ | - | Todas las versiones |
| `traceparent` | Preservar identificador de rastreo | bool | ❌ | false | 0.2.0+ |
| `client-key` | Hash de clave de cliente | string | ❌ | - | 0.2.0+ |
| `checksum` | Suma de verificación combinada | object | ❌ | - | 0.2.0+ |
| `client-version` | Número de versión del cliente | string | ❌ | - | 0.2.0+ |
| `config-version` | Versión de configuración (UUID) | string | ❌ | - | 0.3.0+ |
| `timezone` | Identificador de zona horaria IANA | string | ❌ | - | Todas las versiones |
| `privacy-mode` | Configuración de modo de privacidad | bool | ❌ | true | 0.3.0+ |
| `session-id` | Identificador único de sesión (UUID) | string | ❌ | - | 0.2.0+ |

### Notas de migración de versión
#### 0.2.x → 0.3.0
- **Cambios importantes**:
  - Eliminado `current-override`, reemplazado por mapeo dinámico de tokens Bearer
  - Migrado `service-config.proxy` a `proxies._`
  - Agregadas nuevas secciones de configuración `proxies` y `override-mapping`
  - `ghost-mode` renombrado a `privacy-mode` con funcionalidad mejorada
  - Agregado nuevo campo `config-version`
  - Agregada configuración `tls` para soporte HTTPS

- **Relaciones de configuración**:
  1. El cliente envía un token Bearer (por ejemplo, `sk-test123`)
  2. `override-mapping` busca el nombre de configuración (por ejemplo, `sk-test` → `example`)
  3. Usa la configuración de proxy de `proxies.example`
  4. Usa las configuraciones de anulación de `overrides.example`

**Notas especiales**:
- Cadena vacía `""` significa sin proxy
- La clave `_` se usa como configuración predeterminada/alternativa
- Se recomienda comentar los elementos de configuración opcionales para evitar problemas potenciales

## Interfaces internas

### ConfigUpdate
**Función**: Activar recarga del servicio después de actualizar el archivo de configuración

---

*Descargo de responsabilidad incluido en EULA. El proyecto puede terminar el mantenimiento en cualquier momento.*

Feel free!