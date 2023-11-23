package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
)

func main() {
	proxyServer := http.NewServeMux()
	proxyServer.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// Forward the request to the upstream server
		upstreamServer := "https://example.com"
		resp, err := http.Get(upstreamServer)
		if err != nil {
			fmt.Fprintf(w, "Error forwarding request: %v", err)
			return
		}

		// Copy the response headers
		for k, v := range resp.Header {
			w.Header().Set(k, v[0])
		}

		// Copy the response body
		defer resp.Body.Close()
		io.Copy(w, resp.Body)
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	fmt.Printf("Starting proxy server on port %s...\n", port)
	http.ListenAndServe(":"+port, proxyServer)
}
