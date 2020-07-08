package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	_ "path"
	"strings"

	"rsc.io/quote"
)

func main() {
	handler := GetHTTPHandlers()
	/* #nosec */
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

	currentEnvironment := os.Getenv("ENVIRONMENT")

	var output strings.Builder

	w.Header().Set("Content-Type", "text/html")

	output.WriteString("<html><head><title>Why, hello there!</title></head><body>")
	output.WriteString("<h1>Hi there!</h1>")
	output.WriteString(fmt.Sprintf("<h2>Random Quote: %s</h2>", quote.Glass()))
	output.WriteString(fmt.Sprintf("<h2>Current Environment: %s</h2>", currentEnvironment))
	output.WriteString("</body><html>")
	fmt.Fprintf(w, output.String())
}

// HealthCheckHandler responds with a mocked "ok" (real prod app should do some work here)
func HealthCheckHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Header().Set("Content-Type", "application/json")

	_, err := io.WriteString(w, `{"alive": true}`)
	if err != nil {
		// fmt.Errorf("Unable to write to reponse with error: %w", err)
		log.Fatal(err)
	}
}
