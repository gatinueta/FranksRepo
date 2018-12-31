package ch.frank;

import java.awt.Point;
import java.util.Set;

public class PersonStartField extends Field {
	
	public PersonStartField(Point pos, Set<Vertex> transitions, Person person) {
		super(pos, transitions);
		this.person = person;
	}
	Person person;
	Person getPerson() {
		return person;
	}
}
