package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

type Pokemon struct {
	Name   string `json:"Name"`
	Number string `json:"Number"`
	Type   string `json:"Type"`
}

func entry(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Welcome page!")
	fmt.Println("Endpoint Hit: WelcomePage")
}

func handleRequests() {
	PrimaryRouter := mux.NewRouter().StrictSlash(true)
	PrimaryRouter.HandleFunc("/", entry)
	PrimaryRouter.PathPrefix("hi").
		Handler(http.FileServer(http.Dir("./static")))

	log.Fatal(http.ListenAndServe(":8080", PrimaryRouter))

}

func main() {

	//	fileServer := http.FileServer(http.Dir("./static"))
	//	http.Handle("/go", fileServer)

	http.HandleFunc("/hi", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "*Hi!!")
	})

	//http.Handle("/", http.FileServer(http.Dir("./static")))

	handleRequests()
}
