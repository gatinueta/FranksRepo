package ch.frank;

import java.awt.Point;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class Cluedo {

	Map<String, Field> fields = new HashMap<>();
	List<Person> persons = new ArrayList<>(Arrays.asList(Person.values()));
	List<Weapon> tools = new ArrayList<>(Arrays.asList(Weapon.values()));
	List<Room> rooms = new ArrayList<>(Arrays.asList(Room.values()));
	List<Card> cards;
	
	List<Player> players = new ArrayList<Player>();
	private SolutionFile solutionFile;
	
	static int NOF_PLAYERS = 3;
	
	void init() {
		for (Person person: persons) {
			// TODO: point, vertices from graph
			Point pos = new Point();
			Set<Vertex> vertices = new HashSet<>();
			fields.put(person.name(), new PersonStartField(pos, vertices, person));
		}
		for (Room room: rooms) {
			// TODO: point, vertices from graph
			Point pos = new Point();
			Set<Vertex> vertices = new HashSet<>();
			fields.put(room.name(), new RoomField(pos,  vertices,  room));
		}
		Collections.shuffle(persons);
		Collections.shuffle(tools);
		Collections.shuffle(rooms);
		
		solutionFile = new SolutionFile();
		solutionFile.person = persons.remove(0);
		solutionFile.weapon = tools.remove(0);
		solutionFile.room = rooms.remove(0);

		List<Card> cards = new ArrayList<>();		
		cards.addAll(persons);
		cards.addAll(tools);
		cards.addAll(rooms);
		
		Collections.shuffle(cards);
		
		int nofCardsPerPlayer = cards.size() / NOF_PLAYERS;
		
		int startIndex = 0;
		for (int i=0; i<NOF_PLAYERS; i++) {
			Person playerPerson = persons.get(i);
			Player player = new Player("Player " + (i+1), playerPerson);
			players.add(player);
			Hand hand = new Hand(
					cards.subList(startIndex, startIndex + nofCardsPerPlayer));
			player.setHand(hand);
			Field personField = fields.get(playerPerson.name());
			player.setField(personField);
			startIndex += nofCardsPerPlayer;
			//TODO wenn's nicht aufgeht?
		}
		
	}
	public static void main(String[] args) {
		Cluedo game = new Cluedo();
		game.init();
	}
	

}
