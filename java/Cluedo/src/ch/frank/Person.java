package ch.frank;

import java.awt.Color;

public enum Person implements Card {
	MRS_SCARLETT(Color.RED),
	PROFESSOR_PLUM(Color.MAGENTA),
	MR_PEACOCK(Color.BLUE),
	MR_GREEN(Color.GREEN),
	COL_MUSTARD(Color.YELLOW),
	MRS_WHITE(Color.WHITE);
	
	private Color color;

	Person(Color color) {
		this.color = color;
	}
	
	Color getColor() {
		return color;
	}
}
