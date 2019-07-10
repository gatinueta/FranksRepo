#include <iostream>

class Piece {
   const bool m_black;
public:
   Piece(bool black) : m_black(black) {
   }
   virtual const char getSym() const = 0;
   
   const char sym() const {
     return m_black ? getSym() : tolower(getSym());
   }
};

class Pawn : public Piece {
public:
    Pawn(bool black) : Piece(black) {
    }
    const char getSym() const { 
        return 'P';
    }
};

class Knight : public Piece {
public:
    Knight(bool black) : Piece(black) {
    }
    const char getSym() const {
        return 'N';
    }
};

class Rook : public Piece {
public:
    Rook(bool black) : Piece(black) {
    }
    const char getSym() const {
        return 'R';
    }
};

class Queen : public Piece {
public:
    Queen(bool black) : Piece(black) {
    }
    const char getSym() const {
        return 'Q';
    }
};

class Bishop : public Piece {
    Bishop(bool black) : Piece(black) {
    }
    const char getSym() const {
        return 'B';
    }
};

class King : public Piece {
    King(bool black) : Piece(black) {
    }
    const char getSym() const {
        return 'K';
    }
};


class Field {
    Piece *m_content;
public:
    Field() {
        m_content = NULL;
    }
    const Piece *put(Piece& p) {
        Piece *old = m_content;
        m_content = &p;
        return old;
    }
    const Piece *remove() {
        Piece *old = m_content;
        m_content = NULL;
        return old;
    }
    const Piece* get() const {
        return m_content;
    }
};
const static int DIM = 8;

const static std::string ROWNAMES = "ABCDEFGH";
const static std::string COLNAMES = "12345678";

struct Point {
    int x, y;
    Point(int ax, int ay) : x(ax), y(ay) {
    }
    static Point convert(std::string pos) {
        size_t y = ROWNAMES.find(pos[0]);
        size_t x = COLNAMES.find(pos[1]);
        if (x == std::string::npos || y == std::string::npos) {
            throw std::runtime_error("can't parse " + pos);
        }
        return Point(x, y);
    }
};  

class Board {
    Field m_b[DIM * DIM];
public:
    Field& get(Point p) {
        return m_b[p.x + DIM*p.y];
    }
    const Field& at(Point p) const {
        return m_b[p.x + DIM*p.y];
    }
    Field& get(const std::string& pos) {
        return this->get(Point::convert(pos));
    }
};

std::ostream& operator<<(std::ostream &strm, const Field &f) {
    const Piece *p = f.get();
    strm << (p == NULL ? '.' : p->sym());
    return strm;
}

std::ostream& operator<<(std::ostream &strm, const Board &b) {
    strm << "  1 2 3 4 5 6 7 8" << std::endl;
    Point p(0, 0);
    for (int y=0; y<DIM; y++) {
        p.y = y;
        strm << ROWNAMES[y] << ' ';
        for (int x=0; x<DIM; x++) {
            p.x = x;
            strm << b.at(p) << ' ';
        }
        strm << std::endl;
    }
    strm << std::endl;
    return strm;
}

int main(int argc, char **argv) {
    Pawn w_p(false);
    Pawn b_p(true);
    Board b;

    b.get("F2").put(w_p);
    std::cout << b << std::endl;
    b.get("C3").put(b_p);
    std::cout << b << std::endl;

    Rook w_r(false);
    b.get("H7").put(w_r);
    std::cout << b << std::endl;
    return 0;
}


