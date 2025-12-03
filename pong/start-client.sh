#!/bin/bash

# Script para ejecutar cliente gRPC Pong

echo "🟢 Conectando al servidor Ping en localhost:50051..."
echo "Asegúrate de que el servidor esté corriendo primero!"
echo ""
cd "$(dirname "$0")"
go run main.go
