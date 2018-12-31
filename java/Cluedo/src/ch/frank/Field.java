package ch.frank;

import java.awt.Point;
import java.util.Set;

public class Field {
	public Field(Point pos, Set<Vertex> transitions) {
		this.pos = pos;
		this.transitions = transitions;
	}
	Point pos;
	Set<Vertex> transitions;
}
