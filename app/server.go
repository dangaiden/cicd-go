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

func main() {
 
  fileServer := http.FileServer(http.Dir("./static")) // New code
  http.Handle("/", fileServer) // New code
  /* http.Handle("/", http.FileServer(http.Dir("./static"))) */

  /* http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request){
	http.ServeFile(w, r, r.URL.Path[1:])
  }) */

  http.HandleFunc("/hi", func(w http.ResponseWriter, r *http.Request){
	fmt.Fprintf(w, "***********Hi!!")
  })

  log.Println("Started, serving on port 8080")
  err := http.ListenAndServe(":8080", nil)

  if err != nil {
    log.Fatal(err.Error())
  }

}