#include <iostream>
#include <array>
#include <vector>
#include <list>
#include <algorithm>
#include <memory>
#include <iterator>
#include <sstream>
#include <fstream>

#include <boost/archive/text_iarchive.hpp>
#include <boost/archive/text_oarchive.hpp>
#include <boost/serialization/export.hpp>
#include <boost/serialization/vector.hpp>
#include <boost/serialization/list.hpp>
#include <boost/serialization/unique_ptr.hpp>
#include <boost/serialization/shared_ptr.hpp>

//#define USEDEBUG

#ifdef USEDEBUG
#define Debug(x) std::cout << x << std::endl;
#else
#define Debug(x) 
#endif 

// Forward declaration of class boost::serialization::access
namespace boost {
namespace serialization {
class access;
}
}

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
    bool operator==(const Point& p) const {
        return x == p.x && y == p.y;
    }
    bool isOnBoard() const {
        return x >= 0 && x < DIM && y >= 0 && y < DIM;
    }
    template<typename Archive>
    void serialize(Archive& ar, const unsigned version) {
        ar & x & y; 
    }

}; 

const Point Point::OFFBOARD = Point(-1, -1);

std::ostream& operator<<(std::ostream &strm, const Point &p) {
    strm << COLNAMES[p.x] << ROWNAMES[p.y];
    return strm;
}

class Field;

class Piece {
    friend class boost::serialization::access;
protected:
   bool m_black;
   Field* m_field;
   std::vector<Point>& getDirectTargets();
   std::vector<Point>& getIterTargets();
   int m_nofMoves;
   std::vector<Point> m_targets;
   std::vector<Point> m_moveTargets;
   virtual const std::vector<Point>& getIncs() const {
     // can't be pure virtual because it has to be implemented even if not called
     throw std::runtime_error("getIncs() not implemented");
   }
public:
   Piece() : m_field(nullptr), m_nofMoves(0) {
   }
   virtual void setField(Field *field) {
     m_field = field;
   }
   const Field *getField() const {
     return m_field;
   }
   Field *getField() {
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
   virtual const std::vector<Point>& getTargets() = 0;

   const std::vector<Point>& getMoveTargets();
   virtual bool isMoveTarget(Point origPos, Point target) const;
   virtual float value() const = 0;
   virtual ~Piece() {
   }
   template<typename Archive>
   void serialize(Archive& ar, const unsigned version) {
       ar & m_black & m_field & m_nofMoves;
   }
};

std::ostream& operator<<(std::ostream &strm, const Piece &p);

class Pawn : public Piece {
    std::unique_ptr<Piece> m_promoted;
public:
    Pawn() : m_promoted() {
        Debug("creating pawn");
    }
    const char getSym() const override { 
        if (m_promoted) {
            return m_promoted->getSym();
        } else {
            return 'P';
        }
    }
    ~Pawn() {
        Debug ("destroying pawn");
        if (m_promoted) {
            m_promoted.reset();
        }
    }
    bool isPawn() const override {
        return !m_promoted;
    }
    const std::vector<Point>& getTargets() override;
    
    void setField(Field* f) override {
        Piece::setField(f);
        if (m_promoted) {
            m_promoted->setField(f);
        }
    }

    template<typename T> void promote() {
        if (m_promoted) {
            std::ostringstream strstream;
            strstream << "already promoted to " << *m_promoted;
            
            throw std::runtime_error(strstream.str());
        }
        m_promoted = std::make_unique<T>();
        m_promoted->setBlack(m_black);
        m_promoted->setField(m_field);
    }
    void unpromote() {
        m_promoted.reset();
    }
    float value() const override {
        if (m_promoted) {
            return m_promoted->value();
        } else {
            return 1.0;
        }
    }

