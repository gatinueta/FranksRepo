package ch.frank;

import java.awt.Point;
import java.util.Set;

public class RoomField extends Field {
	Room room;
	public RoomField(Point pos, Set<Vertex> transitions, Room room) {
		super(pos, transitions);
		this.room = room;
	}
	Room getRoom() {
		return room;
	}
}
