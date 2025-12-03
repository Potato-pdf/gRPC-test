# 🚀 Resumen: Testing Manual de gRPC

## ✅ Estado Actual del Proyecto

Tu proyecto gRPC está **completamente configurado** con soporte para testing manual mediante:
- ✅ gRPC Reflection habilitado
- ✅ Postman (GUI)
- ✅ grpcurl (CLI) - **instalado y funcionando**
- ✅ Scripts de testing automatizados

---

## 🎯 3 Formas Rápidas de Probar tu Servicio

### 🟣 Método 1: Postman (Más Visual y Fácil)

#### Paso 1: Iniciar servidor
```bash
cd ping
./start-server.sh
```

#### Paso 2: Configurar Postman
1. Abre **Postman** (descarga desde postman.com si no lo tienes)
2. **New** → **gRPC Request**
3. Server URL: `localhost:50051`
4. Method: Aparecerá automáticamente → `ping.PingPongService/SendPing`

#### Paso 3: Enviar petición
```json
{
  "message": "Hello from Postman!",
  "id": 123
}
```

#### Paso 4: Ver respuesta
```json
{
  "message": "Hello from Postman!",
  "success": true,
  "timestamp": "2025-12-03 11:19:17"
}
```

📖 **Más detalles**: `POSTMAN-GUIDE.md`

---

### 🔧 Método 2: grpcurl (Línea de Comandos)

#### Opción A: Script automatizado
```bash
# Terminal 1: Servidor
cd ping && ./start-server.sh

# Terminal 2: Tests
cd .. && ./test-grpcurl.sh
```

#### Opción B: Comando manual
```bash
# Agregar grpcurl al PATH (solo una vez)
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc

# Listar servicios
grpcurl -plaintext localhost:50051 list

# Hacer petición
grpcurl -plaintext \
  -d '{"message": "Hello", "id": 1}' \
  localhost:50051 \
  ping.PingPongService/SendPing
```

📖 **Más detalles**: `TESTING.md`

---

### 🎨 Método 3: Cliente Pong (Programático)

```bash
# Terminal 1: Servidor
cd ping && ./start-server.sh

# Terminal 2: Cliente
cd pong && ./start-client.sh
```

Este método ejecuta un cliente completo que hace 5 peticiones automáticas.

---

## 📊 Comparación de Métodos

| Método | Dificultad | Visual | Autoexploratoría | Scriptable |
|--------|------------|--------|-----------------|------------|
| **Postman** | ⭐ Fácil | ✅ Sí | ✅ Sí | ⚠️ Limitado |
| **grpcurl** | ⭐⭐ Media | ❌ No | ✅ Sí | ✅ Sí |
| **Cliente Pong** | ⭐⭐⭐ Avanzada | ❌ No | ❌ No | ✅ Sí |

---

## 🔥 Quick Start (5 minutos)

### Para principiantes (Postman):

```bash
# 1. Terminal: Iniciar servidor
cd /home/charizardbellako/Documentos/Lumina/gRPC-test/ping
./start-server.sh

# 2. Abre Postman en tu computadora
# 3. New → gRPC → localhost:50051
# 4. Método: SendPing
# 5. Mensaje: {"message": "Test", "id": 1}
# 6. Click "Invoke"
```

### Para desarrolladores (grpcurl):

```bash
# 1. Asegúrate de que grpcurl esté en el PATH
export PATH=$PATH:$HOME/go/bin

# 2. Terminal 1: Servidor
cd /home/charizardbellako/Documentos/Lumina/gRPC-test/ping
./start-server.sh

# 3. Terminal 2: Test
cd /home/charizardbellako/Documentos/Lumina/gRPC-test
grpcurl -plaintext -d '{"message":"Hello","id":1}' localhost:50051 ping.PingPongService/SendPing
```

---

## 📚 Ejemplos de Peticiones

### Petición Básica
```json
{
  "message": "Hello World",
  "id": 1
}
```

### Mensaje Largo
```json
{
  "message": "This is a very long message to test the service with larger payloads",
  "id": 999
}
```

### Caracteres Especiales
```json
{
  "message": "¡Hola! 你好 🚀",
  "id": 42
}
```

### Mensaje Vacío
```json
{
  "message": "",
  "id": 0
}
```

---

## 🎯 Siguiente Paso Recomendado

1. **Ahora mismo**: Prueba con grpcurl usando el script:
   ```bash
   cd /home/charizardbellako/Documentos/Lumina/gRPC-test
   ./test-grpcurl.sh
   ```

2. **Después**: Descarga Postman y sigue `POSTMAN-GUIDE.md`

3. **Avanzado**: Lee `TESTING.md` para todas las opciones

---

## 📖 Documentación Completa

- **[POSTMAN-GUIDE.md](POSTMAN-GUIDE.md)** - Guía paso a paso de Postman
- **[TESTING.md](TESTING.md)** - Todas las herramientas de testing
- **[INSTALLATION.md](INSTALLATION.md)** - Instalar herramientas adicionales
- **[README.md](README.md)** - Documentación principal del proyecto

---

## 🆘 Troubleshooting Rápido

### "Connection refused"
```bash
# Verifica que el servidor esté corriendo
netstat -tuln | grep 50051
# Si no hay resultado, inicia el servidor
```

### "grpcurl: command not found"
```bash
# Agregar al PATH
export PATH=$PATH:$HOME/go/bin
grpcurl --version
```

### "Failed to list services"
Los servicios se descubren automáticamente gracias a gRPC Reflection que ya está habilitado en tu servidor.

---

**¡Listo para probar! 🎉**
