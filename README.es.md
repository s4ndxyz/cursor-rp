# cursor-rp

[简体中文](README.md) | [English](README.en.md) | [Русский](README.ru.md) | [Français](README.fr.md) | [العربية](README.ar.md)

## Introducción
Proxy inverso local. La introducción es concisa, intencionalmente.

## Instalación
1. Visite https://github.com/[NAME]/cursor-rp/releases para descargar dbwriter, modifier y ccursor
2. Renómbrelos a nombres estándar y colóquelos en el mismo directorio

## Configuración y uso

### 1. Administración de cuentas (dbwriter)
dbwriter es una herramienta de administración de cuentas para cambiar rápidamente la información de cuenta de Cursor. Admite aplicación directa, administración de grupo de cuentas y otros modos.

#### Uso básico
```bash
# Aplicación directa (sin guardar)
dbwriter apply -a <TOKEN> -m pro -s google
dbwriter apply -a <ACCESS_TOKEN> -r <REFRESH_TOKEN> -e user@example.com -m pro_plus -s auth0

# Guardar cuenta en el grupo
dbwriter save -a <TOKEN> -e user@example.com -m pro -s google
dbwriter save -a <TOKEN> -e user@example.com -m free_trial -s github --apply  # Guardar y aplicar inmediatamente

# Cambiar cuenta desde el grupo
dbwriter use -e user@example.com              # Seleccionar por email
dbwriter use -m pro                           # Seleccionar cuenta Pro (la primera si hay varias)
dbwriter use --interactive                    # Selección interactiva

# Ver grupo de cuentas
dbwriter list                                 # Listar todas las cuentas
dbwriter list -m pro                          # Listar tipo de membresía específico
dbwriter list --verbose                       # Mostrar información detallada (incluyendo vista previa del token)

# Administrar grupo de cuentas
dbwriter manage remove user@example.com       # Eliminar cuenta
dbwriter manage disable user@example.com      # Desactivar cuenta (eliminación suave)
dbwriter manage stats                         # Mostrar estadísticas
```

#### Descripción de parámetros de comando

**Parámetros globales**
| Parámetro | Descripción | Por defecto |
|-----------|-------------|-------------|
| `--pool-db` | Ruta de la base de datos del grupo de cuentas | `./accounts.db` |

**Subcomando: apply (aplicación directa)**
| Parámetro | Abreviatura | Descripción | Requerido |
|-----------|-------------|-------------|-----------|
| `--access-token` | `-a` | Token de acceso | ✅ |
| `--refresh-token` | `-r` | Token de actualización (por defecto igual que access) | ❌ |
| `--email` | `-e` | Email de la cuenta | ❌ |
| `--membership` | `-m` | Tipo de membresía | ✅ |
| `--signup-type` | `-s` | Método de registro | ✅ |

**Subcomando: save (guardar en grupo de cuentas)**
| Parámetro | Abreviatura | Descripción | Requerido |
|-----------|-------------|-------------|-----------|
| `--access-token` | `-a` | Token de acceso | ✅ |
| `--refresh-token` | `-r` | Token de actualización | ❌ |
| `--email` | `-e` | Email de la cuenta (recomendado) | ❌ |
| `--membership` | `-m` | Tipo de membresía | ✅ |
| `--signup-type` | `-s` | Método de registro | ✅ |
| `--apply` |  | Aplicar inmediatamente después de guardar | ❌ |

**Subcomando: use (usar desde grupo de cuentas)**
| Parámetro | Abreviatura | Descripción | Mutuamente excluyente |
|-----------|-------------|-------------|----------------------|
| `--email` | `-e` | Seleccionar por email | Con `-m` |
| `--membership` | `-m` | Seleccionar por tipo de membresía | Con `-e` |
| `--interactive` | `-i` | Selección interactiva | ❌ |

**Tipos de valores admitidos**
- **Tipos de membresía**: `free`, `pro`, `pro_plus`, `enterprise`, `free_trial`, `ultra`
- **Métodos de registro**: `unknown`, `auth0`, `google`, `github`

#### Escenarios de uso
1. **Cambio temporal**: Use el comando `apply` para aplicar directamente una cuenta sin guardarla localmente
2. **Colección de cuentas**: Use el comando `save` para crear un grupo de cuentas facilitando la gestión de múltiples cuentas
3. **Cambio rápido**: Use el comando `use` para cambiar rápidamente entre cuentas guardadas
4. **Gestión por lotes**: Administre toda la información de cuentas a través del grupo de cuentas

#### Notas
- El token admite dos modos: tokens de acceso/actualización idénticos, o tokens diferentes
- La base de datos del grupo de cuentas se guarda por defecto en `./accounts.db`, puede especificarse mediante `--pool-db`
- Se recomienda establecer un email para cada cuenta para facilitar la identificación y gestión
- Al usar `--verbose` para ver información detallada, solo se muestran los primeros 20 caracteres de los tokens

