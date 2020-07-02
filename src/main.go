package main

import (
	"fmt"
	"io"
	"net/http"
	_ "path"
)

func main() {
	handler := GetHTTPHandlers()
	http.ListenAndServe(fmt.Sprintf("0.0.0.0:8080"), &handler)
}

// GetHTTPHandlers sets up and runs the main http server
func GetHTTPHandlers() (handlers http.ServeMux) {
	handler := new(http.ServeMux)
	handler.HandleFunc("/", SayHelloHandler)
	handler.HandleFunc("/_health", HealthCheckHandler)

	return *handler
}

// SayHelloHandler handles a response
func SayHelloHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hi there!")
}

// HealthCheckHandler responds with a mocked "ok" (real prod app should do some work here)
func HealthCheckHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Header().Set("Content-Type", "application/json")

	io.WriteString(w, `{"alive": true}`)
}
