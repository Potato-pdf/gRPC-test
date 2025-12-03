# Servicio Pong - Cliente gRPC

Este servicio actúa como **cliente** del servicio Ping. Simula un microservicio independiente que se comunica con el servicio Ping mediante gRPC.

## 📁 Estructura

```
pong/
├── go.mod          # Módulo Go independiente
├── main.go         # Cliente que consume el servicio Ping
└── README.md       # Esta documentación
```

## 🔗 Dependencias

El servicio Pong depende del servicio Ping:
- Importa los archivos protobuf generados de `ping/pb`
- Se conecta al servidor gRPC en `localhost:50051`

## 🚀 Ejecutar el Servicio

### 1. Preparar el entorno

Primero, asegúrate de que el módulo ping esté disponible localmente:

```bash
# Desde el directorio pong/
go mod edit -replace github.com/charizardbellako/ping=../ping
go mod tidy
```

### 2. Iniciar el servidor Ping

En una terminal, inicia el servidor ping:

```bash
# Terminal 1 - Servidor Ping
cd ../ping
go run main.go
```

Deberías ver:
```
2025/12/03 11:04:56 Server started on :50051
```

### 3. Ejecutar el cliente Pong

En otra terminal, ejecuta el cliente pong:

```bash
# Terminal 2 - Cliente Pong
cd pong
go run main.go
```

## 📊 Salida Esperada

```
2025/12/03 11:07:34 Pong service connected to ping service at localhost:50051

[Request #1]
  Sending: Pong says hello! (ID: 1)
[Response #1]
  ✓ Message: Pong says hello!
  ✓ Success: true
  ✓ Timestamp: 2025-12-03 11:07:34

[Request #2]
  Sending: Pong says hello! (ID: 2)
[Response #2]
  ✓ Message: Pong says hello!
  ✓ Success: true
  ✓ Timestamp: 2025-12-03 11:07:36

...

✅ Pong service finished all requests
```

## 🏗️ Arquitectura

```
┌─────────────────┐         gRPC          ┌─────────────────┐
│  Pong Service   │ ───────────────────>   │  Ping Service   │
│   (Cliente)     │    :50051/SendPing    │   (Servidor)    │
│   main.go       │ <─────────────────── │   main.go       │
└─────────────────┘      PingResponse      └─────────────────┘
```

## 🔧 Modificar el Cliente

Puedes modificar `main.go` para:
- Cambiar el mensaje enviado
- Ajustar el número de peticiones
- Modificar los intervalos entre peticiones
- Agregar lógica de negocio adicional

## 📝 Notas

- Este servicio es completamente independiente de Ping
- Usa `replace` en go.mod para desarrollo local
- En producción, Ping sería un módulo publicado o importado desde un repositorio
