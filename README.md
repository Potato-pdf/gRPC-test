# gRPC Test - Ping & Pong Services

Este proyecto demuestra la comunicación entre microservicios usando **gRPC** en Go.

## 🏗️ Arquitectura

El proyecto consta de dos servicios independientes:

1. **Ping** (Servidor gRPC) - Puerto 50051
2. **Pong** (Cliente gRPC) - Consume el servicio Ping

```
┌─────────────────────┐         gRPC (TCP :50051)        ┌─────────────────────┐
│                     │                                   │                     │
│  Servicio PONG      │  ────────────────────────────>   │  Servicio PING      │
│   (Cliente)         │     SendPing(PingRequest)        │   (Servidor)        │
│                     │                                   │                     │
│  - Envía peticiones │  <────────────────────────────   │  - Recibe peticiones│
│  - Procesa respuestas│      PingResponse               │  - Genera timestamp │
│                     │                                   │  - Responde         │
└─────────────────────┘                                   └─────────────────────┘
```

## 📁 Estructura del Proyecto

```
gRPC-test/
│
├── ping/                      # 🔵 Servidor gRPC
│   ├── go.mod                 # Módulo independiente
│   ├── go.sum
│   ├── ping.proto             # Definición Protocol Buffers
│   ├── main.go                # Servidor gRPC
│   ├── pb/                    # Código generado
│   │   ├── ping.pb.go
│   │   └── ping_grpc.pb.go
│   └── README.md
│
├── pong/                      # 🟢 Cliente gRPC
│   ├── go.mod                 # Módulo independiente
│   ├── go.sum
│   ├── main.go                # Cliente que consume Ping
│   └── README.md
│
└── README.md                  # Esta documentación
```

## 🚀 Quick Start

### Prerequisitos

- Go 1.24.2 o superior
- protoc (Protocol Buffer Compiler) v3.21.12+

### 1️⃣ Iniciar el Servidor Ping

```bash
# Terminal 1
cd ping
go run main.go
```

Deberías ver:
```
2025/12/03 11:09:35 Server started on :50051
```

### 2️⃣ Ejecutar el Cliente Pong

```bash
# Terminal 2
cd pong
go mod edit -replace github.com/charizardbellako/ping=../ping
go mod tidy
go run main.go
```

Salida esperada:
```
2025/12/03 11:09:53 Pong service connected to ping service at localhost:50051

[Request #1]
  Sending: Pong says hello! (ID: 1)
[Response #1]
  ✓ Message: Pong says hello!
  ✓ Success: true
  ✓ Timestamp: 2025-12-03 11:09:53

[Request #2]
  Sending: Pong says hello! (ID: 2)
[Response #2]
  ✓ Message: Pong says hello!
  ✓ Success: true
  ✓ Timestamp: 2025-12-03 11:09:55

... (5 peticiones en total)

✅ Pong service finished all requests
```

## 📋 Definición del Servicio (Protocol Buffers)

```protobuf
syntax = "proto3";

package ping;

service PingPongService {
	rpc SendPing (PingRequest) returns (PingResponse) {}
}

message PingRequest {
	string message = 1;
	int32 id = 2;
}

message PingResponse {
	string message = 1;
	bool success = 2;
	string timestamp = 3;
}
```

## 🔧 Modificar el Proyecto

### Cambiar el mensaje del cliente

Edita `pong/main.go`:
```go
request := &pb.PingRequest{
    Message: "Tu mensaje personalizado aquí!",
    Id:      int32(i),
}
```

### Regenerar archivos protobuf

Si modificas `ping/ping.proto`:

```bash
cd ping
protoc --go_out=. --go_opt=paths=source_relative \
       --go-grpc_out=. --go-grpc_opt=paths=source_relative \
       ping.proto
       
rm -rf pb/*
mv ping.pb.go pb/
mv ping_grpc.pb.go pb/
```

### Agregar lógica al servidor

Edita `ping/main.go` en el método `SendPing`:
```go
func (s *server) SendPing(ctx context.Context, req *pb.PingRequest) (*pb.PingResponse, error) {
    log.Printf("Received ping from ID: %d with message: %s", req.Id, req.Message)
    
    return &pb.PingResponse{
        Message: req.Message,
        Success: true,
        Timestamp: time.Now().Format("2006-01-02 15:04:05"),
    }, nil
}
```

## 🧪 Testing Manual

El proyecto incluye soporte completo para testing manual con diversas herramientas:

### Opción 1: Postman (Recomendado para beginners)
```bash
# 1. Inicia el servidor
cd ping && ./start-server.sh

# 2. Abre Postman (v9.7+)
# 3. Nueva petición gRPC → localhost:50051
# 4. Selecciona ping.PingPongService/SendPing
```

📖 **[Ver guía completa de Postman](POSTMAN-GUIDE.md)**

### Opción 2: grpcurl (Herramienta CLI)
```bash
# Instalar grpcurl (solo una vez)
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest

# Listar servicios disponibles
grpcurl -plaintext localhost:50051 list

# Hacer una petición
grpcurl -plaintext \
  -d '{"message": "Hello from grpcurl!", "id": 42}' \
  localhost:50051 \
  ping.PingPongService/SendPing

# O usar el script de pruebas
./test-grpcurl.sh
```

### Scripts de Testing Incluidos

- `test-grpcurl.sh` - Pruebas básicas con grpcurl
- `test-comprehensive.sh` - Suite completa de tests

### Más información

- 📖 **[Guía completa de Testing](TESTING.md)** - Todas las opciones disponibles
- 📖 **[Guía de instalación](INSTALLATION.md)** - Instalar herramientas de testing
- 📖 **[Guía de Postman](POSTMAN-GUIDE.md)** - Paso a paso con Postman

## 📚 Documentación Adicional

- [README del servicio Ping](ping/README.md) - Detalles del servidor
- [README del servicio Pong](pong/README.md) - Detalles del cliente

## 💡 Conceptos Clave

### gRPC
- Framework RPC (Remote Procedure Call) de alto rendimiento
- Usa HTTP/2 para transporte
- Serialización eficiente con Protocol Buffers

### Protocol Buffers
- Formato de serialización estructurada
- Más eficiente que JSON/XML
- Genera código automáticamente para múltiples lenguajes

### Microservicios
- Ping y Pong son servicios independientes
- Cada uno tiene su propio `go.mod`
- Se comunican mediante interfaces bien definidas (protobuf)

## ✅ Verificación

Para confirmar que todo funciona:

1. ✅ El servidor Ping debe iniciar sin errores
2. ✅ El cliente Pong debe conectarse exitosamente
3. ✅ Se deben enviar y recibir 5 peticiones
4. ✅ Cada respuesta debe incluir el mensaje, success=true y timestamp

## 🐛 Troubleshooting

### Error: "connection refused"
- Verifica que el servidor Ping esté corriendo
- Confirma que está escuchando en :50051

### Error: "could not import github.com/charizardbellako/ping/pb"
```bash
cd pong
go mod edit -replace github.com/charizardbellako/ping=../ping
go mod tidy
```

### Error en archivos generados
Regenera los archivos protobuf (ver sección "Regenerar archivos protobuf")

## 📈 Próximos Pasos

- Agregar autenticación (TLS/SSL)
- Implementar streaming bidireccional
- Agregar interceptores para logging
- Implementar manejo de errores más robusto
- Agregar tests unitarios y de integración
- Dockerizar los servicios

## 📄 Licencia

Proyecto de prueba/aprendizaje - Libre para uso educativo
