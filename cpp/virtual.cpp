class A {
public:
	virtual void foo() = 0;
	void bar();
};

class B: public A {
	void foo() override;
};

int main(int argc, char** argv) {
	B b;
	A& a = b;
	a.bar();
	return 0;
}

void A::bar() {
}

void B::foo() {
}

