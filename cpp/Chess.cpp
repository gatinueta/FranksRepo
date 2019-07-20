#include <iostream>
#include <array>
#include <vector>

const static int DIM = 8;

const static std::string COLNAMES = "ABCDEFGH";
const static std::string ROWNAMES = "12345678";

struct Point {
    int x, y;
    Point(int ax, int ay) : x(ax), y(ay) {
    }
    Point() : Point(0, 0) {
    }
    static Point convert(const char col, const char row) {
        size_t x = COLNAMES.find(col);
        size_t y = ROWNAMES.find(row);
        if (x == std::string::npos || y == std::string::npos) {
            std::string msg("can't parse ");
            msg += col;
            msg += row;
            throw std::runtime_error(msg);
        }
        return Point(x, y);
    }
    static Point convert(const std::string& pos) {
        return convert(pos[0], pos[1]);
    }
    const static Point OFFBOARD;

    Point operator+(const Point& p) const {
        Point res(x, y);
        res.x += p.x;
        res.y += p.y;
        return res;
    }
    bool isOnBoard() const {
        return x >= 0 && x < DIM && y >= 0 && y < DIM;
    }

}; 

const Point Point::OFFBOARD = Point(-1, -1);

std::ostream& operator<<(std::ostream &strm, const Point &p) {
    strm << COLNAMES[p.x] << ROWNAMES[p.y];
    return strm;
}

class Piece {
   bool m_black;
protected:
   Point m_pos;
public:
   Piece() : m_pos(Point::OFFBOARD) {
   }
   void setPos(const Point& pos) {
     m_pos = pos;
   }
   Point getPos() const {
     return m_pos;
   }
   void setBlack(bool black) {
     m_black = black;
   }
   bool isBlack() const {
     return m_black;
   }
   virtual const char getSym() const = 0;
   
   const char sym() const {
     return m_black ? getSym() : tolower(getSym());
   }
   virtual bool isKing() const {
     return false;
   }
   virtual bool isPawn() const {
     return false;
   }
   virtual std::vector<Point> getTargets() const { // TODO pure virtual?
     return {};
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
    bool isPawn() const {
        return true;
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
    const static Point M_INCS[];
public:
    const char getSym() const {
        return 'K';
    }
    bool isKing() const {
        return true;
    }

    std::vector<Point> getTargets() const;
};

const Point King::M_INCS[] = { 
    Point(1,-1), Point(1,0), Point(1,1), 
    Point(0,-1), Point(0,1), 
    Point(-1,-1), Point(-1,0), Point(-1,1) 
};

std::vector<Point> King::getTargets() const {
        std::vector<Point> targets;
        for (Point inc: M_INCS) {
            Point target = m_pos + inc;
            if (target.isOnBoard()) {
                targets.push_back(target);
            }
        }
        return targets;
}


class Field {
    Piece *m_content;
public:
    Point m_pos; // TODO not public
    Point getPos() const {
        return m_pos;
    }
    Field() {
        m_content = nullptr;
    }
    const Piece *put(Piece& p) {
        Piece *old = m_content;
        m_content = &p;
        if (old != nullptr) {
            old->setPos(Point(-1, -1));
        }
        p.setPos(m_pos);
        return old;
    }
    const Piece *remove() {
        Piece *old = m_content;
        m_content = nullptr;
        return old;
    }
    const Piece* get() const {
        return m_content;
    }
};

class Board {
    Field m_b[DIM * DIM];
    bool m_whitesTurn;
    Point m_bKingPos, m_wKingPos;
public:
    Board() : m_whitesTurn(true) {
        Point p;
        for (int y=0; y<DIM; y++) {
            p.y = y;
            for (int x=0; x<DIM; x++) {
                p.x = x;
                Field& f = get(p);
                f.m_pos = p;
            }
        }
    }

    Point getKingPos(bool black) const {
        return black ? m_bKingPos : m_wKingPos;
    }
    Field& get(Point p) {
        return m_b[p.y + DIM*p.x];
    }
    const Field& at(Point p) const {
        return m_b[p.y + DIM*p.x];
    }
    Field& get(const std::string& pos) {
        return get(Point::convert(pos));
    }
    Field& get(const char col, const char row) {
        return get(Point::convert(col, row));
    }
    bool whitesTurn() const {
        return m_whitesTurn;
    }
    bool validate() {
        int n_wKings = 0, n_bKings = 0;
        for(const Field& field : m_b) {
            if (field.get() && field.get()->isKing()) {
                if (field.get()->isBlack()) {
                    m_bKingPos = field.m_pos;
                    n_bKings++;
                 } else {
                    m_wKingPos = field.m_pos;
                    n_wKings++;
                 }
            }
         }
         if (n_wKings != 1 || n_bKings != 1) {
            std::cerr << "n_wKings=" << n_wKings << ", n_bKings=" << n_bKings << std::endl;
            return false;
         }
         for (int x=0; x<DIM; x++) {
            for (auto row: { '1', '8' }) {
                Field& f = get(COLNAMES[x], row);
                if (f.get() && f.get()->isPawn()) {
                    std::cerr << "pawn on " << f.getPos() << std::endl;
                    return false;
                }
            }
         }
         return true;
    }
};

std::ostream& operator<<(std::ostream &strm, const Field &f) {
    const Piece *p = f.get();
    strm << (p == nullptr ? '.' : p->sym());
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
    std::array<Pawn,DIM>& pawns = *pawns_p;
    for (int i=0; i<DIM; i++) {
        pawns[i].setBlack(black);
        b.get(COLNAMES[i], row).put(pawns[i]);
    }
    return pawns_p; 
}

typedef std::shared_ptr<Piece> P_Piece;

template<typename T>
static std::shared_ptr<T> add(Board& b, const char col, const char row, bool black, std::vector<P_Piece>& ptrs) {
    auto w_piece = std::make_shared<T>();
    w_piece->setBlack(black);
    b.get(col, row).put(*w_piece);
    ptrs.push_back(w_piece);
    return w_piece;
}

static auto place_pieces(Board& b, const char row, const bool black) {
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

template <typename T>
std::ostream& operator<< (std::ostream& out, const std::vector<T>& v) {
  if ( !v.empty() ) {
    out << '[';
    std::copy (v.begin(), v.end(), std::ostream_iterator<T>(out, ", "));
    out << "\b\b]";
  }
  return out;
}


int main(int argc, char **argv) {
    Board b;

    auto white_pawns = place_pawns(b, '2', false);
    std::cout << "got shared ptr " << white_pawns << std::endl;
    auto black_pawns = place_pawns(b, '7', true);
    auto white_pieces = place_pieces(b, '1', false);
    auto black_pieces = place_pieces(b, '8', true);
    if (!b.validate()) {
        std::cout << "error: validate failed" << std::endl;
    }
    std::cout << "black king pos is " << b.getKingPos(true) << std::endl;
    std::cout << b << std::endl;
    const Piece* wKing = b.get(b.getKingPos(false)).get();
    auto targets = wKing->getTargets();
    std::cout << "white king targets: " << targets << std::endl;
    return 0;
}


