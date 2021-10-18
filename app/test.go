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

// "Proxy" for endpoints.
func handleRequests() {
	PrimaryRouter := mux.NewRouter().StrictSlash(true)
	PrimaryRouter.HandleFunc("/", entry)
	PrimaryRouter.HandleFunc("/pokemons", returnPokemons)
	PrimaryRouter.HandleFunc("/hi", hitext)
	PrimaryRouter.HandleFunc("/pokemon/{number}", returnPokemon)
	PrimaryRouter.HandleFunc("/pokemon", newPokemon).Methods("POST")

	//	goimage := http.FileServer(http.Dir("./static"))
	//	PrimaryRouter.HandleFunc("/go", goimage)

	log.Fatal(http.ListenAndServe(":8080", nil))
}

func newPokemon(w http.ResponseWriter, r *http.Request) {
	reqBody, _ := ioutil.ReadAll(r.Body)
	//fmt.Fprintf(w, "%+v", string(reqBody))
	var pokemon Pokemon
	json.Unmarshal(reqBody, &pokemon)

	Pokemons = append(Pokemons, pokemon)
	json.NewEncoder(w).Encode(pokemon)
}

// Function to return an specific object.
func returnPokemon(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	key := vars["Number"]

	for _, pokemon := range Pokemons {
		if pokemon.Number == key {
			json.NewEncoder(w).Encode(Pokemon)
		}
	}
}

// Function to return all objects within the array.
func returnPokemons(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Endpoint Hit: returnPokemons")
	json.NewEncoder(w).Encode(Pokemons)
}

func hitext(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "*Hi!")
}

func main() {
	//Initial "DB" content
	Pokemons = []Pokemon{
		Pokemon{Name: "Dragonite", Number: "149", Type: "Dragon"},
		Pokemon{Name: "Aerodactyl", Number: "142", Type: "Rock"},
		Pokemon{Name: "Charmander", Number: "004", Type: "Fire"},
	}

	fileServer := http.FileServer(http.Dir("./static")) // New code
	http.Handle("/go", fileServer)                      // New code

	log.Println("Started, serving on port 8080")
	err := http.ListenAndServe(":8080", nil)

	if err != nil {
		log.Fatal(err.Error())
	}

	handleRequests()
}

/* https://en.wikipedia.org/w/api.php?action=parse&format=json&page=Bulbasaur */
