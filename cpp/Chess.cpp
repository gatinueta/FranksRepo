#include <iostream>

class Piece {
   bool m_black;
public:
   void setBlack(bool black) {
     std::cout << "setting black to " << black << std::endl;
     m_black = black;
   }
   bool isBlack() const {
     return m_black;
   }
   virtual const char getSym() const = 0;
   
   const char sym() const {
     return m_black ? getSym() : tolower(getSym());
   }
};

class Pawn : public Piece {
public:
    const char getSym() const { 
        return 'P';
    }
};

class Knight : public Piece {
public:
    const char getSym() const {
        return 'N';
    }
};

class Rook : public Piece {
public:
    const char getSym() const {
        return 'R';
    }
};

class Queen : public Piece {
public:
    const char getSym() const {
        return 'Q';
    }
};

class Bishop : public Piece {
    const char getSym() const {
        return 'B';
    }
};

class King : public Piece {
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

void place_pawns(Board& b, const std::string& col, const bool black) {
    std::unique_ptr<Pawn[]> pawns = std::make_unique<Pawn[]>(8);
    for (int i=0; i<8; i++) {
        pawns[i].setBlack(black);
        std::string pos(col);
        pos += COLNAMES[i];
        b.get(pos).put(pawns[i]);
    }
}

int main(int argc, char **argv) {
    Pawn w_p;
    Pawn b_p;
    b_p.setBlack(true);
    Board b;

    b.get("F2").put(w_p);
    std::cout << b << std::endl;
    b.get("C3").put(b_p);
    std::cout << b << std::endl;

    Rook w_r;
    b.get("H7").put(w_r);
    place_pawns(b, "A", false);
    std::cout << b.get("A3").get()->isBlack() << ", " << b.get("H4").get()->isBlack() << std::endl;
    place_pawns(b, "H", true);
    std::cout << b << std::endl;
    return 0;
}


