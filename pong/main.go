package main

import (
	"context"
	"log"
	"time"

	"github.com/charizardbellako/ping/pb"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

func main() {
	// Conectar al servidor gRPC (ping service)
	conn, err := grpc.NewClient("localhost:50051", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("Failed to connect to ping service: %v", err)
	}
	defer conn.Close()

	log.Println("Pong service connected to ping service at localhost:50051")

	// Crear el cliente del servicio PingPong
	client := pb.NewPingPongServiceClient(conn)

	// Enviar múltiples pings como ejemplo
	for i := 1; i <= 5; i++ {
		// Crear el contexto con timeout
		ctx, cancel := context.WithTimeout(context.Background(), time.Second*5)

		// Crear la petición
		request := &pb.PingRequest{
			Message: "Pong says hello!",
			Id:      int32(i),
		}

		log.Printf("\n[Request #%d]", i)
		log.Printf("  Sending: %s (ID: %d)", request.Message, request.Id)

		// Llamar al método SendPing
		response, err := client.SendPing(ctx, request)
		if err != nil {
			log.Printf("  ❌ Error calling SendPing: %v", err)
			cancel()
			continue
		}

		// Mostrar la respuesta
		log.Printf("[Response #%d]", i)
		log.Printf("  ✓ Message: %s", response.Message)
		log.Printf("  ✓ Success: %v", response.Success)
		log.Printf("  ✓ Timestamp: %s", response.Timestamp)

		cancel()

		// Esperar un poco entre peticiones
		if i < 5 {
			time.Sleep(time.Second * 2)
		}
	}

	log.Println("\n✅ Pong service finished all requests")
}
