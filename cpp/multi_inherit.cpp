#include <iostream>

class Movable {
public:
	virtual void move() { std::cout << "Movable::move" << std::endl; }
};

class Floatable {
public:
	virtual void do_float();
	virtual void move() { std::cout << "Floatable::move" << std::endl; }
};


class Ship : public Movable, public Floatable {
public:
	
	void do_float() { std::cout << "Ship::do_float" << std::endl; }
};

int main(int argc, char **argv) {
	Ship s = Ship();
	
	s.Movable::move();
	s.Floatable::move();	
	s.do_float();
	
	return 0;
}
