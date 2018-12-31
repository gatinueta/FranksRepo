package ch.frank;

import java.util.List;

public class Hand {
	private List<Card> cards;

	Hand(List<Card> cards) {
		this.cards = cards;
	}
	
	List<Card> getCards() {
		return cards;
	}
	@Override
	public String toString() {
		return cards.toString();
	}
}
