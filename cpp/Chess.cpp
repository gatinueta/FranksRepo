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
    Point& operator+=(const Point& p) {
        x += p.x;
        y += p.y;
        return *this;
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

class Field;

class Piece {
   bool m_black;
protected:
   const Field* m_field;
   std::vector<Point> getDirectTargets() const;
   std::vector<Point> getIterTargets() const;
public:
   Piece() : m_field(nullptr) {
   }
   void setField(const Field *field) {
     m_field = field;
   }
   const Field *getField() const {
     return m_field;
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

   virtual const std::vector<Point> getIncs() const {
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
    std::vector<Point> getTargets() const;
};

class Knight : public Piece {
    static const std::vector<Point> M_INCS;
public:
    const char getSym() const {
        return 'N';
    }
    const std::vector<Point> getIncs() const {
        return M_INCS;
    }
    std::vector<Point> getTargets() const;
};

const std::vector<Point> Knight::M_INCS = { 
    Point(1,-2), Point(1,2), 
    Point(2,-1), Point(2,1), 
    Point(-1,-2), Point(-1,2), 
    Point(-2,-1), Point(-2,1)
};

class Rook : public Piece {
    const static std::vector<Point> M_INCS;
public:
    const char getSym() const {
        return 'R';
    }
    std::vector<Point> getTargets() const;
    const std::vector<Point> getIncs() const {
        return M_INCS;
    }
};

class Queen : public Piece {
    const static std::vector<Point> M_INCS;
public:
    const char getSym() const {
        return 'Q';
    }
    std::vector<Point> getTargets() const;
    const std::vector<Point> getIncs() const {
        return M_INCS;
    }
};

class Bishop : public Piece {
    const static std::vector<Point> M_INCS;
public: 
    const char getSym() const {
        return 'B';
    }
    std::vector<Point> getTargets() const;
    const std::vector<Point> getIncs() const {
        return M_INCS;
    }
};

const std::vector<Point> Bishop::M_INCS = {
    Point(1,-1), Point(1,1), 
    Point(-1,-1), Point(-1,1)
};

const std::vector<Point> Rook::M_INCS = {
    Point(1,0), Point(0,1),
    Point(-1,0), Point(0,-1)
};

const std::vector<Point> Queen::M_INCS = {
    Point(1,-1), Point(1,1), 
    Point(-1,-1), Point(-1,1),
    Point(1,0), Point(0,1),
    Point(-1,0), Point(0,-1)
};


class King : public Piece {
    const static std::vector<Point> M_INCS;
public:
    const char getSym() const {
        return 'K';
    }
    bool isKing() const {
        return true;
    }
    const std::vector<Point> getIncs() const {
        return M_INCS;
    }
    std::vector<Point> getTargets() const;
};

const std::vector<Point> King::M_INCS = { 
    Point(1,-1), Point(1,0), Point(1,1), 
    Point(0,-1), Point(0,1), 
    Point(-1,-1), Point(-1,0), Point(-1,1) 
};


class Board;

class Field {
    Piece *m_content;
    const Board *m_b;
    Point m_pos;
public:
    void init(const Point pos, const Board *b) {
        m_pos = pos;
        m_b = b;
    }
    Point getPos() const {
        return m_pos;
    }
    const Board* getBoard() const {
        return m_b;
    }
    Field() {
        m_content = nullptr;
    }
    const Piece *put(Piece& p) {
        Piece *old = m_content;
        m_content = &p;
        if (old != nullptr) {
            old->setField(nullptr);
        }
        p.setField(this);
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
    bool isEmpty() const {
        return m_content == nullptr;
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
                f.init(p, this);
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
                    m_bKingPos = field.getPos();
                    n_bKings++;
                 } else {
                    m_wKingPos = field.getPos();
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

std::vector<Point> Piece::getDirectTargets() const {
    std::vector<Point> targets;
    const Board *b = m_field->getBoard();
    for (Point inc: getIncs()) {
        Point target = m_field->getPos() + inc;
        if (target.isOnBoard()) {
            if ( b->at(target).isEmpty() || b->at(target).get()->isBlack() != isBlack()) {
                targets.push_back(target);
            }
        }
    }
    return targets;
}

std::vector<Point> Piece::getIterTargets() const {
    std::vector<Point> targets;
    const Board *b = m_field->getBoard();
    for (Point inc: getIncs()) {
        Point target = m_field->getPos();
        while(true) {
            target += inc;
            if (!target.isOnBoard()) {
                break;
            }
            if ( b->at(target).isEmpty()) {
                targets.push_back(target);
            } else if (b->at(target).get()->isBlack() == isBlack()) {
                break;
            } else {
                targets.push_back(target);
                break;
            }
        }
    }
    return targets;
}

std::vector<Point> King::getTargets() const {
    return getDirectTargets();
}

std::vector<Point> Knight::getTargets() const {
    return getDirectTargets();
}

std::vector<Point> Bishop::getTargets() const {
    return getIterTargets();
}

std::vector<Point> Rook::getTargets() const {
    return getIterTargets();
}

std::vector<Point> Queen::getTargets() const {
    return getIterTargets();
}

std::vector<Point> Pawn::getTargets() const {
    std::vector<Point> targets;
    const Board *b = m_field->getBoard();
    Point pos = m_field->getPos();
    Point straightTarget = pos + (isBlack() ? Point(0, -1) : Point(0, 1));
    Point doubleStepTarget = pos + (isBlack() ? Point(0, -2) : Point(0, 2));
    Point capTarget1 = pos + (isBlack() ? Point(1, -1) : Point(1, 1));
    Point capTarget2 = pos + (isBlack() ? Point(-1, -1) : Point(-1, 1));

    if (straightTarget.isOnBoard() && b->at(straightTarget).isEmpty()) {
        targets.push_back(straightTarget);
        if ((isBlack() && pos.y == DIM-2) ||
            (!isBlack() && pos.y == 1)) {
            if (doubleStepTarget.isOnBoard() && b->at(doubleStepTarget).isEmpty()) {
                targets.push_back(doubleStepTarget);
            }
        }
    }
    for (Point capTarget: { capTarget1, capTarget2 }) {
        if (capTarget.isOnBoard() && !b->at(capTarget).isEmpty() && b->at(capTarget).get()->isBlack() != isBlack()) {
            targets.push_back(capTarget);
        }
        //TODO en passant
    }
    return targets;
}

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


typedef std::shared_ptr<Piece> P_Piece;

template<typename T>
static std::shared_ptr<T> add(Board& b, const char col, const char row, bool black, std::vector<P_Piece>& ptrs) {
    auto w_piece = std::make_shared<T>();
    w_piece->setBlack(black);
    b.get(col, row).put(*w_piece);
    ptrs.push_back(w_piece);
    return w_piece;
}

static auto place_pawns(Board& b, const char row, const bool black) {
    std::vector<P_Piece> ptrs;
    for (int i=0; i<DIM; i++) {
        add<Pawn>(b, COLNAMES[i], row, black, ptrs);
    }
    return ptrs; 
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

static auto setup(Board& b) {
    auto white_pawns = place_pawns(b, '2', false);
    auto black_pawns = place_pawns(b, '7', true);
    auto white_pieces = place_pieces(b, '1', false);
    auto black_pieces = place_pieces(b, '8', true);
    if (!b.validate()) {
        std::cout << "error: validate failed" << std::endl;
    }
    std::vector<P_Piece> all_pieces;
    all_pieces.insert(all_pieces.end(), white_pawns.begin(), white_pawns.end());
    all_pieces.insert(all_pieces.end(), black_pawns.begin(), black_pawns.end());
    all_pieces.insert(all_pieces.end(), white_pieces.begin(), white_pieces.end());
    all_pieces.insert(all_pieces.end(), black_pieces.begin(), black_pieces.end());
    return all_pieces;
}

int main(int argc, char **argv) {
    Board b;
    auto pieces = setup(b);

    // test code
    std::cout << "black king pos is " << b.getKingPos(true) << std::endl;
    const Piece* wKing = b.get(b.getKingPos(false)).get();
    auto targets = wKing->getTargets();
    std::cout << "white king targets: " << targets << std::endl;
    const Piece* bKnight = b.get("B8").get();
    targets = bKnight->getTargets();
    std::cout << "black knight targets: " << targets << std::endl;
    Bishop bi;
    b.get("D4").put(bi);
    std::cout << b << std::endl;
    std::cout << "white bishop targets: " << bi.getTargets() << std::endl;
    b.get("D4").remove();
    targets = b.get("D7").get()->getTargets();
    std::cout << "D7 pawn targets: " << targets << std::endl; 
    return 0;
}


