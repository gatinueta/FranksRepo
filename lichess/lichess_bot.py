import berserk
import chess.engine
import os
import threading

TOKEN = os.environ.get('LICHESS_TOKEN')
STOCKFISH_PATH = "/Users/frankammeter/stockfish/stockfish-macos-x86-64-bmi2"
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

def select_move(board):
    top_moves = get_top_moves(board)
    print("Stockfish Vorschläge:")
    for i, (uci_move, score) in enumerate(top_moves, 1):
        print(f"{i}: {uci_move} (Score: {score})")

    # Wähle z. B. den ersten Zug automatisch:
    chosen_move = top_moves[0][0]
    board.push_uci(chosen_move)
    return chosen_move

def handle_game(game_id):
    print(f'Starting game: {game_id}')
    
    board = chess.Board()
    game_stream = client.bots.stream_game_state(game_id)

    is_white = None

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
                move = select_move(board)
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
                move = select_move(board)
                client.bots.make_move(game_id, move)



# Stream von Herausforderungen


for event in client.bots.stream_incoming_events():
    print(f'got event {event}')
    if event["type"] == "challenge":
        challenge = event["challenge"]
        if challenge["variant"]["key"] == "standard" and challenge["speed"] in ("bullet", "blitz", "rapid"):
            client.bots.accept_challenge(challenge["id"])
    elif event["type"] == "gameStart":
        game_id = event["game"]["id"]
        threading.Thread(target=handle_game, args=(game_id,)).start()
