package ch.frank;

public class Suggestion {
	private Person person;
	private Room room;
	private Weapon weapon;

	Suggestion(Person person, Room room, Weapon weapon) {
		this.person = person;
		this.room = room;
		this.weapon = weapon;
	}
	
	Card react(Hand hand) {
		// TODO strategy
		for(Card card: hand.getCards()) {
			if (card == person || card == room || card == weapon) {
				return card;
			}
		}
		return null;
	}
}