    template <typename Archive>
    void serialize(Archive &ar, const unsigned int version) {
        ar & boost::serialization::base_object<Piece>(*this);
        ar & m_promoted;
    }

};

class Knight : public Piece {
    static const std::vector<Point> M_INCS;
protected:
    const std::vector<Point>& getIncs() const override {
        return M_INCS;
    }
public:
    const char getSym() const override {
        return 'N';
    }
    const std::vector<Point>& getTargets() override;
    float value() const override {
        return 3.5;
    }
    template <typename Archive>
    void serialize(Archive &ar, const unsigned int version) {
            ar & boost::serialization::base_object<Piece>(*this);
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
protected:
    const std::vector<Point>& getIncs() const override {
        return M_INCS;
    }
public:
    const char getSym() const override {
        return 'R';
    }
    const std::vector<Point>& getTargets() override;
    float value() const override {
        return 5.0;
    }
    template <typename Archive>
    void serialize(Archive &ar, const unsigned int version) {
            ar & boost::serialization::base_object<Piece>(*this);
    }
};

class Queen : public Piece {
    const static std::vector<Point> M_INCS;
protected:
    const std::vector<Point>& getIncs() const override {
        return M_INCS;
    }
public:
    const char getSym() const override {
        return 'Q';
    }
    const std::vector<Point>& getTargets() override;
    float value() const override {
        return 9.0;
    }
    template <typename Archive>
    void serialize(Archive &ar, const unsigned int version) {
            ar & boost::serialization::base_object<Piece>(*this);
    }
};

class Bishop : public Piece {
    const static std::vector<Point> M_INCS;
protected:
    const std::vector<Point>& getIncs() const override {
        return M_INCS;
    }
public: 
    const char getSym() const override {
        return 'B';
    }
    const std::vector<Point>& getTargets() override;
    float value() const override {
        return 3.5;
    }
    template <typename Archive>
    void serialize(Archive &ar, const unsigned int version) {
            ar & boost::serialization::base_object<Piece>(*this);
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
protected:
    const std::vector<Point>& getIncs() const override {
        return M_INCS;
    }
public:
    const char getSym() const override {
        return 'K';
    }
    bool isKing() const override {
        return true;
    }
    const std::vector<Point>& getTargets() override;
    float value() const override {
        return 1000.0;
    }
    bool isMoveTarget(Point origPos, Point target) const override; 
    template <typename Archive>
    void serialize(Archive &ar, const unsigned int version) {
            ar & boost::serialization::base_object<Piece>(*this);
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
    Board* getBoard() {
        return m_b;
    }
    Field() {
        m_content = nullptr;
    }
    /**
     * putting a piece on this field, returning the one
     * that was there before
     */
    Piece *put(Piece& p);
    Piece *remove();
    const Piece* get() const {
        return m_content;
    }
    Piece* get() {
        return m_content;
    }
    bool isEmpty() const {
        return m_content == nullptr;
    }
    template<typename Archive>
    void serialize(Archive& ar, const unsigned version) {
       ar & m_content & m_b & m_pos;
    }
};

class Game;

class Board {
    Field m_b[DIM * DIM];
    std::list<Piece*> m_whitePieces;
    std::list<Piece*> m_blackPieces;
    bool m_blacksTurn;
    Point m_bKingPos, m_wKingPos;
    Game *m_game;
    bool m_inCheck = false;
public:
    Board() : m_blacksTurn(false) {
        Point p;
        for (int y=0; y<DIM; y++) {
            p.y = y;
            for (int x=0; x<DIM; x++) {
                p.x = x;
                Field& f = at(p);
                f.init(p, this);
            }
        }
    }
    bool possibleDiscoveryCheck(const Piece& p, Point pos);
    void setGame(Game *game) {
        m_game = game;
    }
    Game *getGame() {
        return m_game;
    }
    /**
     * whether the point has threats (targets, not necessarily legal)
     * by pieces by opponent of 'black'
     */
    bool hasThreats(Point point, bool black) const;
    bool inCheck() const;
    void setInCheck();
    std::list<Piece*>& getPieces(bool black) {
        if (black) {
            return m_blackPieces;
        } else {
            return m_whitePieces;
        }
    }
    const std::list<Piece*>& getPieces(bool black) const {
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
    
    Field& at(Point p) {
        return m_b[p.y + DIM*p.x];
    }
    const Field& at(Point p) const {
        return m_b[p.y + DIM*p.x];
    }
    Field& at(const std::string& pos) {
        return at(Point::convert(pos));
    }
    Field& at(const char col, const char row) {
        return at(Point::convert(col, row));
    }
    bool blacksTurn() const {
        return m_blacksTurn;
    }
    void setBlacksTurn(bool blacksTurn) {
        m_blacksTurn = blacksTurn;
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
                Field& f = at(COLNAMES[x], row);
                if (f.get() && f.get()->isPawn()) {
                    std::cerr << "pawn on " << f.getPos() << std::endl;
                    return false;
                }
            }
         }
         return true;
    }
    /**
     * evaluating the position, + for white's advantage, - for black's
     */
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
    bool searchPiece(bool black, Point pos, int incx, int incy) const; 
    template<typename Archive>
    void serialize(Archive& ar, const unsigned version) {
        ar & m_b & m_whitePieces & m_blackPieces & m_blacksTurn & m_bKingPos & m_wKingPos & m_game & m_inCheck;
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
    
std::vector<Point>& Piece::getDirectTargets() {
    m_targets.clear();
    const Board *b = m_field->getBoard();
    for (Point inc: getIncs()) {
        Point target = m_field->getPos() + inc;
        if (target.isOnBoard()) {
            if (b->at(target).isEmpty() || b->at(target).get()->isBlack() != isBlack()) {
                m_targets.push_back(target);
            }
        }
    }
    return m_targets;
}

std::vector<Point>& Piece::getIterTargets() {
    m_targets.clear();
    const Board *b = m_field->getBoard();
    for (Point inc: getIncs()) {
        Point target = m_field->getPos();
        while(true) {
            target += inc;
            if (!target.isOnBoard()) {
                break;
            }
            if ( b->at(target).isEmpty()) {
                m_targets.push_back(target);
            } else if (b->at(target).get()->isBlack() == isBlack()) {
                break;
            } else {
                m_targets.push_back(target);
                break;
            }
        }
    }
    return m_targets;
}

const std::vector<Point>& King::getTargets() {
    getDirectTargets();
    // castling. TODO: simplify & readability
    if (m_nofMoves == 0 && m_field->getPos().x == 4) {
        const Board *b = m_field->getBoard();
        int row = m_field->getPos().y;
        if (!b->at(Point(0, row)).isEmpty() && 
            b->at(Point(0, row)).get()->getNofMoves() == 0 &&
            b->at(Point(1, row)).isEmpty() &&
            b->at(Point(2, row)).isEmpty() &&
            b->at(Point(3, row)).isEmpty() 
         ) {
            m_targets.push_back(Point(2, row));
         }
         if (!b->at(Point(7, row)).isEmpty() &&
            b->at(Point(7, row)).get()->getNofMoves() == 0 &&
            b->at(Point(6, row)).isEmpty() &&
            b->at(Point(5, row)).isEmpty()
          ) {
            m_targets.push_back(Point(6, row));
          }
     }
     return m_targets;
}

const std::vector<Point>& Knight::getTargets() {
    return getDirectTargets();
}

const std::vector<Point>& Bishop::getTargets() {
    return getIterTargets();
}

const std::vector<Point>& Rook::getTargets() {
    return getIterTargets();
}

const std::vector<Point>& Queen::getTargets()  {
    return getIterTargets();
}

const std::vector<Point>& Pawn::getTargets() {
    if (m_promoted) {
        return m_promoted->getTargets();
    } 
    m_targets.clear();
    const Board *b = m_field->getBoard();
    Point pos = m_field->getPos();
    Point straightTarget = pos + (isBlack() ? Point(0, -1) : Point(0, 1));
    Point doubleStepTarget = pos + (isBlack() ? Point(0, -2) : Point(0, 2));
    Point capTarget1 = pos + (isBlack() ? Point(1, -1) : Point(1, 1));
    Point capTarget2 = pos + (isBlack() ? Point(-1, -1) : Point(-1, 1));

    if (straightTarget.isOnBoard() && b->at(straightTarget).isEmpty()) {
        m_targets.push_back(straightTarget);
        if ((isBlack() && pos.y == DIM-2) ||
            (!isBlack() && pos.y == 1)) {
            if (doubleStepTarget.isOnBoard() && b->at(doubleStepTarget).isEmpty()) {
                m_targets.push_back(doubleStepTarget);
            }
        }
    }
    for (Point capTarget: { capTarget1, capTarget2 }) {
        if (capTarget.isOnBoard() && !b->at(capTarget).isEmpty() && b->at(capTarget).get()->isBlack() != isBlack()) {
            m_targets.push_back(capTarget);
        }
        //TODO en passant
    }
    return m_targets;
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
    b.at(col, row).put(*w_piece);
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
    bool promotion = false;
    bool castling = false;
    bool causesCheck = false;
    // Allow serialization to access non-public data members.
    friend class boost::serialization::access;

    template<typename Archive>
    void serialize(Archive& ar, const unsigned version) {
        ar & from & to & piece & capturedPiece & promotion & castling & causesCheck;
    }
};

std::ostream& operator<< (std::ostream& out, const Move& m) {
    std::string cap;
    if (m.piece == nullptr) {
        out << "(none)";
        return out;
    } 
    if (m.capturedPiece != nullptr) {
        cap = "X";
    }
    if (m.castling) {
        if (m.from.x < m.to.x) {
            out << "0-0";
        } else {
            out << "0-0-0";
        }
    } else {
        if (m.promotion) {
           out << 'P' << m.from << cap << m.to << "=" << *m.piece;
        } else {
            out << m.piece->getSym() << m.from << cap << m.to;
        }
    }
    if (m.causesCheck) {
        out << '+';
    }
    return out;
}

std::ostream& operator<<(std::ostream &strm, const Piece &p)
{
    if (p.getField()) {
        strm << p.sym() << p.getField()->getPos();
    } else {
        strm << p.sym() << "(OFFBOARD)";
    }
    return strm;
}
struct EvalMove : public Move {
public:
    EvalMove(const Move& move) : Move(move), eval(0.0) {
    }
    EvalMove() : Move(), eval(0.0) {
    }
    float eval;
};

std::ostream& operator<< (std::ostream& out, const EvalMove& evalMove) {
    out << static_cast<Move>(evalMove) << ", eval: " << evalMove.eval;
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
        if (p.isBlack() != m_b.blacksTurn()) {
           std::cerr << "error: moving " << p << ", black's turn: " << m_b.blacksTurn() << std::endl;
           return nullptr;
        }
        Move move;
        move.from = p.getField()->getPos();
        move.to = to;
        move.piece = &p;
        
        m_b.at(move.from).remove();
        move.capturedPiece = m_b.at(to).put(p);
        if (p.isPawn() && (to.y == 0 || to.y == DIM-1)) {
           dynamic_cast<Pawn&>(p).promote<Queen>();
           move.promotion = true;
        } else {
           move.promotion = false;
        }
        if (p.isKing() && abs(move.to.x-move.from.x) > 1) {
            move.castling = true;
            Point rookTarget = Point((move.to.x+move.from.x)/2, move.from.y);
            Point rookPos = Point(move.to.x > move.from.x ? 7 : 0, move.from.y);
            Piece* rook = m_b.at(rookPos).remove();
            m_b.at(rookTarget).put(*rook);
        } else {
            move.castling = false;
        }
        m_b.setBlacksTurn(!m_b.blacksTurn());
        m_b.setInCheck();
        move.causesCheck = m_b.inCheck();
        m_moves.push_back(move);
        p.incNofMoves(1);
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
        Piece* p = m_b.at(move.to).remove();
        if (p != move.piece) {
            std::cerr << "can't find piece of last move" << std::endl;
            return false;
        }
        if (move.promotion) {
            dynamic_cast<Pawn*>(p)->unpromote();
        }
        m_moves.pop_back();
        m_b.at(move.from).put(*p);
        if (move.castling) {
            Point rookTarget = Point((move.to.x+move.from.x)/2, move.from.y);
            Point rookPos = Point(move.to.x > move.from.x ? 7 : 0, move.from.y);
            Piece *rook = m_b.at(rookTarget).remove();
            m_b.at(rookPos).put(*rook);
        }
        p->incNofMoves(-1);

        if (move.capturedPiece != nullptr) {
            m_b.at(move.to).put(*move.capturedPiece);
        }
        m_b.setBlacksTurn(!m_b.blacksTurn());
        m_b.setInCheck();
         if (p->isKing()) {
            m_b.setKingPos(p->isBlack(), move.from);
        }
        return true;
    }

    bool compareMoves(float newMove, float r, bool max) {
        if (max) {
            return newMove > r;
        } else {
            return newMove < r;
        }
    }

    EvalMove getBestMove(int depth, bool print = true) {
        static const float MAXEVAL = 1000.0;
        bool blacksTurn = m_b.blacksTurn();
        EvalMove bestMove;
        bestMove.eval = blacksTurn ? MAXEVAL : -MAXEVAL;
        auto activePieces = m_b.getPieces(blacksTurn);
        for (Piece *p: activePieces) {
            std::vector<Point> moveTargets(p->getMoveTargets());
            for (Point target: moveTargets) {
                const Move* move = makeMove(*p, target);
                EvalMove evalMove(*move);
                if (depth > 0) {
                    EvalMove nextBestMove = getBestMove(depth-1, false);
                    Debug("next best is " << nextBestMove);
                    evalMove.eval = nextBestMove.eval;
                } else {
                    evalMove.eval = m_b.eval();
                }
                if (print) {
                    std::cout << "depth " << depth << ", checking " << evalMove << std::endl;
                }
                if (compareMoves(evalMove.eval, bestMove.eval, !blacksTurn)) {
                    bestMove = evalMove;
                }
                retractMove();
            }
        }
        if (print) {
            std::cout << "depth " << depth << ", best move " << bestMove << std::endl;
        }
        // no moves found?
        if (bestMove.piece == nullptr) {
            Debug("no moves found");
            if (m_b.inCheck()) {
                // checkmate
            } else {
                // stalemate
                bestMove.eval = 0.0;
            }
        }
        return bestMove;
    }
    EvalMove getBestMove() {
        return getBestMove(3, true);
    }

    template<typename Archive>
    void serialize(Archive& ar, const unsigned version) {
        ar & m_b & m_moves & m_ptr_pieces;
    }
};   

bool Board::hasThreats(Point point, bool black) const {
   for (Piece* p: getPieces(!black)) {
        const std::vector<Point>& oppTargets = p->getTargets();
        if (std::find(oppTargets.begin(), oppTargets.end(), point) != oppTargets.end()) {
            return true;
        }
   }
   return false;
}

const std::vector<Point>& Piece::getMoveTargets() {
     m_moveTargets.clear();
     if (isBlack() != m_field->getBoard()->blacksTurn()) {
        return m_moveTargets;
     }
     std::vector<Point> targets(getTargets()); // TODO doesn't make sense, optimize
     Point origPos = m_field->getPos();
     for (Point target: targets) {
        if (isMoveTarget(origPos, target)) {
            m_moveTargets.push_back(target);
        }
     }
     return m_moveTargets;
}

bool Board::inCheck() const {
    return m_inCheck;
}

void Board::setInCheck() {
    Point kingPos = getKingPos(blacksTurn());
    m_inCheck = hasThreats(kingPos, blacksTurn());
}

static int sgn(int v) {
    return v > 0 ? 1 : -1;
}

bool Board::searchPiece(bool black, Point pos, int incx, int incy) const {
    Point inc(incx, incy);

    while(true) {
        pos += inc;
        if (!pos.isOnBoard()) {
            return false;
        }
        if (!at(pos).isEmpty()) {
            return at(pos).get()->isBlack() == black;
        }
    }
}

bool Board::possibleDiscoveryCheck(const Piece& p, Point pos) {
    Point kingPos = getKingPos(p.isBlack());
    bool onRow = (pos.x == kingPos.x);
    bool onRank = (pos.y == kingPos.y);
    bool onUpDiag = (pos.x - kingPos.x == pos.y - kingPos.y);
    bool onDownDiag = (pos.x - kingPos.x == kingPos.y - pos.y);
    if (onRow) {
        return searchPiece(!p.isBlack(), pos, sgn(pos.x - kingPos.x), 0);
    }
    if (onRank) {
        return searchPiece(!p.isBlack(), pos, 0, sgn(pos.y - kingPos.y));
    }
    if (onUpDiag) {
        return searchPiece(!p.isBlack(), pos, sgn(pos.x - kingPos.x), sgn(pos.x - kingPos.x));
    }
    if (onDownDiag) {
        return searchPiece(!p.isBlack(), pos, sgn(pos.x - kingPos.x), sgn(kingPos.x - pos.x));
    }
    return false;

}

bool Piece::isMoveTarget(Point origPos, Point target) const {
    // TODO make this faster?
    Game *game = m_field->getBoard()->getGame();
    Board& b = game->getBoard();   
    if (isKing() || b.inCheck() || b.possibleDiscoveryCheck(*this, origPos)) {
        // check if check after move
        Piece* that = const_cast<Piece*>(this);
        game->makeMove(*that, target);
        bool inCheck = b.hasThreats(b.getKingPos(isBlack()), isBlack());
        if (inCheck) {
            Debug (*this << " doesn't work because king is in check");
        }  
        game->retractMove();
        return !inCheck;
    } else {
        return true;
    }
}

bool King::isMoveTarget(Point origPos, Point target) const {
    Board *b = m_field->getBoard(); 
    // check castling legality 
    if (abs(target.x-origPos.x)>1) {
        Point adjPos((origPos.x+target.x)/2, origPos.y);
        if (b->hasThreats(origPos, isBlack()) || b->hasThreats(adjPos, isBlack())) {
            Debug("castling to " << target << " doesn't work because of king threats");
            return false;
         }
    }
    return Piece::isMoveTarget(origPos, target);
}
    
void auto_game(Game& g) {
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

void str_toupper(std::string& str) {
    std::transform(str.begin(), str.end(), str.begin(), ::toupper);
}

void serialize(const Game& game) {
   std::string fileName("moves.ser");
   // Create an output archive
   std::ofstream ofs(fileName);
   boost::archive::text_oarchive ar(ofs);

   ar & game;
}

void deserialize(Game& game) {
    std::string fileName("moves.ser");
    std::ifstream ifs(fileName);
    boost::archive::text_iarchive ar(ifs);
    // Load data
    ar & game;
}

bool starts_with(const std::string& s, const std::string prefix) {
    return s.compare(0, prefix.length(), prefix) == 0;
}

void interactive_game(Game& g) {
    Board& b = g.getBoard();
    while(true) {
        std::cout << b << std::endl;
        std::cout << "enter move: ";
        std::string movestr;
        std::getline(std::cin, movestr);
        if (movestr == "save") {
            serialize(g);
        } else if (movestr == "restore") {
            deserialize(g);
            std::cout << "deserialized moves: " << g.getMoves() << std::endl;
            b = g.getBoard();
        } else if (movestr == "retract") {
            g.retractMove();
        } else if (starts_with(movestr, "best")) {
            if (movestr.length() > 4) {
                std::cout << g.getBestMove(atoi(movestr.substr(4).c_str()), true) << std::endl;
            } else {
                std::cout << g.getBestMove() << std::endl;
            }
        } else if (movestr == "quit") {
            return;
        } else {
            try {
                str_toupper(movestr);
                Point from = Point::convert(movestr.substr(0, 2));
                Point to = Point::convert(movestr.substr(2, 2));
                
                Field& f = b.at(from);
                if (f.isEmpty()) {
                    std::cerr << from << " is empty" << std::endl;
                } else {
                    Piece *p = f.get();
                    const std::vector<Point>& targets = p->getMoveTargets();
                    if (std::find(targets.begin(), targets.end(), to) == targets.end()) {
                        std::cerr << to << " is not a legal move for " << *p << std::endl;
                        std::cerr << "legal moves: " << targets << std::endl;
                    } else {
                        g.makeMove(*p, to);
                        std::cout << g.getMoves().back() << std::endl;
                    }
                }
            } catch (const std::runtime_error& err) {
                std::cerr << err.what() << std::endl;
            }
        }
    }
}

void test_game(Game& g) {
    Board& b = g.getBoard();

    // test code
    std::cout << "black king pos is " << b.getKingPos(true) << std::endl;
    Piece* wKing = b.at(b.getKingPos(false)).get();
    auto targets = wKing->getTargets();
    std::cout << "white king targets: " << targets << std::endl;
    Piece* bKnight = b.at("B8").get();
    targets = bKnight->getTargets();
    std::cout << "black knight targets: " << targets << std::endl;
    Bishop bi;
    b.at("D4").put(bi);
    std::cout << b << std::endl;
    std::cout << "white bishop moves: " << bi.getMoveTargets() << std::endl;
    b.at("D4").remove();
    targets = b.at("D7").get()->getTargets();
    std::cout << "D7 pawn targets: " << targets << std::endl; 
    Piece *pawn = b.at("D2").get();
    if (!g.makeMove(*pawn, pawn->getTargets()[0])) {
        std::cout << "can't make the move to " << targets[0] << std::endl;
    }
    std::cout << b << std::endl;
    g.retractMove();
}

void random_game(Game& g) {
    Board& b = g.getBoard();
    while(true) {
        std::cout << b << std::endl;
        auto activePieces = b.getPieces(b.blacksTurn());
        std::vector<Piece*> piecesVec = { std::begin(activePieces), std::end(activePieces) };
        std::random_shuffle(piecesVec.begin(), piecesVec.end());
        Piece *movingPiece = nullptr;
        Point target;
        for (Piece *p: activePieces) {
            std::vector<Point> moves(p->getMoveTargets());
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

BOOST_CLASS_EXPORT_GUID(Pawn, "Pawn");
BOOST_CLASS_EXPORT_GUID(Rook, "Rook");
BOOST_CLASS_EXPORT_GUID(Queen, "Queen");
BOOST_CLASS_EXPORT_GUID(King, "King");
BOOST_CLASS_EXPORT_GUID(Bishop, "Bishop");
BOOST_CLASS_EXPORT_GUID(Knight, "Knight");

enum Mode { AUTO, TEST, RANDOM, INTERACTIVE };

int main(int argc, char **argv) {
    Game g;
    g.setup();
    Mode mode = RANDOM;
    if (argc > 1) {
        mode = static_cast<Mode>(std::stoi(argv[1]));
    }
    switch(mode) {
    case TEST:
        test_game(g);
        break;
    case RANDOM:
        random_game(g);
        break;
    case INTERACTIVE:
        interactive_game(g);
        break;
    case AUTO:
        auto_game(g);
        break;
    }
}


