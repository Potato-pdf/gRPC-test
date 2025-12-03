package main

import (
	"context"
	"log"
	"net"
	"time"

	"github.com/charizardbellako/ping/pb"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

type server struct {
	pb.UnimplementedPingPongServiceServer
}

func (s *server) SendPing(ctx context.Context, req *pb.PingRequest) (*pb.PingResponse, error) {
	return &pb.PingResponse{
		Message:   req.Message,
		Success:   true,
		Timestamp: time.Now().Format("2006-01-02 15:04:05"),
	}, nil
}

func main() {
	lis, err := net.Listen("tcp", ":50052")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()
	pb.RegisterPingPongServiceServer(s, &server{})

	// Habilitar reflection para herramientas como Postman, grpcurl, etc.
	reflection.Register(s)

	log.Println("Server started on :50052 (gRPC Reflection enabled)")
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
