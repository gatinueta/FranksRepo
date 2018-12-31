package ch.frank;

class SolutionFile {
	Person person;
	Weapon weapon;
	Room room;
	@Override
	public String toString() {
		return "person: " + person + ", weapon: " + weapon + ", room: " + room;
	}
}