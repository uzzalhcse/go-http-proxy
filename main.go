package main

import (
	"encoding/json"
	"log"
	"net"
	"net/http"
	"time"

	"github.com/elazarl/goproxy"
)

func getPublicIP() (string, error) {
	client := &http.Client{
		Timeout: 10 * time.Second,
	}
	resp, err := client.Get("https://httpbin.org/ip")
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	var result struct {
		Origin string `json:"origin"`
	}

	err = json.NewDecoder(resp.Body).Decode(&result)
	if err != nil {
		return "", err
	}

	return result.Origin, nil
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
	publicIP, err := getPublicIP()
	if err != nil {
		log.Fatalf("Failed to get public IP: %v", err)
	}

	proxy := goproxy.NewProxyHttpServer()
	proxy.Verbose = true

	http.Handle("/", loggingMiddleware(proxy))

	log.Printf("Server started at %s:3000", publicIP)
	log.Fatal(http.ListenAndServe(":3000", nil))
}
