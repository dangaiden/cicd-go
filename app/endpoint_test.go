package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

/*
Simple test to check if we get the expected JSON value with a Get request.
*/

func TestEndpoint(t *testing.T) {
	req, err := http.NewRequest("GET", "/pokemon/004", nil) //Create new request to an endpoint
	if err != nil {
		t.Fatal(err)
	}
	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(returnPokemon) // Specify our Handler to test
	handler.ServeHTTP(rr, req)                 // Check the endpoint with the previous request.
	//Check if the endpoint give us a 200 code status

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("Returned wrong status code: got %v want %v",
			status, http.StatusOK)
	}

	// Check the expected response (item in JSON format)
	// Commenting this as I am not able to make this work for now.

	expected := `[{"Name":"Charmander","Number":"004","Type":"Fire"}]`
	if rr.Body.String() != expected {
		t.Errorf("Returned unexpected body: got %v want %v",
			rr.Body.String(), expected)
	}

}
