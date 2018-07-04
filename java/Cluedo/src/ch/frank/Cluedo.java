package ch.frank;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class Cluedo {

	static class SolutionFile {
		Person person;
		Weapon tool;
		Room room;
	}
	
	static int NOF_PLAYERS = 3;
	
	public static void main(String[] args) {
		List<Person> persons = new ArrayList<>(Arrays.asList(Person.values()));
		List<Weapon> tools = new ArrayList<>(Arrays.asList(Weapon.values()));
		List<Room> rooms = new ArrayList<>(Arrays.asList(Room.values()));
		
		Collections.shuffle(persons);
		Collections.shuffle(tools);
		Collections.shuffle(rooms);
		
		SolutionFile solutionFile = new SolutionFile();
		solutionFile.person = persons.remove(0);
		solutionFile.tool = tools.remove(0);
		solutionFile.room = rooms.remove(0);
		
		List<Card> cards = new ArrayList<>();
		
		cards.addAll(persons);
		cards.addAll(tools);
		cards.addAll(rooms);
		
		Collections.shuffle(cards);
		
		List<Hand> hands = new ArrayList<>();
		int nofCardsPerPlayer = cards.size() / NOF_PLAYERS;
		
		int startIndex = 0;
		for (int i=0; i<NOF_PLAYERS; i++) {
			hands.add(new Hand(cards.subList(startIndex, startIndex + nofCardsPerPlayer)));
			startIndex += nofCardsPerPlayer;
		}
		
		for (Hand hand: hands) {
			System.out.println(hand.getCards().toString());
		}
		
		
	}
	

}
