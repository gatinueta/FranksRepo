import berserk
import chess.engine
import os
import threading

TOKEN = os.environ.get('LICHESS_TOKEN')
STOCKFISH_PATH = os.environ.get('STOCKFISH_PATH')
BOT_ID = "gatinuetabot"

session = berserk.TokenSession(TOKEN)
client = berserk.Client(session=session)

# Test: Hole dein Bot-Profil
profile = client.account.get()
print("Bot ist verbunden als:", profile["username"])

engine = chess.engine.SimpleEngine.popen_uci(STOCKFISH_PATH)

def get_top_moves(board, limit=5):
    result = engine.analyse(board, chess.engine.Limit(time=0.1), multipv=limit)
    suggestions = []
    print(f'analyse result: {result}')
    for info in result:
        move = info["pv"][0]  # bester Zug laut PV (Principal Variation)
        score = info["score"].relative
        suggestions.append((move.uci(), score))
    return suggestions

# maximaler Bewertungsabfall gegenüber dem besten Zug in Centipawns
def get_max_eval_drop(game_parameters):
    try:
        return float(game_parameters['max_eval_drop'])
    except:
        return 1.0
    
# minimale geopferte Materialsumme (z. B. Bauer=1, Springer=3 …)
def get_min_sacrifice_material(game_parameters):
    try:
        return int(game_parameters['min_sacrifice_material'])
    except:
        return 2


def select_move(board, game_parameters):
    result = engine.analyse(board, chess.engine.Limit(depth=15), multipv=5)
    best_score = result[0]["score"].relative.score(mate_score=10000) / 100.0

    candidate_moves = []
    for entry in result:
        move = entry["pv"][0]
        score = entry["score"].relative.score(mate_score=10000) / 100.0
        eval_drop = best_score - score

        if eval_drop <= get_max_eval_drop(game_parameters):
            candidate_moves.append((move, score, eval_drop, board.san(move)))

    # Suche unter den akzeptablen Zügen nach Opfern / Komplikationen
    ranked_moves = sorted(candidate_moves, key=lambda x: (
        -is_sacrifice(board, x[0], game_parameters),  # Opfer bevorzugen
        x[2],  # dann kleinere Bewertungseinbuße
    ))

    print("Kandidaten:")
    for move, score, eval_drop, san in ranked_moves:
        print(f"{san}: Bewertung {score:.2f}, Abfall {eval_drop:.2f}, Opfer: {is_sacrifice(board, move, game_parameters)}")

    if ranked_moves:
        return ranked_moves[0][0].uci()
    else:
        # Fallback: bester verfügbarer Zug
        return result[0]["pv"][0].uci()


def is_sacrifice(board, move, game_parameters):
    """Bestimme, ob der Zug eine Art Opfer ist."""
    piece = board.piece_at(move.from_square)
    captured = board.piece_at(move.to_square)

    if not piece:
        return False

    value = material_value(piece)
    capture_value = material_value(captured) if captured else 0

    # Einfaches Opfer: Figur wird geschlagen ohne Gegengewicht
    if capture_value < value:
        # Aber nur werten, wenn Materialverlust mindestens 2 Punkte beträgt (z.B. Springer geopfert)
        if (value - capture_value) >= get_min_sacrifice_material(game_parameters):
            return True

    # Erweitert: Zug zieht Figur auf Feld, wo sie leicht geschlagen werden kann (hängt)
    board.push(move)
    is_hanging = board.is_attacked_by(not board.turn, move.to_square)
    board.pop()

    if is_hanging and value >= get_min_sacrifice_material(game_parameters):
        return True

    return False


def material_value(piece):
    """Grobe Materialbewertung"""
    if piece is None:
        return 0
    return {
        chess.PAWN: 1,
        chess.KNIGHT: 3,
        chess.BISHOP: 3,
        chess.ROOK: 5,
        chess.QUEEN: 9,
        chess.KING: 0  # irrelevant für Opfer
    }[piece.piece_type]

def handle_game(game_id):
    print(f'Starting game: {game_id}')
    
    board = chess.Board()
    game_stream = client.bots.stream_game_state(game_id)

    is_white = None
    game_parameters = {}
    
    for event in game_stream:
        print(f'Game event: {event}')

        if event['type'] == 'gameFull':
            # Feststellen, ob der Bot weiß ist
            is_white = event['white']['id'].lower() == BOT_ID.lower()

            # Startstellung anwenden
            board = chess.Board()
            moves = event['state']['moves'].split()
            for move in moves:
                board.push_uci(move)

            # Wenn wir weiß sind und es noch keinen Zug gibt, sind wir dran
            if is_white and len(moves) == 0:
                move = select_move(board, game_parameters)
                client.bots.make_move(game_id, move)

        elif event['type'] == 'gameState':
            moves = event['moves'].split()
            board = chess.Board()
            for move in moves:
                board.push_uci(move)

            if event['status'] != 'started':
                print('Game ended.')
                break

            # Jetzt prüfen wir, ob wir dran sind
            if (is_white and board.turn == chess.WHITE) or (not is_white and board.turn == chess.BLACK):
                move = select_move(board, game_parameters)
                client.bots.make_move(game_id, move)
        elif event["type"] == "chatLine" and event["room"] == "player":
            user = event["username"]
            text = event["text"]
            # simple parsing
            if "=" in text:
                key, value = text.strip().split("=", 1)
                print(f'set parameter {key} to {value}')
                game_parameters[key] = value



# Stream von Herausforderungen


for event in client.bots.stream_incoming_events():
    print(f'got event {event["type"]}: {event}')
    if event["type"] == "challenge":
        challenge = event["challenge"]
        if challenge["variant"]["key"] == "standard" and challenge["speed"] in ("bullet", "blitz", "rapid"):
            client.bots.accept_challenge(challenge["id"])
    elif event["type"] == "gameStart":
        game_id = event["game"]["id"]
        threading.Thread(target=handle_game, args=(game_id,)).start()
