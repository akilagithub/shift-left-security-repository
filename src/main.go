package main

import (
	"fmt"
	"net/http"
)

func main() {
	handler := http.NewServeMux()
	handler.HandleFunc("/", SayHello)
	http.ListenAndServe("0.0.0.0:8080", handler)
}

// SayHello handles a response
func SayHello(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, `Hello world, this is a new version`)
}
