# Guía de Testing Manual - Servicio gRPC Ping

Esta guía te muestra diferentes formas de probar manualmente tu servicio gRPC.

## 📋 Tabla de Contenidos

1. [Postman (gRPC)](#postman-grpc)
2. [grpcurl - CLI Tool](#grpcurl)
3. [BloomRPC / Postman Desktop](#bloomrpc)
4. [grpcui - Web Interface](#grpcui)

---

## 🟣 Postman (gRPC)

### Requisitos
- Postman versión 9.7+ (soporte nativo para gRPC)
- Descargar desde: https://www.postman.com/downloads/

### Pasos para usar Postman con gRPC:

#### 1. Habilitar Reflection en el Servidor (Recomendado)

Primero, necesitas habilitar reflection en tu servidor para que Postman pueda descubrir los servicios. 

Actualiza `ping/main.go`:
```go
import (
    // ... otros imports
    "google.golang.org/grpc/reflection"
)

func main() {
    // ... código existente hasta RegisterPingPongServiceServer
    
    pb.RegisterPingPongServiceServer(s, &server{})
    
    // ⭐ Habilitar reflection para herramientas como Postman
    reflection.Register(s)
    
    log.Println("Server started on :50051")
    if err := s.Serve(lis); err != nil {
        log.Fatalf("failed to serve: %v", err)
    }
}
```

#### 2. Configurar Postman

1. **Abrir Postman**
2. **Crear nueva petición → gRPC Request**
3. **Configurar:**
   - URL: `localhost:50051`
   - Método: Selecciona `ping.PingPongService/SendPing`
   - Message (JSON):
     ```json
     {
       "message": "Hello from Postman!",
       "id": 123
     }
     ```
4. **Click en "Invoke"**

#### 3. Alternativa: Importar archivo .proto

Si no usas reflection:
1. En Postman: **Import → Proto Files**
2. Selecciona el archivo `ping/ping.proto`
3. Postman generará automáticamente las peticiones disponibles

---

## 🔧 grpcurl - Herramienta CLI

**grpcurl** es como `curl` pero para gRPC. Es la herramienta más popular para testing manual desde la terminal.

### Instalación

#### Linux/Mac:
```bash
# Opción 1: Usando go install
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest

# Opción 2: Linux con apt
sudo apt install grpcurl

# Opción 3: Mac con brew
brew install grpcurl
```

#### Verificar instalación:
```bash
grpcurl --version
```

### Uso Básico

#### 1. Listar servicios disponibles (requiere reflection):
```bash
grpcurl -plaintext localhost:50051 list
```

Salida esperada:
```
grpc.reflection.v1alpha.ServerReflection
ping.PingPongService
```

#### 2. Listar métodos de un servicio:
```bash
grpcurl -plaintext localhost:50051 list ping.PingPongService
```

Salida esperada:
```
ping.PingPongService.SendPing
```

#### 3. Ver schema de un método:
```bash
grpcurl -plaintext localhost:50051 describe ping.PingPongService.SendPing
```

#### 4. Hacer una petición:
```bash
grpcurl -plaintext \
  -d '{"message": "Hello from grpcurl!", "id": 42}' \
  localhost:50051 \
  ping.PingPongService/SendPing
```

Salida esperada:
```json
{
  "message": "Hello from grpcurl!",
  "success": true,
  "timestamp": "2025-12-03 11:19:17"
}
```

#### 5. Usando archivo .proto (sin reflection):
```bash
grpcurl -plaintext \
  -proto ping/ping.proto \
  -d '{"message": "Test", "id": 1}' \
  localhost:50051 \
  ping.PingPongService/SendPing
```

### Scripts de Prueba con grpcurl

Crear archivo `ping/test-with-grpcurl.sh`:
```bash
#!/bin/bash

echo "🧪 Testing PingPong Service with grpcurl"
echo "========================================"
echo ""

# Test 1
echo "📤 Test 1: Basic ping"
grpcurl -plaintext \
  -d '{"message": "Test message 1", "id": 1}' \
  localhost:50051 \
  ping.PingPongService/SendPing
echo ""

# Test 2
echo "📤 Test 2: Different ID"
grpcurl -plaintext \
  -d '{"message": "Another test", "id": 999}' \
  localhost:50051 \
  ping.PingPongService/SendPing
echo ""

# Test 3
echo "📤 Test 3: Empty message"
grpcurl -plaintext \
  -d '{"message": "", "id": 0}' \
  localhost:50051 \
  ping.PingPongService/SendPing
echo ""

echo "✅ All tests completed!"
```

---

## 🌸 BloomRPC (Interfaz Gráfica)

**BloomRPC** es una GUI similar a Postman pero específica para gRPC.

### Instalación
- Descargar desde: https://github.com/bloomrpc/bloomrpc/releases
- Disponible para Windows, Mac y Linux

### Uso:
1. Abrir BloomRPC
2. **Import Proto** → Seleccionar `ping/ping.proto`
3. Configurar:
   - Server URL: `localhost:50051`
   - Desmarcar "Use TLS"
4. Seleccionar método `SendPing`
5. Editar el JSON del request
6. Click en "Play" ▶️

---

## 🌐 grpcui - Interfaz Web

**grpcui** genera automáticamente una interfaz web para tu servicio gRPC.

### Instalación
```bash
go install github.com/fullstorydev/grpcui/cmd/grpcui@latest
```

### Uso
```bash
# Iniciar interfaz web (requiere reflection habilitado)
grpcui -plaintext localhost:50051
```

Esto abrirá automáticamente tu navegador en `http://localhost:XXXX` con una interfaz web donde puedes:
- Ver todos los servicios y métodos
- Probar peticiones con formularios interactivos
- Ver responses en tiempo real

---

## 🔑 Comparación de Herramientas

| Herramienta | Tipo | Pros | Contras |
|-------------|------|------|---------|
| **Postman** | GUI Desktop | Familiar, potente, collections | Pesado, requiere versión reciente |
| **grpcurl** | CLI | Ligero, scriptable, rápido | Solo terminal, no tan visual |
| **BloomRPC** | GUI Desktop | Simple, específico para gRPC | Proyecto pausado |
| **grpcui** | Web | No requiere instalación GUI, automático | Requiere reflection |

---

## 📝 Ejemplo Completo con grpcurl

### Archivo: `test-all-scenarios.sh`

```bash
#!/bin/bash

SERVER="localhost:50051"
SERVICE="ping.PingPongService/SendPing"

echo "🚀 Starting comprehensive gRPC tests..."
echo ""

# Check if server is running
if ! nc -z localhost 50051 2>/dev/null; then
    echo "❌ Error: Server is not running on port 50051"
    echo "   Please start the server first: cd ping && go run main.go"
    exit 1
fi

echo "✅ Server is running"
echo ""

# Test 1: Normal request
echo "📤 Test 1: Normal ping request"
grpcurl -plaintext -d '{
  "message": "Hello World",
  "id": 1
}' $SERVER $SERVICE
echo "---"
echo ""

# Test 2: Long message
echo "📤 Test 2: Long message"
grpcurl -plaintext -d '{
  "message": "This is a very long message to test how the service handles larger payloads",
  "id": 12345
}' $SERVER $SERVICE
echo "---"
echo ""

# Test 3: Special characters
echo "📤 Test 3: Special characters"
grpcurl -plaintext -d '{
  "message": "¡Hola! 你好 🚀",
  "id": 999
}' $SERVER $SERVICE
echo "---"
echo ""

# Test 4: Empty message
echo "📤 Test 4: Empty message"
grpcurl -plaintext -d '{
  "message": "",
  "id": 0
}' $SERVER $SERVICE
echo "---"
echo ""

# Test 5: Negative ID
echo "📤 Test 5: Negative ID"
grpcurl -plaintext -d '{
  "message": "Negative test",
  "id": -1
}' $SERVER $SERVICE
echo "---"
echo ""

echo "✅ All tests completed successfully!"
```

---

## 🎯 Recomendación

Para empezar rápidamente:

1. **CLI/Scripts**: Usa `grpcurl` (más rápido)
2. **GUI**: Usa Postman si ya lo tienes instalado
3. **Web**: Usa `grpcui` para pruebas rápidas sin instalar nada

**Mi recomendación personal**: `grpcurl` para desarrollo diario y Postman para documentación/testing más formal.

---

## 🔧 Troubleshooting

### Error: "Failed to list services"
- Asegúrate de que reflection esté habilitado en el servidor
- Verifica que el servidor esté corriendo: `netstat -an | grep 50051`

### Error: "Unavailable"
- El servidor no está corriendo
- El puerto está bloqueado

### Error: "Unimplemented"
- El método no está implementado en el servidor
- Verifica el nombre del servicio/método
