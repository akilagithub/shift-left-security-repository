package main

import (
	"fmt"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestSetupHTTPServer(t *testing.T) {

	handlers := GetHTTPHandlers()

	first, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Fatal(err)
	}
	_, path := handlers.Handler(first)

	if path != "/" {
		t.Errorf("home path not in handlers")
	}
}

// TestHello is a dummy example
func TestHello(t *testing.T) {

	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(SayHelloHandler)

	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusOK)
	}

	expected := `Hi there`
	result := rr.Body.String()

	if !strings.ContainsAny(result, expected) {
		t.Errorf("handler returned unexpected body: got %v want %v",
			rr.Body.String(), expected)
	}

	fmt.Println("HERE")
}

func TestHealthCheckHandler(t *testing.T) {

	req, err := http.NewRequest("GET", "/_health", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(HealthCheckHandler)

	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v", status, http.StatusOK)
	}

	expected := `{"alive": true}`

	if rr.Body.String() != expected {
		t.Errorf("handler returned unexpected body: got %v want %v", rr.Body.String(), expected)
	}
}
