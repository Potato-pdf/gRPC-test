syntax = "proto3";
package ping

option go_package = "github.com/charizardbellako/ping/pb";

service PingPongService {
	rpc SendPing (PingRequest) returns (PingResponse);
}

message PingRequest {
	string message = 1;
	int32 id =2;
}

message PingResponse {
	string message = 1;
	bool success = 2;
	String timestamp = 3;
}
