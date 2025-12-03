#!/bin/bash

# Script para ejecutar servidor gRPC Ping

echo "🔵 Iniciando servidor Ping en puerto :50051..."
cd "$(dirname "$0")"
go run main.go