### 2. Parchear Cursor (modifier)
Cierre Cursor, aplique el parche (debe volver a ejecutarse después de cada actualización):
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

# Ejemplo completo
/path/to/modifier -C /path/to/cursor --scheme https -p 3000 --suffix .local --skip-hosts -s modifier.cmd --confirm --pass-token
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
| `--pass-token` | | Pasar validación de token (recomendado) | - |
| `--debug` | | Modo de depuración | - |

### Notas específicas de plataforma
- **Windows**: Ejecución directa
- **macOS**: Firma manual requerida debido a SIP (igual que ejecución directa si SIP está desactivado)
  - Script de referencia: [macos.sh](macos.sh)
- **Linux**: Necesita manejar el formato AppImage
  - Script de referencia: [linux.sh](linux.sh)

¡Las contribuciones PR para mejorar los scripts de adaptación de plataforma son bienvenidas!

### 3. Configurar Hosts
Si usa el parámetro `--skip-hosts`, agregue manualmente estos registros de hosts:
```
127.0.0.1 api2.cursor.sh.local api3.cursor.sh.local repo42.cursor.sh.local api4.cursor.sh.local us-asia.gcpp.cursor.sh.local us-eu.gcpp.cursor.sh.local us-only.gcpp.cursor.sh.local
```

### 4. Iniciar el servicio
```bash
/path/to/ccursor
```

Para desarrolladores de extensiones o plugins de IDE, agregue el parámetro `--debug` después de iniciar ccursor para ver registros detallados.

## Detalles de configuración
En `config.toml`, comente o elimine los parámetros desconocidos, **NO los deje vacíos**.

### Configuración básica
| Elemento | Descripción | Tipo | Requerido | Por defecto | Versión soportada |
|----------|-------------|------|-----------|-------------|-------------------|
| `check-updates` | Verificar actualizaciones al inicio | bool | ❌ | false | 0.2.0+ |
| `github-token` | Token de acceso GitHub | string | ❌ | "" | 0.2.0+ |
| ~~`usage-statistics`~~ | ~~Estadísticas de uso del modelo~~ | ~~bool~~ | ❌ | true | 0.2.1-0.2.x, obsoleto, implementación futura en base de datos |

### Configuración del servicio (`service-config`)
| Elemento | Descripción | Tipo | Requerido | Por defecto | Versión soportada |
|----------|-------------|------|-----------|-------------|-------------------|
| `tls` | Configuración de certificado TLS | object | ✅ | {cert_path="", key_path=""} | 0.3.0+ |
| `ip-addr` | Dirección IP de escucha del servicio | object | ✅ | {ipv4="", ipv6=""} | 0.3.1+ |
| `port` | Puerto de escucha del servicio | u16 | ✅ | - | Todas las versiones |
| `dns-resolver` | Resolvedor DNS (gai/hickory) | string | ❌ | "gai" | 0.2.0+ |
| `lock-updates` | Bloquear actualizaciones | bool | ✅ | false | Todas las versiones |
| `fake-email` | Configuración de correo electrónico falso | object | ❌ | {email="", sign-up-type="unknown", enable=false} | 0.2.0+ |
| `service-addr` | Configuración de dirección de servicio | object | ❌ | {scheme="http", suffix="", port=0} | 0.2.0+ |
| ~~`proxy`~~ | ~~Configuración del servidor proxy~~ | ~~string~~ | ❌ | - | 0.2.0-0.2.x, obsoleto, migrar a `proxies._` |

### Configuración del pool de proxys (`proxies`) - Nuevo en 0.3.0
| Elemento | Descripción | Tipo | Requerido | Por defecto |
|----------|-------------|------|-----------|-------------|
| `nombre_clave` | Identificador de configuración, corresponde a `overrides.nombre_clave` | string | ❌ | - |
| `_` | Configuración proxy por defecto | string | ❌ | "" |

### Configuración de mapeo (`override-mapping`) - Nuevo en 0.3.0
| Elemento | Descripción | Tipo | Requerido | Por defecto |
|----------|-------------|------|-----------|-------------|
| `Prefijo del token Bearer` | Mapea al nombre de configuración | string | ❌ | - |
| `_` | Mapeo por defecto | string | ❌ | - |

### Configuración de anulaciones (`overrides.nombre_config`)
| Elemento | Descripción | Tipo | Requerido | Por defecto | Versión soportada |
|----------|-------------|------|-----------|-------------|-------------------|
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
- El archivo de configuración siempre será actualizado cuando se cierre ccursor. Si necesita modificar el archivo de configuración, elija GET /internal/ConfigUpdate o cierre y luego actualice

## Interfaces internas

### ConfigUpdate
**Función**: Activar recarga del servicio después de actualizar el archivo de configuración
**Limitación**: No se puede activar a través de acceso por dominio, requiere acceso externo con proxy inverso personalizado

---

*Descargo de responsabilidad incluido en EULA. El proyecto puede terminar el mantenimiento en cualquier momento.*

Feel free!