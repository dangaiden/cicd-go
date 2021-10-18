package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

func appHandler(w http.ResponseWriter, r *http.Request) {

	fmt.Println(time.Now(), "Hello from my new fresh server")

}

/* func handleRequests() {
  myRouter := mux.NewRouter().StrictSlash(true)
  myRouter.HandleFunc("/all", returnAllArticles)
  myRouter.HandleFunc("/article", createNewArticle).Methods("POST")
  myRouter.HandleFunc("/article/{id}", returnPokemon)
  myRouter.
    PathPrefix("/").
    Handler(http.FileServer(http.Dir("./static")))
  log.Fatal(http.ListenAndServe(":8080", myRouter))
} */

func main() {

	fileServer := http.FileServer(http.Dir("./static")) // New code
	http.Handle("/go", fileServer)                      // New code

	http.HandleFunc("/hi", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "*Hi!!")
	})

	http.Handle("/", http.FileServer(http.Dir("./static")))

	log.Println("Started, serving on port 8080")
	err := http.ListenAndServe(":8080", nil)

	if err != nil {
		log.Fatal(err.Error())
	}

}
