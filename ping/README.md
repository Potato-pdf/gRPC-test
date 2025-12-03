# Prueba de gRPC - Servicio Ping (Servidor)

Este proyecto es una implementación de prueba de gRPC con un servicio simple de Ping/Pong.

## 📁 Estructura del Proyecto Completo

```
gRPC-test/
├── ping/                   # Servidor gRPC (este proyecto)
│   ├── go.mod
│   ├── ping.proto
│   ├── main.go
│   ├── pb/
│   │   ├── ping.pb.go
│   │   └── ping_grpc.pb.go
│   └── README.md
│
└── pong/                   # Cliente gRPC (servicio separado)
    ├── go.mod
    ├── main.go
    └── README.md
```

## 🚀 Servicio Definido

El servicio `PingPongService` expone un método:

- **SendPing**: Recibe un mensaje y un ID, retorna el mensaje con un timestamp y estado de éxito

### Mensaje de Petición (PingRequest)
```protobuf
message PingRequest {
	string message = 1;
	int32 id = 2;
}
```

### Mensaje de Respuesta (PingResponse)
```protobuf
message PingResponse {
	string message = 1;
	bool success = 2;
	string timestamp = 3;
}
```

## 🛠️ Requisitos

- Go 1.24.2 o superior
- protoc (Protocol Buffer Compiler) v3.21.12
- protoc-gen-go v1.36.10
- protoc-gen-go-grpc v1.6.0

## 📦 Instalación de Dependencias

```bash
# Descargar dependencias de Go
go mod tidy

# Instalar herramientas de protoc (si no las tienes)
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```

## 🔧 Regenerar Archivos Protobuf (si es necesario)

Si modificas el archivo `ping.proto`, debes regenerar los archivos:

```bash
# Desde el directorio ping/
protoc --go_out=. --go_opt=paths=source_relative \
       --go-grpc_out=. --go-grpc_opt=paths=source_relative \
       ping.proto

# Mover los archivos generados a pb/
rm -rf pb/*
mv ping.pb.go pb/
mv ping_grpc.pb.go pb/
```

## ▶️ Ejecutar el Servidor

```bash
# Compilar el servidor
go build -o ping-server main.go

# Ejecutar el servidor
./ping-server
# O directamente:
go run main.go
```

El servidor escuchará en `localhost:50051` y mostrará:
```
2025/12/03 11:04:56 Server started on :50051
```

## 🧪 Probar con el Cliente (Servicio Pong)

El cliente está en un servicio separado llamado **pong**. 

**Terminal 1 - Servidor Ping:**
```bash
cd ping
go run main.go
```

**Terminal 2 - Cliente Pong:**
```bash
cd ../pong
go mod edit -replace github.com/charizardbellako/ping=../ping
go mod tidy
go run main.go
```

Deberías ver en el cliente una salida similar a:

```
2025/12/03 11:07:34 Pong service connected to ping service at localhost:50051

[Request #1]
  Sending: Pong says hello! (ID: 1)
[Response #1]
  ✓ Message: Pong says hello!
  ✓ Success: true
  ✓ Timestamp: 2025-12-03 11:07:34
...
```

Ver el [README del servicio pong](../pong/README.md) para más detalles.

## 📝 Notas Importantes

1. **Package correcto**: El módulo usa `github.com/charizardbellako/ping` como nombre del módulo
2. **Archivos generados**: Los archivos en `pb/` son generados automáticamente y NO deben editarse manualmente
3. **Proto file**: Solo debes tener un archivo `.proto`, el resto son generados

## ✅ Estado del Proyecto

El proyecto está correctamente configurado con:
- ✅ Definición de proto clara y bien estructurada
- ✅ Servidor implementado correctamente
- ✅ Cliente de ejemplo funcional
- ✅ Dependencias correctas en go.mod
- ✅ Archivos protobuf generados correctamente

## 🔍 Troubleshooting

Si encuentras errores de importación:
```bash
go mod tidy
```

Si los tipos no coinciden, regenera los archivos protobuf con el comando mencionado arriba.
