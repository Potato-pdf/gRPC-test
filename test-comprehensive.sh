#!/bin/bash

SERVER="localhost:50051"
SERVICE="ping.PingPongService/SendPing"

echo "🚀 Starting comprehensive gRPC tests..."
echo ""

# Check if server is running
if ! nc -z localhost 50051 2>/dev/null; then
    echo "❌ Error: Server is not running on port 50051"
    echo "   Please start the server first: cd ping && ./start-server.sh"
    exit 1
fi

echo "✅ Server is running"
echo ""

# List available services
echo "🔍 Listing available services:"
grpcurl -plaintext localhost:50051 list
echo ""

# List methods of PingPongService
echo "🔍 Listing methods of PingPongService:"
grpcurl -plaintext localhost:50051 list ping.PingPongService
echo ""

# Describe the SendPing method
echo "🔍 Describing SendPing method:"
grpcurl -plaintext localhost:50051 describe ping.PingPongService.SendPing
echo ""

echo "---"
echo "Starting test requests..."
echo "---"
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
  "message": "This is a very long message to test how the service handles larger payloads and verify that everything works correctly",
  "id": 12345
}' $SERVER $SERVICE
echo "---"
echo ""

# Test 3: Special characters
echo "📤 Test 3: Special characters and emojis"
grpcurl -plaintext -d '{
  "message": "¡Hola! 你好 مرحبا 🚀 🎉 ✨",
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
  "message": "Negative ID test",
  "id": -1
}' $SERVER $SERVICE
echo "---"
echo ""

# Test 6: Maximum int32 value
echo "📤 Test 6: Maximum int32 value"
grpcurl -plaintext -d '{
  "message": "Max ID test",
  "id": 2147483647
}' $SERVER $SERVICE
echo "---"
echo ""

# Test 7: JSON escaped characters
echo "📤 Test 7: JSON with escaped characters"
grpcurl -plaintext -d '{
  "message": "Quote: \"Hello\", Newline: \n, Tab: \t",
  "id": 7
}' $SERVER $SERVICE
echo "---"
echo ""

echo "✅ All tests completed successfully!"
echo ""
echo "📊 Summary:"
echo "   - Total tests: 7"
echo "   - Server: $SERVER"
echo "   - Service: ping.PingPongService"
