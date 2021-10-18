package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

// Declare structure of a Pokemon (Map/Array)
type Pokemon struct {
	Name   string `json:"Name"`
	Number string `json:"Number"`
	Type   string `json:"Type"`
}

// Array variable to store information (like a DB)
var Pokemons []Pokemon

func entry(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Welcome page!")
	fmt.Println("Endpoint Hit: WelcomePage")
}

/*
Function that parses the data received and appends
it to the Pokemons array that we have created
*/
func newPokemon(w http.ResponseWriter, r *http.Request) {
	reqBody, _ := ioutil.ReadAll(r.Body)

	var pokemon Pokemon
	json.Unmarshal(reqBody, &pokemon)

	Pokemons = append(Pokemons, pokemon)
	json.NewEncoder(w).Encode(pokemon)
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
	//PrimaryRouter.HandleFunc("/", entry)
	PrimaryRouter.PathPrefix("/").Handler(http.FileServer(http.Dir("./static")))
	PrimaryRouter.HandleFunc("/all", returnPokemons)
	PrimaryRouter.HandleFunc("/pokemon/{Number}", returnPokemon)
	PrimaryRouter.HandleFunc("/pokemon", newPokemon).Methods("POST")

	log.Fatal(http.ListenAndServe(":8080", PrimaryRouter))

}

// Main function
func main() {
	// We define our array with some entries.
	Pokemons = []Pokemon{
		Pokemon{Name: "Dragonite", Number: "149", Type: "Dragon"},
		Pokemon{Name: "Aerodactyl", Number: "142", Type: "Rock"},
		Pokemon{Name: "Charmander", Number: "004", Type: "Fire"},
	}

	handleRequests()
}
