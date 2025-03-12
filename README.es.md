# cursor-rp

[简体中文](README.md) | [English](README.en.md) | [Русский](README.ru.md) | [Français](README.fr.md) | [العربية](README.ar.md)

## Introducción
Proxy inverso local. La introducción es concisa, intencionalmente.

## Instalación
Descargue modifier y ccursor desde https://github.com/wisdgod/cursor-rp/releases, renómbrelos a nombres estándar y colóquelos en el mismo directorio.

## Configuración y uso
Tomando 2999 y .local como ejemplos:

1. Abra Cursor, use el comando >Open User Settings en Cursor y copie la ruta.
2. Cierre Cursor, aplique el parche (ejecute una vez después de cada actualización, ejecute nuevamente para restaurar):
   ```
   modifier --cursor-path /path/to/cursor --port 2999 --suffix .local local
   ```

3. Puede modificar incorrectamente el archivo hosts, por lo que es posible que deba actualizarlo manualmente agregando lo siguiente:
   ```
   127.0.0.1 api2.cursor.sh.local
   127.0.0.1 api3.cursor.sh.local
   127.0.0.1 repo42.cursor.sh.local
   127.0.0.1 api4.cursor.sh.local
   127.0.0.1 us-asia.gcpp.cursor.sh.local
   127.0.0.1 us-eu.gcpp.cursor.sh.local
   127.0.0.1 us-only.gcpp.cursor.sh.local
   ```

4. Ejecutar el servicio:
   ```
   ccursor /path/to/settings.json
   ```

## Configuraciones importantes
Agregue los siguientes elementos en settings.json:
- `ccursor.port`: Esto requiere un entero sin signo de 16 bits
- `ccursor.lockUpdates`: Si se deben bloquear las actualizaciones
- `ccursor.domainSuffix`: El .local mencionado anteriormente
- `ccursor.timezone`: El identificador de zona horaria de la ubicación de su IP (estándar IANA)

## Mecanismo de actualización
Cuando haya cambios, use solicitudes HTTP GET a las siguientes rutas:
- `/internal/TokenUpdate`
- `/internal/ChecksumUpdate`
- `/internal/ConfigUpdate`

---

Elimine el repositorio y huya en cualquier momento. Descargo de responsabilidad adjunto en el eula. Las actualizaciones no serán frecuentes.

Feel free!