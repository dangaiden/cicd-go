package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

// Declare structure of a Pokemon (Slice)
type Pokemon struct {
	Name   string `json:"Name"`
	Number string `json:"Number"`
	Type   string `json:"Type"`
}

// Slice to store information (like a DB)
var Pokemons []Pokemon

func entry(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Welcome page!")
	fmt.Println("Endpoint Hit: WelcomePage")
}

/*
Function that parses the data received and appends
it to the Pokemons slice that we have created
*/
func newPokemon(w http.ResponseWriter, r *http.Request) {
	reqBody, _ := ioutil.ReadAll(r.Body)

	var pokemon Pokemon
	json.Unmarshal(reqBody, &pokemon)

	Pokemons = append(Pokemons, pokemon)
	json.NewEncoder(w).Encode(pokemon)
}

/*
Function that removes the received item from the Pokemons' slice.
*/
func delPokemon(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	Number := vars["Number"]

	// Loop through all values in the slice
	for i, pokemon := range Pokemons {
		//If gathered data matches the one we have, remove it.
		if pokemon.Number == Number {
			Pokemons = append(Pokemons[:i], Pokemons[i+1:]...)
		}
	}

}

// Return all objects (pokemons)
func returnPokemons(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Endpoint Hit: returnPokemons")
	json.NewEncoder(w).Encode(Pokemons)
}

// Function to return an specific object (pokemon).
func returnPokemon(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	key := vars["Number"]

	for _, pokemon := range Pokemons {
		if pokemon.Number == key {
			json.NewEncoder(w).Encode(pokemon)
		}
	}
}

/*
This is our "proxy" (router) function which will redirect each
request to the corresponding Function.
*/
func handleRequests() {
	PrimaryRouter := mux.NewRouter().StrictSlash(true)

	PrimaryRouter.HandleFunc("/all", returnPokemons)
	PrimaryRouter.HandleFunc("/pokemon", newPokemon).Methods("POST")
	PrimaryRouter.HandleFunc("/pokemon/{Number}", delPokemon).Methods("DELETE")
	PrimaryRouter.HandleFunc("/pokemon/{Number}", returnPokemon)
	PrimaryRouter.PathPrefix("/").Handler(http.FileServer(http.Dir("./static")))

	log.Fatal(http.ListenAndServe(":8080", PrimaryRouter))

}

// Main function
func main() {
	// We define our data with some entries.
	Pokemons = []Pokemon{
		Pokemon{Name: "Dragonite", Number: "149", Type: "Dragon"},
		Pokemon{Name: "Aerodactyl", Number: "142", Type: "Rock"},
		Pokemon{Name: "Charmander", Number: "004", Type: "Fire"},
	}

	handleRequests()
}
