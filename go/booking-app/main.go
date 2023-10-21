package main

import "fmt"

func main() {
	fmt.Println("Welcome to our conference booking application")
	var name = "Go Conference"
	const conferenceTickets = 50
	var remainingTickets = conferenceTickets
	var greeting string
	fmt.Println(greeting)

	fmt.Printf("Welcome to %v booking app\n", name)
	fmt.Println("We have", remainingTickets, "tickets left")
}
