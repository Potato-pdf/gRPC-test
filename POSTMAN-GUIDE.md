# Guía Rápida: Testing con Postman

## 🟣 Configuración Inicial

### 1. Verificar versión de Postman
- Necesitas Postman **v9.7 o superior** para soporte nativo de gRPC
- Descargar desde: https://www.postman.com/downloads/

### 2. Iniciar el servidor con Reflection habilitado
```bash
cd ping
./start-server.sh
```

Deberías ver:
```
2025/12/03 11:19:17 Server started on :50051 (gRPC Reflection enabled)
```

---

## 📝 Opción 1: Usando gRPC Reflection (RECOMENDADO)

### Paso 1: Crear nueva petición gRPC
1. Abre Postman
2. Click en **"New"** → **"gRPC"**
3. Se abrirá una nueva pestaña de gRPC

### Paso 2: Configurar la conexión
```
Server URL: localhost:50051
```

### Paso 3: Seleccionar método
1. Postman descubrirá automáticamente los servicios disponibles
2. En el dropdown de métodos, verás:
   ```
   ping.PingPongService
     └─ SendPing
   ```
3. Selecciona **`SendPing`**

### Paso 4: Configurar el mensaje
En el panel de "Message", verás un editor JSON. Escribe:

```json
{
  "message": "Hello from Postman!",
  "id": 123
}
```

### Paso 5: Enviar la petición
1. Click en **"Invoke"**
2. Verás la respuesta en el panel inferior:

```json
{
  "message": "Hello from Postman!",
  "success": true,
  "timestamp": "2025-12-03 11:19:17"
}
```

---

## 📂 Opción 2: Importando archivo .proto

Si prefieres no usar reflection o tienes problemas:

### Paso 1: Importar el .proto
1. En Postman, ve a **APIs** (barra lateral izquierda)
2. Click en **"Import"**
3. Selecciona **"Proto files"**
4. Navega a: `/path/to/gRPC-test/ping/ping.proto`
5. Click **"Import"**

### Paso 2: Crear petición desde la definición
1. Postman generará automáticamente las peticiones disponibles
2. Ve a **Collections** → encontrarás **ping.PingPongService**
3. Click en **SendPing** para crear una nueva petición

### Paso 3: Configurar y enviar
```
Server URL: localhost:50051
Method: ping.PingPongService/SendPing
Message: (como en opción 1)
```

---

## 🧪 Ejemplos de Peticiones en Postman

### Ejemplo 1: Petición básica
```json
{
  "message": "Testing from Postman",
  "id": 1
}
```

**Respuesta esperada:**
```json
{
  "message": "Testing from Postman",
  "success": true,
  "timestamp": "2025-12-03 11:19:17"
}
```

### Ejemplo 2: Con ID diferente
```json
{
  "message": "Second test",
  "id": 999
}
```

### Ejemplo 3: Mensaje vacío
```json
{
  "message": "",
  "id": 0
}
```

### Ejemplo 4: Caracteres especiales
```json
{
  "message": "¡Hola! 你好 🚀",
  "id": 42
}
```

---

## 🔧 Configuración Avanzada en Postman

### Metadata (Headers gRPC)
Si necesitas enviar metadata personalizada:

1. En la pestaña de la petición, ve a **"Metadata"**
2. Agrega key-value pairs:
   ```
   Key: authorization
   Value: Bearer token123
   ```

### TLS/SSL
Si tu servidor usa TLS (no es nuestro caso):
1. En Server URL settings
2. Activa **"Server requires TLS"**
3. Opcional: Carga certificados personalizados

### Timeout
Ajustar el timeout si el servidor tarda en responder:
1. Settings → General
2. Request timeout: 30000 ms (30 segundos)

---

## 📊 Guardar y Organizar Peticiones

### Crear una Collection
1. Click en **"New Collection"**
2. Nombre: `gRPC Ping Tests`
3. Guarda tus peticiones en esta collection

### Guardar petición
1. Después de configurar tu petición, click en **"Save"**
2. Nombre: `Ping - Basic Test`
3. Selecciona la collection
4. Click **"Save"**

### Variables de entorno
Para reutilizar el servidor en múltiples peticiones:

1. **Environments** → **Create Environment**
2. Nombre: `gRPC Local`
3. Variables:
   ```
   server_url = localhost:50051
   ```
4. En tus peticiones usa: `{{server_url}}`

---

## 🐛 Troubleshooting

### Error: "Could not connect to server"
- ✅ Verifica que el servidor esté corriendo: `netstat -an | grep 50051`
- ✅ Asegúrate de que Postman esté apuntando a `localhost:50051`
- ✅ Verifica que no haya firewall bloqueando

### Error: "Service not found"
- ✅ Confirma que reflection esté habilitado en el servidor
- ✅ Reinicia el servidor
- ✅ Usa la opción de importar .proto como alternativa

### Error: "Invalid JSON"
- ✅ Verifica que el JSON esté bien formado
- ✅ Los campos deben coincidir con el .proto: `message` y `id`
- ✅ `id` debe ser un número, no string

### La respuesta no muestra nada
- ✅ Revisa la pestaña "Response" en la parte inferior
- ✅ Verifica que el método sea Unary (no streaming)

---

## 💡 Consejos Pro

1. **Usa reflection**: Es más rápido y no necesitas mantener archivos .proto actualizados
2. **Crea collections**: Organiza tus tests por funcionalidad
3. **Variables de entorno**: Para desarrollo/staging/producción
4. **Guarda ejemplos**: Postman permite guardar response examples
5. **Tests automatizados**: Usa la pestaña "Tests" para assertions

---

## 🎯 Siguiente Paso

Una vez que domines Postman, considera usar:
- **grpcurl** para scripts automatizados (ver TESTING.md)
- **Newman** para ejecutar collections de Postman en CI/CD
- **Postman monitors** para monitoreo continuo

---

## 📚 Recursos Adicionales

- Documentación oficial de Postman gRPC: https://learning.postman.com/docs/sending-requests/grpc/grpc-client-overview/
- gRPC Reflection: https://github.com/grpc/grpc/blob/master/doc/server-reflection.md
- Ver también: `TESTING.md` en este proyecto
