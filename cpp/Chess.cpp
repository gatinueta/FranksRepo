#include <iostream>
#include <array>
#include <vector>

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
    Pawn() {
        std::cout << "creating pawn" << std::endl;
    }
    const char getSym() const { 
        return 'P';
    }
    ~Pawn() {
        std::cout << "destroying pawn" << std::endl;
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

const static std::string COLNAMES = "ABCDEFGH";
const static std::string ROWNAMES = "12345678";

struct Point {
    int x, y;
    Point(int ax, int ay) : x(ax), y(ay) {
    }
    static Point convert(std::string pos) {
        size_t x = COLNAMES.find(pos[0]);
        size_t y = ROWNAMES.find(pos[1]);
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
        return m_b[p.y + DIM*p.x];
    }
    const Field& at(Point p) const {
        return m_b[p.y + DIM*p.x];
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
    strm << "  A B C D E F G H" << std::endl;
    Point p(0, 0);
    for (int y=DIM-1; y>=0; y--) {
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

static auto place_pawns(Board& b, const char row, const bool black) {
    auto pawns_p = std::make_shared<std::array<Pawn,8>>();
    std::array<Pawn,8>& pawns = *pawns_p;
    for (int i=0; i<8; i++) {
        pawns[i].setBlack(black);
        std::string pos;
        pos += COLNAMES[i];
        pos += row;
        b.get(pos).put(pawns[i]);
    }
    return pawns_p; 
}

typedef std::shared_ptr<Piece> P_Piece;

template<typename T>
static std::shared_ptr<T> add(Board& b, const char col, const char row, bool black, std::vector<P_Piece>& ptrs) {
    auto w_piece = std::make_shared<T>();
    std::string pos;
    pos += col; 
    pos += row;
    w_piece->setBlack(black);
    b.get(pos).put(*w_piece);
    ptrs.push_back(w_piece);
    return w_piece;
}

static auto place_pieces(Board& b, const char row, const bool black) {
    Rook w_r2;
    Bishop w_b1, w_b2;
    Knight w_n1, w_n2;
    Queen w_q;
    King w_k;
    
    std::vector<P_Piece> ptrs;
    
    add<Rook>(b, 'A', row, black, ptrs);
    add<Rook>(b, 'H', row, black, ptrs);
    add<Knight>(b, 'B', row, black, ptrs);
    add<Knight>(b, 'G', row, black, ptrs);
    add<Bishop>(b, 'C', row, black, ptrs);
    add<Bishop>(b, 'F', row, black, ptrs);
    add<Queen>(b, 'D', row, black, ptrs);
    add<King>(b, 'E', row, black, ptrs);
    return ptrs;
}

int main(int argc, char **argv) {
    Board b;

    auto white_pawns = place_pawns(b, '2', false);
    std::cout << "got shared ptr " << white_pawns << std::endl;
    auto black_pawns = place_pawns(b, '7', true);
    auto white_pieces = place_pieces(b, '1', false);
    auto black_pieces = place_pieces(b, '8', true);
    std::cout << b << std::endl;
    return 0;
}


