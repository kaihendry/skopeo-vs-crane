package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"runtime"
	"time"
)

var GoVersion = runtime.Version()

func main() {
	log.Println("Version:", os.Getenv("VERSION"), "GoVersion:", GoVersion)

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello %s\n", time.Now())
	})

	http.ListenAndServe(fmt.Sprintf(":%d", 8080), nil)
}
