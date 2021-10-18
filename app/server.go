package main

import (
	"encoding/json"
	"fmt"
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

// Function to return an specific object.
func returnPokemon(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	key := vars["Number"]

	for _, pokemon := range Pokemons {
		if pokemon.Number == key {
			json.NewEncoder(w).Encode(pokemon)
		}
	}
}

// Return all pokemons
func returnPokemons(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Endpoint Hit: returnPokemons")
	json.NewEncoder(w).Encode(Pokemons)
}

func handleRequests() {
	PrimaryRouter := mux.NewRouter().StrictSlash(true)
	PrimaryRouter.HandleFunc("/", entry)
	PrimaryRouter.PathPrefix("/go").Handler(http.FileServer(http.Dir("./static")))
	PrimaryRouter.HandleFunc("/all", returnPokemons)

	log.Fatal(http.ListenAndServe(":8080", PrimaryRouter))

}

func main() {

	Pokemons = []Pokemon{
		Pokemon{Name: "Dragonite", Number: "149", Type: "Dragon"},
		Pokemon{Name: "Aerodactyl", Number: "142", Type: "Rock"},
		Pokemon{Name: "Charmander", Number: "004", Type: "Fire"},
	}

	//	fileServer := http.FileServer(http.Dir("./static"))
	//	http.Handle("/go", fileServer)

	/* http.HandleFunc("/hi", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "*Hi!!")
	}) */

	//http.Handle("/", http.FileServer(http.Dir("./static")))

	handleRequests()
}
