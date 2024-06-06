package main

import (
	"log"
	"net/http"

	"github.com/elazarl/goproxy"
)

func main() {
	proxy := goproxy.NewProxyHttpServer()
	proxy.Verbose = true

	http.Handle("/", proxy)

	log.Println("Server started at port 3000")
	log.Fatal(http.ListenAndServe(":3000", proxy))
}
