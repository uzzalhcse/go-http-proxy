package main

import (
	"log"
	"net"
	"net/http"

	"github.com/elazarl/goproxy"
)

func getServerIP() string {
	// Get a list of all the system's unicast interface addresses.
	addrs, err := net.InterfaceAddrs()
	if err != nil {
		log.Fatalf("Failed to get server IP: %v", err)
	}

	for _, addr := range addrs {
		// Check the address type and if it's not a loopback, then return it.
		if ipNet, ok := addr.(*net.IPNet); ok && !ipNet.IP.IsLoopback() {
			if ipNet.IP.To4() != nil {
				return ipNet.IP.String()
			}
		}
	}

	return "Unable to determine server IP"
}

func getIP(r *http.Request) string {
	ip, _, err := net.SplitHostPort(r.RemoteAddr)
	if err != nil {
		return r.RemoteAddr
	}
	return ip
}

func loggingMiddleware(proxy *goproxy.ProxyHttpServer) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		ip := getIP(r)
		log.Printf("Request from IP: %s", ip)
		proxy.ServeHTTP(w, r)
	})
}

func main() {
	serverIP := getServerIP()
	log.Printf("Server IP: %s", serverIP)

	proxy := goproxy.NewProxyHttpServer()
	proxy.Verbose = true

	http.Handle("/", loggingMiddleware(proxy))

	log.Println("Server started at port 3000")
	log.Fatal(http.ListenAndServe(":3000", nil))
}
