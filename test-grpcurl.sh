#!/bin/bash

echo "🧪 Testing PingPong Service with grpcurl"
echo "========================================"
echo ""

SERVER="localhost:50051"
SERVICE="ping.PingPongService/SendPing"

# Check if server is running
if ! nc -z localhost 50051 2>/dev/null; then
    echo "❌ Error: Server is not running on port 50051"
    echo "   Please start the server first:"
    echo "   cd ../ping && ./start-server.sh"
    exit 1
fi

echo "✅ Server is running"
echo ""

# Test 1
echo "📤 Test 1: Basic ping"
grpcurl -plaintext \
  -d '{"message": "Test from grpcurl", "id": 1}' \
  $SERVER $SERVICE
echo ""

# Test 2
echo "📤 Test 2: Different ID"
grpcurl -plaintext \
  -d '{"message": "Another test", "id": 999}' \
  $SERVER $SERVICE
echo ""

# Test 3
echo "📤 Test 3: Empty message"
grpcurl -plaintext \
  -d '{"message": "", "id": 0}' \
  $SERVER $SERVICE
echo ""

echo "✅ All tests completed!"
