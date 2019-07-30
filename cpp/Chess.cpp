#include <iostream>
#include <array>
#include <vector>
#include <list>
#include <algorithm>
#include <memory>
#include <iterator>
#include <sstream>

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
    bool operator==(const Point& p) {
        return x == p.x && y == p.y;
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
protected:
   bool m_black;
   Field* m_field;
   std::vector<Point> getDirectTargets() const;
   std::vector<Point> getIterTargets() const;
   int m_nofMoves;
public:
   Piece() : m_field(nullptr), m_nofMoves(0) {
   }
   virtual void setField(Field *field) {
     m_field = field;
   }
   const Field *getField() const {
     return m_field;
   }
   Field *getFieldForUpdate() {
     return m_field;
   }
   void setBlack(bool black) {
     m_black = black;
   }
   bool isBlack() const {
     return m_black;
   }
   int getNofMoves() const {
     return m_nofMoves;
   }
   void incNofMoves(int inc) {
     m_nofMoves += inc;
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
   virtual std::vector<Point> getTargets() const = 0;

   virtual const std::vector<Point> getIncs() const {
     return {};
   }
   std::vector<Point> getMoves() const;
   virtual float value() const = 0;
   virtual ~Piece() {
   }
};

class Pawn : public Piece {
    Piece *m_promoted;
public:
    Pawn() : m_promoted(nullptr) {
        std::cout << "creating pawn" << std::endl;
        
    }
    const char getSym() const { 
        if (m_promoted) {
            return m_promoted->getSym();
        } else {
            return 'P';
        }
    }
    ~Pawn() {
        std::cout << "destroying pawn" << std::endl;
        if (m_promoted) {
            delete m_promoted;
        }
    }
    bool isPawn() const {
        return m_promoted == nullptr;
    }
    std::vector<Point> getTargets() const;
    
    void setField(Field* f) {
        Piece::setField(f);
        if (m_promoted) {
            m_promoted->setField(f);
        }
    }

    template<typename T> void promote() {
        if (m_promoted != nullptr) {
            std::ostringstream strstream;
            strstream << "already promoted to " << m_promoted;
            
            throw std::runtime_error(strstream.str());
        }
        m_promoted = new T();
        m_promoted->setBlack(m_black);
        m_promoted->setField(m_field);
    }
    void unpromote() {
        delete m_promoted;
        m_promoted = nullptr;
    }
    float value() const {
        if (m_promoted) {
            return m_promoted->value();
        } else {
            return 1.0;
        }
    }
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
    float value() const {
        return 3.5;
    }
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
    float value() const {
        return 5.0;
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
    float value() const {
        return 9.0;
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
    float value() const {
        return 3.5;
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
    float value() const {
        return 1000.0;
    }
};

const std::vector<Point> King::M_INCS = { 
    Point(1,-1), Point(1,0), Point(1,1), 
    Point(0,-1), Point(0,1), 
    Point(-1,-1), Point(-1,0), Point(-1,1) 
};


class Board;

class Field {
    Piece *m_content;
    Board *m_b;
    Point m_pos;
public:
    void init(const Point pos, Board *b) {
        m_pos = pos;
        m_b = b;
    }
    Point getPos() const {
        return m_pos;
    }
    const Board* getBoard() const {
        return m_b;
    }
    Board* getBoardForUpdate() {
        return m_b;
    }
    Field() {
        m_content = nullptr;
    }
    Piece *put(Piece& p);
    Piece *remove();
    const Piece* get() const {
        return m_content;
    }
    Piece* getPiece() {
        return m_content;
    }
    bool isEmpty() const {
        return m_content == nullptr;
    }
};

class Game;

class Board {
    Field m_b[DIM * DIM];
    std::list<Piece*> m_whitePieces;
    std::list<Piece*> m_blackPieces;
    bool m_whitesTurn;
    Point m_bKingPos, m_wKingPos;
    Game *m_game;
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
    void setGame(Game *game) {
        m_game = game;
    }
    Game *getGame() {
        return m_game;
    }
    bool hasThreats(Point point, bool black) const;
    std::list<Piece*>& getPieces(bool black) {
        if (black) {
            return m_blackPieces;
        } else {
            return m_whitePieces;
        }
    }
    const std::list<Piece*>& getConstPieces(bool black) const {
        if (black) {
            return m_blackPieces;
        } else {
            return m_whitePieces;
        }
    }
    Point getKingPos(bool black) const {
        return black ? m_bKingPos : m_wKingPos;
    }
    void setKingPos(bool black, Point pos) {
        if (black) {
            m_bKingPos = pos;
        } else {
            m_wKingPos = pos;
        }
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
    void setWhitesTurn(bool whitesTurn) {
        m_whitesTurn = whitesTurn;
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
    float eval() {
        float value = 0.0;
        for (Piece *p: m_whitePieces) {
            value += p->value();
        }
        for (Piece *p: m_blackPieces) {
            value -= p->value();
        }
        return value;
    }
};

Piece *Field::put(Piece& p) {
        Piece *old = m_content;
        m_content = &p;
        if (old != nullptr) {
            old->setField(nullptr);
            m_b->getPieces(old->isBlack()).remove(old);
        }
        p.setField(this);
        m_b->getPieces(p.isBlack()).push_back(&p);
        return old;
}

Piece *Field::remove() {
        Piece *old = m_content;
        m_content = nullptr;
        m_b->getPieces(old->isBlack()).remove(old);
        return old;
}
    
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
    std::vector<Point> directTargets = getDirectTargets();
    if (m_nofMoves == 0 && m_field->getPos().y == 4) {
        const Board *b = m_field->getBoard();
        int row = m_field->getPos().y;
        if (!b->at(Point(0, row)).isEmpty() && 
            b->at(Point(0, row)).get()->getNofMoves() == 0 &&
            b->at(Point(1, row)).isEmpty() &&
            b->at(Point(2, row)).isEmpty() &&
            b->at(Point(3, row)).isEmpty() &&
            !b->hasThreats(Point(3, row), m_black) &&
            !b->hasThreats(Point(4, row), m_black)
         ) {
            directTargets.push_back(Point(2, row));
         }
         if (!b->at(Point(7, row)).isEmpty() &&
            b->at(Point(7, row)).get()->getNofMoves() == 0 &&
            b->at(Point(6, row)).isEmpty() &&
            b->at(Point(5, row)).isEmpty() &&
            !b->hasThreats(Point(4, row), m_black) &&
            !b->hasThreats(Point(5, row), m_black)
          ) {
            directTargets.push_back(Point(6, row));
          }
     }
     return directTargets;
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
    if (m_promoted) {
        return m_promoted->getTargets();
    } 
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


std::ostream& operator<<(std::ostream &strm, const Piece &p) {
    if (p.getField()) {
        strm << p.sym() << p.getField()->getPos();
    } else {
        strm << p.sym() << "(OFFBOARD)";
    }
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


struct Move {
    Move() : piece(nullptr), capturedPiece(nullptr) {
    }
    Point from;
    Point to;
    Piece *piece;
    Piece *capturedPiece;
    bool promotion;
    bool castling;
};

std::ostream& operator<< (std::ostream& out, const Move& m) {
    std::string cap;
    if (m.capturedPiece != nullptr) {
        cap = "X";
    }
    if (m.castling) {
        if (m.from.y < m.to.y) {
            out << "0-0";
        } else {
            out << "0-0-0";
        }
    } else {
        out << m.piece->getSym() << m.from << cap << m.to;
        if (m.promotion) {
            out << "=" << *m.piece;
        }
    }
    return out;
}

class Game {
    Board m_b;
    std::vector<P_Piece> m_ptr_pieces;
    std::vector<Move> m_moves;
public:
    Game() {
        m_b.setGame(this);
    }
    const std::vector<Move>& getMoves() const {
        return m_moves;
    }
    Board& getBoard() {
        return m_b;
    }
    void setBoard(Board& b) {
        m_b = b;
    }

    void setup() {
        auto white_pawns = place_pawns(m_b, '2', false);
        auto black_pawns = place_pawns(m_b, '7', true);
        auto white_pieces = place_pieces(m_b, '1', false);
        auto black_pieces = place_pieces(m_b, '8', true);
        if (!m_b.validate()) {
            std::cout << "error: validate failed" << std::endl;
        }
        m_ptr_pieces.insert(m_ptr_pieces.end(), white_pawns.begin(), white_pawns.end());
        m_ptr_pieces.insert(m_ptr_pieces.end(), black_pawns.begin(), black_pawns.end());
        m_ptr_pieces.insert(m_ptr_pieces.end(), white_pieces.begin(), white_pieces.end());
        m_ptr_pieces.insert(m_ptr_pieces.end(), black_pieces.begin(), black_pieces.end());
    }
    const Move *makeMove(Piece& p, Point to) {
        if (p.isBlack() == m_b.whitesTurn()) {
           std::cout << "error: moving " << p << ", white's turn: " << m_b.whitesTurn() << std::endl;
           return nullptr;
        }
        Move move;
        move.from = p.getField()->getPos();
        move.to = to;
        move.piece = &p;
        
        m_b.get(move.from).remove();
        move.capturedPiece = m_b.get(to).put(p);
        if (p.isPawn() && (to.y == 0 || to.y == DIM-1)) {
           dynamic_cast<Pawn&>(p).promote<Queen>();
           move.promotion = true;
        } else {
           move.promotion = false;
        }
        if (p.isKing() && abs(move.to.x-move.from.x) > 1) {
            move.castling = true;
            Point rookTarget = Point(move.from.x, (move.to.y+move.from.y)/2);
            Point rookPos = Point(move.from.x, move.to.y > move.from.y ? 7 : 0);
            Piece* rook = m_b.get(rookPos).remove();
            m_b.get(rookTarget).put(*rook);
        } else {
            move.castling = false;
        }

        m_moves.push_back(move);
        p.incNofMoves(1);
        m_b.setWhitesTurn(!m_b.whitesTurn());
        if (p.isKing()) {
            m_b.setKingPos(p.isBlack(), to);
        }
        return &m_moves.back();
    }

    bool retractMove() {
        if (m_moves.size() == 0) {
            return false;
        }
        Move& move = m_moves.back();
        Piece* p = m_b.get(move.to).remove();
        if (p != move.piece) {
            std::cerr << "can't find piece of last move" << std::endl;
            return false;
        }
        if (move.promotion) {
            dynamic_cast<Pawn*>(p)->unpromote();
        }
        m_moves.pop_back();
        m_b.get(move.from).put(*p);
        if (move.castling) {
            Point rookTarget = Point(move.from.x, (move.to.y+move.from.y)/2);
            Point rookPos = Point(move.from.x, move.to.y > move.from.y ? 7 : 0);
            Piece *rook = m_b.get(rookTarget).remove();
            m_b.get(rookPos).put(*rook);
        }
        p->incNofMoves(-1);

        if (move.capturedPiece != nullptr) {
            m_b.get(move.to).put(*move.capturedPiece);
        }
        m_b.setWhitesTurn(!m_b.whitesTurn());
         if (p->isKing()) {
            m_b.setKingPos(p->isBlack(), move.from);
        }
        return true;
    }

    Move getBestMove() {
        float bestEval = -1000;
        Move bestMove;
        bool whitesTurn = m_b.whitesTurn();
        auto activePieces = m_b.getPieces(!whitesTurn);
        for (Piece *p: activePieces) {
            for (Point target: p->getMoves()) {
                const Move* move = makeMove(*p, target);
                float evaluation = m_b.eval();
                std::cout << "eval of " << *move << ": " << evaluation << std::endl;
                if (!whitesTurn) {
                    evaluation = -evaluation;
                }
                if (evaluation > bestEval) {
                    bestEval = evaluation;
                    bestMove = *move;
                }
                retractMove();
            }
        }
        return bestMove;
    }
        
};   

bool Board::hasThreats(Point point, bool black) const {
   for (Piece* p: getConstPieces(!black)) {
        auto oppTargets = p->getTargets();
        if (std::find(oppTargets.begin(), oppTargets.end(), point) != oppTargets.end()) {
            return true;
        }
   }
   return false;
}

std::vector<Point> Piece::getMoves() const {
     Piece* that = const_cast<Piece*>(this);
     Game *game = that->m_field->getBoardForUpdate()->getGame();
     std::vector<Point> moves;
     std::vector<Point> targets = getTargets();
     for (Point target: getTargets()) {
        // check if check
        game->makeMove(*that, target);
        Point kingPos = game->getBoard().getKingPos(this->isBlack()); 
        bool inCheck = game->getBoard().hasThreats(kingPos, this->isBlack());
        if (inCheck) {
            std::cout << *this << target << " doesn't work because " << kingPos << " is in check"  << std::endl;
        }
        game->retractMove();
        if (!inCheck) {
            moves.push_back(target);
        }
     }
     return moves;
}

void playGame(Game& g) {
    while(true) {
        std::cout << g.getBoard() << std::endl;
        Move move = g.getBestMove();
        if (move.piece) {
            g.makeMove(*move.piece, move.to);
            std::cout << "made move: " << g.getMoves().back() << std::endl;
        } else {
            break;
        }
    }
}

int main(int argc, char **argv) {
    Game g;
    g.setup();
    Board& b = g.getBoard();

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
    std::cout << "white bishop moves: " << bi.getMoves() << std::endl;
    b.get("D4").remove();
    targets = b.get("D7").get()->getTargets();
    std::cout << "D7 pawn targets: " << targets << std::endl; 
    Piece *pawn = b.get("D2").getPiece();
    if (!g.makeMove(*pawn, pawn->getTargets()[0])) {
        std::cout << "can't make the move to " << targets[0] << std::endl;
    }
    std::cout << b << std::endl;
    g.retractMove();
    
    playGame(g);
}


void random_game(Board& b, Game& g) {
    while(true) {
        std::cout << b << std::endl;
        auto activePieces = b.getPieces(!b.whitesTurn());
        std::vector<Piece*> piecesVec = { std::begin(activePieces), std::end(activePieces) };
        std::random_shuffle(piecesVec.begin(), piecesVec.end());
        Piece *movingPiece = nullptr;
        Point target;
        for (Piece *p: activePieces) {
            std::vector<Point> moves = p->getMoves();
            std::random_shuffle(moves.begin(), moves.end());
            if (moves.size() > 0) {
                movingPiece = p;
                target = moves[0];
            }
            std::cout << *p << ": " << moves << std::endl;
        }
        if (movingPiece == nullptr || !g.makeMove(*movingPiece, target)) {
            break;
        }
        std::cout << "made move: " << g.getMoves().back() << std::endl;
    }
}


