package ch.frank;

public class Player {
	private Hand hand;
	private Field field;
	private final String name;
	private final Person person;
	public Player(String name, Person person) {
		this.name = name;
		this.person = person;
	}
	
	public Person getPerson() {
		return person;
	}
	
	public String getName() {
		return name;
	}
	public Hand getHand() {
		return hand;
	}
	public void setHand(Hand hand) {
		this.hand = hand;
	}
	public Field getField() {
		return field;
	}
	public void setField(Field field) {
		this.field = field;
	}
}
