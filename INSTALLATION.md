# Instalación de Herramientas de Testing gRPC

Esta guía te ayuda a instalar las herramientas necesarias para testing manual de servicios gRPC.

## 🔧 grpcurl (Recomendado - CLI)

### Opción 1: Usando Go (Recomendado)
```bash
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
```

Esto instalará grpcurl en `~/go/bin/grpcurl`. Asegúrate de que `~/go/bin` esté en tu PATH:

```bash
# Agregar al PATH (Linux/Mac)
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc

# O para zsh
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.zshrc
source ~/.zshrc
```

### Opción 2: Usando apt (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install grpcurl
```

### Opción 3: Descarga directa (Linux)
```bash
# Para Linux x86_64
wget https://github.com/fullstorydev/grpcurl/releases/download/v1.8.9/grpcurl_1.8.9_linux_x86_64.tar.gz
tar -xvf grpcurl_1.8.9_linux_x86_64.tar.gz
sudo mv grpcurl /usr/local/bin/
chmod +x /usr/local/bin/grpcurl
```

### Verificar instalación
```bash
grpcurl --version
# Debería mostrar: grpcurl v1.x.x
```

### Uso básico
```bash
# Listar servicios
grpcurl -plaintext localhost:50051 list

# Hacer una petición
grpcurl -plaintext -d '{"message": "Hello", "id": 1}' localhost:50051 ping.PingPongService/SendPing
```

---

## 🌸 grpcui (Opcional - Web UI)

### Instalación
```bash
go install github.com/fullstorydev/grpcui/cmd/grpcui@latest
```

### Uso
```bash
# Iniciar (con el servidor corriendo)
grpcui -plaintext localhost:50051

# Abrirá automáticamente tu navegador con una UI web
```

---

## 🟣 Postman (GUI)

### Instalación

#### Linux
```bash
# Opción 1: Snap
sudo snap install postman

# Opción 2: Descargar .tar.gz
wget https://dl.pstmn.io/download/latest/linux64 -O postman-linux-x64.tar.gz
tar -xzf postman-linux-x64.tar.gz
sudo mv Postman /opt/
sudo ln -s /opt/Postman/Postman /usr/local/bin/postman
```

#### Windows
Descargar desde: https://www.postman.com/downloads/

#### Mac
```bash
brew install --cask postman
```

### Requisitos
- Versión 9.7+ para soporte completo de gRPC
- Ver `POSTMAN-GUIDE.md` para instrucciones de uso

---

## 🌐 BloomRPC (Alternativa GUI - Descontinuado pero funcional)

### Instalación

#### Linux (AppImage)
```bash
wget https://github.com/bloomrpc/bloomrpc/releases/download/1.5.3/BloomRPC-1.5.3.AppImage
chmod +x BloomRPC-1.5.3.AppImage
./BloomRPC-1.5.3.AppImage
```

#### Windows/Mac
Descargar desde: https://github.com/bloomrpc/bloomrpc/releases

**Nota**: BloomRPC ya no está en desarrollo activo, pero sigue siendo muy útil.

---

## ✅ Verificación de Instalación

Ejecuta este script para verificar qué herramientas tienes instaladas:

```bash
#!/bin/bash

echo "🔍 Verificando herramientas de testing gRPC..."
echo ""

# grpcurl
if command -v grpcurl &> /dev/null; then
    echo "✅ grpcurl: $(grpcurl --version)"
else
    echo "❌ grpcurl no instalado"
    echo "   Instalar: go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest"
fi

# grpcui
if command -v grpcui &> /dev/null; then
    echo "✅ grpcui: instalado"
else
    echo "❌ grpcui no instalado (opcional)"
    echo "   Instalar: go install github.com/fullstorydev/grpcui/cmd/grpcui@latest"
fi

# postman
if command -v postman &> /dev/null; then
    echo "✅ Postman: instalado"
else
    echo "❌ Postman no instalado (opcional)"
fi

echo ""
echo "📝 Recomendación mínima: tener grpcurl instalado"
```

---

## 🚀 Quick Start después de la instalación

Una vez instalado grpcurl:

### 1. Iniciar el servidor
```bash
cd ping
./start-server.sh
```

### 2. Probar con grpcurl
```bash
# En otra terminal
cd gRPC-test
./test-grpcurl.sh
```

### 3. O prueba manual
```bash
grpcurl -plaintext \
  -d '{"message": "Hello", "id": 1}' \
  localhost:50051 \
  ping.PingPongService/SendPing
```

---

## 📚 Recursos

- **grpcurl**: https://github.com/fullstorydev/grpcurl
- **grpcui**: https://github.com/fullstorydev/grpcui
- **Postman**: https://www.postman.com/
- **BloomRPC**: https://github.com/bloomrpc/bloomrpc

---

## 🆘 Troubleshooting

### "command not found: grpcurl"
- Verifica tu PATH: `echo $PATH`
- Asegúrate de que `~/go/bin` esté en el PATH
- Reinicia tu terminal después de modificar `.bashrc`

### "permission denied"
```bash
chmod +x /path/to/grpcurl
```

### Go no instalado
Si no tienes Go instalado:
```bash
# Ubuntu/Debian
sudo apt install golang-go

# O descarga desde https://go.dev/dl/
```
